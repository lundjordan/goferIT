# The Main App View / Controller

jQuery ->
    class AppView extends Backbone.View
        el: '#main'
        events:
            'click #inventory-link': 'inventoryRender'
        initialize: ->
            @inventoryView = @options.inventoryView
        inventoryRender: ->
            console.log 'MIH'
            @inventoryView.render()

    @app = window.app ? {}
    @app.AppView = AppView

