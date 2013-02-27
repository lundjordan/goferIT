# Suppliers Collection

class Suppliers extends Backbone.Collection
  model: app.Supplier
  url: '/suppliers'

@app = window.app ? {}
@app.Suppliers = new Suppliers


