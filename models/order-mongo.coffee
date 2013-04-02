mongoose = require 'mongoose'

OrderSchema = new mongoose.Schema
    _company:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Company'
    _supplier:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Supplier'
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
        storeName:
            type: String
            required: true
        totalQuantity: Number
        subTotalQuantity: []
        dateCreated:
            type: Date
            default: new Date().toISOString()
    }]
    referenceNum:
        type: String, required: true
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

