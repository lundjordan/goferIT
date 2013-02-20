# globals

async = require 'async'
mongoose = require 'mongoose'
Company = require '../models/company-mongo'
Employee = require '../models/employee-mongo'
Customer = require '../models/customer-mongo'
Supplier = require '../models/supplier-mongo'
Order = require '../models/order-mongo'
Product = require '../models/product-mongo'
Sale = require '../models/sale-mongo'
[companyArray, employeeArray, customerArray] = [null, null, null]
[supplierArray, orderArray, productArray, saleArray] = [null, null, null, null]

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
            (Product.remove {}).exec()
            (Employee.remove {}).exec()
            (Order.remove {}).exec()
            (Supplier.remove {}).exec()
            (Customer.remove {}).exec()
            (Company.remove {}).exec()

            callback(null, 'connected to mongo - gofer-test')

    ,(callback) -> # create and persist test data - companies
        company = new Company
            name: "Nad's Sports"
            subscriptionType: "trial"
            stores: [
                name: 'Main Store'
            ]
        company.save (err) ->
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
                postalCode: '01'
                city: 'Vancouver'
                country: 'Canada'
            dob: '1989-02-22'
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
        orderObjs = [
            _supplier: supplierArray[0]
            referenceNum: 'aaa111bbb222'
            shippingInfo:
                company: 'UPS'
                travelType: 'air'
                cost: 10000
            arrivaldate: '02/08/2013'
        ,
            _supplier: supplierArray[1]
            referenceNum: 'zzzzzzzz'
            shippingInfo:
                company: 'UPS'
                travelType: 'air'
                cost: 20000
            arrivaldate: '02/10/2013'
        ,
            _supplier: supplierArray[0]
            referenceNum: 'bbbbbbbbb'
            shippingInfo:
                company: 'Fedex'
                travelType: 'road'
                cost: 5000
            arrivaldate: '02/11/2013'

        ]
        async.each orderObjs, (obj) ->
            createDocInModelHelper obj, Order

        callback null, 'order generated'

    ,(callback) -> # order newly created order docs
        # findAllDocsInModelHelper orderArray, Order, callback
        Order.find (err, docsResult) ->
            if err
                throw err
            orderArray = docsResult
            callback err, 'order docs stored in orderArray'

    ,(callback) -> # product - generate test data
        productObjs = [
            _company: companyArray[0].id
            _order: orderArray[0].id
            description:
                brand: 'Bauer'
                name: 'Vapor X4.0'
            category: 'Hockey Skates'
            cost: 30000
            price: 40000
            size: 9
        ,
            _company: companyArray[0].id
            _order: orderArray[0].id
            description:
                brand: 'Bauer'
                name: 'Vapor X4.0'
            category: 'Hockey Skates'
            cost: 30000
            price: 40000
            size: 9
        ,
            _company: companyArray[0].id
            _order: orderArray[0].id
            description:
                brand: 'Bauer'
                name: 'Vapor X4.0'
            category: 'Hockey Skates'
            cost: 30000
            price: 40000
            size: 9
        ,
            _company: companyArray[0].id
            _order: orderArray[0].id
            description:
                brand: 'Bauer'
                name: 'Vapor X4.0'
            category: 'Hockey Skates'
            cost: 30000
            price: 40000
            size: 8
        ,
            _company: companyArray[0].id
            _order: orderArray[0].id
            description:
                brand: 'Bauer'
                name: 'Vapor X4.0'
            category: 'Hockey Skates'
            cost: 30000
            price: 40000
            size: 8
        ,
            _company: companyArray[0].id
            _order: orderArray[0].id
            description:
                brand: 'Bauer'
                name: 'Vapor X4.0'
            category: 'Hockey Skates'
            cost: 30000
            price: 40000
            size: 7
        ,
            _company: companyArray[0].id
            _order: orderArray[0].id
            description:
                brand: 'Bauer'
                name: 'Vapor X4.0'
            category: 'Hockey Skates'
            cost: 30000
            price: 40000
            size: 7
        ,
            _company: companyArray[0].id
            _order: orderArray[0].id
            description:
                brand: 'Bauer'
                name: 'Vapor X4.0'
            category: 'Hockey Skates'
            cost: 30000
            price: 40000
            size: 7
        ,
            _company: companyArray[0].id
            _order: orderArray[0].id
            description:
                brand: 'Bauer'
                name: 'Vapor X4.0'
            category: 'Hockey Skates'
            cost: 30000
            price: 40000
            size: 7
        ,
            _company: companyArray[0].id
            _order: orderArray[0].id
            description:
                brand: 'Bauer'
                name: 'Vapor X4.0'
            category: 'Hockey Skates'
            cost: 30000
            price: 40000
            size: 7
        ,
            _company: companyArray[0].id
            description:
                brand: 'CCM'
                name: 'Crazy Light'
            category: 'Hockey Skates'
            cost: 45000
            price: 65000
            size: 10
        ,
            _company: companyArray[0].id
            description:
                brand: 'CCM'
                name: 'Crazy Light'
            category: 'Hockey Skates'
            cost: 45000
            price: 65000
            size: 10
        ,
            _company: companyArray[0].id
            description:
                brand: 'CCM'
                name: 'Crazy Light'
            category: 'Hockey Skates'
            cost: 45000
            price: 65000
            size: 10
        ,
            _company: companyArray[0].id
            description:
                brand: 'CCM'
                name: 'Crazy Light'
            category: 'Hockey Skates'
            cost: 45000
            price: 65000
            size: 9
        ,
            _company: companyArray[0].id
            description:
                brand: 'CCM'
                name: 'Crazy Light'
            category: 'Hockey Skates'
            cost: 45000
            price: 65000
            size: 9
        ,
            _company: companyArray[0].id
            description:
                brand: 'CCM'
                name: 'Crazy Light'
            category: 'Hockey Skates'
            cost: 45000
            price: 65000
            size: 8
        ,
            _company: companyArray[0].id
            description:
                brand: 'CCM'
                name: 'Crazy Light'
            category: 'Hockey Skates'
            cost: 45000
            price: 65000
            size: 8
        ,
            _company: companyArray[0].id
            description:
                brand: 'CCM'
                name: 'Crazy Light'
            category: 'Hockey Skates'
            cost: 45000
            price: 65000
            size: 8
        ,
            _company: companyArray[0].id
            description:
                brand: 'CCM'
                name: 'Crazy Light'
            category: 'Hockey Skates'
            cost: 45000
            price: 65000
            size: 12
        ,
            _company: companyArray[0].id
            description:
                brand: 'CCM'
                name: 'Crazy Light'
            category: 'Hockey Skates'
            cost: 45000
            price: 65000
            size: 12
        ]
        async.each productObjs, (obj) ->
            createDocInModelHelper obj, Product

        callback null, 'product generated'

    ,(callback) -> # product newly created product docs
        # findAllDocsInModelHelper productArray, Product, callback
        Product.find (err, docsResult) ->
            if err
                throw err
            productArray = docsResult
            callback err, 'product docs stored in productArray'

    ,(callback) -> # sale - generate test data
        saleObjs = [
            _employee: employeeArray[0].id
            _product: productArray[0].id
        ,
            _employee: employeeArray[0].id
            _product: productArray[3].id
        ,
            _employee: employeeArray[0].id
            _product: productArray[5].id
        ,
            _employee: employeeArray[1].id
            _product: productArray[7].id
        ,
            _employee: employeeArray[1].id
            _product: productArray[8].id
        ,
            _employee: employeeArray[2].id
            _product: productArray[10].id

        ]
        async.each saleObjs, (obj) ->
            createDocInModelHelper obj, Sale

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

