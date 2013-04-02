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
            @peopleControllerView = @options.peopleControllerView
            @currentMenuView = @inventoryControllerView
        inventoryRender: ->
            # first remove the previous view's subview (the content)
            @currentMenuView.removeCurrentContentView()
            # then we have to physically tell bootstrap to show the subtab
            $('#inventory-list-tab a').tab('show')
            # now reasign the currentMenuView
            @currentMenuView = @inventoryControllerView
            @currentMenuView.renderProductsInitView()
        peopleRender: ->
            # first remove the previous view's subview (the content)
            @currentMenuView.removeCurrentContentView()
            # then wehave to physically tell bootstrap to show the subtab
            $('#customers-list-tab a').tab('show')
            # now reasign the currentMenuView
            @currentMenuView = @peopleControllerView
            @currentMenuView.renderCustomersInitView()
        dashboardRender: ->

    class PeopleControllerView extends Backbone.View
        el: '#people-main-content'
        events:
            'click #customers-menu-pill': 'renderCustomersInitView'
            'click #employees-menu-pill': 'renderEmployeesInitView'
            'click #suppliers-menu-pill': 'renderSuppliersInitView'
        initialize: ->
            @customerControllerView = @options.customerControllerView
            @employeeControllerView = @options.employeeControllerView
            @supplierControllerView = @options.supplierControllerView
            @currentPeopleView = @customerControllerView
        renderCustomersInitView: ->
            @currentPeopleView.removeCurrentContentView()
            @currentPeopleView = @customerControllerView
            $('#customers-list-tab a').tab('show')
            @currentPeopleView.renderCustomersListView()
        renderEmployeesInitView: ->
            @currentPeopleView.removeCurrentContentView()
            @currentPeopleView = @employeeControllerView
            $('#employees-list-tab a').tab('show')
            @currentPeopleView.renderEmployeesListView()
        renderSuppliersInitView: ->
            @currentPeopleView.removeCurrentContentView()
            @currentPeopleView = @supplierControllerView
            $('#suppliers-list-tab a').tab('show')
            @currentPeopleView.renderSuppliersListView()
        removeCurrentContentView: ->
            @currentPeopleView.removeCurrentContentView()

    class InventoryControllerView extends Backbone.View
        el: '#inventory-main-content'
        events:
            'click #product-menu-pill': 'renderProductsInitView'
            'click #order-menu-pill': 'renderOrderInitView'
        initialize: ->
            @productControllerView = @options.productControllerView
            @orderControllerView = @options.orderControllerView
            @currentInventoryView = @productControllerView
        renderProductsInitView: ->
            @currentInventoryView.removeCurrentContentView()
            @currentInventoryView = @productControllerView
            $('#products-list-tab a').tab('show')
            @currentInventoryView.renderProductsListView()
        renderOrderInitView: ->
            @currentInventoryView.removeCurrentContentView()
            @currentInventoryView = @orderControllerView
            $('#orders-list-tab a').tab('show')
            @currentInventoryView.renderOrdersListView()
        removeCurrentContentView: ->
            @currentInventoryView.removeCurrentContentView()

    @app = window.app ? {}
    @app.AppControllerView = AppControllerView
    @app.InventoryControllerView = InventoryControllerView
    @app.PeopleControllerView = PeopleControllerView
