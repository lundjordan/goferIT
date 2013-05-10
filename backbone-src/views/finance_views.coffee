# Finance Views

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
                ItemsTableClass: TransactionListTable # this overrides GenericItemsTable
            $("#finances-list-view-content").html @currentView.render().el
        # renderFinanceDefaultItemView: ->
        #     @removeCurrentContentView()
        #     @currentView = new app.GenericSingleView
        #         collection: app.Finances
        #         singleLayoutTemplate: "#single-item-view-template"
        #         singleContentTemplate: "#finance-view-content-template"
        #         deleteModalTemplate: "#finance-view-delete-template"
        #         itemControllerView: @
        #     $("#finance-item-view-content").html(
        #         (@currentView.render app.Finances.models[0]).el)
        # renderSpecificItemView: (model) ->
        #     @removeCurrentContentView()
        #     $('#finance-item-tab a').tab('show')
        #     @currentView = new app.GenericSingleView
        #         collection: app.Finances
        #         singleLayoutTemplate: "#single-item-view-template"
        #         singleContentTemplate: "#finance-view-content-template"
        #         deleteModalTemplate: "#finance-view-delete-template"
        #         itemControllerView: @
        #     $("#finance-item-view-content").html (@currentView.render model).el
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
            tmlAttrs = {}
            custModel = app.Customers.findWhere
                _id: @model.get '_customer'
            empModel = app.Employees.findWhere
                _id: @model.get '_employee'
            if custModel
                tmlAttrs.customerEmail = custModel.get 'email'
            if empModel
                tmlAttrs.employeeEmail = empModel.get 'email'
            tmlAttrs = _.extend tmlAttrs, @model.attributes
            @$el.html this.template tmlAttrs
            $(@el).find('i').hide()
            @

    @app = window.app ? {}
    @app.TransactionsControllerView = TransactionsControllerView

