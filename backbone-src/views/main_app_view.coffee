# The Main App View / Controller

jQuery ->
    class AppView extends Backbone.View
        el: '#main'
        events:
            'click #dashboard-link': "dashboardRender"
            'click #inventory-link': "inventoryRender"
        initialize: ->
            @inventoryView = @options.inventoryView
        inventoryRender: ->
            @inventoryView.render()
        dashboardRender: ->

    @app = window.app ? {}
    @app.AppView = AppView
