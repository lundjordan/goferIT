# Inventory Views

jQuery ->
    class InventoryView extends Backbone.View
        el: '#main-window'
        template: _.template ($ '#products-list-template').html()
        render: ->
            @$el.html this.template({})

    @app = window.app ? {}
    @app.InventoryView = InventoryView
