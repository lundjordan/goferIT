routes = (app) ->

    #TODO not XXX hack newSignupStatus

    app.get '/', (req, res) ->
        if req.user
            res.render "#{__dirname}/../views/userIndex", # render the logged in welcome page
                {title: '', stylesheet: 'userStyle', user: req.user, alert: req.flash('error'), alert_type: ''}
        else
            res.render "#{__dirname}/../views/visitorIndex", # render the marketing welcome page
                {title: '', stylesheet: 'visitorStyle', alert: req.flash('error'), alert_type: ''}

    app.get '/signupSuccess', (req, res) ->
        message = "You have now registered. Please Sign in at the top right!"
        res.render "#{__dirname}/../views/index",
            {title: '', stylesheet: 'style', user: req.user, alert: message, alert_type: 'success'}

    app.get '/signupFail', (req, res) ->
        message = "Something went wrong. Please try registering again!"
        res.render "#{__dirname}/../views/index",
            {title: '', stylesheet: 'style', user: req.user, alert: message, alert_type: ''}


module.exports = routes
