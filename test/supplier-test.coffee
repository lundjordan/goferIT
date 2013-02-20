mongoose = require 'mongoose'
Company = require '../models/company-mongo'
Supplier = require '../models/supplier-mongo'

describe "supplier model mongo CRUD", ->
    company = null
    supplier = null
    mongoUrl = 'mongodb://localhost/gofer-test'

    before (done) ->
        mongoose.connect mongoUrl, ->
            (Supplier.remove {}).exec()
            (Company.remove {}).exec()
            company = new Company
                name: "Nad's Hardware"
                subscriptionType: "trial"
            company.save (err) ->
                if err
                    throw err
                done()

    describe "should create a valid Supplier", ->
        it "and save newly created supplier", (done) ->
            supplier = new Supplier
                email: 'abc@gmail.com'
                _company: company._id
                name: 'abc suppliers'
                phone: '16049291111'
                address:
                    street: '1234 sesame street'
                    postalCode: 'v7w4c9'
                    city: 'West Vancouver'
                    country: 'Canada'
            supplier.save done
        it "then retrieve email and first name from new supplier", (done) ->
            Supplier.findOne _id: supplier.id, (err, resSupplier) ->
                resSupplier.email.should.equal 'abc@gmail.com'
                resSupplier.name.should.equal 'abc suppliers'
            done()

    after (done) ->
        (Supplier.remove {}).exec()
        mongoose.connection.close()
        done()
