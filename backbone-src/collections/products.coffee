# Products Collection

class Products extends Backbone.Collection
    model: app.Product
    url: '/products'
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
    ifModelExists: (productName, productBrand) ->
        # console.log productName, productBrand
        # console.log @where
        #     'description.name': productName
        #     'description.brand': productBrand
        @where(
            'description.name': productName
            'description.brand': productBrand
        ).length is 1

@app = window.app ? {}
@app.Products = new Products

