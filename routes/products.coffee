restifyProducts = (app, restify, model) ->
    path = "/products"
    pathWithId = "products/:id"

    app.get path, (req, res) ->
        all_products = 
        model.find({_company: req.user._company})
            .exec (err, result) ->
                if not err
                    res.send result
                else
                    res.send (errMsg err)
    app.post path,(restify.getCreateController model)
    app.get pathWithId, (restify.getReadController model)
    app.put pathWithId, (restify.getUpdateController model)
    app.del pathWithId, (restify.getDeleteController model)

module.exports = restifyProducts
