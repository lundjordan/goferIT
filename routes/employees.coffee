
restifyEmployees = (app, restify, model) ->
    path = "/employees"
    pathWithId = "/employees/:id"

    app.get path, (restify.getListController model)
    app.post path,(restify.getCreateController model)
    app.get pathWithId, (restify.getReadController model)
    app.put pathWithId, (restify.getUpdateController model)
    app.del pathWithId, (restify.getDeleteController model)

module.exports = restifyEmployees

