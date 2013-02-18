# Inventory Views

jQuery ->
    class InventoryView extends Backbone.View
        el: '#inventory-main-content'
        events:
            'click #product-menu-pill': 'renderProductView'
            'click #order-menu-pill': 'renderOrderView'
        template: _.template ($ '#inventory-main-template').html()
        initialize: ->
            @inventorySubViews =
                productMainView: new ProductMainView()
                orderMainView: new OrderMainView()
        render: ->
            @$el.html this.template({})
            @renderProductView()
        renderProductView: ->
            @$('#product-main-view').html(
                @inventorySubViews.productMainView.render().el
            )
        renderOrderView: ->
            @$('#order-main-view').html(
                @inventorySubViews.orderMainView.render().el
            )
            @inventorySubViews.orderMainView.render()

    class ProductMainView extends Backbone.View
        tagClass: 'tabbable'
        template: _.template ($ '#product-content-template').html()
        initialize: ->
            @productSubViews =
                productListView: new ProductListView(collection: app.products)
            @currentContentView = @productSubViews.productListView
        render: ->
            @$el.html this.template({})
            @

    class OrderMainView extends Backbone.View
        el: '#order-main-view'
        template: _.template ($ '#order-content-template').html()
        render: ->
            @$el.html this.template({})
            @

    class ProductListView extends Backbone.View
        el: '#product-list-view'
        template: _.template ($ '#product-list-template').html()
        render: ->
            @$el.html this.template({})

    class OrderListView extends Backbone.View
        el: '#order-list-view'
        template: _.template ($ '#order-list-template').html()
        render: ->
            @$el.html this.template({})

    @app = window.app ? {}
    @app.InventoryView = InventoryView

