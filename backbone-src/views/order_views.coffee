# Inventory Views

jQuery ->
    class OrderControllerView extends Backbone.View
        el: '#orders-main-view'
        events:
            'click #orders-list-tab': 'renderOrdersListView'
            'click #order-item-tab': 'renderOrderDefaultItemView'
            'click #order-create-tab': 'renderOrderCreateView'
        initialize: ->
            @currentView = null
        renderOrdersListView: ->
            @removeCurrentContentView()
            @currentView = new app.GenericListView
                collection: app.Orders
                tableTemplate: '#orders-table-template'
                tableListID: '#orders-table-list'
                itemTrTemplate: '#order-tr-template'
                deleteModalTemplate: '#order-view-delete-template'
                itemControllerView: @
            $("#orders-list-view-content").html @currentView.render().el
        renderOrderDefaultItemView: ->
            @removeCurrentContentView()
            @currentView = new app.GenericSingleView
                collection: app.Orders
                singleLayoutTemplate: "#order-view-template"
                singleContentTemplate: "#order-view-content-template"
                deleteModalTemplate: "#order-view-delete-template"
                itemControllerView: @
            $("#order-item-view-content").html(
                (@currentView.render app.Orders.models[0]).el)
        renderSpecificItemView: (model) ->
            @removeCurrentContentView()
            $('#order-item-tab a').tab('show')
            @currentView = new app.GenericSingleView
                collection: app.Orders
                singleLayoutTemplate: "#order-view-template"
                singleContentTemplate: "#order-view-content-template"
                deleteModalTemplate: "#order-view-delete-template"
                itemControllerView: @
            $("#order-item-view-content").html (@currentView.render model).el
        removeCurrentContentView: ->
            if @currentView
                @currentView.remove()

    @app = window.app ? {}
    @app.OrderControllerView = OrderControllerView
