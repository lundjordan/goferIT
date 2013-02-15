mongoose = require 'mongoose'
Company = require '../models/company-mongo'
Customer = require '../models/customer-mongo'
Store = require '../models/store-mongo'
Product = require '../models/product-mongo'
Sale = require '../models/sale-mongo'
Supplier = require '../models/supplier-mongo'
Order = require '../models/order-mongo'
Employee = require '../models/employee-mongo'

describe "sale model mongo CRUD", ->
    [product, customer, sale] = [null, null, null]
    [company, employee, store, order, supplier] = [null, null, null, null, null]
    mongoUrl = 'mongodb://localhost/gofer-test'

    before (done) ->
        mongoose.connect mongoUrl, ->
            (Sale.remove {}).exec()
            (Product.remove {}).exec()
            (Employee.remove {}).exec()
            (Order.remove {}).exec()
            (Store.remove {}).exec()
            (Supplier.remove {}).exec()
            (Customer.remove {}).exec()
            (Company.remove {}).exec()

        company = new Company
            name: "Nad's Hardware"
            subscriptionType: "trial"
            dateCreated: new Date().toISOString()
        company.save (err) ->
            if err
                throw err
            customer = new Customer
                email: 'nadroj@gmail.com'
                name:
                    first: 'Nadroj'
                    last: 'dnul'
                phone: 16049291111
                address:
                    street: '1234 sesame street'
                    postalCode: 'v7w4c9'
                    city: 'West Vancouver'
                    country: 'Canada'
                dob: '1986-09-20'
                dateCreated: new Date().toISOString()
            customer.save (err) ->
                if err
                    throw err
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
                            employee = new Employee
                                email: 'nadroj@gmail.com'
                                password: 'secretpassword'
                                _company: company.id
                                name:
                                    first: 'Nadroj'
                                    last: 'dnul'
                                phone: '16049291111'
                                address:
                                    street: '1234 sesame street'
                                    postalCode: 'v7w4c9'
                                    city: 'West Vancouver'
                                    country: 'Canada'
                                dob: '1986-09-20'
                                title: 'employee'
                                _store: store

                            employee.save (err) ->
                                if err
                                    throw err
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
                                    done()

    describe "should create a valid Sale", ->
        it "and save newly created sale", (done) ->
            sale = new Sale
                _employee: employee.id
                _product: product.id
            sale.save (err) ->
                if err
                    throw err
                done()

        it "then retrieve the employee id from the sale", (done) ->
            (Sale.findOne _id: sale.id)
                .populate('_employee').exec (err, employee) ->
                    employee._employee.email.should.equal 'nadroj@gmail.com'
                    done()

        it "then retrieve the sale's product's price", (done) ->
            (Sale.findOne _id: sale.id)
                .populate('_product').exec (err, product) ->
                    product._product.cost.should.equal 7500
                    done()

    after (done) ->
        (Sale.remove {}).exec()
        (Product.remove {}).exec()
        (Employee.remove {}).exec()
        (Order.remove {}).exec()
        (Store.remove {}).exec()
        (Supplier.remove {}).exec()
        (Customer.remove {}).exec()
        (Company.remove {}).exec()
        mongoose.connection.close()
        done()
