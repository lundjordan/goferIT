LocalStrategy = (require 'passport-local').Strategy

passport = (User, passport) ->

    passport.serializeUser (user, done) ->
        done null, user.id

    passport.deserializeUser (id, done) ->
        User.findById id, (err, user) ->
            done err, user

    passport.use new LocalStrategy usernameField: 'email', (username, password, done) ->
        console.log 'made it here!!'
        # process.nextTick ->
        User.authenticate username, password, (err, user) ->
            return done err, user

module.exports = passport
