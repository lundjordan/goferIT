# POS Views

jQuery ->
    class SalesControllerView extends Backbone.View
        el: '#sales-main-view'
        events:
            'click #payment-btn': 'renderSalesPaymentView'
            'click #back-to-construct-btn': 'renderSalesConstructView'
            'click #cancel-sale-btn': 'cancelCurrentSale'
            'click #sale-confirm-btn': 'createSale'
        initialize: ->
            @currentView = null
            currentUserEmail = $("#current-user-email-id").text()
            @currentSale = new app.Sale({})
            @listenTo @currentSale, 'change', @renderSalesConstructView
        getCurrentSale: ->
            @currentSale
        renderInitSalesConstructView: ->
            if @currentSale
                @stopListening()
                currentUserEmail = $("#current-user-email-id").text()
                employeeModel = app.Employees.findWhere({email: currentUserEmail})
                @currentSale = new app.Sale
                    _employee: employeeModel.id
                    storeName: app.Companies.at(0).get('stores')[0].name
            @renderSalesConstructView()
        renderSalesConstructView: ->
            @listenTo @currentSale, 'change', @renderSalesConstructView
            if @currentView
                @currentView.remove()
            @currentView = new SalesConstructControllerView
                controller: @ # bubble this all the way down
            # not the best way but @ is needed in AddToTransactionModal
            $("#sales-main-view").html @currentView.render().el
        renderSalesPaymentView: ->
            #stop listening  when in this view so we don't render anything from
            #renderSalesConstructView
            @stopListening()
            if @currentSale.get('products').length
                if @currentView
                    @currentView.remove()
                @currentView = new SalesPaymentControllerView
                    collection: app.Sales
                    controller: @ # bubble this all the way down
                $("#sales-main-view").html @currentView.render().el
            else
                message = "To make a payment you must have at least " +
                    "one item in the transaction list."
                alertWarningView = new app.AlertView
                    alertType: 'warning'
                alertHTML = alertWarningView.render("alert-error", message).el
                $("#root-backbone-alert-view").html(alertHTML)
        cancelCurrentSale: ->
            for product in @currentSale.get 'products'
                productFromStock = app.Products.findWhere
                    'description.name': product.description.name
                    'description.brand': product.description.brand
                productFromStock.applyUndo()
            # now put the sale back to an initial state
            @currentSale.clear({silent: true})
            @currentSale.set
                products: []
                dateCreated: (new Date).toISOString()
        removeCurrentContentView: ->
            if @currentView
                # clean up incomplete transaction
                @cancelCurrentSale()
                @currentView.remove()
        createSale: ->
            # first let's clean up the products with mementos and save them
            for product in @currentSale.get 'products'
                productFromStock = app.Products.findWhere
                    'description.name': product.description.name
                    'description.brand': product.description.brand
                productFromStock.removeMemento()
                productFromStock.save()
            # then take the current selected payment method
            # TODO not implemented
            # save the currentSale to the Sales collection
            app.Sales.create(@currentSale.attributes)
            # finally render the sales init view with a success alert
            @renderInitSalesConstructView()
            message = "Sale created!"
            alertSuccessView = new app.AlertView
                alertType: 'success'
            alertHTML = alertSuccessView.render("alert-success", message).el
            $("#root-backbone-alert-view").html(alertHTML)
        addSelectedToTransaction: (productModel, addToTransactionData) ->
            # first let's capture the current state of the product in case we
            # want to revert (cancel a sale)
            if productModel.currentMementoIsNull()
                # we only want to capture the state once!
                productModel.captureState()

            individualProds = productModel.get 'individualProperties'
            requiredStoreName = $('#store-name-select option:selected').val()
            for subTotal, i in addToTransactionData.measurementsAvailable
                # we have subValues
                value = addToTransactionData.measurementValues[i]
                available =
                    parseInt(addToTransactionData.measurementsAvailable[i], 10)
                wanted = parseInt(addToTransactionData.measurementsWanted[i],10)
                willBeRemaining = available - wanted
                if wanted > 0 # the user selected a value higher 
                    if value # we have subtypes
                        allProdsByRequest = $.grep individualProds, (elem) ->
                            elem.measurements[0].value is value and
                                elem.storeName is requiredStoreName
                        allProdsWithoutRequest = $.grep individualProds, (elem) ->
                            elem.measurements[0].value isnt value or
                                elem.storeName isnt requiredStoreName
                    else # there is just a grand total
                        allProdsByRequest = $.grep individualProds, (elem) ->
                            elem.storeName is requiredStoreName
                        allProdsWithoutRequest = $.grep individualProds, (elem) ->
                            elem.storeName isnt requiredStoreName
                    if willBeRemaining
                        for i in [1..willBeRemaining]
                            extraProdsFromRequest = allProdsByRequest[i-1]
                            allProdsByRequest.splice i-1, 1
                            allProdsWithoutRequest.push extraProdsFromRequest
                    for productToAdd in allProdsByRequest
                        # first delete the _id property of this product
                        # as it will just confuse mongo on creation
                        delete productToAdd._id
                        if productToAdd.measurements
                            for measurement in productToAdd.measurements
                                # also delete all generated _ids from subdocs
                                delete measurement._id
                    @updateProductsInSale(productModel, allProdsByRequest)
                    productModel.set
                        individualProperties: allProdsWithoutRequest
            $("#add-to-transaction-modal").modal 'hide'
            @renderSalesConstructView()
        updateProductsInSale: (productModel, allProdsByRequest) ->
            productName = productModel.get 'description.name'
            productBrand = productModel.get 'description.brand'
            existingProduct =  @currentSale.
                getProductIfExists productName, productBrand
            if existingProduct # this item is already in transaction list
                productIndex =
                    @currentSale.get('products').indexOf(existingProduct)
                currentProducts = @currentSale.get('products')
                newIndividualProps =
                    currentProducts[productIndex].
                    individualProperties.concat allProdsByRequest
                currentProducts[productIndex].individualProperties =
                    newIndividualProps
            else # currentSale does have this product in its list
                @currentSale.get('products').push
                    description:
                        name: productModel.get 'description.name'
                        brand: productModel.get 'description.brand'
                    category: productModel.get 'category'
                    price: productModel.get 'price'
                    cost: productModel.get 'cost'
                    primaryMeasurementFactor:
                        productModel.get 'primaryMeasurementFactor'
                    individualProperties: allProdsByRequest
        addCustomerToSale: (customer) ->
            # this should fire an event to render construct view again
            @currentSale.set
                _customer: customer.get '_id'

    class SalesConstructSkeletonView extends Backbone.View
        template: _.template ($ '#sales-construct-skeleton-template').html()
        render: ->
            @$el.html this.template({})
            @

    class SalesPaymentSkeletonView extends Backbone.View
        template: _.template ($ '#sales-payment-skeleton-template').html()
        render: ->
            @$el.html this.template({})
            @
    class SalesPaymentControllerView extends Backbone.View
        template: _.template ($ '#root-backbone-content-template').html()
        events: ->
            "click #cash-btn": "renderCashDetails"
            "click #credit-btn": "renderCardDetails"
            "click #debit-btn": "renderCardDetails"
            'keyup #cash-given-input': 'showChangeDue'
        initialize: ->
            @controller = @options.controller
        render: ->
            @$el.html this.template({})
            @$("#root-backbone-view-body").html(
                (new SalesPaymentSkeletonView).render(@model).el)
            @renderCashDetails()
            @transactionListRender()
            @customerSelectedRender()
            @employeeSelectedRender()
            @
        renderCashDetails: ->
            cashDetailsView = new SaleCashDetailsView
                controller: @controller
            @$("#payment-total-details").html cashDetailsView.render().el
            @
        renderCardDetails: ->
            cardDetailsView = new SaleCardDetailsView
                controller: @controller
            @$("#payment-total-details").html cardDetailsView.render().el
            @
        showChangeDue: ->
            cashGiven = parseFloat($("#cash-given-input").val())
            changeDue = parseFloat($("#change-due-input").val())
            totalDue =  parseFloat($("#total-due-input").val())
            if cashGiven > totalDue
                $("#change-due-input").val((cashGiven - totalDue).toFixed(2))
            else
                $("#change-due-input").val("not enough cash given")

        transactionListRender: ->
            transactionList = new SaleTransactionList
                controller: @controller
            @$("#transaction-list-id").html transactionList.render().el
            @
        customerSelectedRender: ->
            customerSelected = new SaleCustomerSelected
                controller: @controller
            @$("#customer-selected-id").html customerSelected.render().el
        employeeSelectedRender: ->
            employeeSelected = new SaleEmployeeSelected
                controller: @controller
            @$("#employee-selected-id").html employeeSelected.render().el

    class SalesConstructControllerView extends Backbone.View
        template: _.template ($ '#root-backbone-content-template').html()
        events:
            'change #store-name-select': 'setSaleStoreNameAndRenderProducts'
            'keyup #product-brand-search': 'productsListRender'
            'keyup #product-name-search': 'productsListRender'
            'keyup #customer-last-name-search': 'customerListRender'
            'keyup #customer-email-search': 'customerListRender'
        initialize: ->
            @controller = @options.controller
        render: ->
            @$el.html this.template({})
            @$("#root-backbone-view-body").html(
                (new SalesConstructSkeletonView).render(@model).el)
            @addStoreNames()
            @productsListRender()
            @transactionListRender()
            @customerListRender()
            @customerSelectedRender()
            @
        addStoreNames: ->
            storeNames = app.Companies.models[0].get 'stores'
            @addOneStoreNameToSelect(store.name) for store in storeNames
            # TODO should we delete below?
        addOneStoreNameToSelect: (storeName) ->
            @$('#store-name-select').append(
                "<option value='#{storeName}'>#{storeName}</option>")
        setSaleStoreNameAndRenderProducts: ->
            @controller.getCurrentSale().set
                storeName: @$('#store-name-select option:selected').val()
        productsListRender: ->
            productsList = new SaleProductList
                collection: app.Products
                controller: @controller
                storeName: @$('#store-name-select option:selected').val()
                nameSearch: @$('#product-name-search').val()
                brandSearch: @$('#product-brand-search').val()
            @$("#products-table-id").html productsList.render().el
        customerListRender: ->
            customersList = new SaleCustomerList
                collection: app.Customers
                controller: @controller
                lastNameSearch: @$('#customer-last-name-search').val()
                emailSearch: @$('#customer-email-search').val()
            @$("#customers-list-id").html customersList.render().el
        transactionListRender: ->
            transactionList = new SaleTransactionList
                controller: @controller
            @$("#transaction-list-id").html transactionList.render().el
        customerSelectedRender: ->
            customerSelected = new SaleCustomerSelected
                controller: @controller
            @$("#customer-selected-id").html customerSelected.render().el

    class SaleCustomerList extends Backbone.View
        template: _.template ($ '#sale-customers-table-template').html()
        initialize: ->
            @controller = @options.controller
            @lastNameSearch = @options.lastNameSearch
            @emailSearch = @options.emailSearch
        render: ->
            @$el.html @template({})
            @addAll()
            @
        addOne: (customer) ->
            view = new SaleCustomerListItemView
                model: customer
                controller: @controller
            (@$ "#customers-table-list").append view.render().el
        noCustomerAlert: ->
            message = "You don't have any customers yet. Click on the" +
                " 'People' menu link to start adding some regulars."
            alertWarning = new app.AlertView
                alertType: 'info'
            @$el.append alertWarning.render( "alert-info", message).el
        addAll: ->
            if not app.Customers.length
                return @noCustomerAlert()
            if @lastNameSearch or @emailSearch
                customerResults = []
                if @lastNameSearch
                    customerResults = @collection.filter (model) =>
                        nameString = model.get('name').last.toLowerCase()
                        nameString.indexOf(@lastNameSearch.toLowerCase()) isnt -1
                if @emailSearch
                    customerResults = @collection.filter (model) =>
                        emailString = model.get('email').toLowerCase()
                        emailString.indexOf(@emailSearch.toLowerCase()) isnt -1
                _.each customerResults, @addOne, @
            else
                @collection.each @addOne, @
    class SaleCustomerListItemView extends Backbone.View
        template: _.template ($ '#sale-customer-tr-template').html()
        tagName: 'tr'
        events:
            'mouseover': 'showItemOptions'
            'mouseout': 'hideItemOptions'
            'click #customer-purchase-link': 'customerSelected'
        initialize: ->
            @controller = @options.controller
        render: ->
            @$el.html this.template @model.attributes
            $(@el).find('i').hide()
            @
        showItemOptions: (event) ->
            $(@el).find('i').show()
        hideItemOptions: (event) ->
            $(@el).find('i').hide()
        customerSelected: (e) ->
            @controller.addCustomerToSale(@model)


    class SaleProductList extends Backbone.View
        template: _.template ($ '#sale-products-table-template').html()
        initialize: ->
            @nameSearch = @options.nameSearch
            @brandSearch = @options.brandSearch
            @storeName = @options.storeName
            @controller = @options.controller
        render: ->
            @$el.html @template({})
            @addAll()
            @
        addOne: (product) ->
            storeQuantityCount = 0
            for individualProperty in product.get('individualProperties')
                if individualProperty.storeName is @storeName
                    storeQuantityCount = storeQuantityCount + 1
            if storeQuantityCount isnt 0
                view = new ProductListItemView
                    model: product
                    storeQuantityCount: storeQuantityCount
                    controller: @controller
                (@$ "#products-table-list").append view.render().el
        noProductsAlert: ->
            message = "To make a sale, you need products. Click on the" +
                " 'Inventory' menu link to start stocking up."
            alertWarning = new app.AlertView
                alertType: 'info'
            @$el.append alertWarning.render( "alert-info", message).el
        addAll: ->
            if not app.Products.length
                return @noProductsAlert()
            if @nameSearch or @brandSearch
                if @nameSearch
                    productResults = @collection.filter (model) =>
                        nameString = model.get('description.name').toLowerCase()
                        nameString.indexOf(@nameSearch.toLowerCase()) isnt -1
                if @brandSearch
                    productResults = @collection.filter (model) =>
                        brandString = model.get('description.brand').toLowerCase()
                        brandString.indexOf(@brandSearch.toLowerCase()) isnt -1
                _.each productResults, @addOne, @
            else
                @collection.each @addOne, @

    class ProductListItemView extends Backbone.View
        template: _.template ($ '#sale-product-tr-template').html()
        tagName: 'tr'
        events:
            'mouseover': 'showItemOptions'
            'mouseout': 'hideItemOptions'
            'click #product-purchase-link': 'productSelected'
        initialize: ->
            @storeQuantityCount = @options.storeQuantityCount
            @controller = @options.controller
        render: ->
            renderObject = @model.attributes
            renderObject.storeQuantityCount = @storeQuantityCount
            @$el.html this.template renderObject
            $(@el).find('i').hide()
            @
        showItemOptions: (event) ->
            $(@el).find('i').show()
        hideItemOptions: (event) ->
            $(@el).find('i').hide()
        productSelected: (e) ->
            @addToTransaction = new AddToTransactionModal
                model: @model
                controller: @controller
            $("#root-backbone-view-body").
                append @addToTransaction.render().el
            $("#add-to-transaction-modal").modal 'show'
            $('#add-to-transaction-modal').on 'hidden', =>
                @addToTransaction.remove()

    class AddToTransactionModal extends Backbone.View
        events:
            'click #confirm-add-button': 'confirmAdd'
        template: _.template ($ '#add-to-transaction-template').html()
        initialize: ->
            @controller = @options.controller
        render: ->
            @$el.html @template(@model.attributes)
            if @model.get('primaryMeasurementFactor') isnt null
                @showSubQuantities()
            @
        confirmAdd: ->
            addToTransactionData = {
                measurementValues: []
                measurementsAvailable: []
                measurementsWanted: []
            }
            @$("th.measurements-value").each ->
                addToTransactionData.measurementValues.push $(this).html()
            @$("td.measurements-available").each ->
                addToTransactionData.measurementsAvailable.push $(this).html()
            @$("td.quantity-to-add").each ->
                addToTransactionData.measurementsWanted.push $(this).find("input").val()
            if @productsToAddAreValid addToTransactionData
                @controller.addSelectedToTransaction @model, addToTransactionData
            else
                message = "To add to a sale, include a quantity greater than 0." +
                    " The quantity given must be less than or equal to the" +
                    " quantity available."
                alertWarning = new app.AlertView
                    alertType: 'warning'
                @$("#add-to-transaction-alert").
                    html(alertWarning.render("alert-error", message).el)
        productsToAddAreValid: (addToTransactionData) ->
            # check to see if table sub quants are valid
            noWantsLessThan0 = true
            oneWantGreaterThan0 = false
            noWantsLessThanAvailable = true
            for subTotal, i in addToTransactionData.measurementsAvailable
                available = parseInt(addToTransactionData.measurementsAvailable[i], 10)
                wanted = parseInt(addToTransactionData.measurementsWanted[i],10)
                # separating cases so we can add specific alerts if needed
                if wanted < 0
                    noWantsLessThan0 = false
                if wanted > 0
                    oneWantGreaterThan0 = true
                if wanted > available
                    noWantsLessThanAvailable = false
            return noWantsLessThan0 and oneWantGreaterThan0 and noWantsLessThanAvailable
        showSubQuantities: ->
            individualProducts = []
            individualProps = @model.get('individualProperties')
            productsByStoreNames = _.groupBy individualProps, 'storeName'
            prodsByCurrentStore =
                productsByStoreNames[$('#store-name-select option:selected').val()]
            subTotalTotals = _.countBy prodsByCurrentStore, (elem) ->
                elem.measurements[0]['value']
            for subTotalValues in @model.get 'measurementPossibleValues'
                if subTotalTotals[subTotalValues]
                    quantityHTML = "<input class='input-mini' type='text' " +
                        "value='0'>"
                    individualProducts.push
                        measurementValue: subTotalValues
                        quantityAvailable: subTotalTotals[subTotalValues]
                        quantityToAdd: quantityHTML
            individualProducts = _.sortBy individualProducts, (el) ->
                return el.measurementValue
            subQuantView = new SaleProductItemSubQuantityView()
            quantityViewHTML = subQuantView.render(individualProducts,
                @model.get('primaryMeasurementFactor')).el
            @$('#sub-quantity-totals').html quantityViewHTML

    class SaleProductItemSubQuantityView extends Backbone.View
        template: _.template ($ '#sale-product-view-sub-quantity-template').html()
        render: (individualProducts, measurementFactor) ->
            @$el.html this.template({})
            # now let's add column 1 name and row 1 titles
            tableHeaderValues = "<th>#{measurementFactor}</th>"
            tableRow1Quantity = "<td>Available</td>"
            tableRow2Wanted  = "<td>Quantity</td>"
            # fill in the remaining rows/columns with the subquants
            _.each individualProducts, (elem) ->
                tableHeaderValues +=
                    "<th class='measurements-value'>#{elem.measurementValue}</th>"
                tableRow1Quantity +=
                    "<td class='measurements-available'>#{elem.quantityAvailable}</td>"
                tableRow2Wanted += "<td class='quantity-to-add'>#{elem.quantityToAdd}</td>"
            # finally append this to their respective th and td tags
            @$('#product-sub-quantity-thead-tr').append tableHeaderValues
            @$('#product-sub-quantity-available-td').append tableRow1Quantity
            @$('#product-sub-quantity-wanted-td').append tableRow2Wanted
            @

    class SaleTransactionList extends Backbone.View
        template: _.template ($ '#sale-transaction-list-template').html()
        initialize: ->
            @controller = @options.controller
        render: ->
            @$el.html @template({})
            @addAll()
            @addTotalsDetails()
            @
        addTotalsDetails: ->
            totalDue = 0
            totalInCurrency = 0
            totalTaxesDue = 0
            taxRate = parseInt(app.Companies.at(0).get 'taxRate')
            currentSale = @controller.getCurrentSale().attributes
            for product in currentSale.products
                totalDue += product.price * product.individualProperties.length
            if totalDue isnt 0
                totalTaxesDue =
                    Math.round(((totalDue * taxRate / 100) / 100)*100)/100
                totalInCurrency = ((totalDue / 100) + totalTaxesDue).toFixed(2)
            totalStringDetailsHTML = "<li class='nav-header'>Taxes</li> <li class='pull-right'>#{taxRate}% is #{totalTaxesDue.toFixed(2)}</li> <li class='nav-header'>Total</li> <li class='pull-right'>#{totalInCurrency}</li><hr />"
            (@$ "#transaction-ul").append totalStringDetailsHTML
        addAll: ->
            currentSaleProducts = @controller.getCurrentSale().get 'products'
            if not currentSaleProducts.length
                (@$ "#transaction-ul").append(
                    "<li class='pull-right'>no products</li>")
            _.each currentSaleProducts, @addOne, @
        addOne: (product) ->
            view = new SaleTransactionItemView
                currentSaleProduct: product
            (@$ "#transaction-ul").append view.render().el

    class SaleTransactionItemView extends Backbone.View
        template: _.template ($ '#transaction-li-template').html()
        tagName: 'li'
        initialize: ->
            @currentSaleProduct = @options.currentSaleProduct
        render: ->
            @$el.html @template @currentSaleProduct
            @

    class SaleCashDetailsView extends Backbone.View
        template: _.template ($ '#sales-payment-total-cash-template').html()
        initialize: ->
            @controller = @options.controller
        render: ->
            currentSale = @controller.getCurrentSale().attributes
            totalDue = 0
            for product in currentSale.products
                totalDue += product.price * product.individualProperties.length
            @$el.html @template
                totalDue: totalDue
            @
    class SaleCardDetailsView extends Backbone.View
        template: _.template ($ '#sales-payment-total-card-template').html()
        initialize: ->
            @controller = @options.controller
        render: ->
            currentSale = @controller.getCurrentSale().attributes
            totalDue = 0
            for product in currentSale.products
                totalDue += product.price * product.individualProperties.length
            @$el.html @template
                totalDue: totalDue
            @

    class SaleEmployeeSelected extends Backbone.View
        template: _.template ($ '#sale-employee-selected-template').html()
        initialize: ->
            @controller = @options.controller
        render: ->
            currentUserEmail = $("#current-user-email-id").text()
            emailModel = app.Employees.findWhere({email: currentUserEmail})
            @$el.html @template(emailModel.attributes)
            @
    class SaleCustomerSelected extends Backbone.View
        template: _.template ($ '#sale-customer-selected-template').html()
        initialize: ->
            @controller = @options.controller
        render: ->
            currentSaleCustomerID = @controller.getCurrentSale().get '_customer'
            customerModel = app.Customers.findWhere({_id: currentSaleCustomerID})
            if customerModel
                @$el.html @template(customerModel.attributes)
            else
                @$el.html @template({})
            @


    @app = window.app ? {}
    @app.SalesControllerView = SalesControllerView
