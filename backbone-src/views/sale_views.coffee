# POS Views

jQuery ->
    class SalesControllerView extends Backbone.View
        el: '#sales-main-view'
        initialize: ->
            @currentView = null
        renderSalesConstructView: ->
            @removeCurrentContentView()
            @currentView = new SalesConstructControllerView
                collection: app.Sales
            $("#sales-main-view").html @currentView.render().el
        renderSalesConfirmView: ->
            @removeCurrentContentView()

        removeCurrentContentView: ->
            if @currentView
                @currentView.remove()

    class SalesConstructControllerView extends Backbone.View
        template: _.template ($ '#root-backbone-content-template').html()
        events:
            'change #store-name-select': 'productsListRender'
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
                storeName: @$('#store-name-select option:selected').val()
            @$("#products-table-id").html productsList.render().el

    class SaleProductList extends Backbone.View
        template: _.template ($ '#sale-products-table-template').html()
        initialize: ->
            @storeName = @options.storeName
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
            $("#root-backbone-view-body").
                append @addToTransaction.render().el
            $("#add-to-transaction-modal").modal 'show'
            $('#add-to-transaction-modal').on 'hidden', =>
                @addToTransaction.remove()
    class AddToTransactionModal extends Backbone.View
        events:
            'click #delete-confirmed-button': 'confirmedDeletion'
        template: _.template ($ '#add-to-transaction-template').html()
        render: ->
            @$el.html @template(@model.attributes)
            if @model.get('primaryMeasurementFactor') isnt null
                @showSubQuantities()
            @
        confirmedDeletion: ->
            $("#delete-item-modal").modal 'hide'
            @model.destroy()
            message = "removed..."
            alertInfo = new AlertView
                alertType: 'info'
            $("#root-backbone-alert-view").
                html(alertInfo.render( "alert-info", message).el)
        showSubQuantities: ->
            # XXX this is duplicate code from product_views
            # first let's sort the subquantities for readibility in table
            individualProducts = []
            individualProps = @model.get('individualProperties')
            subTotalTotals = _.countBy individualProps, (elem) ->
                elem.measurements[0]['value']
            for subTotalValues in @model.get 'measurementPossibleValues'
                quantityHTML = "<ul class='inline'> " +
                    "<li><input class='input-mini' type='text'></li>" +
                    "<li><p>Of #{subTotalTotals[subTotalValues] or 0}" +
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
