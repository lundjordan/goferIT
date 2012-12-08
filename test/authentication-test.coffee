require './_helper'
assert  = require 'assert'
request = require 'request'
app     = require '../app'
Employee = require '../back_end/models/employee'
mongoose = require 'mongoose'

describe "authentication", ->
    mongoUrl = 'mongodb://localhost/gofer-test'

    before (done) -> # create a real employee
        mongoose.connect mongoUrl
        mongoose.connection.on 'open', ->
            console.log 'We have connected to mongodb'
        Employee.remove done

    before (done) -> # create a real employee
        employee = new Employee
            email: 'nadroj@gmail.com'
            password: 'secretpassword'
            name:
                first: 'Nadroj'
                last: 'dnul'
            phone: '16049291111'
            address:
                street: '1234 sesame street'
                postalCode: 'v7w4c9'
                city: 'West Vancouver'
                country: 'Canada'
            dob: '1986-09-20'
            title: 'employee'
            startDate: new Date().toISOString()

        employee.save (err) ->
            if err
                throw err
            console.log 'employee nadroj created'
        done()

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
        it "has employee field", ->
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
                        username: 'not_a_employee'
                        password: 'password'
                    followAllRedirects: true
                request.post options, (err, res, _body) ->
                    body = _body
                    done()
            it "will display unknown username flash", ->
                errorText = 'Unknown employee not_a_employee'
                assert.hasTag body, "//p", errorText

        describe "incorrect password", ->
            body = null
            before (done) ->
                options =
                    uri:"http://localhost:#{app.settings.port}/login"
                    form:
                        username: 'nadroj@gmail.com'
                        password: 'wrongPassword'
                    followAllRedirects: true
                request.post options, (err, res, _body) ->
                    body = _body
                    done()
            it "will display  unknown password flash", ->
                errorText = 'Invalid password'
                assert.hasTag body, "//p", errorText

        describe "correct credentials", ->
            [body, res] = [null, null]
            before (done) ->
                options =
                    uri:"http://localhost:#{app.settings.port}/login"
                    form:
                        username: 'nadroj@gmail.com'
                        password: 'secretpassword'
                    followAllRedirects: true
                request.post options, (err, _res, _body) ->
                    [body, res] = [_body,  _res]
                    done()
            it "shows welcome employee flash", ->
                assert.equal res.request.path, '/'
                assert.hasTag body, "//p", "Welcome nadroj@gmail.com"

    # describe "DELETE /login", ->
    #     #TODO

    after (done) ->
        mongoose.connection.close()
        done()
