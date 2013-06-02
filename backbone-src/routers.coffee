# ROUTERS
@app = window.app ? {}

jQuery ->

    class GoferRouter extends Backbone.Router
        initialize: ->
            app.Companies.fetch()
            app.Customers.fetch()
            app.Employees.fetch()
            app.Suppliers.fetch()
            app.Orders.fetch()
            app.Products.fetch()
            app.Sales.fetch()
            app.appControllerView = new app.AppControllerView
                inventoryControllerView: new app.InventoryControllerView
                    productControllerView: new app.ProductControllerView
                    orderControllerView: new app.OrderControllerView
                peopleControllerView: new app.PeopleControllerView
                    customerControllerView: new app.CustomerControllerView
                    employeeControllerView: new app.EmployeeControllerView
                    supplierControllerView: new app.SupplierControllerView
                posControllerView: new app.POSControllerView
                    salesControllerView: new app.SalesControllerView
                companyControllerView: new app.CompanyControllerView
                    companyProfileView: new app.CompanyProfileControllerView
                financeControllerView: new app.FinanceControllerView
                    transactionControllerView: new app.TransactionsControllerView

    @app.GoferRouter = GoferRouter

    @app.router = new app.GoferRouter
    Backbone.history.start()

    # window.setInterval ->
    #     app.Companies.fetch()
    #     app.Customers.fetch()
    #     app.Employees.fetch()
    #     app.Suppliers.fetch()
    #     app.Orders.fetch()
    #     app.Products.fetch()
    #     app.Sales.fetch()
    # , 10000

