errMsg = (msg) ->
    return error:
        message: msg.toString()

restifyProducts = (app, restify, model) ->
    path = "/products"
    pathWithId = "/products/:id"

    app.get path, (req, res) ->
        model.findOne({_company: req.user._company})
            .exec (err, result) ->
                if not err
                    if result
                        res.send result.products
                    else
                        res.send []
                else
                    res.send (errMsg err)

    app.post path, (req, res) ->
        console.log '####> creating a new product'
        (model.findOne {_company: req.user._company})
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
                                res.send stock
                            else
                                res.send (errMsg err)
                else
                    res.send (errMsg err)

    app.get pathWithId, (restify.getReadController model)

    app.put pathWithId, (req, res) ->
        console.log '####> updating an existing product'
        (model.findOne {_company: req.user._company})
            .exec (err, stock) ->
                if not err
                    product = stock.products.id req.params.id
                    for key, value of req.body
                        product[key] = value
                    stock.save (err) ->
                        if not err
                            res.send stock.products.id req.params.id
                        else
                            res.send (errMsg err)

    app.del pathWithId, (req, res) ->
        (model.findOne {_company: req.user._company})
            .exec (err, stock) ->
                if not err
                    product = stock.products.id(req.params.id).remove()
                    stock.save (err) ->
                        if not err
                            res.send stock
                        else
                            res.send (errMsg err)


module.exports = restifyProducts
