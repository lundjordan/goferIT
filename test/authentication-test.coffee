require './_helper'
assert  = require 'assert'
request = require 'request'
app     = require '../app'

describe "authentication", ->
    describe "GET /login", ->
        body = null

        before (done) ->
            options =
                uri: "http://localhost:#{app.settings.port}/login"
            request options, (err, response, _body) ->
                body = _body
                done()
        it "has title", ->
            assert.hasTag body, '//head/title', 'Gofer - Login'
        it "has user field", ->
            assert.hasTag body, '//input[@name="username"]', ''
        it "has password field", ->
            assert.hasTag body, '//input[@name="password"]', ''


    describe "POST /login", ->
        describe "incorrect username", ->
            body = null
            before (done) ->
                options =
                    uri:"http://localhost:#{app.settings.port}/login"
                    form:
                        username: 'not_a_user'
                        password: 'password'
                    followAllRedirects: true
                request.post options, (err, res, _body) ->
                    body = _body
                    done()
            it "shows unknown username flash", ->
                errorText = 'Unknown user not_a_user'
                assert.hasTag body, "//p", errorText

        describe "incorrect password", ->
            body = null
            before (done) ->
                options =
                    uri:"http://localhost:#{app.settings.port}/login"
                    form:
                        username: 'bob'
                        password: 'password'
                    followAllRedirects: true
                request.post options, (err, res, _body) ->
                    body = _body
                    done()
            it "shows unknown password flash", ->
                errorText = 'Invalid password'
                assert.hasTag body, "//p", errorText

        describe "correct credentials", ->
            [body, res] = [null, null]
            before (done) ->
                options =
                    uri:"http://localhost:#{app.settings.port}/login"
                    form:
                        username: 'bob'
                        password: 'secret'
                    followAllRedirects: true
                request.post options, (err, _res, _body) ->
                    [body, res] = [_body,  _res]
                    done()
            it "shows welcome user flash", ->
                assert.equal res.request.path, '/'
                assert.hasTag body, "//p", "Welcome bob"

    # describe "DELETE /login", ->
    #     #TODO

