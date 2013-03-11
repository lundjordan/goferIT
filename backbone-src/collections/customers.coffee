# Customers Collection

class Customers extends Backbone.Collection
  model: app.Customer
  url: '/customers'

@app = window.app ? {}
@app.Customers = new Customers
