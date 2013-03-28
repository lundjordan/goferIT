# Product Model

# class Product extends Backbone.Model
class Product extends Backbone.DeepModel
    idAttribute: "_id"
    initialize: (attributes, options) ->
        if !attributes.createdAt
            @attributes.dateCreated = (new Date).toISOString()

@app = window.app ? {}
@app.Product = Product

