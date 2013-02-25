# The Main App View / Controller

jQuery ->
    class AppControllerView extends Backbone.View
        el: '#main'
        events:
            'click #dashboard-link': "dashboardRender"
            'click #inventory-link': "inventoryRender"
        initialize: ->
            @inventoryControllerView = @options.inventoryControllerView
        inventoryRender: ->
            @inventoryControllerView.render()
        dashboardRender: ->

    @app = window.app ? {}
    @app.AppControllerView = AppControllerView
