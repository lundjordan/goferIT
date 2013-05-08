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
        renderOrderCreateView: ->
            @removeCurrentContentView()
            @currentView = new OrderCreateView
                template: '#order-create-template'
            $("#order-create-view-content").html @currentView.render().el
        preSingleItemContentHook: (orderModel) ->
            @modelAttrsWithSupplier(orderModel)
        preSingleListItemHook: (orderModel) ->
            @modelAttrsWithSupplier(orderModel)
        modelAttrsWithSupplier: (orderModel) ->
            supplierID = orderModel.get '_supplier'
            supplierModel = app.Suppliers.get supplierID
            if supplierModel
                supplierName = supplierModel.get("name")
            else
                supplierName = "N/A"
            _.extend
                supplierName: supplierName
            ,
                orderModel.attributes
        removeCurrentContentView: ->
            if @currentView
                @currentView.remove()
    # ###############



    # ###############
    # Order Single View Section
    class OrderSingleView extends app.GenericSingleView
        events:
            'click #mark-order-arrived-link': 'markOrderArrived'
            'click #single-item-prev-link': 'renderSingleItemPrevView'
            'click #single-item-next-link': 'renderSingleItemNextView'
            'click #item-view-edit-link': 'renderSpecificEditView'
            'click #item-view-delete-link': 'renderSpecificDeleteView'
        initialize: (options) ->
            super()
            @listenTo @collection, 'change', @renderOrderHasArrived
        renderOrderHasArrived: (currentModel) ->
            @render(currentModel)
            orderProductsTable = new OrderProductsTable
                model: @currentModel
            $("#order-products-list").html (orderProductsTable.render()).el
            orderProductsTable.addAll()
            @orderMarkedAsArrivedAlert()
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
        markOrderArrived: () ->
            # first we need to set the order as arrived with a date
            # doing so fires an event to re render the single view template
            # and alert user that order's products have been put in stock
            @currentModel.save
                dateArrived: (new Date()).toISOString()

            # now we need to add the products in the order to our existing
            # stock
            for orderProduct in @currentModel.get("products")
                # first delete the _id property of this orderProduct
                # as it will just confuse mongo on creation 
                delete orderProduct._id

                # then add the storeName from the order
                # and the supplier / order reference to each product
                for indiProduct in orderProduct.individualProperties
                    # also delete all the generated _ids from subdocs
                    if indiProduct.measurements
                        for measurement in indiProduct.measurements
                            delete measurement._id
                    delete indiProduct._id
                    indiProduct.storeName = @currentModel.get "storeName"
                    indiProduct.sourceHistory =
                        _order: @currentModel.get "_id"
                        _supplier: @currentModel.get("_supplier")._id
                # now check to see if this product in the order exists
                isExistingProduct = app.Products.ifModelExists(
                    orderProduct.description.name,
                    orderProduct.description.brand
                )
                if isExistingProduct
                    # grab that existing product in our stock
                    existingProduct = app.Products.where(
                        'description.name': orderProduct.description.name
                        'description.brand': orderProduct.description.brand
                    )[0]
                    newIndividualProperties =
                        existingProduct.get "individualProperties"
                    newPossibleValues = null

                    # now concat the existing and new product indi properties
                    for orderProductProperty in orderProduct.individualProperties
                        newIndividualProperties.push orderProductProperty

                    # find the union of existing and new product possibleValues
                    if existingProduct.get("primaryMeasurementFactor") isnt null
                        existingPossibleValues =
                            existingProduct.get("measurementPossibleValues")
                        orderProductPossibleValues =
                            orderProduct.measurementPossibleValues
                        newPossibleValues = _.union(existingPossibleValues,
                            orderProductPossibleValues)
                    existingProduct.save
                        measurementPossibleValues: newPossibleValues
                        individualProperties: newIndividualProperties
                else
                    # product does not exist so create a whole new one
                    app.Products.create orderProduct
        orderMarkedAsArrivedAlert: ->
            message = "Order Arrived! Products have been added to your stock."
            alertWarningView = new app.AlertView
                alertType: 'info'
            alertHTML = alertWarningView.
                render("alert-info", message).el
            $("#root-backbone-alert-view").html(alertHTML)
    class OrderProductsTable extends Backbone.View
        template: _.template ($ '#order-products-table-template').html()
        render: ->
            @$el.html this.template({})
            @
        addOne: (orderProduct) ->
            view = new OrderProductListItemView
                orderProduct: orderProduct
            ($ "#products-table-list").append view.render().el
        addAll: ->
            _.each @model.attributes.products, @addOne
    class OrderProductListItemView extends Backbone.View
        template: _.template ($ '#order-product-tr-template').html()
        tagName: 'tr'
        initialize: ->
            @orderProduct = @options.orderProduct
        render: ->
            @$el.html this.template @orderProduct
            @
    # ###############


    # ###############
    # Order Create Section
    class OrderCreateView extends Backbone.View
        events:
            "click #add-new-order-product": "renderAddNewOrderProductForm"
            "click #create-new-order-product": "checkValidityAndAddNewOrderProduct"
            "click #cancel-new-order-product": "renderOrderProductSummaryView"
            "click #create-new-order-button": "checkValidityAndCreateNewOrder"
            "click #clear-new-order-button": "clearNewOrderForm"
        template: _.template ($ '#root-backbone-content-template').html()
        initialize: ->
            @orderCreateBodyView =  new OrderCreateBodyView
                template: @options.template
            @storeSelectView = new app.StoreSelectView
            @storeSelectView.template = _.template(
                ($ '#order-create-store-names-template').html())
            @supplierSelectView = new SupplierSelectView
            @orderProductsView = new OrderProductSummaryView
            # @singleOrderProductView = new SingleOrderProductView
            # @orderProductSummaryView = new OrderProductSummaryView
            @currentOrderProducts = []
        render: ->
            @$el.html this.template({})
            @$("#root-backbone-view-body").html(
                @orderCreateBodyView.render().el)
            @$("#order-create-store-names").html(
                @storeSelectView.render().el)
            @$("#order-create-supplier-names").
                html @supplierSelectView.render().el
            @renderOrderProductSummaryView()
            @
        renderOrderProductSummaryView: ->
            @orderProductsView = new OrderProductSummaryView
            @$("#order-products-div").html(
                @orderProductsView.render(
                    @currentOrderProducts.length).el)
        renderAddNewOrderProductForm: ->
            @orderProductsView = new SingleOrderProductView
            @$("#order-products-div").
                html @orderProductsView.render().el
        checkValidityAndAddNewOrderProduct: (e) ->
            e.preventDefault()
            productAdded = @orderProductsView.
                checkValidityAndAddNewOrderProduct()
            if productAdded
                @currentOrderProducts.push productAdded
                @renderOrderProductSummaryView()
        checkValidityAndCreateNewOrder: (e) ->
            e.preventDefault()
            @orderCreateBodyView.checkValidityAndCreateNewOrder(
                @currentOrderProducts)
        clearNewOrderForm: ->
            $("#order-create-tab").click()
    class OrderCreateBodyView extends Backbone.View
        initialize: ->
            @template = _.template ($ @options.template).html()
        render: ->
            @$el.html @template({})
            @setBootstrapFormHelperInputs()
            @setJQueryOrderValidityRules()
            @
        setBootstrapFormHelperInputs: ->
            @$('div.bfh-datepicker').each ->
                inputField = $(this)
                inputField.bfhdatepicker inputField.data()
        setJQueryOrderValidityRules: ->
            @validateForm @$("#order-form"),
                refNum:
                    required: true
                supplierSelect:
                    required: true
        checkValidityAndCreateNewOrder: (currentProducts) ->
            $("#main-alert-div").html("")
            if $("#order-product-form").html()
                # new product form still incomplete
                return @finishProductCreationAlert()
            else
                passesJQueryValidation = @$("#order-form").valid()
                if passesJQueryValidation
                    # now check if
                    isUniqueOrder = app.Orders.where(
                        referenceNum: $("#refNum-input").val()).length < 1
                    if not isUniqueOrder
                        # not valid
                        return @orderExistsAlert()
                    else
                        if currentProducts.length is 0
                            return @orderHasNoProductsAlert()
                        else
                            # time to create an order!
                            @createNewOrder(currentProducts)
                else
                    return
        createNewOrder: (currentProducts) ->
            referenceNum = $("#refNum-input").val()
            supplier = app.Suppliers.where(
                {name: $("#supplier-name-select").val()})[0].id or null
            storeName = $("#store-name-select").val()
            shipCompany = $("#ship-company-input").val()
            cost = parseFloat($("#ship-cost-input").val(), 10) * 100
            estArrival = $("#est-arrival-input").val()

            order =
                referenceNum: referenceNum
                _supplier: supplier
                storeName: storeName
                products: currentProducts
                shippingInfo:
                    company: shipCompany
                    cost: cost
                estimatedArrivalDate: estArrival
            app.Orders.create order
            @orderCreatedAlert()
        orderExistsAlert: -> # alerts!!! TODO all these cleaner
            message = "There is already have a order by this reference " +
                "Number. Please Change the order name and/or brand"
            alertWarningView = new app.AlertView
                alertType: 'warning'
            alertHTML = alertWarningView.render("alert-error", message).el
            $("#root-backbone-alert-view").html(alertHTML)
        orderHasNoProductsAlert: ->
            message = "You must have at least one product in your order"
            alertWarningView = new app.AlertView
                alertType: 'warning'
            alertHTML = alertWarningView.render("alert-error", message).el
            $("#root-backbone-alert-view").html(alertHTML)
        orderCreatedAlert: ->
            message = "Order Created!"
            alertWarningView = new app.AlertView
                alertType: 'success'
            alertHTML = alertWarningView.
                render("alert-success", message).el
            $("#root-backbone-alert-view").html(alertHTML)
        finishProductCreationAlert: ->
            message = "You must finish creating the new product in your " +
                "order. If you do not wish to do so, click cancel"
            alertWarningView = new app.AlertView
                alertType: 'warning'
            alertHTML = alertWarningView.render("alert-error", message).el
            $("#root-backbone-alert-view").html(alertHTML)
    class SingleOrderProductView extends Backbone.View
        # TODO combine this code from the following class
        # implementation to improve DRY: ProductCreateView
        events:
            "click input[type=radio]": "quantityOptionInput"
            "click #cancel-sub-total-options": "cancelSubTotalOptions"
            "click #save-sub-total-options": "saveSubTotalOptions"
        template: _.template ($ '#single-order-product-template').html()
        render: ->
            @$el.html this.template({})
            @setJQueryProductOrderValidityRules()
            @
        setJQueryProductOrderValidityRules: ->
            @validateForm @$("#order-product-form"),
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
        checkValidityAndAddNewOrderProduct: ->
            passesJQueryValidation = @$("#order-product-form").valid()
            if passesJQueryValidation
                # TODO add check to see if we have already added
                # this product to the order
                hasSubQuants = $("#grand-total-quantity-content").
                    is(":hidden")
                if hasSubQuants
                    # first get the values for all the subquant table cells
                    subQuantTypes = []
                    subQuantValues = []
                    $("th.order-prod-sub-quant").each ->
                        subQuantTypes.push $(this).html()
                    $("td.order-prod-sub-quant").each ->
                        if $(this).html() isnt "Totals"
                            subQuantValues.push $(this).find("input").val()
                    if not @subQuantTotalValid(
                        subQuantTypes, subQuantValues)
                        return false # not valid
                    return @appendProductToOrder
                        subQuantTypes: subQuantTypes
                        subQuantValues: subQuantValues
                return @appendProductToOrder()
                # added product to order
            else
                return false # failed $ validation
        appendProductToOrder: (subQuants) ->
            name = $("#name-input").val()
            brand = $("#brand-input").val()
            category = $("#category-input").val()
            price = parseFloat($("#price-input").val(), 10) * 100
            cost = parseFloat($("#cost-input").val(), 10) * 100
            individualProperties = []

            if subQuants
                # this product has a subTotalQuantity
                primaryMeasurementFactor = subQuants.subQuantTypes[0]
                measurementPossibleValues = subQuants.subQuantTypes[1..]
                for quantity, i in subQuants.subQuantValues
                    if quantity isnt "0"
                        for individualProperty in [1..parseInt(quantity, 10)]
                            # we want to represent each product as an identity
                            individualProperties.push
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
                    individualProperties.push {}

            orderProduct =
                description:
                    name: name
                    brand: brand
                category: category
                price: price
                cost: cost
                primaryMeasurementFactor: primaryMeasurementFactor
                measurementPossibleValues: measurementPossibleValues
                individualProperties: individualProperties
            return orderProduct
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
                @orderProductSubQuantsInvalidAlert()
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
                    quantity: '<input class="input-mini" ' +
                        'type="text" value="0">'
            $('#sub-total-quantity-content')
                .html (new ProductItemSubQuantityView()).render(productSubQuants).el
        orderProductSubQuantsInvalidAlert: ->
            message = "For sub quantity totals, there must be at" +
                " least one value higher than: 0. Only positive" +
                " numbers are accepted."
            alertWarningView = new app.AlertView
                alertType: 'warning'
            alertHTML = alertWarningView.render("alert-error", message).el
            $("#root-backbone-alert-view").html(alertHTML)
    class OrderProductSummaryView extends Backbone.View
        template: _.template ($ '#order-product-summary-template').html()
        render: (productsLength) ->
            @$el.html this.template({productsTotal: productsLength})
            @
    # ###############




    # ###############
    # HELPER CLASSES -> SHARED <- TODO THESE CLASSES ARE DUPS FROM
    # product_views.coffee
    class SupplierSelectView extends Backbone.View
        template: _.template ($ '#order-create-supplier-names-template').html()
        render: ->
            @$el.html this.template({})
            supplierNames = app.Suppliers.pluck "name"
            @addToSelect(name) for name in supplierNames
            if @model # we are in edit mode
                if @model.attributes._order
                    # set the select tag to the model's supplier name is
                    supplierName = app.Suppliers.
                        get(@model.attributes._order._supplier).get 'name'
                    @$("select[id=supplier-name-select]").val(supplierName)
            @
        addToSelect: (supplierName) ->
            @$('#supplier-name-select').append(
                "<option value='#{supplierName}'>#{supplierName}</option>")
    class ProductItemSubQuantityView extends Backbone.View
        # TODO this is a copy from class in product_views.coffee
        template: _.template ($ '#product-view-sub-quantity-template').html()
        render: (productSubQuants) ->
            @$el.html this.template({})

            # now let's add column 1 name and row 1 titles
            tableHeaderValues = "<th class='order-prod-sub-quant'>#{productSubQuants[0].measurementName}</th>"
            tableRow1Values = "<td class='order-prod-sub-quant'>Totals</td>"

            # fill in the remaining rows/columns with the subquants
            _.each productSubQuants, (elem) ->
                tableHeaderValues += "<th class='order-prod-sub-quant'>#{elem.measurementValue}</th>"
                tableRow1Values += "<td class='order-prod-sub-quant'>#{elem.quantity}</td>"

            # finally append this to their respective th and td tags
            @$('#product-sub-quantity-thead-tr').append tableHeaderValues
            @$('#product-sub-quantity-tbody-td').append tableRow1Values

            @
    # ###############


    @app = window.app ? {}
    @app.OrderControllerView = OrderControllerView
