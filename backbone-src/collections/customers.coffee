# Customers Collection

class Customers extends Backbone.Collection
    model: app.Customer
    url: '/customers'
    initialize: ->
        @comparator = (customer) ->
            customer.get('name').last.toLowerCase()
    findPrev: (currentModel) ->
        indexCurrentModel = @indexOf(currentModel)
        if indexCurrentModel is 0
            return @at @length-1
        @at indexCurrentModel-1
    findNext: (currentModel) ->
        indexCurrentModel = @indexOf(currentModel)
        if @length is indexCurrentModel+1
            return this.at 0
        @at indexCurrentModel+1

@app = window.app ? {}
@app.Customers = new Customers
