# Order Model

# class Order extends Backbone.Model
class Order extends Backbone.DeepModel
    idAttribute: "_id"
    defaults:
        'products': []
    initialize: (attributes, options) ->
        if !attributes.createdAt
            @attributes.dateCreated = (new Date).toISOString()

@app = window.app ? {}
@app.Order = Order


