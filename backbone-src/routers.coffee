# ROUTERS

jQuery ->

  class GoferRouter extends Backbone.Router
    routes:
        '': 'dashboard'
        'inventory': 'inventory'
    dashboard: ->
        console.log 'WIP :('
    inventory: ->
        console.log 'WIP :('


  @app = window.app ? {}
  @app.GoferRouter = GoferRouter

