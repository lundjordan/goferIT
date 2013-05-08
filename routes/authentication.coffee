Employee = require '../models/employee-mongo'
Company = require '../models/company-mongo'

routes = (app, passport) ->
    failureRedirection = {failureRedirect: '/', failureFlash: true}

    app.post '/login', (passport.authenticate 'local', failureRedirection), (req, res) ->
        res.redirect '/'

    app.get '/logout', (req, res) ->
        req.logout()
        res.redirect '/'

    app.post '/register', (req, res) ->
        registeredErrorFree = true
        [company, employee] = [null, null]
        company = new Company
            name: req.body.companyName
            subscriptionType: "trial"
            stores: [
                name: 'Main Store'
            ]
        company.save (err) ->
            if err
                throw err
                registeredErrorFree = false
            employee = new Employee
                email: req.body.email
                _company: company.id
                password: req.body.password
                name:
                    first: req.body.fullName.match(/[^\s-]+-?/g)[0]
                    last: req.body.fullName.match(/[^\s-]+-?/g)[1]
                title: 'admin'
            employee.save (err) ->
                if err
                    throw err
                    registeredErrorFree = false
                if not registeredErrorFree
                    if Employee.findById(employee.id)
                        employee.remove (err, obj) ->
                            if err
                                console.log err
                    if Company.findById(company.id)
                        company.remove (err, obj) ->
                            if err
                                console.log err
                    req.flash 'error', 'Something went wrong. Please try registering again!'
                    res.redirect '/'
                else
                    req.flash 'info', 'You have now registered. Please Sign in at the top right!'
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
