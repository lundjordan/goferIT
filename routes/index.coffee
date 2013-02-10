routes = (app) ->

    #TODO not XXX hack newSignupStatus

    app.get '/', (req, res) ->
        if req.user
            res.render "#{__dirname}/../views/userIndex", # render the logged in welcome page
                stylesheet: 'userStyle'
                user: req.user
                info_alert: req.flash('info')
                error_alert: req.flash('error')
        else
            res.render "#{__dirname}/../views/visitorIndex", # render the marketing welcome page
                stylesheet: 'visitorStyle'
                info_alert: req.flash('info')
                error_alert: req.flash('error')

module.exports = routes
