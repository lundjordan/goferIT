# Sales Collection

class Sales extends Backbone.Collection
    model: app.Sale
    url: '/sales'
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
@app.Sales = new Sales

