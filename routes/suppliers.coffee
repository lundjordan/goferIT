
restifySuppliers = (app, restify, model) ->
    path = "/suppliers"
    pathWithId = "/suppliers/:id"

    app.get path, (restify.getListController model)
    app.post path,(restify.getCreateController model)
    app.get pathWithId, (restify.getReadController model)
    app.put pathWithId, (restify.getUpdateController model)
    app.del pathWithId, (restify.getDeleteController model)

module.exports = restifySuppliers
