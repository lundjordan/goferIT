# Inventory Views

# TODO Refactor. This code is all original bbone views. Many instances of
# repetitive code and is also not very readable
# The people views (supplier, customer, and employee) all share code and are
# clean versions for list, view, create, update and destroy

jQuery ->
    class ProductControllerView extends Backbone.View
        el: '#products-main-view'
        events:
            'click #products-list-tab': 'renderProductsListView'
            'click #product-item-tab': 'renderProductDefaultItemView'
            'click #product-create-tab': 'renderProductCreateView'
        initialize: ->
            @currentView = null
        renderProductsListView: ->
            @removeCurrentContentView()
            @currentView = new app.GenericListView
                collection: app.Products
                storeSelectView: ProductsListStoreSelectView
                tableTemplate: '#products-table-template'
                tableListID: '#products-table-list'
                itemTrTemplate: '#product-tr-template'
                deleteModalTemplate: '#product-view-delete-template'
                ItemsTableClass: ProductsListTable # this overrides GenericItemsTable
                itemControllerView: @
            $("#products-list-view-content").html @currentView.render().el
        renderProductDefaultItemView: ->
            @removeCurrentContentView()
            @currentView = new ProductItemView
                itemControllerView: @
            $("#product-item-view-content").html(
                (@currentView.render app.Products.models[0]).el)
        renderSpecificItemView: (model) ->
            @removeCurrentContentView()
            $('#product-item-tab a').tab('show')
            @currentView = new ProductItemView
                itemControllerView: @
            $("#product-item-view-content").html (@currentView.render model).el
        renderProductCreateView: ->
            @removeCurrentContentView()
            @currentView = new ProductCreateView
                template: '#product-create-template'
            $("#product-create-view-content").html @currentView.render().el
        renderSpecificEditView: (model) ->
            @removeCurrentContentView()
            $('#product-create-tab a').tab('show')
            @currentView = new ProductCreateView
                template: '#product-edit-template'
                model: model
            $("#product-create-view-content").html @currentView.render().el

        removeCurrentContentView: ->
            if @currentView
                @currentView.remove()

    # ###############
    # HELPER CLASSES -> SHARED
    class SupplierSelectView extends Backbone.View
        template: _.template ($ '#product-create-supplier-names-template').html()
        render: ->
            @$el.html this.template({})
            supplierNames = app.Suppliers.pluck "name"
            @addToSelect(name) for name in supplierNames
            if @model # we are in edit mode
                if @model.get '_order'
                    # set the select tag to the model's supplier name is
                    supplierName = app.Suppliers.
                        get(@model.attributes._order._supplier).get 'name'
                    @$("select[id=supplier-name-select]").val(supplierName)
            @
        addToSelect: (supplierName) ->
            @$('#supplier-name-select').append(
                "<option value='#{supplierName}'>#{supplierName}</option>")
    class ProductsListStoreSelectView extends app.StoreSelectView
        template: _.template ($ '#store-names-template').html()
    class ProductItemSubQuantityView extends Backbone.View
        template: _.template ($ '#product-view-sub-quantity-template').html()
        render: (individualProducts, measurementFactor) ->
            @$el.html this.template({})

            # now let's add column 1 name and row 1 titles
            tableHeaderValues = "<th>#{measurementFactor}</th>"
            tableRow1Values = "<td>Totals</td>"

            # fill in the remaining rows/columns with the subquants
            _.each individualProducts, (elem) ->
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
    class ProductsListTable extends app.GenericItemsTable
        addBasedByStoreName: (product) ->
            storeQuantityCount = 0
            for individualProperty in product.get('individualProperties')
                if individualProperty.storeName is @storeName
                    storeQuantityCount = storeQuantityCount + 1

            view = new ProductListItemView
                model: product
                template: @itemTrTemplate
                itemControllerView: @itemControllerView
                deleteModalTemplate: @deleteModalTemplate
                storeQuantityCount: storeQuantityCount
            (@$ @tableListID).append view.render().el
    class ProductListItemView extends app.GenericSingleListItemView
        initialize: ->
            @template = _.template ($ @options.template).html()
            @itemControllerView = @options.itemControllerView
            @deleteModalTemplate = @options.deleteModalTemplate
            @storeQuantityCount = @options.storeQuantityCount
        render: ->
            renderObject = @model.attributes
            renderObject.storeQuantityCount = @storeQuantityCount
            @$el.html this.template renderObject
            $(@el).find('i').hide()
            @

# ###############
    # Product Single View Section
    class ProductItemView extends Backbone.View
        template: _.template ($ '#root-backbone-content-template').html()
        events:
            'click #product-item-prev-link': 'renderProductItemPrevView'
            'click #product-item-next-link': 'renderProductItemNextView'
            'click #item-view-edit-link': 'renderSpecificEditView'
            'click #item-view-delete-link': 'renderSpecificDeleteView'
        initialize: (options) ->
            @listenTo app.Products, 'remove', @renderProductItemNextView
            @productView =  new ProductItemBodyView()
            @itemControllerView = @options.itemControllerView
        render: (productModel) ->
            @model = productModel
            @$el.html this.template({})
            @$("#root-backbone-view-body").html @productView.render(@model).el
            @
        renderProductItemPrevView: (event) ->
            @model = app.Products.findPrev @model
            @productView.render @model
        renderProductItemNextView: (event) ->
            @model = app.Products.findNext @model
            @productView.render @model
        renderSpecificEditView: (model) ->
            @itemControllerView.renderSpecificEditView @model
        renderSpecificDeleteView: ->
            @deleteView =  new app.ConfirmDeleteModal
                model: @model
                template: '#product-view-delete-template'
            $("#root-backbone-view-body").append @deleteView.render().el
            $('#delete-item-modal').on 'hidden', =>
                @deleteView.remove()
            $("#delete-item-modal").modal 'show'
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
            @currentProductSubQuantity = new ProductItemSubQuantityView()
            @$('#product-view-content')
                .html @currentProduct.render(productModel).el
            if productModel.get('primaryMeasurementFactor') isnt null
                # first let's sort the subquantities for readibility in table
                individualProducts = []
                individualProps = productModel.get('individualProperties')
                subTotalTotals = _.countBy individualProps, (elem) ->
                    elem.measurements[0]['value']
                for subTotalValues in productModel.get 'measurementPossibleValues'
                    individualProducts.push
                        measurementValue: subTotalValues
                        quantity: subTotalTotals[subTotalValues] or 0
                individualProducts = _.sortBy individualProducts, (el) ->
                    return el.measurementValue
                @$('#sub-quantity-totals')
                    .html @currentProductSubQuantity.render(individualProducts,
                        productModel.get('primaryMeasurementFactor')).el
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

    # ###############
    # Product Create Section
    class ProductCreateView extends Backbone.View
        template: _.template ($ '#root-backbone-content-template').html()
        initialize: ->
            @productCreateBodyView =  new ProductCreateBodyView
                model: @options.model
                template: @options.template
            @storeSelectView = new app.StoreSelectView
                model: @options.model
            @supplierSelectView = new SupplierSelectView
                model: @options.model
            @storeSelectView.template = _.template ($ '#product-create-store-names-template').html()
        render: ->
            @$el.html this.template({})
            # @$("#root-backbone-view-head").html @productcreatebodyview.render().el
            @$("#root-backbone-view-body").html @productCreateBodyView.render().el
            @$("#product-create-store-names").html @storeSelectView.render().el
            @$("#product-create-supplier-names").
                html @supplierSelectView.render().el
            if @model # we are in edit mode
                if @model.get('primaryMeasurementFactor') isnt null
                    # first let's sort the subquantities for readibility in table
                    individualProducts = []
                    individualProps = @model.get('individualProperties')
                    subTotalTotals = _.countBy individualProps, (elem) ->
                        elem.measurements[0]['value']
                    for subTotalValues in @model.get 'measurementPossibleValues'
                        individualProducts.push
                            measurementValue: subTotalValues
                            quantity: "<input class='input-mini' type='text' " +
                                "value='#{subTotalTotals[subTotalValues] or 0}'>"
                    individualProducts = _.sortBy individualProducts, (el) ->
                        return el.measurementValue
                    subQuantView = new ProductItemSubQuantityView()
                    subQuantHTML = subQuantView.render(individualProducts,
                        @model.get('primaryMeasurementFactor')).el
                    @$('#sub-total-quantity-content').html subQuantHTML
            @
    class ProductCreateBodyView extends Backbone.View
        events:
            "click input[type=radio]": "quantityOptionInput"
            "click #cancel-sub-total-options": "cancelSubTotalOptions"
            "click #save-sub-total-options": "saveSubTotalOptions"
            "click #create-new-product-button": "checkValidityAndCreateNewProduct"
            "click #update-existing-product-button": "checkValidityAndUpdateProduct"
        initialize: ->
            @template = _.template ($ @options.template).html()
        render: ->
            if @model
                @$el.html @template(@model.attributes)
            else
                @$el.html @template({})
            @setJQueryValidityRules()
            @
        setJQueryValidityRules: ->
            @validateForm @$("#product-form"),
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
        checkValidityAndUpdateProduct: (e) ->
            # TODO clean up this method and remove DRY code from this and
            # checkValidityAndCreateNewProduct()
            e.preventDefault()
            $("#main-alert-div").html("")
            passesJQueryValidation = @$("#product-form").valid()
            if passesJQueryValidation
                if $("#grand-total-input").val() # only has grand total
                    @createOrUpdateProduct("Updated an existing product!") # valid
                else
                    # get the values for all the subquant table cells
                    subQuantTypes = []
                    subQuantValues = []
                    $("th").each ->
                        subQuantTypes.push $(this).html()
                    $("td").each ->
                        if $(this).html() isnt "Totals"
                            subQuantValues.push $(this).find("input").val()

                    if not @subQuantTotalValid(subQuantTypes, subQuantValues)
                        return # not valid
                    return @createOrUpdateProduct "Updated an existing product!",
                        subQuantTypes: subQuantTypes
                        subQuantValues: subQuantValues
        checkValidityAndCreateNewProduct: (e) ->
            e.preventDefault()
            $("#main-alert-div").html("")
            passesJQueryValidation = @$("#product-form").valid()

            if passesJQueryValidation
                isExistingProduct = app.Products.ifModelExists(
                    $('#name-input').val(), $('#brand-input').val())
                hasSubQuants = $("#grand-total-quantity-content").is(":hidden")

                if isExistingProduct
                    message = "There is already have a product by this name. " +
                        "Please Change the product name and/or brand"
                    alertWarningView = new app.AlertView
                        alertType: 'warning'
                    alertHTML = alertWarningView.render("alert-error", message).el
                    $("#root-backbone-alert-view").html(alertHTML)
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
                        return # not valid
                    return @createOrUpdateProduct "Added a new product!",
                        subQuantTypes: subQuantTypes
                        subQuantValues: subQuantValues

                # made it here means the form is completely valid!
                @createOrUpdateProduct "Added a new product!"
            else
                return # not valid
        createOrUpdateProduct: (successMessage, subQuants) ->
            name = $("#name-input").val()
            brand = $("#brand-input").val()
            category = $("#category-input").val()
            price = parseFloat($("#price-input").val(), 10) * 100
            cost = parseFloat($("#cost-input").val(), 10) * 100
            supplierName = $("#supplier-name-select").val()
            storeName = $("#store-name-select").val()
            individualProperties = []

            if subQuants
                primaryMeasurementFactor = subQuants.subQuantTypes[0]
                measurementPossibleValues = subQuants.subQuantTypes[1..]
                for quantity, i in subQuants.subQuantValues
                    if quantity isnt "0"
                        for individualProperty in [1..parseInt(quantity, 10)]
                            # we want to represent each product as an identity
                            individualProperties.push
                                storeName: storeName
                                sourceHistory:
                                    _supplier: app.Suppliers.where(
                                        {name: supplierName})[0].id or null
                                measurements: [
                                    factor: primaryMeasurementFactor
                                    value: subQuants.subQuantTypes[i+1]
                                ]
            else
                # this product has a GrandTotalQuantity
                primaryMeasurementFactor = null
                measurementPossibleValues = null
                totalQuantity = parseInt $("#grand-total-input").val(), 10
                for individualProperty in [1..totalQuantity]
                    # we want to represent each product as an identity
                    individualProperties.push
                        storeName: storeName
                        sourceHistory:
                            _supplier: app.Suppliers.where(
                                {name: supplierName})[0].id or null

            productModel =
                description:
                    name: name
                    brand: brand
                category: category
                price: price
                cost: cost
                primaryMeasurementFactor: primaryMeasurementFactor
                measurementPossibleValues: measurementPossibleValues
                individualProperties: individualProperties

            if @model # we are in edit mode
                @model.save productModel
            else
                app.Products.create productModel

            message = successMessage
            alertWarning = new app.AlertView
                alertType: 'success'
            $("#root-backbone-alert-view").
                html(alertWarning.render( "alert-success", message).el)

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
                message = "For sub quantity totals, there must be at" +
                    " least one value higher than: 0. Only positive numbers are" +
                    " accepted."
                alertWarning = new app.AlertView
                    alertType: 'warning'
                $("#root-backbone-alert-view").
                    html(alertWarning.render("alert-error alert-block", message).el)
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
                    measurementValue: columnName
                    quantity: '<input class="input-mini" type="text" value="0">'
            $('#sub-total-quantity-content')
                .html (new ProductItemSubQuantityView()).render(productSubQuants, measurementType).el


    # ###############



    @app = window.app ? {}
    @app.ProductControllerView = ProductControllerView
    @app.ProductItemSubQuantityView = ProductItemSubQuantityView
