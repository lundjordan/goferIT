# Inventory Views

jQuery ->
    class InventoryControllerView extends Backbone.View
        el: '#inventory-main-content'
        events:
            'click #product-menu-pill': 'renderProductListView'
            'click #order-menu-pill': 'renderOrderListView'
        initialize: ->
            @productSubViews =
                productListView: new ProductListView(collection: app.products)
            @orderSubViews =
                orderListView: new OrderListView()
            @currentContentView = @productSubViews.productListView
        render: ->
            @currentContentView.render()
        renderProductListView: ->
            @currentContentView = @productSubViews.productListView
            @render()
        renderOrderListView: ->
            @currentContentView = @orderSubViews.orderListView
            @render()

    class ProductListView extends Backbone.View
        el: '#product-list-view'
        template: _.template ($ '#product-list-template').html()
        render: ->
            @$el.html this.template({})
            this.addAll()
            @
        addOne: (product) ->
            view = new ProductItemView model: product
            (@$ "#inventory-table-list").append view.render().el
        addAll: ->
            app.Products.each @addOne, @

    class ProductItemView extends Backbone.View
        tagName: 'tr'
        events:
            'mouseover': 'showProductOptions'
            'mouseout': 'hideProductOptions'
        template: _.template ($ '#product-item-template').html()
        render: ->
            @$el.html this.template(@model.toJSON())
            $(@el).find('i').hide()
            @
        showProductOptions: (event) ->
            # $('#item-options').prepend("<i class='icon-search'></i>")
            console.log "mouse over #{@model.get('cost')}"
            $(@el).find('i').show()
        hideProductOptions: (event) ->
            # $('#item-options').html()
            console.log "mouse out #{@model.get('cost')}"
            $(@el).find('i').hide()


    class OrderListView extends Backbone.View
        el: '#order-list-view'
        template: _.template ($ '#order-list-template').html()
        render: ->
            @$el.html this.template({})

    @app = window.app ? {}
    @app.InventoryControllerView = InventoryControllerView

