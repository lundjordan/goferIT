
routes = (app, passport) ->
    failureRedirection = {failureRedirect: '/login', failureFlash: true}

    app.get '/login', (req, res) ->
        res.render "#{__dirname}/../views/login", { user: req.user, message: req.flash('error') }

    app.post '/login', (passport.authenticate 'local', failureRedirection), (req, res) ->
        res.redirect '/'

    app.get '/logout', (req, res) ->
        req.logout()
        res.redirect '/'

    #TODO do an account details and ensure authenticated
    # app.get('/account', ensureAuthenticated, function(req, res){
    #   res.render('account', { user: req.user });
    # });

    ensureAuthenticated = (req, res, next) ->
        if req.isAuthenticated()
            return next()
        res.redirect '/login'

module.exports = routes
