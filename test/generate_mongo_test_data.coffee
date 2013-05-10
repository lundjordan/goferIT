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
            phone: '(604)929-3333'
            address:
                street: '1234 sesame street'
                postalCode: 'v7w4c9'
                city: 'West Vancouver'
                state: 'British Columbia'
                country: 'CA'
            dob: '1986-09-20'
            title: 'admin'
        ,
            email: 'employee1@gmail.com'
            _company: companyArray[0].id
            password: 'password'
            name:
                first: 'Connor'
                last: 'Fitzpatrick'
            phone: '(604)929-4444'
            address:
                street: '2468 Badger Road'
                postalCode: 'v7w-6h2'
                city: 'North Vancouver'
                state: 'British Columbia'
                country: 'CA'
            dob: '1990-08-12'
            title: 'employee'
        ,
            email: 'rookie@gmail.com'
            _company: companyArray[0].id
            password: 'password'
            name:
                first: 'Jennifer'
                last: 'Hayes'
            phone: '(604)929-5555'
            address:
                street: '1111 apple grove'
                postalCode: 'v7w8p5'
                city: 'West Vancouver'
                state: 'British Columbia'
                country: 'CA'
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
            phone: '(604)929-6666'
            address:
                street: '2222 Beetle Ave'
                postalCode: 'v7w5n8'
                city: 'Vancouver'
                state: 'British Columbia'
                country: 'CA'
            dob: '1989-02-22'
            sex: 'male'
        ,
            email: 'customer2@gmail.com'
            _company: companyArray[0].id
            name:
                first: 'Joe'
                last: 'Skully'
            phone: '(604)929-7777'
            address:
                street: '1234 sesame street'
                postalCode: 'v7w4c9'
                city: 'West Vancouver'
                state: 'British Columbia'
                country: 'CA'
            dob: '1986-09-20'
            sex: 'male'
        ,
            email: 'customer3@gmail.com'
            _company: companyArray[0].id
            name:
                first: 'Sanzhar'
                last: 'Kushekbayev'
            phone: '(604)929-8888'
            address:
                street: '3333 Simple Street'
                postalCode: 'vlr2d5'
                city: 'Vancouver'
                state: 'British Columbia'
                country: 'CA'
            dob: '1971-01-08'
            sex: 'male'
        ,
            email: 'customer4@gmail.com'
            _company: companyArray[0].id
            name:
                first: 'Jennie'
                last: 'Hayes'
            phone: '(604)929-9999'
            address:
                street: '4444 Hazer Street'
                postalCode: 'vlr3d9'
                city: 'Vancouver'
                state: 'British Columbia'
                country: 'CA'
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
            phone: '(604)929-0000'
            address:
                street: ''
                postalCode: 'v7w4c9'
                city: 'West Vancouver'
                state: 'British Columbia'
                country: 'CA'
        ,
            email: 'def@gmail.com'
            _company: companyArray[0].id
            name: 'def big co'
            phone: '(604)929-2233'
            address:
                street: '9999 baffle place'
                postalCode: 'v7w3e5'
                city: 'Burnaby'
                state: 'British Columbia'
                country: 'CA'
        ,
            email: 'ghi@gmail.com'
            _company: companyArray[0].id
            name: 'ghi gear4U'
            phone: '(604)929-3344'
            address:
                street: '777 west hastings'
                postalCode: 'v7w3e7'
                city: 'Vancouver'
                state: 'British Columbia'
                country: 'CA'
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
            _supplier: supplierArray[0].id
            referenceNum: 'aaa111bbb222'
            storeName: "Main Store"
            products: [
                description:
                    brand: 'Bauer'
                    name: 'Vapor X5.0'
                category: 'Hockey Skates'
                cost: 30000
                price: 40000
                primaryMeasurementFactor: 'size'
                measurementPossibleValues: ["8", "9", "10"]
                individualProperties: [
                    measurements: [
                        factor: 'size'
                        value: "8"
                    ]
                ,
                    measurements: [
                        factor: 'size'
                        value: "8"
                    ]
                ,
                    measurements: [
                        factor: 'size'
                        value: "8"
                    ]
                ,
                    measurements: [
                        factor: 'size'
                        value: "8"
                    ]
                ,
                    measurements: [
                        factor: 'size'
                        value: "8"
                    ]
                ,
                    measurements: [
                        factor: 'size'
                        value: "8"
                    ]
                ,
                    measurements: [
                        factor: 'size'
                        value: "8"
                    ]
                ,
                    measurements: [
                        factor: 'size'
                        value: "9"
                    ]
                ,
                    measurements: [
                        factor: 'size'
                        value: "10"
                    ]
                ,
                ]
            ,
                description:
                    brand: 'CCM'
                    name: 'X1 Carbon'
                category: 'Hockey Skates'
                cost: 30000
                price: 40000
                primaryMeasurementFactor: 'size'
                measurementPossibleValues: ['8', '9', '10']
                individualProperties: [
                    measurements: [
                        factor: 'size'
                        value: "8"
                    ]
                ,
                    measurements: [
                        factor: 'size'
                        value: '8'
                    ]
                ,
                    measurements: [
                        factor: 'size'
                        value: "8"
                    ]
                ,
                    measurements: [
                        factor: 'size'
                        value: "8"
                    ]
                ,
                    measurements: [
                        factor: 'size'
                        value: '8'
                    ]
                ,
                ]
            ,
                description:
                    brand: 'Reebok'
                    name: '20K Pump'
                category: 'Hockey Skates'
                cost: 30000
                price: 14000
                primaryMeasurementFactor: 'size'
                measurementPossibleValues: ["8", "9"]
                individualProperties: [
                    measurements: [
                        factor: 'size'
                        value: "8"
                    ]
                ,
                    measurements: [
                        factor: 'size'
                        value: "8"
                    ]
                ,
                    measurements: [
                        factor: 'size'
                        value: "9"
                    ]
                ,
                    measurements: [
                        factor: 'size'
                        value: "9"
                    ]
                ]
            ]
            shippingInfo:
                company: 'UPS'
                travelType: 'air'
                cost: 10000
            estimatedArrivalDate: '04/28/13'

        order2 = new Order
            _company: companyArray[0].id
            _supplier: supplierArray[1].id
            referenceNum: 'bbb111kkk222'
            storeName: "Main Store"
            products: [
                description:
                    brand: 'Easton'
                    name: 'Mako'
                category: 'Hockey Skates'
                cost: 30000
                price: 18000
                primaryMeasurementFactor: 'size'
                measurementPossibleValues: ["8", "10"]
                individualProperties: [
                    measurements: [
                        factor: 'size'
                        value: "8"
                    ]
                ,
                    measurements: [
                        factor: 'size'
                        value: "8"
                    ]
                ,
                    measurements: [
                        factor: 'size'
                        value: "8"
                    ]
                ,
                    measurements: [
                        factor: 'size'
                        value: "10"
                    ]
                ]
            ]
            shippingInfo:
                company: 'DHL'
                travelType: 'road'
                cost: 4500
            estimatedArrivalDate: '04/20/13'

        order3 = new Order
            _company: companyArray[0].id
            _supplier: supplierArray[1].id
            referenceNum: 'ccc111ccc222'
            storeName: "Main Store"
            products: [
                description:
                    brand: 'Bauer'
                    name: 'Hydro X7.0'
                category: 'Hockey Skates'
                cost: 30000
                price: 11000
                primaryMeasurementFactor: 'size'
                measurementPossibleValues: ["7", "10"]
                individualProperties: [
                    measurements: [
                        factor: 'size'
                        value: "7"
                    ]
                ,
                    measurements: [
                        factor: 'size'
                        value: "7"
                    ]
                ,
                    measurements: [
                        factor: 'size'
                        value: "7"
                    ]
                ,
                    measurements: [
                        factor: 'size'
                        value: "10"
                    ]
                ,
                    measurements: [
                        factor: 'size'
                        value: "10"
                    ]
                ,
                ]
            ]
            shippingInfo:
                company: 'UPS'
                travelType: 'road'
                cost: 5000
            estimatedArrivalDate: '04/30/13'


        storeName = companyArray[0].stores[0].name
        product.storeName =  storeName for product in order1.products
        product.storeName =  storeName for product in order2.products
        product.storeName =  storeName for product in order3.products

        order1.save (err) ->
            if err
                throw err
            order2.save (err) ->
                if err
                    throw err
                order3.save (err) ->
                    if err
                        throw err
                    callback null, 'created stock docs'

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
                description:
                    brand: 'Nike'
                    name: 'Featherlite'
                category: 'Basketball'
                cost: 2000
                price: 3599
                primaryMeasurementFactor: null
                measurementPossibleFactors: []
                individualProperties: [
                    sourceHistory:
                        _order: orderArray[2].id
                        _supplier: supplierArray[0].id
                    measurements: []
                ]
            ,
                description:
                    brand: 'Bauer'
                    name: 'Vapor X4.0'
                category: 'Hockey Skates'
                cost: 30000
                price: 40099
                primaryMeasurementFactor: 'size'
                measurementPossibleValues: ["8", "9", "10", "11", "12"]
                individualProperties: [
                    sourceHistory:
                        _order: orderArray[0].id
                        _supplier: supplierArray[0].id
                    measurements: [
                        factor: 'size'
                        value: "8"
                    ]
                ,
                    sourceHistory:
                        _order: orderArray[0].id
                        _supplier: supplierArray[0].id
                    measurements: [
                        factor: 'size'
                        value: "8"
                    ]
                ,
                    sourceHistory:
                        _order: orderArray[0].id
                        _supplier: supplierArray[0].id
                    measurements: [
                        factor: 'size'
                        value: "8"
                    ]
                ,
                    sourceHistory:
                        _order: orderArray[0].id
                        _supplier: supplierArray[0].id
                    measurements: [
                        factor: 'size'
                        value: "9"
                    ]
                ,
                    sourceHistory:
                        _order: orderArray[0].id
                        _supplier: supplierArray[0].id
                    measurements: [
                        factor: 'size'
                        value: "9"
                    ]
                ,
                    sourceHistory:
                        _order: orderArray[0].id
                        _supplier: supplierArray[0].id
                    measurements: [
                        factor: 'size'
                        value: "10"
                    ]
                ,
                    sourceHistory:
                        _order: orderArray[0].id
                        _supplier: supplierArray[0].id
                    measurements: [
                        factor: 'size'
                        value: "10"
                    ]
                ,
                    sourceHistory:
                        _order: orderArray[0].id
                        _supplier: supplierArray[0].id
                    measurements: [
                        factor: 'size'
                        value: "11"
                    ]
                ,
                    sourceHistory:
                        _order: orderArray[0].id
                        _supplier: supplierArray[0].id
                    measurements: [
                        factor: 'size'
                        value: "11"
                    ]
                ,
                    sourceHistory:
                        _order: orderArray[0].id
                        _supplier: supplierArray[0].id
                    measurements: [
                        factor: 'size'
                        value: "9"
                    ]
                ,
                    sourceHistory: {}
                    measurements: [
                        factor: 'size'
                        value: "12"
                    ]
                ]
            ,
                description:
                    brand: 'CCM'
                    name: 'Crazy Light'
                category: 'Hockey Skates'
                cost: 45000
                price: 65099
                primaryMeasurementFactor: 'size'
                measurementPossibleValues: ["8", "9", "11", "12"]
                individualProperties: [
                    sourceHistory:
                        _order: orderArray[0].id
                        _supplier: supplierArray[0].id
                    measurements: [
                        factor: 'size'
                        value: "8"
                    ]
                ,
                    sourceHistory:
                        _order: orderArray[0].id
                        _supplier: supplierArray[0].id
                    measurements: [
                        factor: 'size'
                        value: "9"
                    ]
                ,
                    sourceHistory:
                        _order: orderArray[0].id
                        _supplier: supplierArray[0].id
                    measurements: [
                        factor: 'size'
                        value: "9"
                    ]
                ,
                    sourceHistory:
                        _order: orderArray[0].id
                        _supplier: supplierArray[0].id
                    measurements: [
                        factor: 'size'
                        value: "9"
                    ]
                ,
                    sourceHistory:
                        _order: orderArray[0].id
                        _supplier: supplierArray[0].id
                    measurements: [
                        factor: 'size'
                        value: "11"
                    ]
                ,
                    sourceHistory:
                        _order: orderArray[0].id
                        _supplier: supplierArray[0].id
                    measurements: [
                        factor: 'size'
                        value: "12"
                    ]
                ,
                    sourceHistory: {}
                    measurements: [
                        factor: 'size'
                        value: "12"
                    ]
                ]
            ,
                description:
                    brand: 'Adidas'
                    name: 'F30 TRX'
                category: 'Men\'s Soccer Cleats'
                cost: 9000
                price: 14099
                primaryMeasurementFactor: 'size'
                measurementPossibleValues: ["8", "9"]
                individualProperties: [
                    sourceHistory:
                        _supplier: supplierArray[0].id
                    measurements: [
                        factor: 'size'
                        value: "8"
                    ]
                ,
                    sourceHistory:
                        _supplier: supplierArray[0].id
                    measurements: [
                        factor: 'size'
                        value: "8"
                    ]
                ,
                    sourceHistory:
                        _supplier: supplierArray[0].id
                    measurements: [
                        factor: 'size'
                        value: "9"
                    ]
                ]
            ,
                description:
                    brand: 'Adidas'
                    name: 'Nike Vapor Talon Elite'
                category: 'Men\'s Football Cleats'
                cost: 11000
                price: 19099
                primaryMeasurementFactor: 'size'
                measurementPossibleValues: ["7", "8", "10"]
                individualProperties: [
                    sourceHistory: {}
                    measurements: [
                        factor: 'size'
                        value: "7"
                    ]
                    sourceHistory: {}
                    measurements: [
                        factor: 'size'
                        value: "7"
                    ]
                    sourceHistory: {}
                    measurements: [
                        factor: 'size'
                        value: "7"
                    ]
                    sourceHistory: {}
                    measurements: [
                        factor: 'size'
                        value: "7"
                    ]
                    sourceHistory: {}
                    measurements: [
                        factor: 'size'
                        value: "8"
                    ]
                    sourceHistory: {}
                    measurements: [
                        factor: 'size'
                        value: "10"
                    ]
                    sourceHistory: {}
                    measurements: [
                        factor: 'size'
                        value: "10"
                    ]
                    sourceHistory: {}
                    measurements: [
                        factor: 'size'
                        value: "10"
                    ]
                    sourceHistory: {}
                    measurements: [
                        factor: 'size'
                        value: "10"
                    ]
                    sourceHistory: {}
                    measurements: [
                        factor: 'size'
                        value: "8"
                    ]
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
                primaryMeasurementFactor: 'length'
                measurementPossibleValues: ["145", "155"]
                individualProperties: [
                    sourceHistory: {}
                    measurements: [
                        factor: 'length'
                        value: "145"
                    ]
                    sourceHistory: {}
                    measurements: [
                        factor: 'length'
                        value: "155"
                    ]
                    sourceHistory: {}
                    measurements: [
                        factor: 'length'
                        value: "155"
                    ]
                ]
            ,
                description:
                    brand: 'Hyperlite'
                    name: 'Marek Nova'
                category: 'Wakeboard'
                cost: 50000
                price: 76999
                primaryMeasurementFactor: 'length'
                measurementPossibleValues: ["135"]
                individualProperties: [
                    sourceHistory: {}
                    measurements: [
                        factor: 'length'
                        value: "135"
                    ]
                    sourceHistory: {}
                    measurements: [
                        factor: 'length'
                        value: "135"
                    ]
                    sourceHistory: {}
                    measurements: [
                        factor: 'length'
                        value: "135"
                    ]
                ]
            ]

        storeName = companyArray[0].stores[0].name
        for product in stock1.products
            indieProp.storeName = storeName for indieProp in product.individualProperties
        for product in stock2.products
            indieProp.storeName = storeName for indieProp in product.individualProperties
        stock1.products[3].individualProperties[0].storeName = companyArray[0].stores[1].name

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
            _employee: employeeArray[0].id
            _customer: customerArray[0].id
            storeName: companyArray[0].stores[0].name
            products: [
                description:
                    brand: 'CCM'
                    name: 'Crazy Light'
                category: 'Hockey Skates'
                cost: 45000
                price: 65099
                primaryMeasurementFactor: 'size'
                individualProperties: [
                    storeName: companyArray[0].stores[0].name
                    sourceHistory:
                        _order: orderArray[0].id
                        _supplier: supplierArray[0].id
                    measurements: [
                        factor: 'size'
                        value: "8"
                    ]
                ]
            ,
                description:
                    brand: 'Nike'
                    name: 'Featherlite'
                category: 'Basketball'
                cost: 2000
                price: 3599
                primaryMeasurementFactor: null
                measurementPossibleFactors: []
                individualProperties: [
                    sourceHistory:
                        _order: orderArray[2].id
                        _supplier: supplierArray[0].id
                    measurements: []
                ]
            ]
        sale2 = new Sale
            _company: companyArray[0].id
            _employee: employeeArray[1].id
            _customer: customerArray[0].id
            storeName: companyArray[0].stores[0].name
            dateCreated: new Date("5/10/2013").toISOString()
            products: [
                description:
                    brand: 'Bauer'
                    name: 'Vapor X4.0'
                category: 'Hockey Skates'
                cost: 30000
                price: 40099
                primaryMeasurementFactor: 'size'
                individualProperties: [
                    sourceHistory:
                        _order: orderArray[0].id
                        _supplier: supplierArray[0].id
                    measurements: [
                        factor: 'size'
                        value: "9"
                    ]
                ]
            ]
        sale3 = new Sale
            _company: companyArray[0].id
            _employee: employeeArray[1].id
            _customer: customerArray[0].id
            storeName: companyArray[0].stores[0].name
            dateCreated: new Date("6/2/2013").toISOString()
            products: [
                description:
                    brand: 'Nike'
                    name: 'Zooms'
                category: 'Hockey Skates'
                cost: 35000
                price: 40099
                primaryMeasurementFactor: 'size'
                individualProperties: [
                    measurements: [
                        factor: 'size'
                        value: "11"
                    ]
                ]
            ]
        sale4 = new Sale
            _company: companyArray[0].id
            _employee: employeeArray[0].id
            storeName: companyArray[0].stores[0].name
            dateCreated: new Date("1/1/2013").toISOString()
            products: [
                description:
                    brand: 'Under Armor'
                    name: 'Light Tee'
                category: 'Shirt'
                cost: 1200
                price: 2599
                primaryMeasurementFactor: 'size'
                individualProperties: [
                    storeName: companyArray[0].stores[0].name
                    sourceHistory:
                        _order: orderArray[1].id
                        _supplier: supplierArray[2].id
                    measurements: [
                        factor: 'size'
                        value: "large"
                    ]
                ,
                    storeName: companyArray[0].stores[0].name
                    sourceHistory:
                        _order: orderArray[1].id
                        _supplier: supplierArray[2].id
                    measurements: [
                        factor: 'size'
                        value: "small"
                    ]
                ]
            ,
                description:
                    brand: 'Adidas'
                    name: 'Runner'
                category: 'Running Footwear'
                cost: 8000
                price: 12099
                primaryMeasurementFactor: 'size'
                individualProperties: [
                    storeName: companyArray[0].stores[0].name
                    measurements: [
                        factor: 'size'
                        value: "9"
                    ]
                ]
            ]

        sale5 = new Sale
            _company: companyArray[0].id
            _employee: employeeArray[0].id
            _customer: customerArray[2].id
            storeName: companyArray[0].stores[1].name
            products: [
                description:
                    brand: 'CCM'
                    name: 'Crazy Light'
                category: 'Hockey Skates'
                cost: 45000
                price: 65099
                primaryMeasurementFactor: 'size'
                individualProperties: [
                    storeName: companyArray[0].stores[1].name
                    sourceHistory:
                        _order: orderArray[0].id
                        _supplier: supplierArray[0].id
                    measurements: [
                        factor: 'size'
                        value: "10"
                    ]
                ]
            ]
        async.each [sale1, sale2, sale3, sale4, sale5], (obj) ->
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

