mongoose = require 'mongoose'
Company = require '../models/company-mongo'
Customer = require '../models/customer-mongo'

describe "customer model mongo CRUD", ->
    customer = null
    company = null
    mongoUrl = 'mongodb://localhost/gofer-test'

    before (done) ->
        mongoose.connect mongoUrl, ->
            (Customer.remove {}).exec()
            (Company.remove {}).exec()
            company = new Company
                name: "Nad's Hardware"
                subscriptionType: "trial"
            company.save (err) ->
                if err
                    throw err
                done()
            done()

    describe "should create a valid Customer", ->
        it "save newly created customer", (done) ->
            customer = new Customer
                email: 'nadroj@gmail.com'
                _company: company._id
                name:
                    first: 'Nadroj'
                    last: 'dnul'
                phone: 16049291111
                address:
                    street: '1234 sesame street'
                    postalCode: 'v7w4c9'
                    city: 'West Vancouver'
                    country: 'Canada'
                dob: '1986-09-20'
                dateCreated: new Date().toISOString()
            customer.save (err) ->
                if err
                    throw err
                else
                    done()
        it "retrieve email and first name from new customer", (done) ->
            Customer.findOne _id: customer.id, (err, resCustomer) ->
                resCustomer.email.should.equal 'nadroj@gmail.com'
                resCustomer.name.first.should.equal 'Nadroj'
            done()

    after (done) ->
        (Customer.remove {}).exec()
        mongoose.connection.close()
        done()
