# globals

async = require 'async'
mongoose = require 'mongoose'
Company = require '../models/company-mongo'
Order = require '../models/order-mongo'
Product = require '../models/product-mongo'
[companyArray, employeeArray, customerArray, storeArray] = [null, null, null, null]
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
        mongoUrl = 'mongodb://localhost/gofer-test'
        mongoose.connect mongoUrl, ->
            (Company.remove {}).exec()
            callback(null, 'connected to mongo - gofer-test')

    ,(callback) ->
        company = null
        company = new Company
            name: 'nads'
            subscriptionType: "trial"
            dateCreated: new Date().toISOString()
            stores: [
                name: "Main Store"
            ]
        company.save (err) ->
            if err
                throw err
            Company.find (err, docsResult) ->
                if err
                    throw err
                console.log docsResult
                callback(null, 'connected to mongo - gofer-test')
                # employee = new Employee
                #     email: req.body.email
                #     _company: company.id
                #     password: req.body.password
                #     name:
                #         first: req.body.fullName.match(/[^\s-]+-?/g)[0]
                #         last: req.body.fullName.match(/[^\s-]+-?/g)[1]
                #     title: 'admin'
                # employee.save (err) ->
                #     if err
                #         throw err
                #         registeredErrorFree = false
                #     else
                #         store = new Store
                #             _company: company.id
                #             dateCreated: new Date().toISOString()
                #         store.save (err) ->
                #             if err
                #                 throw err
                #                 registeredErrorFree = false
                #             else
                #                 if not registeredErrorFree
                #                     if Employee.findById(employee.id)
                #                         employee.remove (err, obj) ->
                #                             if err
                #                                 console.log err
                #                     if Store.findById(store.id)
                #                         store.remove (err, obj) ->
                #                             if err
                #                                 console.log err
                #                     if Company.findById(company.id)
                #                         company.remove (err, obj) ->
                #                             if err
                #                                 console.log err
    ,(callback) ->
        # (Order.findOne { 'shippingInfo.cost': '5000' })
        #     .populate('_supplier').exec (err, order) ->
        #         console.log order
        # supplier = (Supplier.findOne { email: 'abc@gmail.com' })
        # supplier.populate('orders').exec (err, docs) ->
        #     console.log docs
            # .populate('_supplier').exec (err, order) ->
            #     console.log order

        callback(null, 'connected to mongo - gofer-test')


], (err, result) ->
    if err
        throw err
    console.log result
    mongoose.connection.close()


