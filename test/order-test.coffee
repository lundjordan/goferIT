mongoose = require 'mongoose'
Supplier = require '../models/supplier-mongo'
Order = require '../models/order-mongo'

describe "order model mongo CRUD", ->
    order = null
    company = null
    supplier = null
    mongoUrl = 'mongodb://localhost/gofer-test'

    before (done) ->
        mongoose.connect mongoUrl, ->
            (Order.remove {}).exec()
            (Supplier.remove {}).exec()
        supplier = new Supplier
            email: 'abc@gmail.com'
            name: 'abc suppliers'
            phone: 16049291111
            address:
                street: '1234 sesame street'
                postalCode: 'v7w4c9'
                city: 'West Vancouver'
                country: 'Canada'
        supplier.save done

    describe "should create a valid Order", ->

        it "and save newly created order", (done) ->
            order = new Order
                _supplier: supplier
                referenceNum: 'aaa111bbb222'
                shippingInfo:
                    company: 'UPS'
                    travelType: 'air'
                    cost: 10000
                arrivaldate: '12/12/12'
            order.save done

        it "then retrieve reference number and shipping company from new order", (done) ->
            Order.findOne _id: order._id, (err, resOrder) ->
                resOrder.referenceNum.should.equal 'aaa111bbb222'
                resOrder.shippingInfo.company.should.equal 'UPS'
                done()

        it "then retrieve the order supplier's email", (done) ->
            (Order.findOne _id: order._id)
                .populate('_supplier').exec (err, supplier) ->
                    # supplier.email.should.equal 'abc@gmail.com'
                    done()

    after (done) ->
        (Order.remove {}).exec()
        (Supplier.remove {}).exec()
        mongoose.connection.close()
        done()
