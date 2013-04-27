# POS Views

jQuery ->
    class SalesControllerView extends Backbone.View
        el: '#sales-main-view'
        initialize: ->
            @currentView = null
            @currentSale = new app.Sale({})
        renderSalesConstructView: ->
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
        addSelectedToTransaction: (productModel, productsToAdd) ->
            individualProducts = productModel.get 'individualProperties'
            console.log individualProducts, productsToAdd
            # _.filter individualProducts, (product) ->
            #     product.measurements[0].value is "8"

            # console.log productModel, measureVals[i], allTotals

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
            [measurementValues, measurementQuants, productsToAdd] =
                [[], [], []]
            @$("th").each ->
                measurementValues.push $(this).html()
            @$("td").each ->
                if $(this).html() isnt "Totals"
                    measurementQuants.push $(this).find("input").val()
            # remove first elem as it's the primaryMeasurementFactor
            measurementValues = measurementValues[1..]
            if @subQuantTotalValid measurementQuants
                # filter only quants > 0
                for quant, i in measurementQuants
                    if parseInt(quant, 10) > 0
                        productsToAdd.push
                            factor: measurementValues[i]
                            value: quant
                @controller.addSelectedToTransaction @model, productsToAdd
                $("#add-to-transaction-modal").modal 'hide'
            else
                message = "One value must be higher than 0. " +
                    "Only positive integers are accepted"
                alertWarning = new app.AlertView
                    alertType: 'warning'
                @$("#add-to-transaction-alert").
                    html(alertWarning.render("alert-error", message).el)
        subQuantTotalValid: (values) ->
            # check to see if table sub quants are valid
            oneValueMoreThan0 = false
            anyValuesLessThan0 = false
            for value in values
                if parseInt(value, 10) > 0
                    oneValueMoreThan0 = true
                if parseInt(value, 10) < 0
                    anyValuesLessThan0 = true
            return oneValueMoreThan0 and not anyValuesLessThan0
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
                    quantityHTML = "<ul class='inline'> " +
                        "<li><input class='input-mini' type='text' " +
                        "value='0'></li><li><p>" +
                        " Of #{subTotalTotals[subTotalValues]}" +
                        "</p></li></ul>"
                    individualProducts.push
                        measurementValue: subTotalValues
                        quantity: quantityHTML
            individualProducts = _.sortBy individualProducts, (el) ->
                return el.measurementValue
            subQuantView = new app.ProductItemSubQuantityView()
            quantityViewHTML = subQuantView.render(individualProducts,
                @model.get('primaryMeasurementFactor')).el
            @$('#sub-quantity-totals').html quantityViewHTML


    class SalesConstructSkeletonView extends Backbone.View
        template: _.template ($ '#sales-skeleton-template').html()
        render: ->
            @$el.html this.template({})
            @




    @app = window.app ? {}
    @app.SalesControllerView = SalesControllerView
