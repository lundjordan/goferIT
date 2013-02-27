# ROUTERS
@app = window.app ? {}

jQuery ->

    class GoferRouter extends Backbone.Router
        routes:
            '': 'dashboard'
            'inventory': 'inventory'
        initialize: ->
            app.Companies.fetch()
            app.Suppliers.fetch()
            app.Products.fetch()
            app.appControllerView = new app.AppControllerView
                inventoryControllerView: new app.InventoryControllerView
        dashboard: ->
            # console.log 'WIP :('
        inventory: ->
            app.appControllerView.inventoryRender()

    @app.GoferRouter = GoferRouter

    @app.router = new app.GoferRouter
    Backbone.history.start()

