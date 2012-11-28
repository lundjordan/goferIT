mongoose = require 'mongoose'
User = require '../back_end/models/user'

describe "user model CRUD", ->
    [storedName, storedEmail] = [null, null]
    before (done) ->
        mongoose.connect 'mongodb://localhost/gofer-test', ->
            User.remove done
    describe "should create a valid new User", ->
        user = new User
            email: 'nadroj@gmail.com'
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
        it "retrieve email and first name from mongodb", ->
            user.save ->
                console.log user.id
                User.findOne _id: user.id, (err, resUser) ->
                    [storedEmail, storedName] = [resUser.email, resUser.name.first]
                    storedEmail.should.equal 'nadroj@gmail.com'
                    storedName.should.equal 'Nadroj'


