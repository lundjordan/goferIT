mongoose = require 'mongoose'

SaleSchema = new mongoose.Schema
    _company:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Company'
    storeName:
        type: String
        required: true
    products: [{
        serialID:
            type: String
        description:
            brand: String
            name: String
        category: String
        cost: Number
        price: Number
        dateCreated:
            type: Date
            default: new Date().toISOString()
    }]
    _employee:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Employee'
        required: true
    _customer:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Customer'
        required: false
    dateCreated:
        type: Date
        default: new Date().toISOString()

module.exports = mongoose.model 'Sale', SaleSchema
