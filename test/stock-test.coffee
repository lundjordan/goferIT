mongoose = require 'mongoose'
Company = require '../models/company-mongo'
Supplier = require '../models/supplier-mongo'
Order = require '../models/order-mongo'
Stock = require '../models/stock-mongo'

describe "stock model mongo CRUD", ->
    [stock, company, supplier, order] = [null, null, null, null]
    mongoUrl = 'mongodb://localhost/gofer-test'

    before (done) ->
        mongoose.connect mongoUrl, ->
            (Stock.remove {}).exec()
            (Order.remove {}).exec()
            (Supplier.remove {}).exec()
            (Company.remove {}).exec()

            company = new Company
                name: "Nad's Hardware"
                subscriptionType: "trial"
                stores: [
                    name: 'Main Store'
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
                supplier = new Supplier
                    _company: company._id
                    email: 'abc@gmail.com'
                    name: 'abc suppliers'
                    phone: 16049291111
                    address:
                        street: '1234 sesame street'
                        postalCode: 'v7w4c9'
                        city: 'West Vancouver'
                        country: 'Canada'
                supplier.save (err) ->
                    if err
                        throw err
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
                        ]
                        referenceNum: 'aaa111bbb222'
                        shippingInfo:
                            company: 'UPS'
                            travelType: 'air'
                            cost: 10000
                        estimatedArrivalDate: '04/28/13'

                    order.save (err) ->
                        if err
                            throw err
                        done()

    describe "should create a valid Stock", ->
        it "and save newly created stock", (done) ->
            stock = new Stock
                _company: company.id
                storeName: company.stores[0].name
                products: [
                    description:
                        brand: 'Bauer'
                        name: 'Vapor X4.0'
                    category: 'Hockey Skates'
                    cost: 30000
                    price: 40000
                    size: 8
                    _order: order.id
                ,
                    description:
                        brand: 'Bauer'
                        name: 'Vapor X4.0'
                    category: 'Hockey Skates'
                    cost: 30000
                    price: 40000
                    size: 9
                    _order: order.id
                ,
                    description:
                        brand: 'CCM'
                        name: 'Crazy Light'
                    category: 'Hockey Skates'
                    cost: 45000
                    price: 65000
                    size: 9
                    _order: order.id
                ]
            stock.save (err) ->
                if err
                    throw err
                done()

        it "then retrieve serial id and name from new stock", (done) ->
            Stock.findOne _id: stock.id, (err, resStock) ->
                resStock.products[0].cost.should.equal 30000
                done()

        it "then retrieve the stock company's name", (done) ->
            (Stock.findOne _id: stock.id)
                .populate('_company').exec (err, stock) ->
                    stock._company.name.should.equal "Nad's Hardware"
                    done()


    after (done) ->
        (Stock.remove {}).exec()
        (Order.remove {}).exec()
        (Supplier.remove {}).exec()
        (Company.remove {}).exec()
        mongoose.connection.close()
        done()
