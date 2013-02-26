# Inventory Views

jQuery ->
    class InventoryControllerView extends Backbone.View
        el: '#inventory-main-content'
        events:
            'click #product-menu-pill': 'renderProductListView'
            'click #order-menu-pill': 'renderOrderListView'
        initialize: ->
            @productSubViews =
                productListView: new ProductListView()
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

    class StoreSelectView extends Backbone.View
        el: '#product-list-head'
        template: _.template ($ '#store-names-template').html()
        render: ->
            @$el.html this.template({})
            storeNames = app.Companies.models[0].get 'stores'
            @addToSelect(store.name) for store in storeNames
            @
        addToSelect: (storeName) ->
            console.log storeName
            @$('#store-name-select').append "<option>#{storeName}</option>"

    class ProductsTable extends Backbone.View
        el: '#product-list-body'
        template: _.template ($ '#products-table-template').html()
        render: ->
            @$el.html this.template({})
            @addAll()
            @
        addOne: (product) ->
            if $('#store-name-select').val() is product.get('storeName')
                view = new ProductItemView model: product
                (@$ "#inventory-table-list").append view.render().el
        addAll: ->
            app.Products.each @addOne, @

    class ProductListView extends Backbone.View
        el: '#product-list-view'
        events:
            'change #store-name-select': 'renderProductsTable'
        initialize: (options) ->
            @storeSelectView = new StoreSelectView()
            @productsTable = new ProductsTable()
        render: ->
            @storeSelectView.render()
            @productsTable.render()
        renderProductsTable: ->
            @productsTable.render()

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
            $(@el).find('i').show()
        hideProductOptions: (event) ->
            # $('#item-options').html()
            $(@el).find('i').hide()


    class OrderListView extends Backbone.View
        el: '#order-list-view'
        template: _.template ($ '#order-list-template').html()
        render: ->
            @$el.html this.template({})

    @app = window.app ? {}
    @app.InventoryControllerView = InventoryControllerView

