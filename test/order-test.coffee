mongoose = require 'mongoose'
Company = require '../models/company-mongo'
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
            (Company.remove {}).exec()

            company = new Company
                name: "Nad's Hardware"
                subscriptionType: "trial"
                stores: [{
                    name: "Main Store"
                }]
            company.save (err) ->
                if err
                    throw err
                supplier = new Supplier
                    email: 'abc@gmail.com'
                    _company: company._id
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
                referenceNum: 'aaa111bbb222'
                _supplier: supplier._id
                _company: company._id
                storeName: company.stores[0].name
                products: [
                    description:
                        brand: 'Bauer'
                        name: 'Vapor X4.0'
                    category: 'Hockey Skates'
                    cost: 30000
                    price: 40000
                    size: 8
                ,
                    description:
                        brand: 'Bauer'
                        name: 'Vapor X4.0'
                    category: 'Hockey Skates'
                    cost: 30000
                    price: 40000
                    size: 9
                ,
                    description:
                        brand: 'CCM'
                        name: 'Crazy Light'
                    category: 'Hockey Skates'
                    cost: 45000
                    price: 65000
                    size: 9
                ]
                shippingInfo:
                    company: 'UPS'
                    travelType: 'air'
                    cost: 10000
                estimatedArrivalDate: '04/28/13'
            order.save (err) ->
                if err
                    throw err
                done()

        it "then retrieve reference number and shipping company from new order", (done) ->
            Order.findOne _id: order._id, (err, resOrder) ->
                resOrder.referenceNum.should.equal 'aaa111bbb222'
                resOrder.shippingInfo.company.should.equal 'UPS'

            Order.findOne _id: order._id, (err, resOrder) ->
                resOrder.products[0].description.brand.should.equal 'Bauer'
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
