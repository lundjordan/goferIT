mongoose = require 'mongoose'

SupplierSchema = new mongoose.Schema
    email:
        type: String, unique: true, required: true
    companyName:
        type: String, required: true
    phone: Number
    address:
        street: String
        postalCode: String
        city: String
        country: String
    startDate: Date

module.exports = mongoose.model 'Supplier', SupplierSchema
