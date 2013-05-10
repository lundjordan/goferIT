# Customer Model

class Customer extends Backbone.Model
    idAttribute: "_id"
    initialize: (attributes, options) ->
        if !attributes.dateCreated
            @attributes.dateCreated = (new Date).toISOString()


@app = window.app ? {}
@app.Customer = Customer
