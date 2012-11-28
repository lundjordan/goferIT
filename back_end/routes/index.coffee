routes = (app) ->

    app.get '/', (req, res) ->
        res.render "#{__dirname}/../views/index",
            {title: '', stylesheet: 'index', user: req.user}

module.exports = routes
