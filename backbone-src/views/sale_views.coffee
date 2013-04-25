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
        render: ->
            @$el.html this.template({})
            @$("#root-backbone-view-body").html(
                (new SalesConstructSkeletonView).render(@model).el)
            @
    class SalesConstructSkeletonView extends Backbone.View
        template: _.template ($ '#sales-skeleton-template').html()
        render: ->
            @$el.html this.template({})
            @




    @app = window.app ? {}
    @app.SalesControllerView = SalesControllerView
