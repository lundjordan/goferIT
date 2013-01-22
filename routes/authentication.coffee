Employee = require '../models/employee'
Company = require '../models/company'

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

    # TODO make sure I can remove this
    # app.get '/register', (req, res) ->
    #     res.render "#{__dirname}/../views/register",
    #         title: 'Register',
    #         stylesheet: 'register',
    #         user: req.user,
    #         message: req.flash('error'),

    app.post '/register', (req, res) ->
        company = new Company
            name: req.body.companyName
            subscriptionType: "trial"
            dateCreated: new Date().toISOString()
        company.save (err) ->
            if err
                throw err
                res.redirect '/SignupFailed'
            else
                employee = new Employee
                    email: req.body.email
                    _company: company.id
                    password: req.body.password
                    name:
                        first: req.body.fullName.match(/[^\s-]+-?/g)[0]
                        last: req.body.fullName.match(/[^\s-]+-?/g)[1]
                    startDate: new Date().toISOString()
                employee.save (err) ->
                    if err
                        throw err
                        company.remove (err, comp) ->
                            if err
                                throw err
                        res.redirect '/SignupFailed'
                    res.redirect '/'

    #TODO do an account details and ensure authenticated
    # app.get('/account', ensureAuthenticated, function(req, res){
    #   res.render('account', { user: req.user });
    # });


    # helpers

    app.post '/uniqueEmail', (req, res) ->
        console.log req.body.email
        Employee.findOne email: req.body.email, (err, resEmployee) ->
            if resEmployee is null
                res.send true
            else
                res.send false

    ensureAuthenticated = (req, res, next) ->
        if req.isAuthenticated()
            return next()
        res.redirect '/login'


module.exports = routes
