# The Main App View / Controller

jQuery ->
    class AppControllerView extends Backbone.View
        el: '#main'
        events:
            'click #dashboard-link': "dashboardRender"
            'click #inventory-link': "inventoryRender"
            'click #people-link': "peopleRender"
        initialize: ->
            @inventoryControllerView = @options.inventoryControllerView
            @customerControllerView = @options.customerControllerView
        inventoryRender: ->
            @inventoryControllerView.renderProductsListView()
        peopleRender: ->
            @customerControllerView.renderCustomersListView()
        dashboardRender: ->

    @app = window.app ? {}
    @app.AppControllerView = AppControllerView
