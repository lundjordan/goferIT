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
    products: []
    shippingInfo:
        company:
            type: String, required: true
        travelType: String
        cost: Number
    estimatedArrivalDate: Date
    dateArrived: Date
    dateCreated:
        type: Date
        default: new Date().toISOString()

module.exports = mongoose.model 'Order', OrderSchema

