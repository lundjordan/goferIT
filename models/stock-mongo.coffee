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
        category: String
        cost: Number
        price: Number
        primaryMeasurementFactor: String
        measurementPossibleValues: []
        individualProperties: [{
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


module.exports = mongoose.model 'Stock', StockSchema
