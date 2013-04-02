# Orders Collection

class Orders extends Backbone.Collection
    model: app.Order
    url: '/orders'
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
    ifModelExists: (orderName, orderBrand) ->

@app = window.app ? {}
@app.Orders = new Orders


