# Inventory Views

jQuery ->
    class InventoryControllerView extends Backbone.View
        el: '#inventory-main-content'
        events:
            'click #product-menu-pill': 'renderProductsListView'
            'click #inventory-list-tab': 'renderProductsListView'
            'click #inventory-item-tab': 'renderProductDefaultItemView'
            'click #inventory-create-tab': 'renderProductCreateView'
            'click #order-menu-pill': 'renderOrderListView'
        initialize: ->
            @currentView = null
        renderProductsListView: ->
            if @currentView
                @currentView.$el.html("")
            @currentView = new ProductsListView()
            @currentView.render()
        renderProductDefaultItemView: ->
            if @currentView
                @currentView.$el.html("")
            @currentView = new ProductItemView()
            @currentView.render app.Products.models[0]
        renderProductSpecificItemView: (model) ->
            if @currentView
                @currentView.$el.html("")
            # $('#inventory-list-tab').removeClass('active')
            # $('#inventory-item-tab').addClass('active')
            # $('#inventory-item-tab a').tab('show');
            @currentView = new ProductItemView()
            @currentView.render model
        renderProductCreateView: ->
            if @currentView
                @currentView.$el.html("")
            @currentView = new ProductCreateView()
            @currentView.render()
        renderOrderListView: ->
            if @currentView
                @currentView.$el.html("")
            @currentView = new OrderListView()
            @currentView.render()

    # ###############
    # HELPER CLASS -> SHARED
    class StoreSelectView extends Backbone.View
        render: ->
            @$el.html this.template({})
            storeNames = app.Companies.models[0].get 'stores'
            @addToSelect(store.name) for store in storeNames
            @
        addToSelect: (storeName) ->
            @$('#store-name-select').append "<option>#{storeName}</option>"
    class ProductsListStoreSelectView extends StoreSelectView
        template: _.template ($ '#store-names-template').html()
    class ProductItemSubQuantityView extends Backbone.View
        className: 'container-fluid'
        template: _.template ($ '#product-view-sub-quantity-template').html()
        render: (productSubQuants) ->
            @$el.html this.template({})

            # now let's add column 1 name and row 1 titles
            tableHeaderValues = "<th>#{productSubQuants[0].measurementName}</th>"
            tableRow1Values = "<td>Totals</td>"

            # fill in the remaining rows/columns with the subquants
            _.each productSubQuants, (elem) ->
                tableHeaderValues += "<th>#{elem.measurementValue}</th>"
                tableRow1Values += "<td>#{elem.quantity}</td>"

            # finally append this to their respective th and td tags
            @$('#product-sub-quantity-thead-tr').append tableHeaderValues
            @$('#product-sub-quantity-tbody-td').append tableRow1Values

            @
    # ###############

    # ###############
    # Products List View Section
    class ProductsListView extends Backbone.View
        el: '#products-list-view-content'
        events:
            'change #store-name-select': 'renderProductsTable'
        template: _.template ($ '#inventory-content-template').html()
        initialize: (options) ->
            @storeSelectView = new ProductsListStoreSelectView()
            @productsTable = new ProductsTable()
        render: ->
            @$el.html this.template({})
            $("#inventory-view-head").html @storeSelectView.render().el
            $("#inventory-view-body").html @productsTable.render().el
        renderProductsTable: ->
            @productsTable.render()
    # Products List View Section
    class ProductsTable extends Backbone.View
        # el: '#products-view-body'
        template: _.template ($ '#products-table-template').html()
        render: ->
            @$el.html this.template({})
            @addAll()
            @
        addOne: (product) ->
            if $('#store-name-select').val() is product.get('storeName')
                view = new ProductListItemView model: product
                (@$ "#products-table-list").append view.render().el
        addAll: ->
            app.Products.each @addOne, @
    # Products List View Section
    class ProductListItemView extends Backbone.View
        tagName: 'tr'
        events:
            'mouseover': 'showProductOptions'
            'mouseout': 'hideProductOptions'
            'click #product-view-eye-link': 'renderProductItemView'
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
        renderProductItemView: ->
            app.appControllerView.inventoryControllerView
                .renderProductSpecificItemView @model
    # ###############


    # ###############
    # Product Item View Section
    class ProductItemView extends Backbone.View
        el: '#product-item-view-content'
        events:
            'click #product-item-prev-link': 'renderProductItemPrevView'
            'click #product-item-next-link': 'renderProductItemNextView'
        template: _.template ($ '#inventory-content-template').html()
        initialize: (options) ->
            # @storeSelectView = new ProductsListStoreSelectView()
            @productView =  new ProductItemBodyView()
        render: (productModel) ->
            @model = productModel
            @$el.html this.template({})
            # @$("#inventory-view-head").html @storeSelectView.render().el
            # @storeSelectView.render()
            $("#inventory-view-body").html @productView.render(@model).el
        renderProductItemPrevView: (event) ->
            @model = app.Products.findPrev @model
            @productView.render @model
        renderProductItemNextView: (event) ->
            @model = app.Products.findNext @model
            @productView.render @model
    # Product Item View Section
    class ProductItemBodyView extends Backbone.View
        # el: '#product-item-view-body'
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
                # first let's sort the subquantities for readibility in table
                productSubQuants = productModel.attributes.subTotalQuantity
                _.sortBy productSubQuants, (el) ->
                    return el.measurementValue
                @$('#sub-quantity-totals')
                    .html @currentProductItemSubQuantity.render(productSubQuants).el
    class ProductItemContentView extends Backbone.View
        className: 'container-fluid'
        template: _.template ($ '#product-view-content-template').html()
        render: (productModel) ->
            @$el.html this.template(productModel.attributes)
            @
    class ProductItemSupplierNameView extends Backbone.View
        template: _.template ($ '#product-view-supplier-name-template').html()
        render: (productModel) ->
            if productModel.attributes._order
                supplierID = productModel.attributes._order._supplier
                supplierName = app.Suppliers.get(supplierID)
                @$el.html this.template(supplierName.attributes)
            else
                @$el.html this.template({name: 'N/A'})
            @
    # ###############
    #

    # ###############
    # Product Create Section
    class ProductCreateView extends Backbone.View
        el: '#product-create-view-content'
        template: _.template ($ '#inventory-content-template').html()
        initialize: ->
            @productCreateBodyView =  new ProductCreateBodyView()
            @storeSelectView = new StoreSelectView()
            @supplierSelectView = new SupplierSelectView()
            @storeSelectView.template = _.template ($ '#product-create-store-names-template').html()
        render: ->
            @$el.html this.template({})
            $("#inventory-view-body").html @productCreateBodyView.render().el
            $("#product-create-store-names").html @storeSelectView.render().el
            $("#product-create-supplier-names").html @supplierSelectView.render().el
            # $("#store-name-select").html @storeSelectView.render().el
    class ProductCreateBodyView extends Backbone.View
        events:
            "click input[type=radio]": "quantityOptionInput"
            "click #cancel-sub-total-options": "cancelSubTotalOptions"
            "click #save-sub-total-options": "saveSubTotalOptions"
            # "focusout": "validateForm"
        template: _.template ($ '#product-create-template').html()
        render: ->
            @$el.html this.template({})
            @validateCreateProductForm()
            @
        validateCreateProductForm: ->
            @validateForm @$("#create-product-form"),
                productName:
                    minlength: 2
                    required: true
                price:
                    required: true
                    decimalTwo: true

        quantityOptionInput: (e) ->
            if $(e.currentTarget).val() == "sub-total-selected"
                $("#sub-total-quantity-modal").modal("toggle")
            $('#grand-total-quantity-content').toggle()
            $('#sub-total-quantity-content').toggle()
        cancelSubTotalOptions: (e) ->
            $("#sub-total-quantity-modal").modal("toggle")
            $('input[name=totalOptionsRadio][value="grand-total-selected"]')
                .prop 'checked', true
            $('#grand-total-quantity-content').show()
            $('#sub-total-quantity-content').hide()
        saveSubTotalOptions: (e) ->
            $("#sub-total-quantity-modal").modal("toggle")
            $('#sub-total-quantity-content').show()
            $('#grand-total-quantity-content').hide()
            measurementType = $("#measurement-type-input").val()
            columnNamesString = $("#measurement-values-input").val()

            # split and trim columnNamesString by ','
            columnNamesArray = columnNamesString.split ','
            for name, i in columnNamesArray
                columnNamesArray[i] = name.replace(/(^\s+|\s+$)/g, '')

            productSubQuants = []
            for columnName in columnNamesArray
                productSubQuants.push
                    measurementName: measurementType
                    measurementValue: columnName
                    quantity: '<input class="input-mini" type="text">'
            $('#sub-total-quantity-content')
                .html (new ProductItemSubQuantityView()).render(productSubQuants).el
            # $('#grand-total-quantity-content').toggle()
            # $('#sub-total-quantity-content').toggle()


    class SupplierSelectView extends Backbone.View
        template: _.template ($ '#product-create-supplier-names-template').html()
        render: ->
            @$el.html this.template({})
            supplierNames = app.Suppliers.pluck "name"
            @addToSelect(name) for name in supplierNames
            @
        addToSelect: (supplierName) ->
            @$('#supplier-name-select').append "<option>#{supplierName}</option>"
    # ###############


    class OrderListView extends Backbone.View
        el: '#order-list-view'
        template: _.template ($ '#order-list-template').html()
        render: ->
            @$el.html this.template({})

    @app = window.app ? {}
    @app.InventoryControllerView = InventoryControllerView

