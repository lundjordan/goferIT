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
            @currentView = new OrderSingleView
                collection: app.Orders
                singleLayoutTemplate: "#order-view-template"
                singleContentTemplate: "#order-view-content-template"
                deleteModalTemplate: "#order-view-delete-template"
                itemControllerView: @
            model = app.Orders.models[0]
            $("#order-item-view-content").html((@currentView.render model).el)
            orderProductsTable = new OrderProductsTable
                model: model
            $("#order-products-list").html((orderProductsTable.render()).el)
            orderProductsTable.addAll()
        renderSpecificItemView: (model) ->
            @removeCurrentContentView()
            $('#order-item-tab a').tab('show')
            @currentView = new OrderSingleView
                collection: app.Orders
                singleLayoutTemplate: "#order-view-template"
                singleContentTemplate: "#order-view-content-template"
                deleteModalTemplate: "#order-view-delete-template"
                itemControllerView: @
            $("#order-item-view-content").html (@currentView.render model).el
            orderProductsTable = new OrderProductsTable
                model: model
            $("#order-products-list").html (orderProductsTable.render()).el
            orderProductsTable.addAll()
        removeCurrentContentView: ->
            if @currentView
                @currentView.remove()

    class OrderSingleView extends app.GenericSingleView
        renderSingleItemPrevView: (event) ->
            super()
            orderProductsTable = new OrderProductsTable
                model: @currentModel
            $("#order-products-list").html (orderProductsTable.render()).el
            orderProductsTable.addAll()
        renderSingleItemNextView: (event) ->
            super()
            orderProductsTable = new OrderProductsTable
                model: @currentModel
            $("#order-products-list").html (orderProductsTable.render()).el
            orderProductsTable.addAll()

    class OrderProductsTable extends Backbone.View
        template: _.template ($ '#order-products-table-template').html()
        render: ->
            @$el.html this.template({})
            @
        addOne: (orderProduct) ->
            view = new SingleListItemView
                orderProduct: orderProduct
            ($ "#products-table-list").append view.render().el
        addAll: ->
            _.each @model.attributes.products, @addOne
    class SingleListItemView extends Backbone.View
        template: _.template ($ '#order-product-tr-template').html()
        tagName: 'tr'
        initialize: ->
            @orderProduct = @options.orderProduct
        render: ->
            @$el.html this.template @orderProduct
            @


    @app = window.app ? {}
    @app.OrderControllerView = OrderControllerView
