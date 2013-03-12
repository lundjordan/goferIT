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
            @currentView = new app.ItemListView
                collection: app.Products
                el: "#products-list-view-content"
                storeSelectView: ProductsListStoreSelectView
                tableTemplate: '#products-table-template'
                tableListID: '#products-table-list'
                itemTrTemplate: '#product-tr-template'
                itemControllerView: @
            @currentView.render()
        renderProductDefaultItemView: ->
            if @currentView
                @currentView.$el.html("")
            @currentView = new ProductItemView()
            @currentView.render app.Products.models[0]
        renderSpecificItemView: (model) ->
            if @currentView
                @currentView.$el.html("")
            $('#inventory-item-tab a').tab('show')
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
    # Product List View Section
    # -> comes from ItemListVIew in # helper_views.coffee
    # ###############

    # ###############
    # Product Item View Section
    class ProductItemView extends Backbone.View
        el: '#product-item-view-content'
        events:
            'click #product-item-prev-link': 'renderProductItemPrevView'
            'click #product-item-next-link': 'renderProductItemNextView'
        template: _.template ($ '#root-backbone-content-template').html()
        initialize: (options) ->
            # @storeSelectView = new ProductsListStoreSelectView()
            @productView =  new ProductItemBodyView()
        render: (productModel) ->
            @model = productModel
            @$el.html this.template({})
            # @$("#root-backbone-view-head").html @storeSelectView.render().el
            # @storeSelectView.render()
            $("#root-backbone-view-body").html @productView.render(@model).el
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
            if productModel.attributes.subTotalQuantity.length
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
        template: _.template ($ '#root-backbone-content-template').html()
        initialize: ->
            @productCreateBodyView =  new ProductCreateBodyView()
            @storeSelectView = new StoreSelectView()
            @supplierSelectView = new SupplierSelectView()
            @storeSelectView.template = _.template ($ '#product-create-store-names-template').html()
        render: ->
            @$el.html this.template({})
            $("#root-backbone-view-body").html @productCreateBodyView.render().el
            $("#product-create-store-names").html @storeSelectView.render().el
            $("#product-create-supplier-names").html @supplierSelectView.render().el
            # $("#store-name-select").html @storeSelectView.render().el
    class ProductCreateBodyView extends Backbone.View
        events:
            "click input[type=radio]": "quantityOptionInput"
            "click #cancel-sub-total-options": "cancelSubTotalOptions"
            "click #save-sub-total-options": "saveSubTotalOptions"
            "click #create-new-product-button": "checkValidityAndCreateNewProduct"
        template: _.template ($ '#product-create-template').html()
        render: ->
            @$el.html this.template({})
            @setJQueryValidityRules()
            @
        setJQueryValidityRules: ->
            @validateForm @$("#create-product-form"),
                productName:
                    required: true
                brand:
                    required: true
                category:
                    required: true
                price:
                    required: true
                    decimalTwo: true
                    min: 0.01
                cost:
                    required: true
                    decimalTwo: true
                    min: 0.01
                grandTotal:
                    required: true
                    min: 1
        checkValidityAndCreateNewProduct: (e) ->
            e.preventDefault()
            $("#main-alert-div").html("")
            passesJQueryValidation = @$("#create-product-form").valid()

            if passesJQueryValidation
                isExistingProduct = app.Products.ifModelExists(
                    $('#name-input').val(), $('#brand-input').val())
                hasSubQuants = $("#grand-total-quantity-content").is(":hidden")

                if isExistingProduct
                    message = "You already have a product by this name. " +
                        "Please Change the product name and/or brand"
                    alertWarning = new app.AlertView
                    $("#main-alert-div").html(alertWarning.render( "alert-error", message).el)
                    console.log "didn't pass existing product check"
                    return # not valid

                if hasSubQuants
                    # first get the values for all the subquant table cells
                    subQuantTypes = []
                    subQuantValues = []
                    $("th").each ->
                        subQuantTypes.push $(this).html()
                    $("td").each ->
                        if $(this).html() isnt "Totals"
                            subQuantValues.push $(this).find("input").val()

                    if not @subQuantTotalValid(subQuantTypes, subQuantValues)
                        console.log "didn't pass subquants val"
                        return # not valid
                    return @createNewProduct
                        subQuantTypes: subQuantTypes
                        subQuantValues: subQuantValues

                # made it here means the form is completely valid!
                console.log "valid"
                @createNewProduct()
            else
                console.log "didn't pass $ val"
                return # not valid
        createNewProduct: (subQuants) ->
            name = $("#name-input").val()
            brand = $("#brand-input").val()
            category = $("#category-input").val()
            price = parseFloat($("#price-input").val(), 10) * 100
            cost = parseFloat($("#cost-input").val(), 10) * 100
            storeName = $("#store-name-select").val()
            totalQuantity = 0
            subTotalQuantity = []

            if subQuants
                # this product has a subTotalQuantity
                totalQuantity += parseInt(quant, 10) for quant in subQuants.subQuantValues
                for quantity, i in subQuants.subQuantValues
                    subTotalQuantity.push
                        measurementName: subQuants.subQuantTypes[0]
                        measurementValue: subQuants.subQuantTypes[i+1]
                        quantity: quantity
            else
                # this product has a GrandTotalQuantity
                totalQuantity = parseInt $("#grand-total-input").val(), 10

            productModel =
                description:
                    name: name
                    brand: brand
                storeName: storeName
                category: category
                price: price
                cost: cost
                totalQuantity: totalQuantity
                subTotalQuantity: subTotalQuantity
            console.log productModel
            app.Products.create productModel

        subQuantTotalValid: (types, values) ->
            # check to see if table sub quants are valid
            oneValueMoreThan0 = false
            anyValuesLessThan0 = false
            for value in values
                if parseInt(value, 10) > 0
                    oneValueMoreThan0 = true
                if parseInt(value, 10) < 0
                    anyValuesLessThan0 = true
            if not oneValueMoreThan0 or anyValuesLessThan0
                message = "For sub quantity totals, you must have at" +
                    " least one value higher than 0. Only numbers are" +
                    " accepted."
                alertWarning = new app.AlertView
                $("#main-alert-div").html(alertWarning.render(
                    "alert-error alert-block", message).el)
                return false
            return true

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
                    quantity: '<input class="input-mini" type="text" value="0">'
            $('#sub-total-quantity-content')
                .html (new ProductItemSubQuantityView()).render(productSubQuants).el


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

    @app = window.app ? {}
    @app.InventoryControllerView = InventoryControllerView

