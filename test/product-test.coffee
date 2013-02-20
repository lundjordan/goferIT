mongoose = require 'mongoose'
Company = require '../models/company-mongo'
Supplier = require '../models/supplier-mongo'
Order = require '../models/order-mongo'
Product = require '../models/product-mongo'

describe "product model mongo CRUD", ->
    [product, company, supplier, order] = [null, null, null, null]
    mongoUrl = 'mongodb://localhost/gofer-test'

    before (done) ->
        mongoose.connect mongoUrl, ->
            (Product.remove {}).exec()
            (Order.remove {}).exec()
            (Supplier.remove {}).exec()
            (Company.remove {}).exec()

            company = new Company
                name: "Nad's Hardware"
                subscriptionType: "trial"
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
                        _supplier: supplier._id
                        referenceNum: 'aaa111bbb222'
                        shippingInfo:
                            company: 'UPS'
                            travelType: 'air'
                            cost: 10000
                        arrivaldate: '12/12/12'

                    order.save (err) ->
                        if err
                            throw err
                        done()

    describe "should create a valid Product", ->
        it "and save newly created product", (done) ->
            product = new Product
                _company: company.id
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
                done()

        it "then retrieve serial id and name from new product", (done) ->
            Product.findOne _id: product.id, (err, resProduct) ->
                resProduct.serialID.should.equal '666666666'
                resProduct.description.name.should.equal 'skate pro'
                done()

        it "then retrieve the product company's name", (done) ->
            (Product.findOne _id: product.id)
                .populate('_company').exec (err, product) ->
                    product._company.name.should.equal "Nad's Hardware"
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
        (Company.remove {}).exec()
        mongoose.connection.close()
        done()
