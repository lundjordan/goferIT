mongoose = require 'mongoose'
Terminal = require '../back_end/models/terminal'
Store = require '../back_end/models/store'

describe "terminal model mongo CRUD", ->
    terminal = null
    store = null
    mongoUrl = 'mongodb://localhost/gofer-test'

    before (done) ->
        mongoose.connect mongoUrl, ->
            (Terminal.remove {}).exec()
            (Store.remove {}).exec()
        store = new Store
            name: 'Alpine Place'
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
        it "then retrieve referenceNum and associated store name from new terminal", (done) ->
            Terminal.findOne _id: terminal.id, (err, resTerminal) ->
                resTerminal.referenceNum.should.equal 1
                resTerminal._store.name.should.equal 'Alpine Place'
            done()

    after (done) ->
        (Terminal.remove {}).exec()
        (Store.remove {}).exec()
        mongoose.connection.close()
        done()
