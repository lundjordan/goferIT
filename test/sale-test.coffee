mongoose = require 'mongoose'
Company = require '../models/company-mongo'
Customer = require '../models/customer-mongo'
Stock = require '../models/stock-mongo'
Sale = require '../models/sale-mongo'
Supplier = require '../models/supplier-mongo'
Order = require '../models/order-mongo'
Employee = require '../models/employee-mongo'

describe "sale model mongo CRUD", ->
    [stock, customer, sale] = [null, null, null]
    [company, employee, order, supplier] = [null, null, null, null]
    mongoUrl = 'mongodb://localhost/gofer-test'

    before (done) ->
        mongoose.connect mongoUrl, ->
            (Sale.remove {}).exec()
            (Stock.remove {}).exec()
            (Employee.remove {}).exec()
            (Order.remove {}).exec()
            (Supplier.remove {}).exec()
            (Customer.remove {}).exec()
            (Company.remove {}).exec()

        company = new Company
            name: "Nad's Hardware"
            subscriptionType: "trial"
            dateCreated: new Date().toISOString()
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
            customer = new Customer
                email: 'nadroj@gmail.com'
                _company: company._id
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
                    _company: company._id
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
                        employee = new Employee
                            email: 'nadroj@gmail.com'
                            password: 'secretpassword'
                            _company: company._id
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

                        employee.save (err) ->
                            if err
                                throw err
                            stock = new Stock
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
                                    _order: order.id
                                ]
                            stock.save (err) ->
                                if err
                                    throw err
                                done()

    describe "should create a valid Sale", ->
        it "and save newly created sale", (done) ->
            sale = new Sale
                _company: company._id
                _employee: employee.id
                storeName: company.stores[0].name
                products: [
                    stock.products[0],
                    stock.products[1],
                ]
            sale.save (err) ->
                if err
                    throw err
                done()

        it "then retrieve the employee id from the sale", (done) ->
            (Sale.findOne _id: sale.id)
                .populate('_employee').exec (err, employee) ->
                    employee._employee.email.should.equal 'nadroj@gmail.com'
                    done()


    after (done) ->
        (Sale.remove {}).exec()
        (Stock.remove {}).exec()
        (Employee.remove {}).exec()
        (Order.remove {}).exec()
        (Supplier.remove {}).exec()
        (Customer.remove {}).exec()
        (Company.remove {}).exec()
        mongoose.connection.close()
        done()
