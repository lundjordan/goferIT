restifyProducts = (app, restify, model) ->
    path = "/products"
    pathWithId = "products/:id"

    app.get path, (req, res) ->
        (model.findOne {_company: req.user._company})
            .populate('products._order')
            .exec (err, result) ->
                if not err
                    res.send result.products
                else
                    res.send (errMsg err)

    app.post path, (req, res) ->
        (model.findOne {_company: req.user._company})
            .populate('products._order')
            .exec (err, stock) ->
                if not err
                    model.update
                        _id: stock.id
                    ,
                        $push:
                            products: req.body
                    ,
                        (err, stock) ->
                            if not err
                                console.log stock.products
                                return stock
                            else
                                return (errMsg err)
                else
                    res.send (errMsg err)

    # app.post path, (restify.getCreateController model)
    app.get pathWithId, (restify.getReadController model)
    app.put pathWithId, (restify.getUpdateController model)
    app.del pathWithId, (restify.getDeleteController model)


module.exports = restifyProducts
