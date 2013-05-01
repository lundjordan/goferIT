# POS Views

jQuery ->
    class SalesControllerView extends Backbone.View
        el: '#sales-main-view'
        initialize: ->
            @currentView = null
            @currentSale = new app.Sale({})
            @listenTo @currentSale, 'change', @renderSalesConstructView
        renderSalesConstructView: ->
            console.log 'rendered salesconstructView'
            @removeCurrentContentView()
            @currentView = new SalesConstructControllerView
                collection: app.Sales
                controller: @ # bubble this all the way down
            # not the best way but @ is needed in AddToTransactionModal
            $("#sales-main-view").html @currentView.render().el
        renderSalesConfirmView: ->
        removeCurrentContentView: ->
            if @currentView
                # clean up incomplete transaction
                @currentView.remove()
        addSelectedToTransaction: (productModel, addToTransactionData) ->
            individualProducts = productModel.get 'individualProperties'
            for subTotal, i in addToTransactionData.measurementValues
                [allProductsWithoutValue, allProductsByValue] = [[], []]
                value = addToTransactionData.measurementValues[i]
                available = parseInt(addToTransactionData.measurementsAvailable[i], 10)
                wanted = parseInt(addToTransactionData.measurementsWanted[i],10)
                willBeRemaining = available - wanted
                console.log "value", value, "available", available, "wanted", wanted, "willBeRemaining", willBeRemaining
                if wanted > 0
                    allProductsByValue = $.grep individualProducts, (elem) ->
                        elem.measurements[0].value is value
                    allProductsWithoutValue = $.grep individualProducts, (elem) ->
                        elem.measurements[0].value isnt value

                    for i in [1..willBeRemaining]
                        productWithValueNotNeeded = allProductsByValue[i]
                        allProductsByValue.splice i, 1
                        allProductsWithoutValue.push productWithValueNotNeeded
                    for productToAdd in allProductsByValue
                        # first delete the _id property of this product
                        # as it will just confuse mongo on creation
                        delete productToAdd._id
                        if productToAdd.measurements
                            for measurement in productToAdd.measurements
                                # also delete all the generated _ids from subdocs
                                delete measurement._id
                    console.log individualProducts, allProductsWithoutValue, allProductsByValue

                    # if @currentSale.productExists(productName, productBrand)
                    #     productName = productModel.get 'description.name'
                    #     productBrand = productModel.get 'description.brand'
                    #     for product in @currentSale.get 'products'
                    #         ref = product.description
                    #         if ref.name is productName and ref.brand is productBrand
                    #             product.individualProperties.concat allProductsByValue
                    #             break
                    #     @currentSale.save()
                    # else
                    #     @currentSale.get('products').push
                    #         description:
                    #             name: productModel.get 'description.name'
                    #             brand: productModel.get 'description.brand'
                    #         category: productModel.get 'category'
                    #         price: productModel.get 'price'
                    #         cost: productModel.get 'cost'
                    #         primaryMeasurementFactor:
                    #             productModel.get 'primaryMeasurementFactor'
                    #         individualProperties:
                    #             @currentSale.get('products').concat allProductsByValue
                    # console.log allProductsWithoutValue, allProductsByValue
                    # console.log @currentSale.attributes
                    # productModel.save
                    #     individualProperties: allProductsWithoutValue
                    # console.log allProductsWithoutValue, allProductsByValue
                    # console.log @currentSale.attributes
                    # console.log productModel.attributes


            # TODO START HERE DUDE!
                    # console.log "value", value
                    # console.log "available", available
                    # console.log "wanted", wanted
                    # console.log "willBeRemain", willBeRemaining


    class SalesConstructControllerView extends Backbone.View
        template: _.template ($ '#root-backbone-content-template').html()
        events:
            'change #store-name-select': 'productsListRender'
        initialize: ->
            @listenTo app.Sales, 'change', @render
            @controller = @options.controller
        render: ->
            @$el.html this.template({})
            @$("#root-backbone-view-body").html(
                (new SalesConstructSkeletonView).render(@model).el)
            @addStoreNames()
            @productsListRender()
            @
        addStoreNames: ->
            storeNames = app.Companies.models[0].get 'stores'
            @addOneStoreNameToSelect(store.name) for store in storeNames
            if @model
                # incase we are in edit mode, set the select tag to 
                # whatever the model's store name is
                @$("select[id=store-name-select]").
                    val(@model.attributes.storeName)
        addOneStoreNameToSelect: (storeName) ->
            @$('#store-name-select').append(
                "<option value='#{storeName}'>#{storeName}</option>")
        productsListRender: ->
            productsList = new SaleProductList
                collection: app.Products
                controller: @controller
                storeName: @$('#store-name-select option:selected').val()
            @$("#products-table-id").html productsList.render().el

    class SaleProductList extends Backbone.View
        template: _.template ($ '#sale-products-table-template').html()
        initialize: ->
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
        addAll: ->
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
            @$("th.measurement-value").each ->
                addToTransactionData.measurementValues.push $(this).html()
            @$("td.measurement-available").each ->
                addToTransactionData.measurementsAvailable.push $(this).html()
            @$("td.quantity-to-add").each ->
                addToTransactionData.measurementsWanted.push $(this).find("input").val()
            if @productsToAddAreValid addToTransactionData
                @controller.addSelectedToTransaction @model, addToTransactionData
                $("#add-to-transaction-modal").modal 'hide'
            else
                message = "To add an item to a sale, include a quantity greater than 0." +
                    " The quantity given must be less than the quantity available."
                alertWarning = new app.AlertView
                    alertType: 'warning'
                @$("#add-to-transaction-alert").
                    html(alertWarning.render("alert-error", message).el)
        productsToAddAreValid: (addToTransactionData) ->
            # check to see if table sub quants are valid
            noWantsLessThan0 = true
            oneWantGreaterThan0 = false
            noWantsLessThanAvailable = true

            for subTotal, i in addToTransactionData.measurementValues
                value = parseInt(addToTransactionData.measurementValues[i], 10)
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
            # XXX this is mostly duplicate code from product_views
            # first let's sort the subquantities for readibility in table
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
                    "<th class='measurement-value'>#{elem.measurementValue}</th>"
                tableRow1Quantity +=
                    "<td class='measurement-available'>#{elem.quantityAvailable}</td>"
                tableRow2Wanted += "<td class='quantity-to-add'>#{elem.quantityToAdd}</td>"

            # finally append this to their respective th and td tags
            @$('#product-sub-quantity-thead-tr').append tableHeaderValues
            @$('#product-sub-quantity-available-td').append tableRow1Quantity
            @$('#product-sub-quantity-wanted-td').append tableRow2Wanted

            @


    class SalesConstructSkeletonView extends Backbone.View
        template: _.template ($ '#sales-skeleton-template').html()
        render: ->
            @$el.html this.template({})
            @




    @app = window.app ? {}
    @app.SalesControllerView = SalesControllerView
