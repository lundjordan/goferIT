mongoose = require 'mongoose'
Company = require '../models/company-mongo'

describe "company model mongo CRUD", ->
    company = null
    mongoUrl = 'mongodb://localhost/gofer-test'

    before (done) ->
        mongoose.connect mongoUrl, ->
            (Company.remove {}).exec()
            done()

    describe "should create a valid Company", ->
        it "and save newly created company", (done) ->
            company = new Company
                name: "Nad's Hardware"
                subscriptionType: "trial"
                dateCreated: new Date().toISOString()
                stores: [
                    name: 'Second Grove'
                    phone: 16049291111
                    address:
                        street: '1234 sesame street'
                        postalCode: 'v7w4c9'
                        city: 'West Vancouver'
                        country: 'Canada'
                ]
            company.save (err) ->
                if err
                    throw err
                done()

        it "then retrieve comp name from new company", (done) ->
            Company.findOne _id: company.id, (err, resCompany) ->
                console.log resCompany
                resCompany.name.should.equal "Nad's Hardware"
                done()

    after (done) ->
        (Company.remove {}).exec()
        mongoose.connection.close()
        done()
