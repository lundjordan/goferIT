mongoose = require 'mongoose'
Terminal = require '../models/terminal'
Store = require '../models/store'
Company = require '../models/company'

describe "terminal model mongo CRUD", ->
    terminal = null
    store = null
    company = null
    mongoUrl = 'mongodb://localhost/gofer-test'

    before (done) ->
        mongoose.connect mongoUrl, ->
            (Terminal.remove {}).exec()
            (Store.remove {}).exec()
            (Company.remove {}).exec()
            company = new Company
                name: "Nad's Hardware"
                subscriptionType: "trial"
                dateCreated: new Date().toISOString()
            company.save (err) ->
                if err
                    throw err
                else
                    store = new Store
                        name: 'Alpine Place'
                        _company: company.id
                        phone: '16049291111'
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

    describe "should create a valid Terminal", ->
        it "and save newly created terminal", (done) ->
            terminal = new Terminal
                _store: store.id
                referenceNum: 1
            terminal.save (err) ->
                if err
                    throw err
                else
                    done()

        it "then retrieve referenceNum from new terminal", (done) ->
            Terminal.findOne _id: terminal.id, (err, resTerminal) ->
                resTerminal.referenceNum.should.equal 1
            done()

        it "then retrieve store name from new terminal", (done) ->
            (Terminal.findOne _id: terminal.id)
                .populate('_store').exec (err, store) ->
                    store.name.should.equal "Alpine Place"
            done()

    after (done) ->
        (Terminal.remove {}).exec()
        (Store.remove {}).exec()
        (Company.remove {}).exec()
        mongoose.connection.close()
        done()
