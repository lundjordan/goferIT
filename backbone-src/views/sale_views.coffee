# POS Views

jQuery ->
    class SalesControllerView extends Backbone.View
        el: '#sales-main-view'
        initialize: ->
            @currentView = null
        renderSalesConstructView: ->
            @removeCurrentContentView()
            # @currentView = new app.GenericListView
            #     collection: app.Sales
            #     storeSelectView: SalesListStoreSelectView
            #     tableTemplate: '#sales-table-template'
            #     tableListID: '#sales-table-list'
            #     itemTrTemplate: '#sale-tr-template'
            #     deleteModalTemplate: '#sale-view-delete-template'
            #     ItemsTableClass: SalesListTable # this overrides GenericItemsTable
            #     itemControllerView: @
            # $("#sales-list-view-content").html @currentView.render().el
        renderSalesConfirmView: ->
            @removeCurrentContentView()

        removeCurrentContentView: ->
            if @currentView
                @currentView.remove()



    @app = window.app ? {}
    @app.SalesControllerView = SalesControllerView
