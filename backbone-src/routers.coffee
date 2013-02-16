# ROUTERS
@app = window.app ? {}

jQuery ->

    class GoferRouter extends Backbone.Router
        routes:
            '': 'dashboard'
            'inventory': 'inventory'
        initialize: ->
            app.Products.fetch()
            app.appView = new app.AppView
                inventoryView: new app.InventoryView
        dashboard: ->
            # console.log 'WIP :('
        inventory: ->
            app.appView.inventoryRender()

    @app.GoferRouter = GoferRouter

    @app.router = new app.GoferRouter
    Backbone.history.start()

