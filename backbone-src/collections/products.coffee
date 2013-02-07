# COLLECTIONS

class Products extends Backbone.Collection
  model: app.Product
  url: '/products'

@app = window.app ? {}
@app.Products = new Products

