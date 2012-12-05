LocalStrategy = (require 'passport-local').Strategy

passport = (User, passport) ->

    passport.serializeUser (user, done) ->
        done null, user.id

    passport.deserializeUser (id, done) ->
        User.findById id, (err, user) ->
            done err, user

    passport.use new LocalStrategy (username, password, done) ->
        process.nextTick ->
            User.authenticate username, password, done

module.exports = passport
