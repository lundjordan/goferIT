# Product Model

# class Product extends Backbone.Model
class Product extends Backbone.DeepModel
    idAttribute: "_id"
    initialize: (attributes, options) ->
        if !attributes.dateCreated
            @attributes.dateCreated = (new Date).toISOString()
        @_memento = null
    # this is for in sale if we want to cancel the current sale (and any
    # changes in products)
    captureState: ->
        @_memento = _.clone @attributes
    applyUndo: ->
        @set(@_memento, {silent : true}) if @_memento
        @_memento = null
    currentMementoIsNull: ->
        @_memento is null
    removeMemento: ->
        @_memento = null

@app = window.app ? {}
@app.Product = Product
