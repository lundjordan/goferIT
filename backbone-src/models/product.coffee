# Product Model

class Product extends Backbone.NestedModel
    idAttribute: "_id"
    initialize: (attributes, options) ->
        if !attributes.createdAt
            @attributes.dateCreated = (new Date).toISOString()

@app = window.app ? {}
@app.Product = Product

