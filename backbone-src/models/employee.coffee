# Employee Model

class Employee extends Backbone.Model
    idAttribute: "_id"
    initialize: (attributes, options) ->
        if !attributes.dateCreated
            @attributes.dateCreated = (new Date).toISOString()


@app = window.app ? {}
@app.Employee = Employee

