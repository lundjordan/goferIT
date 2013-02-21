mongoose = require 'mongoose'

StockSchema = new mongoose.Schema
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

module.exports = mongoose.model 'Stock', StockSchema
