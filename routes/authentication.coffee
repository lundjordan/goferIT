Employee = require '../models/employee'

routes = (app, passport) ->
    failureRedirection = {failureRedirect: '/login', failureFlash: true}

    app.get '/login', (req, res) ->
        res.render "#{__dirname}/../views/authentication",
            title: 'Login',
            stylesheet: 'login',
            user: req.user,
            message: req.flash('error'),

    app.post '/login', (passport.authenticate 'local', failureRedirection), (req, res) ->
        res.redirect '/'

    app.get '/logout', (req, res) ->
        req.logout()
        res.redirect '/'

    app.get '/register', (req, res) ->
        res.render "#{__dirname}/../views/register",
            title: 'Register',
            stylesheet: 'register',
            user: req.user,
            message: req.flash('error'),

    app.post '/register', (req, res) ->
        newUser = new Employee
            email: req.body.email
            name:
                first: req.body.firstName
                last: req.body.lastName
            password: req.body.password
        newUser.save (err) ->
            if err
                throw err
                res.redirect '/register'
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
