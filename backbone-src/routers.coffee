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
            app.Products.fetch()
            app.appControllerView = new app.AppControllerView
                inventoryControllerView: new app.InventoryControllerView
                customerControllerView: new app.CustomerControllerView
                employeeControllerView: new app.EmployeeControllerView
        dashboard: ->
            # console.log 'WIP :('
        inventory: ->
            $("#root-backbone-view-head").remove()
            $("#root-backbone-view-body").remove()
            app.appControllerView.inventoryRender()

    @app.GoferRouter = GoferRouter

    @app.router = new app.GoferRouter
    Backbone.history.start()

