restifyProducts = (app, restify, model) ->
    path = "/products"
    pathWithId = "/products/:id"

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
                                res.send stock
                            else
                                res.send (errMsg err)
                else
                    res.send (errMsg err)

    # app.post path, (restify.getCreateController model)
    app.get pathWithId, (restify.getReadController model)

    app.put pathWithId, (req, res) ->
        (model.findOne {_company: req.user._company})
            .populate('products._order')
            .exec (err, stock) ->
                if not err
                    product = stock.products.id req.params.id
                    for key, value of req.body
                        product[key] = value
                    stock.save (err) ->
                        if not err
                            console.log stock
                            res.send stock
                        else
                            console.log(errMsg err)
                            res.send (errMsg err)
    app.del pathWithId, (restify.getDeleteController model)


module.exports = restifyProducts
