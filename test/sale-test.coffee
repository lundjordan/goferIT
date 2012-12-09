mongoose = require 'mongoose'
Customer = require '../back_end/models/customer'
Terminal = require '../back_end/models/terminal'
Store = require '../back_end/models/store'
Product = require '../back_end/models/product'
Sale = require '../back_end/models/sale'
Supplier = require '../back_end/models/supplier'
Order = require '../back_end/models/order'
Employee = require '../back_end/models/employee'

describe "sale model mongo CRUD", ->
    [product, customer, terminal, sale] = [null, null, null, null]
    [employee, store, order, supplier] = [null, null, null, null]
    mongoUrl = 'mongodb://localhost/gofer-test'

    # customer = createCustomer ->
    # supplier = createSupplier ->
    # store = createStore ->
    # order = createOrder ->
    # employee = createEmployee ->
    # terminal = createTerminal ->
    # product = createProduct ->

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
                                        employee = new Employee
                                            email: 'nadroj@gmail.com'
                                            password: 'secretpassword'
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
            Sale.findOne _id: sale.id, (err, resSale) ->
                Terminal.findOne _id: resSale._terminal, (err, resTerminal) ->
                    resTerminal.referenceNum.should.equal 1
                    done()

        it "then retrieve the sale's product's price", (done) ->
            Sale.findOne _id: sale.id, (err, resSale) ->
                Product.findOne _id: resSale._product, (err, resProduct) ->
                    resProduct.cost.should.equal 7500
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
        mongoose.connection.close()
        done()
