# Sale Model

# class Sale extends Backbone.Model
class Sale extends Backbone.DeepModel
    idAttribute: "_id"
    initialize: (attributes, options) ->
        if !attributes.createdAt
            @attributes.dateCreated = (new Date).toISOString()
        if !attributes.products
            @attributes.products = []
    getProductIfExists: (productName, productBrand) ->
        console.log productName, productBrand
        products = @attributes.products
        for product in products
            ref = product.description
            if ref.name is productName and ref.brand is productBrand
                return product
        return false


@app = window.app ? {}
@app.Sale = Sale

