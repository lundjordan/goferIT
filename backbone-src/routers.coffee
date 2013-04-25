# ROUTERS
@app = window.app ? {}

jQuery ->

    class GoferRouter extends Backbone.Router
        routes:
            '': 'dashboard'
            'inventory': 'inventory'
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
        dashboard: ->
            # console.log 'WIP :('
        inventory: ->
            $("#root-backbone-view-head").remove()
            $("#root-backbone-view-body").remove()
            app.appControllerView.inventoryRender()

    @app.GoferRouter = GoferRouter

    @app.router = new app.GoferRouter
    Backbone.history.start()

