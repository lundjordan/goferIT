
express = require 'express'
mongoose = require 'mongoose'
path = require 'path'
passport = require 'passport'
flash = require 'connect-flash'
util = require 'util'
LocalStrategy = (require 'passport-local').Strategy


#TODO connect to mongodb server
users = [ # just a dummy db for testing until we hook up mongo
    { id: 1, username: 'bob', password: 'secret', email: 'bob@example.com' },
    { id: 2, username: 'joe', password: 'birthday', email: 'joe@example.com' }
]

findById = (id, fn) ->
    if users[id - 1]
        fn null, users[id - 1]
    else
        (fn new Error "User #{id} does not exist")


findByUsername = (username, fn) ->
    for user in users
        if user.username is username
            return fn null, user
        else
            return fn null, null
##

passport.serializeUser (user, done) ->
    done(null, user.id)


passport.deserializeUser (id, done) ->
    findById id, (err, user) ->
        done(err, user)

passport.use new LocalStrategy (username, password, done) ->
    process.nextTick ->
        findByUsername username, (err, user) ->
            if err
                return done err
            if !user
                return done null, false, { message: "Unknown user #{username}" }
            if user.password != password
                return done null, false, { message: 'Invalid password' }

            done null, user # username and password is correct!

app = module.exports = express()

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
    app.use express.static path.join __dirname, 'public'

app.configure 'development', ->
    app.use express.errorHandler()

app.configure 'test', ->
    app.set 'port', 3001

## Routes

# home page
app.get '/', (req, res) ->
    res.render 'index', {title: 'Gofer', stylesheet: 'index', user: req.user}


(require './apps/authentication/routes') app, passport

##

server = app.listen app.settings.port
console.log "Express server listening on port #{app.settings.port} in #{app.settings.env} mode"
