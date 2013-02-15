mongoose = require 'mongoose'
Store = require '../models/store-mongo'
Company = require '../models/company-mongo'

describe "store model mongo CRUD", ->
    store = null
    company = null
    mongoUrl = 'mongodb://localhost/gofer-test'

    before (done) ->
        mongoose.connect mongoUrl, ->
            (Company.remove {}).exec()
            (Store.remove {}).exec ->
            company = new Company
                name: "Nad's Hardware"
                subscriptionType: "trial"
            company.save (err) ->
                if err
                    throw err
                else
                    done()

    describe "should create a valid Store", ->
        it "and save newly created store", (done) ->
            store = new Store
                name: 'Second Grove'
                _company: company.id
                phone: 16049291111
                address:
                    street: '1234 sesame street'
                    postalCode: 'v7w4c9'
                    city: 'West Vancouver'
                    country: 'Canada'
            store.save (err) ->
                if err
                    throw err
                else
                    done()
        it "then retrieve email and first name from new store", (done) ->
            Store.findOne _id: store.id, (err, resStore) ->
                resStore.phone.should.equal 16049291111
                resStore.name.should.equal 'Second Grove'
            done()

        it "then retrieve company name from new store", (done) ->
            (Store.findOne _id: store.id)
                .populate('_company').exec (err, resStore) ->
                    resStore._company.name.should.equal "Nad's Hardware"
            done()

    after (done) ->
        (Store.remove {}).exec ->
            (Company.remove {}).exec()
            mongoose.connection.close ->
                done()
