connectCoffeescript = require 'connect-coffee-script'

expressConfig = (app, passport) ->

    express = require 'express'
    mongoose = require 'mongoose'
    path = require 'path'
    util = require 'util'
    flash = require 'connect-flash'
    mongoStore = require 'connect-mongodb'

    mongodbUrl = 'mongodb://localhost/gofer'

    app.configure ->
        app.set 'port', process.env.PORT || 3000
        app.set 'views', "#{__dirname}/views"
        app.set 'view engine', 'jade'
        app.use express.favicon()
        app.use express.cookieParser()
        app.use express.logger 'dev'
        app.use express.bodyParser()
        app.use express.methodOverride()
        app.use express.session
            store: mongoStore mongodbUrl
            secret: 'this is top secret', ->
                app.use app.router
        app.use flash()
        # Initialize Passport! Also use passport.session() middleware, to support
        # persistent login sessions (recommended).
        app.use passport.initialize()
        app.use passport.session()
        app.use express.static path.join __dirname, 'public'
        app.use connectCoffeescript
            src: path.join __dirname, 'public'
            enable: ['coffeescript']

    app.configure 'development', ->
        app.use express.errorHandler()
        # connect to mongodb
        mongoose.connect mongodbUrl
        mongoose.connection.on 'open', ->
            console.log 'We have connected to mongodb'
        mongoose.set 'debug', true

    app.configure 'test', ->
        app.set 'port', 3001


module.exports = expressConfig
