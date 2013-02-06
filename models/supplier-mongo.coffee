mongoose = require 'mongoose'

SupplierSchema = new mongoose.Schema
    orders: [{type: mongoose.Schema.Types.ObjectId, ref: 'Order'}]
    email:
        type: String, unique: true, required: true
    name:
        type: String, required: true
    phone: Number
    address:
        street: String
        postalCode: String
        city: String
        country: String
    startDate: Date

module.exports = mongoose.model 'Supplier', SupplierSchema
