# The Main App View / Controller

jQuery ->
    class AppView extends Backbone.View
        el: '#main'
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
