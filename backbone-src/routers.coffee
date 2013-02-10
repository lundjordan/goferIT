# ROUTERS

jQuery ->

  class GoferRouter extends Backbone.Router
    routes:
        '': 'dashboard'
        'inventory': 'inventory'
    initialize: ->
        @app.Products.fetch()

    dashboard: ->
        console.log 'WIP :('
    inventory: ->
        @app.appView = new @app.AppView
            inventoryView: new @app.InventoryView


  @app = window.app ? {}
  @app.GoferRouter = GoferRouter

