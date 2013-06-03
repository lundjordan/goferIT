# Finance Views

# helper function
findSaleTotals = (sale) ->
    currentSale = sale.attributes
    totalPrice = 0
    totalCost = 0
    for product in currentSale.products
        totalPrice += product.price * product.individualProperties.length
        totalCost += product.cost * product.individualProperties.length

    totalPrice: (totalPrice / 100).toFixed(2)
    totalCost: (totalCost / 100).toFixed(2)


jQuery ->

    class TransactionsControllerView extends Backbone.View
        el: '#finances-main-view'
        events:
            'click #finances-list-tab': 'renderFinancesListView'
            'click #finance-item-tab': 'renderFinanceDefaultItemView'
        initialize: ->
            @currentView = null
        renderFinancesListView: ->
            @removeCurrentContentView()
            @currentView = new app.GenericListView
                collection: app.Sales
                tableTemplate: "#finances-table-template"
                tableListID: "#finances-table-list"
                itemTrTemplate: "#finance-tr-template"
                itemControllerView: @
                HeadView: TransactionListHeadView
                ItemsTableView: TransactionListTable
                # this overrides GenericItemsTable
            $("#finances-list-view-content").html @currentView.render().el
        renderFinanceDefaultItemView: ->
            @removeCurrentContentView()
            @currentView = new FinanceSingleView
                collection: app.Sales
                singleLayoutTemplate: "#finance-view-template"
                singleContentTemplate: "#finance-view-content-template"
                deleteModalTemplate: "#finance-view-delete-template"
                itemControllerView: @
            model = app.Sales.at(0)
            $("#finance-item-view-content").html((@currentView.render model).el)
            if model
                financeProductsTable = new FinanceProductsTable
                    model: model
                $("#finance-products-list").
                    html((financeProductsTable.render()).el)
                financeProductsTable.addAll()
        renderSpecificItemView: (model) ->
            @removeCurrentContentView()
            $('#finance-item-tab a').tab('show')
            @currentView = new FinanceSingleView
                collection: app.Sales
                singleLayoutTemplate: "#finance-view-template"
                singleContentTemplate: "#finance-view-content-template"
                deleteModalTemplate: "#finance-view-delete-template"
                itemControllerView: @
            $("#finance-item-view-content").html (@currentView.render model).el
            financeProductsTable = new FinanceProductsTable
                model: model
            $("#finance-products-list").
                html((financeProductsTable.render()).el)
            financeProductsTable.addAll()
        preSingleListItemHook: (sale) ->
            tmlAttrs =
                customerEmail: "N/A"
                employeeEmail: "N/A"
            custModel = app.Customers.findWhere
                _id: sale.get '_customer'
            empModel = app.Employees.findWhere
                _id: sale.get '_employee'
            if custModel
                tmlAttrs.customerEmail = custModel.get 'email'
            if empModel
                tmlAttrs.employeeEmail = empModel.get 'email'
            _.extend tmlAttrs, findSaleTotals(sale), sale.attributes
        # helpers
        removeCurrentContentView: ->
            if @currentView
                @currentView.remove()
    # # ###############
    # Finances List View Section
    # -> comes from ItemListVIew in # generic_views.coffee
    # ###############
    class TransactionListHeadView extends app.StoreSelectView
        events:
            'keyup #sale-id-search': 'setSearchFieldsAndRender'
            'keyup #sale-employee-search': 'setSearchFieldsAndRender'
            'keyup #sale-customer-search': 'setSearchFieldsAndRender'
            'change #sale-timeframe-select': 'setSearchFieldsAndRender'
        template: _.template ($ '#sale-store-names-template').html()
        initialize: ->
            @itemControllerView = @options.itemControllerView
            @itemsTable = @options.itemsTable
        setSearchFieldsAndRender: ->
            @itemsTable.setSearchFieldsAndRender()

    class TransactionListTable extends app.GenericItemsTable
        addBasedByStoreName: (transaction) ->
            if transaction.get('storeName') is @storeName
                view = new TransactionListItemView
                    model: transaction
                    template: @itemTrTemplate
                    itemControllerView: @itemControllerView
                    deleteModalTemplate: @deleteModalTemplate
                (@$ @tableListID).append view.render().el
        setSearchFieldsAndRender: ->
            @idSearchVal = $("#sale-id-search").val()
            @employeeSearchVal = $("#sale-employee-search").val()
            @customerSearchVal = $("#sale-customer-search").val()
            @timeFrameSearchVal = $("#sale-timeframe-select").val()
            $("#root-backbone-view-body").html @render().el
        addAll: -> # overriding super
            if not @collection.length
                return @noSaleAlert() # TODO IMPLEMENT THIS
            saleResults = @filterResultsBySearchFields(@collection)
            _.each saleResults, @addOne, @
        filterResultsBySearchFields: (collection) ->
            finalResults = collection.models
            if @idSearchVal
                finalResults = collection.filter (model) =>
                    idString = model.get('_id').toLowerCase()
                    idString.indexOf(@idSearchVal.toLowerCase()) isnt -1
            if @employeeSearchVal
                finalResults = finalResults.filter (model) =>
                    employeeModel = app.Employees.findWhere
                        _id: model.get('_employee')
                    employeeEmail = employeeModel.get('email').toLowerCase()
                    employeeEmail.indexOf(@employeeSearchVal.toLowerCase()) isnt -1
            if @customerSearchVal
                finalResults = finalResults.filter (model) =>
                    customerModel = app.Customers.findWhere
                        _id: model.get('_customer')
                    if customerModel
                        customerEmail = customerModel.get('email').toLowerCase()
                        customerEmail.
                            indexOf(@customerSearchVal.toLowerCase()) isnt -1
                    else
                        false
            if @timeFrameSearchVal and @timeFrameSearchVal isnt "Anytime"
                startTime = new Date("1/1/1900")
                endTime = new Date("1/1/2200")
                now = new Date()
                if @timeFrameSearchVal is "Today"
                    startTime = new Date(now.toDateString())
                    endTime = new Date(
                        now.getFullYear(), now.getMonth(), now.getDate(), 23, 59, 59)
                else if @timeFrameSearchVal is "This Month"
                    startOfMonthString = "#{now.getMonth()+1}/1/#{now.getFullYear()}"
                    endOfMonthString = "#{now.getMonth()+2}/1/#{now.getFullYear()}"
                    startTime = new Date(startOfMonthString)
                    endTime = new Date(endOfMonthString)
                else
                    startOfYearString = "1/1/#{now.getFullYear()}"
                    endOfYearString = "1/1/#{now.getFullYear()+1}"
                    startTime = new Date(startOfYearString)
                    endTime = new Date(endOfYearString)
                finalResults = finalResults.filter (model) =>
                    Date.parse(startTime) <= Date.parse(model.get('dateCreated')) <= Date.parse(endTime)
            finalResults
        noSaleAlert: ->
            message = "You have no existing finances yet."
            alertWarning = new app.AlertView
                alertType: 'info'
            @$el.append alertWarning.render( "alert-info", message).el

    class TransactionListItemView extends app.GenericSingleListItemView
        initialize: ->
            @template = _.template ($ @options.template).html()
            @itemControllerView = @options.itemControllerView
            @deleteModalTemplate = @options.deleteModalTemplate
        render: ->
            tmlAttrs =
                customerEmail: "N/A"
                employeeEmail: "N/A"
            custModel = app.Customers.findWhere
                _id: @model.get '_customer'
            empModel = app.Employees.findWhere
                _id: @model.get '_employee'
            if custModel
                tmlAttrs.customerEmail = custModel.get 'email'
            if empModel
                tmlAttrs.employeeEmail = empModel.get 'email'
            tmlAttrs = _.extend tmlAttrs, findSaleTotals(@model), @model.attributes
            @$el.html this.template tmlAttrs
            $(@el).find('i').hide()
            @


    class FinanceSingleView extends app.GenericSingleView
        events:
            'click #single-item-prev-link': 'renderSingleItemPrevView'
            'click #single-item-next-link': 'renderSingleItemNextView'
        initialize: (options) ->
            super()
        renderSingleItemPrevView: (event) ->
            super()
            financeProductsTable = new FinanceProductsTable
                model: @currentModel
            $("#finance-products-list").html (financeProductsTable.render()).el
            financeProductsTable.addAll()
        renderSingleItemNextView: (event) ->
            super()
            financeProductsTable = new FinanceProductsTable
                model: @currentModel
            $("#finance-products-list").html (financeProductsTable.render()).el
            financeProductsTable.addAll()

    class FinanceProductsTable extends Backbone.View
        template: _.template ($ '#finance-products-table-template').html()
        render: ->
            @$el.html this.template({})
            @
        addOne: (financeProduct) ->
            view = new FinanceProductListItemView
                financeProduct: financeProduct
            ($ "#products-table-list").append view.render().el
        addAll: ->
            _.each @model.attributes.products, @addOne
    class FinanceProductListItemView extends Backbone.View
        template: _.template ($ '#finance-product-tr-template').html()
        tagName: 'tr'
        initialize: ->
            @financeProduct = @options.financeProduct
        render: ->
            @$el.html this.template @financeProduct
            @

    # ###############
    @app = window.app ? {}
    @app.TransactionsControllerView = TransactionsControllerView

