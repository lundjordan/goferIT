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
        removeCurrentContentView: ->
            if @currentView
                @currentView.remove()

    # ###############
    # Order Create Section
    class SingleOrderProductView extends Backbone.View
        template: _.template ($ '#single-order-product-template').html()
        render: ->
            @$el.html this.template({})
            @
    class OrderCreateView extends Backbone.View
        template: _.template ($ '#root-backbone-content-template').html()
        initialize: ->
            @orderCreateBodyView =  new OrderCreateBodyView
                model: @options.model
                template: @options.template
            @storeSelectView = new app.StoreSelectView
                model: @options.model
            @supplierSelectView = new SupplierSelectView
                model: @options.model
            @singleOrderProductView = new SingleOrderProductView
            @storeSelectView.template = _.template ($ '#order-create-store-names-template').html()
        render: ->
            @$el.html this.template({})
            @$("#root-backbone-view-body").html @orderCreateBodyView.render().el
            @$("#order-create-store-names").html @storeSelectView.render().el
            @$("#order-create-supplier-names").
                html @supplierSelectView.render().el
            @$("#single-order-product-div").
                html @singleOrderProductView.render().el
            @
    class OrderCreateBodyView extends Backbone.View
        events:
            "click input[type=radio]": "quantityOptionInput"
            "click #cancel-sub-total-options": "cancelSubTotalOptions"
            "click #save-sub-total-options": "saveSubTotalOptions"
            "click #create-new-order-button": "checkValidityAndCreateNewOrder"
            "click #update-existing-order-button": "checkValidityAndUpdateOrder"
        initialize: ->
            @template = _.template ($ @options.template).html()
        render: ->
            if @model
                @$el.html @template(@model.attributes)
            else
                @$el.html @template({})
            @setBootstrapFormHelperInputs()
            @setJQueryValidityRules()
            @
        setBootstrapFormHelperInputs: ->
            @$('div.bfh-datepicker').each ->
                inputField = $(this)
                inputField.bfhdatepicker inputField.data()
        setJQueryValidityRules: ->
            @validateForm @$("#order-form"),
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
        checkValidityAndCreateNewOrder: (e) ->
            e.preventDefault()
            $("#main-alert-div").html("")
            passesJQueryValidation = @$("#order-form").valid()

            if passesJQueryValidation
                isExistingProduct = app.Products.ifModelExists(
                    $('#name-input').val(), $('#brand-input').val())
                hasSubQuants = $("#grand-total-quantity-content").is(":hidden")

                if isExistingProduct
                    message = "There is already have a order by this reference " +
                        "Number. Please Change the order name and/or brand"
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
                    return @createOrUpdateProduct "Added a new order!",
                        subQuantTypes: subQuantTypes
                        subQuantValues: subQuantValues

                # made it here means the form is completely valid!
                @createOrUpdateProduct "Added a new order!"
            else
                return # not valid
        createOrUpdateProduct: (successMessage, subQuants) ->
            name = $("#name-input").val()
            brand = $("#brand-input").val()
            category = $("#category-input").val()
            price = parseFloat($("#price-input").val(), 10) * 100
            cost = parseFloat($("#cost-input").val(), 10) * 100
            storeName = $("#store-name-select").val()
            totalQuantity = 0
            subTotalQuantity = []

            if subQuants
                # this order has a subTotalQuantity
                totalQuantity += parseInt(quant, 10) for quant in subQuants.subQuantValues
                for quantity, i in subQuants.subQuantValues
                    subTotalQuantity.push
                        measurementName: subQuants.subQuantTypes[0]
                        measurementValue: subQuants.subQuantTypes[i+1]
                        quantity: quantity
            else
                # this order has a GrandTotalQuantity
                totalQuantity = parseInt $("#grand-total-input").val(), 10

            orderModel =
                description:
                    name: name
                    brand: brand
                storeName: storeName
                category: category
                price: price
                cost: cost
                totalQuantity: totalQuantity
                subTotalQuantity: subTotalQuantity
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
                alertWarning = new app.AlertView 'error'
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


    # ###############

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


    @app = window.app ? {}
    @app.OrderControllerView = OrderControllerView
