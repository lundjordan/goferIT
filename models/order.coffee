mongoose = require 'mongoose'

OrderSchema = new mongoose.Schema
    _supplier:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Supplier'
        required: true
    products: [{type: mongoose.Schema.Types.ObjectId, ref: 'Product'}]
    referenceNum:
        type: String, required: true
    shippingInfo:
        company:
            type: String, required: true
        travelType: String
        cost: Number
    arrivaldate: Date
    dateCreated: Date

module.exports = mongoose.model 'Order', OrderSchema

