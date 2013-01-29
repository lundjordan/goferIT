routes = (app) ->

    #TODO not XXX hack newSignupStatus

    app.get '/', (req, res) ->
        res.render "#{__dirname}/../views/index",
            {title: '', stylesheet: 'style', user: req.user, alert: req.flash('error'), alert_type: ''}

    app.get '/signupSuccess', (req, res) ->
        message = "You have now registered. Please Sign in at the top right!"
        res.render "#{__dirname}/../views/index",
            {title: '', stylesheet: 'style', user: req.user, alert: message, alert_type: 'success'}

    app.get '/signupFail', (req, res) ->
        message = "Something went wrong. Please try registering again!"
        res.render "#{__dirname}/../views/index",
            {title: '', stylesheet: 'style', user: req.user, alert: message, alert_type: ''}


module.exports = routes
