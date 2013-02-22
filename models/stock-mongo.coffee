mongoose = require 'mongoose'

StockSchema = new mongoose.Schema
    _company:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Company'
    products: [{
        serialID:
            type: String
        description:
            brand: String
            name: String
        storeName:
            type: String
            required: true
        category: String
        cost: Number
        price: Number
        dateCreated:
            type: Date
            default: new Date().toISOString()
    }]

module.exports = mongoose.model 'Stock', StockSchema
