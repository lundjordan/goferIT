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
        template: _.template ($ '#products-table-template').html()
        initialize: ->
            @storeName = @options.storeName
        render: ->
            @$el.html this.template({})
            @addAll()
            @
        addOne: (product) ->
            console.log @storeName
            storeQuantityCount = 0
            for individualProperty in product.get('individualProperties')
                if individualProperty.storeName is @storeName
                    storeQuantityCount = storeQuantityCount + 1
            view = new ProductListItemView
                model: product
                storeQuantityCount: storeQuantityCount
            (@$ "#products-table-list").append view.render().el
        addAll: ->
            @collection.each @addOne, @
    class ProductListItemView extends Backbone.View
        template: _.template ($ '#product-tr-template').html()
        tagName: 'tr'
        events:
            'mouseover': 'showItemOptions'
            'mouseout': 'hideItemOptions'
            'click #item-view-eye-link': 'renderSpecificItemView'
        initialize: ->
            @storeQuantityCount = @options.storeQuantityCount
            console.log @storeQuantityCount
        render: ->
            renderObject = @model.attributes
            renderObject.storeQuantityCount = @storeQuantityCount
            @$el.html this.template renderObject
            $(@el).find('i').hide()
            @
        showItemOptions: (event) ->
            # $('#item-options').prepend("<i class='icon-search'></i>")
            $(@el).find('i').show()
        hideItemOptions: (event) ->
            # $('#item-options').html()
            $(@el).find('i').hide()
        renderSpecificItemView: ->

    class SalesConstructSkeletonView extends Backbone.View
        template: _.template ($ '#sales-skeleton-template').html()
        render: ->
            @$el.html this.template({})
            @




    @app = window.app ? {}
    @app.SalesControllerView = SalesControllerView
