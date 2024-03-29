# The Main App View / Controller

jQuery ->
    class AppControllerView extends Backbone.View
        el: '#main'
        events:
            'click #dashboard-link': "dashboardRender"
            'click #inventory-link': "inventoryRender"
            'click #people-link': "peopleRender"
            'click #company-link': "companyRender"
            'click #pos-link': "posRender"
            'click #finance-link': "financeRender"
        initialize: ->
            @inventoryControllerView = @options.inventoryControllerView
            @peopleControllerView = @options.peopleControllerView
            @posControllerView = @options.posControllerView
            @companyControllerView = @options.companyControllerView
            @financeControllerView = @options.financeControllerView
            @currentMenuView = @inventoryControllerView
        financeRender: ->
            # first remove the previous view's subview (the content)
            @currentMenuView.removeCurrentContentView()
            # now reasign the currentMenuView
            @currentMenuView = @financeControllerView
            @currentMenuView.renderTransactionsInitView()
        companyRender: ->
            # first remove the previous view's subview (the content)
            @currentMenuView.removeCurrentContentView()
            # now reasign the currentMenuView
            @currentMenuView = @companyControllerView
            @currentMenuView.renderCompanyInitView()
        inventoryRender: ->
            # first remove the previous view's subview (the content)
            @currentMenuView.removeCurrentContentView()
            # then we have to physically tell bootstrap to show the subtab
            $('#product-menu-pill a').tab('show')
            $('#products-list-tab a').tab('show')
            # now reasign the currentMenuView
            @currentMenuView = @inventoryControllerView
            @currentMenuView.renderProductsInitView()
        peopleRender: ->
            # first remove the previous view's subview (the content)
            @currentMenuView.removeCurrentContentView()
            # then wehave to physically tell bootstrap to show the subtab
            $('#customers-menu-pill a').tab('show')
            $('#customers-list-tab a').tab('show')
            # now reasign the currentmenuview
            @currentMenuView = @peopleControllerView
            @currentMenuView.renderCustomersInitView()
        posRender: ->
            # first remove the previous view's subview (the content)
            @currentMenuView.removeCurrentContentView()
            @currentMenuView = @posControllerView
            @currentMenuView.renderPOSInitView()
        dashboardRender: ->
            @currentMenuView = @inventoryControllerView

    class CompanyControllerView extends Backbone.View
        el: '#company-main-content'
        initialize: ->
            @companyProfileView = @options.companyProfileView
        renderCompanyInitView: ->
            @currentCompanyView = @companyProfileView
            @currentCompanyView.renderCompanyProfileView()
        removeCurrentContentView: ->
            @currentCompanyView.removeCurrentContentView()

    class POSControllerView extends Backbone.View
        # this controller keeps the format of the others in case we expand
        # sales functionality to support more inner nav tabs
        el: '#sales-main-content'
        initialize: ->
            @salesControllerView = @options.salesControllerView
            @currentPOSView = @salesControllerView
        renderPOSInitView: ->
            @currentPOSView = @salesControllerView
            @currentPOSView.renderInitSalesConstructView()
        removeCurrentContentView: ->
            @currentPOSView.removeCurrentContentView()

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

    class FinanceControllerView extends Backbone.View
        el: '#finances-main-content'
        initialize: ->
            @transactionControllerView = @options.transactionControllerView
            @currentFinanceView = @transactionControllerView
        renderTransactionsInitView: ->
            @currentFinanceView.removeCurrentContentView()
            @currentFinanceView = @transactionControllerView
            $('#finances-list-tab a').tab('show')
            @currentFinanceView.renderFinancesListView()
        removeCurrentContentView: ->
            @currentFinanceView.removeCurrentContentView()

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
    @app.POSControllerView = POSControllerView
    @app.CompanyControllerView = CompanyControllerView
    @app.FinanceControllerView = FinanceControllerView
