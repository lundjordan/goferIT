# Sales Collection

class Sales extends Backbone.Collection
    model: app.Sale
    url: '/sales'

@app = window.app ? {}
@app.Sales = new Sales

