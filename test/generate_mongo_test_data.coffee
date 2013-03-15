# globals

async = require 'async'
mongoose = require 'mongoose'
Company = require '../models/company-mongo'
Employee = require '../models/employee-mongo'
Customer = require '../models/customer-mongo'
Supplier = require '../models/supplier-mongo'
Order = require '../models/order-mongo'
Stock = require '../models/stock-mongo'
Sale = require '../models/sale-mongo'
[companyArray, employeeArray, customerArray] = [null, null, null]
[supplierArray, orderArray, stock, saleArray] = [null, null, null, null]

# helpers
createDocInModelHelper = (obj, model) ->
    doc = new model obj
    doc.save (err) ->
        if err
            throw err

findAllDocsInModelHelper = (modelArray, modelCollection, cb) ->
    modelCollection.find (err, docsResult) ->
        if err
            throw err
        modelArray = docsResult
        cb err, 'employee docs stored'

async.series [
    (callback) -> # open mongo connection and remove any previous data
        mongoUrl = 'mongodb://localhost/gofer'
        mongoose.connect mongoUrl, ->
            (Sale.remove {}).exec()
            (Stock.remove {}).exec()
            (Employee.remove {}).exec()
            (Order.remove {}).exec()
            (Supplier.remove {}).exec()
            (Customer.remove {}).exec()
            (Company.remove {}).exec()

            callback(null, 'connected to mongo - gofer-test')

    ,(callback) -> # create and persist test data - companies
        company1 = new Company
            name: "Time Out Sports"
            subscriptionType: "trial"
            stores: [
                name: 'Main Store'
            ,
                name: 'Second Store'
            ]
        company2 = new Company
            name: "The Boardroom"
            subscriptionType: "trial"
            stores: [
                name: 'Main Store'
            ]
        company1.save (err) ->
            if err
                throw err
            company2.save (err) ->
                if err
                    throw err
                callback null, 'created company docs'

    ,(callback) -> # populate listArray - companyArray
        # findAllDocsInModelHelper companyArray, Company, callback
        Company.find (err, docsResult) ->
            if err
                throw err
            companyArray = docsResult
            callback null, 'company docs stored in companyArray'

    ,(callback) -> # employee - generate test data
        employeeObjs = [
            email: 'nadroj@gmail.com'
            _company: companyArray[0].id
            password: 'password'
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
            title: 'admin'
        ,
            email: 'employee1@gmail.com'
            _company: companyArray[0].id
            password: 'password'
            name:
                first: 'Connor'
                last: 'Fitzpatrick'
            phone: '16049292222'
            address:
                street: '2468 Badger Road'
                postalCode: 'v7w-6h2'
                city: 'North Vancouver'
                country: 'Canada'
            dob: '1990-08-12'
            title: 'employee'
        ,
            email: 'rookie@gmail.com'
            _company: companyArray[0].id
            password: 'password'
            name:
                first: 'Jennifer'
                last: 'Hayes'
            phone: '16049292222'
            address:
                street: '1111 apple grove'
                postalCode: 'v7w8p5'
                city: 'West Vancouver'
                country: 'Canada'
            dob: '1981-06-11'
            title: 'employee'
        ]
        async.each employeeObjs, (obj) ->
            createDocInModelHelper obj, Employee

        callback null, 'created employee docs'

    ,(callback) -> # store newly created employee docs
        # findAllDocsInModelHelper employeeArray, Employee, callback
        Employee.find (err, docsResult) ->
            if err
                throw err
            employeeArray = docsResult
            callback err, 'employee docs stored in companyArray'

    ,(callback) -> # customer - generate test data
        customerObjs = [
            email: 'customer1@gmail.com'
            _company: companyArray[0].id
            name:
                first: 'Martin'
                last: 'Brennan'
            phone: 16049992222
            address:
                street: '2222 Beetle Ave'
                postalCode: 'v7w5n8'
                city: 'Vancouver'
                country: 'Canada'
            dob: '1989-02-22'
            sex: 'male'
        ,
            email: 'customer2@gmail.com'
            _company: companyArray[0].id
            name:
                first: 'Joe'
                last: 'Skully'
            phone: 16049992222
            address:
                street: '1234 sesame street'
                postalCode: 'v7w4c9'
                city: 'West Vancouver'
                country: 'Canada'
            dob: '1986-09-20'
            sex: 'male'
        ,
            email: 'customer3@gmail.com'
            _company: companyArray[0].id
            name:
                first: 'Sanzhar'
                last: 'Kushekbayev'
            phone: 16049992222
            address:
                street: '3333 Simple Street'
                postalCode: 'vlr2d5'
                city: 'Vancouver'
                country: 'Canada'
            dob: '1971-01-08'
            sex: 'male'
        ,
            email: 'customer4@gmail.com'
            _company: companyArray[0].id
            name:
                first: 'Jennie'
                last: 'Hayes'
            phone: 16049993333
            address:
                street: '4444 Hazer Street'
                postalCode: 'vlr3d9'
                city: 'Vancouver'
                country: 'Canada'
            dob: '1981-11-26'
            sex: 'female'
        ]
        async.each customerObjs, (obj) ->
            createDocInModelHelper obj, Customer

        callback null, 'customers generated'

    ,(callback) -> # store newly created customer docs
        # findAllDocsInModelHelper customerArray, Customer, callback
        Customer.find (err, docsResult) ->
            if err
                throw err
            customerArray = docsResult
            callback err, 'customer docs stored in companyArray'

    ,(callback) -> # supplier - generate test data
        supplierObjs = [
            email: 'abc@gmail.com'
            _company: companyArray[0].id
            name: 'abc suppliers'
            phone: '16049290000'
            address:
                street: ''
                postalCode: 'v7w4c9'
                city: 'West Vancouver'
                country: 'Canada'
        ,
            email: 'def@gmail.com'
            _company: companyArray[0].id
            name: 'def big co'
            phone: '16049299999'
            address:
                street: '9999 baffle place'
                postalCode: 'v7w3e5'
                city: 'Burnaby'
                country: 'Canada'
        ,
            email: 'ghi@gmail.com'
            _company: companyArray[0].id
            name: 'ghi gear4U'
            phone: '16049298888'
            address:
                street: '777 west hastings'
                postalCode: 'v7w3e7'
                city: 'Vancouver'
                country: 'Canada'
        ]
        async.each supplierObjs, (obj) ->
            createDocInModelHelper obj, Supplier

        callback null, 'suppliers generated'

    ,(callback) -> # store newly created supplier docs
        # findAllDocsInModelHelper supplierArray, Supplier, callback
        Supplier.find (err, docsResult) ->
            if err
                throw err
            supplierArray = docsResult
            callback err, 'supplier docs stored in supplierArray'

    ,(callback) -> # order - generate test data
        order1 = new Order
            _company: companyArray[0].id
            storeName: companyArray[0].stores[0].name
            _supplier: supplierArray[0].id
            referenceNum: 'aaa111bbb222'
            products: [
                description:
                    brand: 'Bauer'
                    name: 'Vapor X4.0'
                category: 'Hockey Skates'
                cost: 30000
                price: 40000
                size: 9
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
                    brand: 'Bauer'
                    name: 'Vapor X4.0'
                category: 'Hockey Skates'
                cost: 30000
                price: 40000
                size: 9
            ,
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
                size: 8
            ,
                description:
                    brand: 'Bauer'
                    name: 'Vapor X4.0'
                category: 'Hockey Skates'
                cost: 30000
                price: 40000
                size: 7
            ,
                description:
                    brand: 'Bauer'
                    name: 'Vapor X4.0'
                category: 'Hockey Skates'
                cost: 30000
                price: 40000
                size: 7
            ,
                description:
                    brand: 'Bauer'
                    name: 'Vapor X4.0'
                category: 'Hockey Skates'
                cost: 30000
                price: 40000
                size: 7
            ,
                description:
                    brand: 'Bauer'
                    name: 'Vapor X4.0'
                category: 'Hockey Skates'
                cost: 30000
                price: 40000
                size: 7
            ,
                description:
                    brand: 'Bauer'
                    name: 'Vapor X4.0'
                category: 'Hockey Skates'
                cost: 30000
                price: 40000
                size: 7
            ]
            shippingInfo:
                company: 'UPS'
                travelType: 'air'
                cost: 10000
            estimatedArrivalDate: '04/28/13'

        order1.save (err) ->
            if err
                throw err
            callback null, 'order generated'

    ,(callback) -> # order newly created order docs
        # findAllDocsInModelHelper orderArray, Order, callback
        Order.find (err, docsResult) ->
            if err
                throw err
            orderArray = docsResult
            callback err, 'order docs stored in orderArray'

    ,(callback) -> # stock - generate test data
        stock1 = new Stock
            _company: companyArray[0].id
            products: [
                _order: orderArray[0].id
                description:
                    brand: 'Bauer'
                    name: 'Vapor X4.0'
                category: 'Hockey Skates'
                cost: 30000
                price: 40099
                totalQuantity: 9
                subTotalQuantity: [
                    measurementName: 'size'
                    measurementValue: 8
                    quantity: 3
                ,
                    measurementName: 'size'
                    measurementValue: 9
                    quantity: 3
                ,
                    measurementName: 'size'
                    measurementValue: 10
                    quantity: 2
                ,
                    measurementName: 'size'
                    measurementValue: 11
                    quantity: 1
                ]
            ,
                _order: orderArray[0].id
                description:
                    brand: 'CCM'
                    name: 'Crazy Light'
                category: 'Hockey Skates'
                cost: 45000
                price: 65099
                totalQuantity: 8
                subTotalQuantity: [
                    measurementName: 'size'
                    measurementValue: 9
                    quantity: 1
                ,
                    measurementName: 'size'
                    measurementValue: 10
                    quantity: 3
                ,
                    measurementName: 'size'
                    measurementValue: 11
                    quantity: 4
                ,
                    measurementName: 'size'
                    measurementValue: 12
                    quantity: 0
                ]
            ,
                description:
                    brand: 'Adidas'
                    name: 'F30 TRX'
                category: 'Men\'s Soccer Cleats'
                cost: 9000
                price: 14099
                totalQuantity: 2
                subTotalQuantity: [
                    measurementName: 'size'
                    measurementValue: 9
                    quantity: 2
                ]
            ,
                description:
                    brand: 'Adidas'
                    name: 'Nike Vapor Talon Elite'
                category: 'Men\'s Football Cleats'
                cost: 11000
                price: 19099
                totalQuantity: 7
                subTotalQuantity: [
                    measurementName: 'size'
                    measurementValue: 10
                    quantity: 3
                ,
                    measurementName: 'size'
                    measurementValue: 9
                    quantity: 2
                ,
                    measurementName: 'size'
                    measurementValue: 8
                    quantity: 1
                ,
                    measurementName: 'size'
                    measurementValue: 12
                    quantity: 1
                ]
            ]
        stock2 = new Stock
            _company: companyArray[1].id
            products: [
                description:
                    brand: 'Ride'
                    name: 'Arcade Snowboard'
                category: 'Snowboard'
                cost: 35000
                price: 50999
                totalQuantity: 3
                subTotalQuantity: [
                    measurementName: 'length'
                    measurementValue: 145
                    quantity: 3
                ]
            ,
                description:
                    brand: 'Hyperlite'
                    name: 'Marek Nova'
                category: 'Wakeboard'
                cost: 50000
                price: 76999
                totalQuantity: 4
                subTotalQuantity: [
                    measurementName: 'length'
                    measurementValue: 145
                    quantity: 3
                ,
                    measurementName: 'length'
                    measurementValue: 130
                    quantity: 1
                ]
            ]

        storeName = companyArray[0].stores[0].name
        product.storeName =  storeName for product in stock1.products
        product.storeName =  storeName for product in stock2.products
        stock1.products[3].storeName = companyArray[0].stores[1].name

        stock1.save (err) ->
            if err
                throw err
            stock2.save (err) ->
                if err
                    throw err
                callback null, 'created stock docs'

        # async.each [stock1], (obj) ->
        #     obj.save (err) ->
        #         if err
        #             throw err

        # callback null, 'stock generated'

    ,(callback) -> # stock newly created stock docs
        # findAllDocsInModelHelper stockArray, Stock, callback
        Stock.find (err, docsResult) ->
            if err
                throw err
            stockArray = docsResult
            callback err, 'stock docs stored in stockArray'

    ,(callback) -> # sale - generate test data
        sale1 = new Sale
            _company: companyArray[0].id
            storeName: companyArray[0].stores[0].name
            _employee: employeeArray[0].id
            products: [
                description:
                    brand: 'Adidas'
                    name: 'F30 TRX'
                category: 'Men\'s Soccer Cleats'
                cost: 45000
                price: 65000
                size: 11
            ]
        sale2 = new Sale
            _company: companyArray[0].id
            storeName: companyArray[0].stores[0].name
            _employee: employeeArray[0].id
            products: [
                description:
                    brand: 'Adidas'
                    name: 'Nike Vapor Talon Elite'
                category: 'Men\'s Football Cleats'
                cost: 45000
                price: 65000
                size: 9
            ,
                description:
                    brand: 'Adidas'
                    name: 'F30 TRX'
                category: 'Men\'s Football Cleats'
                cost: 6000
                price: 19000
                size: 8
            ]
        sale3 = new Sale
            _company: companyArray[0].id
            storeName: companyArray[0].stores[0].name
            _employee: employeeArray[0].id
            products: [
                description:
                    brand: 'CCM'
                    name: 'Crazy Light'
                category: 'Hockey Skates'
                cost: 45000
                price: 65000
                size: 9
            ]
        sale4 = new Sale
            _company: companyArray[0].id
            storeName: companyArray[0].stores[0].name
            _employee: employeeArray[1].id
            products: [
                description:
                    brand: 'CCM'
                    name: 'Crazy Light'
                category: 'Hockey Skates'
                cost: 45000
                price: 65000
                size: 10
            ]
        async.each [sale1, sale2, sale3, sale4], (obj) ->
            obj.save (err) ->
                if err
                    throw err

        callback null, 'sale generated'

    ,(callback) -> # sale newly created sale docs
        # findAllDocsInModelHelper saleArray, Sale, callback
        Sale.find (err, docsResult) ->
            if err
                throw err
            saleArray = docsResult
            callback err, 'sale docs stored in saleArray'

], (err, result) ->
    if err
        throw err
    console.log result
    mongoose.connection.close()

