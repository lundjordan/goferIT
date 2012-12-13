routes = (app) ->

    app.get '/', (req, res) ->
        res.render "#{__dirname}/../views/index",
            {title: '', stylesheet: 'style', user: req.user}

module.exports = routes
