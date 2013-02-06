mongoose = require 'mongoose'

SaleSchema = new mongoose.Schema
    _terminal:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Terminal'
        required: true
    _product:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Product'
        required: true
    _customer:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Customer'
        required: false
    dateCreated: Date

module.exports = mongoose.model 'Sale', SaleSchema
