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
                headView: TransactionListHeadView
                ItemsTableClass: TransactionListTable
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
        template: _.template ($ '#sale-store-names-template').html()
        initialize: ->
            @itemControllerView = @options.itemControllerView

    class TransactionListTable extends app.GenericItemsTable
        addBasedByStoreName: (transaction) ->
            if transaction.get('storeName') is @storeName
                view = new TransactionListItemView
                    model: transaction
                    template: @itemTrTemplate
                    itemControllerView: @itemControllerView
                    deleteModalTemplate: @deleteModalTemplate
                (@$ @tableListID).append view.render().el
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

