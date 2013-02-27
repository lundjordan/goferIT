# Inventory Views

jQuery ->
    class InventoryControllerView extends Backbone.View
        el: '#inventory-main-content'
        events:
            'click #product-menu-pill': 'renderProductsListView'
            'click #inventory-list-tab': 'renderProductsListView'
            'click #inventory-item-tab': 'renderProductDefaultItemView'
            'click #order-menu-pill': 'renderOrderListView'
        renderProductsListView: ->
            productsListView = new ProductsListView()
            productsListView.render()
        renderProductDefaultItemView: ->
            productItemView = new ProductItemView()
            productItemView.render app.Products.models[0]
        renderProductSpecificItemView: (event) ->
            productItemView = new ProductItemView()
            productItemView.render app.Products.models[0]
        renderOrderListView: ->
            orderListView = new OrderListView()
            orderListView.render()

    # ###############
    # HELPER CLASS -> SHARED
    class StoreSelectView extends Backbone.View
        el: '#inventory-view-head'
        template: _.template ($ '#store-names-template').html()
        render: ->
            @$el.html this.template({})
            storeNames = app.Companies.models[0].get 'stores'
            @addToSelect(store.name) for store in storeNames
            @
        addToSelect: (storeName) ->
            @$('#store-name-select').append "<option>#{storeName}</option>"
    # ###############

    # ###############
    # Products List View Section
    class ProductsListView extends Backbone.View
        el: '#inventory-view-content'
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
    # Products List View Section
    class ProductsTable extends Backbone.View
        el: '#inventory-view-body'
        template: _.template ($ '#products-table-template').html()
        render: ->
            @$el.html this.template({})
            @addAll()
            @
        addOne: (product) ->
            if $('#store-name-select').val() is product.get('storeName')
                view = new ProductListItemView model: product
                (@$ "#inventory-table-list").append view.render().el
        addAll: ->
            app.Products.each @addOne, @
    # Products List View Section
    class ProductListItemView extends Backbone.View
        tagName: 'tr'
        events:
            'mouseover': 'showProductOptions'
            'mouseout': 'hideProductOptions'
        template: _.template ($ '#product-tr-template').html()
        render: ->
            @$el.html this.template @model.attributes
            $(@el).find('i').hide()
            @
        showProductOptions: (event) ->
            # $('#item-options').prepend("<i class='icon-search'></i>")
            $(@el).find('i').show()
        hideProductOptions: (event) ->
            # $('#item-options').html()
            $(@el).find('i').hide()
    # ###############


    # ###############
    # Product Item View Section
    class ProductItemView extends Backbone.View
        el: '#inventory-view-content'
        initialize: (options) ->
            @storeSelectView =  new StoreSelectView()
            @productView =  new ProductItemBodyView()
        render: (productModel) ->
            @storeSelectView.render()
            @productView.render(productModel)
        renderProductItemMenuView: ->
            @productView.render(productModel)
    # Product Item View Section
    class ProductItemBodyView extends Backbone.View
        el: '#inventory-view-body'
        template: _.template ($ '#product-view-template').html()
        initialize: ->
            @currentProduct = null
        render: (productModel) ->
            @$el.html this.template({})
            @renderProductContent(productModel)
            @
        renderProductContent: (productModel) ->
            @currentProduct = new ProductItemContentView()
            @currentProductSupplier = new ProductItemSupplierNameView()
            @currentProductItemSubQuantity = new ProductItemSubQuantityView()
            @$('#product-view-content')
                .html @currentProduct.render(productModel).el
            @$('#product-view-supplier-name')
                .html @currentProductSupplier.render(productModel).el
            if productModel.attributes.subTotalQuantity
                @$('#sub-quantity-totals')
                    .html @currentProductItemSubQuantity.render(productModel).el

    class ProductItemContentView extends Backbone.View
        className: 'container-fluid'
        template: _.template ($ '#product-view-content-template').html()
        render: (productModel) ->
            console.log productModel.attributes
            @$el.html this.template(productModel.attributes)
            @
    class ProductItemSupplierNameView extends Backbone.View
        template: _.template ($ '#product-view-supplier-name-template').html()
        render: (productModel) ->
            supplierID = productModel.attributes._order._supplier
            supplierName = app.Suppliers.get(supplierID)
            @$el.html this.template(supplierName.attributes)
            @
    class ProductItemSubQuantityView extends Backbone.View
        className: 'container-fluid'
        template: _.template ($ '#product-view-sub-quantity-template').html()
        render: (productModel) ->
            # first let's sort the subquantities for readibility in table
            productSubQuants = productModel.attributes.subTotalQuantity
            _.sortBy productSubQuants, (el) ->
                return el.measurementValue
            @$el.html this.template({})

            # now let's add column 1 name and row 1 titles
            tableHeaderValues = "<th>Measurement</th>"
            tableRow1Values = "<td>#{productSubQuants[0].measurementName}</td>"

            # fill in the remaining rows/columns with the subquants
            _.each productSubQuants, (el) ->
                tableHeaderValues += "<th>#{el.measurementValue}</th>"
                tableRow1Values += "<td>#{el.quantity}</td>"

            # finally append this to their respective th and td tags
            @$('#product-sub-quantity-thead-tr').append tableHeaderValues
            @$('#product-sub-quantity-tbody-td').append tableRow1Values

            @
    # ###############
    # dateCreated, price, category, quantity


    class OrderListView extends Backbone.View
        el: '#order-list-view'
        template: _.template ($ '#order-list-template').html()
        render: ->
            @$el.html this.template({})

    @app = window.app ? {}
    @app.InventoryControllerView = InventoryControllerView

