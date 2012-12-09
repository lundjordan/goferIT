mongoose = require 'mongoose'
Store = require '../back_end/models/store'
Supplier = require '../back_end/models/supplier'
Order = require '../back_end/models/order'
Product = require '../back_end/models/product'

describe "product model mongo CRUD", ->
    [product, store, supplier, order] = [null, null, null, null]
    mongoUrl = 'mongodb://localhost/gofer-test'

    before (done) ->
        mongoose.connect mongoUrl, ->
            (Product.remove {}).exec()
            (Order.remove {}).exec()
            (Supplier.remove {}).exec()
            (Store.remove {}).exec()

        supplier = new Supplier
            email: 'abc@gmail.com'
            companyName: 'abc suppliers'
            phone: 16049291111
            address:
                street: '1234 sesame street'
                postalCode: 'v7w4c9'
                city: 'West Vancouver'
                country: 'Canada'
            dateCreated: new Date().toISOString()
        supplier.save (err) ->
            if err
                throw err
            else
                order = new Order
                    _supplier: supplier
                    referenceNum: 'aaa111bbb222'
                    shippingInfo:
                        company: 'UPS'
                        travelType: 'air'
                        cost: 10000
                    arrivaldate: '12/12/12'
                    dateCreated: new Date().toISOString()

                order.save (err) ->
                    if err
                        throw err
                    else
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

    describe "should create a valid Product", ->
        it "and save newly created product", (done) ->
            product = new Product
                _store: store
                _order: order
                serialID: '666666666'
                description:
                    brand: 'CCM'
                    name: 'skate pro'
                category: 'hockey'
                cost: 7500
                price: 15000
                dateCreated: new Date().toISOString()
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
            Product.findOne _id: product.id, (err, resProduct) ->
                Store.findOne _id: resProduct._store, (err, resStore) ->
                    resStore.name.should.equal 'Second Grove'
            done()
        it "then retrieve the product order's referenceNum", (done) ->
            Product.findOne _id: product.id, (err, resProduct) ->
                Order.findOne _id: resProduct._order, (err, resOrder) ->
                    resOrder.referenceNum.should.equal 'aaa111bbb222'
            done()

    after (done) ->
        (Product.remove {}).exec()
        (Order.remove {}).exec()
        (Supplier.remove {}).exec()
        (Store.remove {}).exec()
        mongoose.connection.close()
        done()