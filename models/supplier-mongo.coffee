mongoose = require 'mongoose'

SupplierSchema = new mongoose.Schema
    _company:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Company'
        required: true
    orders: [{type: mongoose.Schema.Types.ObjectId, ref: 'Order'}]
    email:
        type: String, unique: true, required: true
    name:
        type: String, required: true
    phone: String
    address:
        street: String
        postalCode: String
        city: String
        state: String
        country: String
    dateCreated:
        type: Date
        default: new Date().toISOString()

module.exports = mongoose.model 'Supplier', SupplierSchema
