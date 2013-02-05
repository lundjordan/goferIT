mongoose = require 'mongoose'
Company = require '../models/company-mongo'
Customer = require '../models/customer-mongo'
Terminal = require '../models/terminal-mongo'
Store = require '../models/store-mongo'
Product = require '../models/product-mongo'
Sale = require '../models/sale-mongo'
Supplier = require '../models/supplier-mongo'
Order = require '../models/order-mongo'
Employee = require '../models/employee-mongo'

describe "sale model mongo CRUD", ->
    [product, customer, terminal, sale] = [null, null, null, null]
    [company, employee, store, order, supplier] = [null, null, null, null, null]
    mongoUrl = 'mongodb://localhost/gofer-test'

    before (done) ->
        mongoose.connect mongoUrl, ->
            (Sale.remove {}).exec()
            (Product.remove {}).exec()
            (Terminal.remove {}).exec()
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
            else
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
                    else
                        supplier = new Supplier
                            email: 'abc@gmail.com'
                            name: 'abc suppliers'
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
                                            _company: company.id
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
                                                    startDate: new Date().toISOString()
                                                    _store: store

                                                employee.save (err) ->
                                                    if err
                                                        throw err
                                                    else
                                                        terminal = new Terminal
                                                            _store: store
                                                            _employee: employee
                                                            referenceNum: 1
                                                        terminal.save (err) ->
                                                            if err
                                                                throw err
                                                            else
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
                                                                    done()

    describe "should create a valid Sale", ->
        it "and save newly created sale", (done) ->
            sale = new Sale
                _terminal: terminal
                _product: product
                dateCreated: new Date().toISOString()
            sale.save (err) ->
                if err
                    throw err
                else
                    done()

        it "then retrieve the terminal id from the sale", (done) ->
            (Sale.findOne _id: sale.id)
                .populate('_terminal').exec (err, terminal) ->
                    # console.log terminal
                    terminal._terminal.referenceNum.should.equal 1
                    done()

        it "then retrieve the sale's product's price", (done) ->
            (Sale.findOne _id: sale.id)
                .populate('_product').exec (err, product) ->
                    # console.log product
                    product._product.cost.should.equal 7500
                    done()

    after (done) ->
        (Sale.remove {}).exec()
        (Product.remove {}).exec()
        (Terminal.remove {}).exec()
        (Employee.remove {}).exec()
        (Order.remove {}).exec()
        (Store.remove {}).exec()
        (Supplier.remove {}).exec()
        (Customer.remove {}).exec()
        (Company.remove {}).exec()
        mongoose.connection.close()
        done()
