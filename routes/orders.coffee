
errMsg = (msg) ->
    return error:
        message: msg.toString()

restifyOrders = (app, restify, model) ->
    path = "/orders"
    pathWithId = "/orders/:id"

    app.get path, (req, res) ->
        (model.find {_company: req.user._company})
            .populate('_supplier')
            .exec (err, result) ->
                if not err
                    res.send result
                else
                    res.send (errMsg err)

    app.post path,(restify.getCreateController model)
    app.get pathWithId, (restify.getReadController model)
    app.put pathWithId, (restify.getUpdateController model)
    app.del pathWithId, (restify.getDeleteController model)

module.exports = restifyOrders
