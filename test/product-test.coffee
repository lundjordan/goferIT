mongoose = require 'mongoose'
Company = require '../models/company-mongo'
Store = require '../models/store-mongo'
Supplier = require '../models/supplier-mongo'
Order = require '../models/order-mongo'
Product = require '../models/product-mongo'

describe "product model mongo CRUD", ->
    [product, store, company, supplier, order] = [null, null, null, null, null]
    mongoUrl = 'mongodb://localhost/gofer-test'

    before (done) ->
        mongoose.connect mongoUrl, ->
            (Product.remove {}).exec()
            (Order.remove {}).exec()
            (Supplier.remove {}).exec()
            (Store.remove {}).exec()
            (Company.remove {}).exec()

        supplier = new Supplier
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
            else
                order = new Order
                    _supplier: supplier.id
                    referenceNum: 'aaa111bbb222'
                    shippingInfo:
                        company: 'UPS'
                        travelType: 'air'
                        cost: 10000
                    arrivaldate: '12/12/12'

                order.save (err) ->
                    if err
                        throw err
                    else
                        company = new Company
                            name: "Nad's Hardware"
                            subscriptionType: "trial"
                        company.save (err) ->
                            if err
                                throw err
                            else
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

    describe "should create a valid Product", ->
        it "and save newly created product", (done) ->
            product = new Product
                _store: store.id
                _order: order.id
                serialID: '666666666'
                description:
                    brand: 'CCM'
                    name: 'skate pro'
                category: 'hockey'
                cost: 7500
                price: 15000
            product.save (err) ->
                if err
                    throw err
                else
                    done()

        it "then retrieve serial id and name from new product", (done) ->
            Product.findOne _id: product.id, (err, resProduct) ->
                resProduct.serialID.should.equal '666666666'
                resProduct.description.name.should.equal 'skate pro'
                done()

        it "then retrieve the product store's name", (done) ->
            (Product.findOne _id: product.id)
                .populate('_store').exec (err, product) ->
                    product._store.name.should.equal 'Second Grove'
                    done()

        it "then retrieve the product order's referenceNum", (done) ->
            (Product.findOne _id: product.id)
                .populate('_order').exec (err, product) ->
                    product._order.referenceNum.should.equal 'aaa111bbb222'
                    done()

    after (done) ->
        (Product.remove {}).exec()
        (Order.remove {}).exec()
        (Supplier.remove {}).exec()
        (Store.remove {}).exec()
        (Company.remove {}).exec()
        mongoose.connection.close()
        done()
