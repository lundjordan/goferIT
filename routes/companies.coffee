restifyCompanies = (app, restify, model) ->
    path = "/companies"
    pathWithId = "/companies/:id"

    app.get path, (req, res) ->
        model.findOne {_id: req.user._company}, (err, result) ->
            if not err
                res.send result
            else
                res.send (errMsg err)
    app.post path,(restify.getCreateController model)
    app.get pathWithId, (restify.getReadController model)
    app.put pathWithId, (restify.getUpdateController model)
    app.del pathWithId, (restify.getDeleteController model)


module.exports = restifyCompanies

