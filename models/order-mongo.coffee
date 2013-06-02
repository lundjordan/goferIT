mongoose = require 'mongoose'

OrderSchema = new mongoose.Schema
    _company:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Company'
    _supplier:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Supplier'
        required: true
    referenceNum:
        type: String, required: true
    storeName:
        type: String
        required: true
    products: [
        description:
            brand: String
            name: String
        category: String
        cost: Number
        price: Number
        primaryMeasurementFactor: String
        measurementPossibleValues: []
        individualProperties: [
            measurements: [{
                factor: String
                value: String
            }]
        ]
    ]
    shippingInfo:
        company: String
        travelType: String
        cost: Number
    estimatedArrivalDate: Date
    dateArrived: Date
    dateCreated:
        type: Date
        default: new Date().toISOString()

module.exports = mongoose.model 'Order', OrderSchema

