# Sale Model

# class Sale extends Backbone.Model
class Sale extends Backbone.DeepModel
    idAttribute: "_id"
    initialize: (attributes, options) ->
        if !attributes.createdAt
            @attributes.dateCreated = (new Date).toISOString()

@app = window.app ? {}
@app.Sale = Sale

