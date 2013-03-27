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
            # @employeeControllerView = @options.employeeControllerView
        inventoryRender: ->
            $('#inventory-list-tab a').tab('show')
            $("#root-backbone-view-head").remove()
            $("#root-backbone-view-body").remove()
            @inventoryControllerView.renderProductsListView()
        peopleRender: ->
            $('#customers-list-tab a').tab('show')
            $("#root-backbone-view-head").remove()
            $("#root-backbone-view-body").remove()
            @customerControllerView.renderCustomersListView()
        dashboardRender: ->

    @app = window.app ? {}
    @app.AppControllerView = AppControllerView
