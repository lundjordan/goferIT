mongoose = require 'mongoose'

SaleSchema = new mongoose.Schema
    _company:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Company'
    _employee:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Employee'
        required: true
    _customer:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Customer'
        required: false
    storeName: String
    products: [{
        serialID:
            type: String
        description:
            brand: String
            name: String
        category: String
        cost: Number
        price: Number
        primaryMeasurementFactor: String
        individualProperties: [{
            storeName: String
            sourceHistory:
                _order:
                    type: mongoose.Schema.Types.ObjectId
                    ref: 'Company'
                _supplier:
                    type: mongoose.Schema.Types.ObjectId
                    ref: 'Supplier'
            measurements: [{
                factor: String
                value: String
            }]
        }]
        dateCreated:
            type: Date
            default: new Date().toISOString()
    }]
    dateCreated:
        type: Date
        default: new Date().toISOString()

module.exports = mongoose.model 'Sale', SaleSchema
