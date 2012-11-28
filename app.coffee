express = require 'express'
path = require 'path'
util = require 'util'
passport = require 'passport'
LocalStrategy = (require 'passport-local').Strategy

## models
User = require './back_end/models/user'
#

passport.serializeUser (user, done) ->
    done null, user.id

passport.deserializeUser (id, done) ->
    User.findById id, (err, user) ->
        done err, user

passport.use new LocalStrategy usernameField: 'email', (username, password, done) ->
    console.log 'made it here!!'
    # process.nextTick ->
    return 'I am BROKEN'
    # User.authenticate username, password, (err, user) ->
    #     return done err, user

# authentication setup
# passport = (require './back_end/utils/authenticateUtils') User, passport

# kick off the app/express
app = module.exports = express()

# configure express
(require './back_end/configure') app, passport

## Routes
(require './back_end/routes/index') app
(require './back_end/routes/authentication') app, passport
##

server = app.listen app.settings.port
console.log "Express server listening on port #{app.settings.port} in #{app.settings.env} mode"
