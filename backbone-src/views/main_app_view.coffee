# The Main App View / Controller

jQuery ->
    class AppView extends Backbone.View
        el: '#main'
        events:
            'click #inventory-link': 'inventoryRender'
            'click #dashboard-link': 'dashboardRender'
        initialize: ->
            @inventoryView = @options.inventoryView
            @selectedNavMenuItem = $('#dashboard-link')
        inventoryRender: ->
            @inventoryView.render()
            @selectedNavMenuItem.removeClass 'active'
            @selectedNavMenuItem = @$('#inventory-link')
            @selectedNavMenuItem.addClass 'active'
        dashboardRender: ->
            @selectedNavMenuItem.removeClass 'active'
            @selectedNavMenuItem = @$('#dashboard-link')
            @selectedNavMenuItem.addClass 'active'

    @app = window.app ? {}
    @app.AppView = AppView

    @app.Products.fetch()
    @app.appView = new @app.AppView
        inventoryView: new @app.InventoryView
