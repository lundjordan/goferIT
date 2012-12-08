mongoose = require 'mongoose'
Store = require '../back_end/models/store'

describe "store model mongo CRUD", ->
    store = null
    mongoUrl = 'mongodb://localhost/gofer-test'

    before (done) ->
        mongoose.connect mongoUrl, ->
            (Store.remove {}).exec ->
                done()

    describe "should create a valid Store", ->
        it "and save newly created store", (done) ->
            store = new Store
                name: 'Second Grove'
                phone: 16049291111
                address:
                    street: '1234 sesame street'
                    postalCode: 'v7w4c9'
                    city: 'West Vancouver'
                    country: 'Canada'
                dateCreated: new Date().toISOString()
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

    after (done) ->
        (Store.remove {}).exec ->
            mongoose.connection.close ->
                done()
