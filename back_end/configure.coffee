app_configure = (app) ->
    express = require 'express'
    path = require 'path'
    passport = require 'passport'
    flash = require 'connect-flash'

    app.configure ->
        app.set 'port', process.env.PORT || 3000
        app.set 'views', "#{__dirname}/views"
        app.set 'view engine', 'jade'
        app.use express.favicon()
        app.use express.cookieParser()
        app.use express.logger 'dev'
        app.use express.bodyParser()
        app.use express.methodOverride()
        app.use express.session { secret: 'keyboard cat' }
        app.use flash()
        # Initialize Passport! Also use passport.session() middleware, to support
        # persistent login sessions (recommended).
        app.use passport.initialize()
        app.use passport.session()
        app.use app.router
        app.use express.static path.join __dirname, 'front_end'

    app.configure 'development', ->
        app.use express.errorHandler()

    app.configure 'test', ->
        app.set 'port', 3001

module.exports = app_configure
