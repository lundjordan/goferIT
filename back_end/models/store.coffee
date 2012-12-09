mongoose = require 'mongoose'

StoreSchema = new mongoose.Schema
    name:
        type: String, unique: true, required: true
    phone: Number
    address:
        street: String
        postalCode: String
        city: String
        country: String
    dateCreated: Date

module.exports = mongoose.model 'Store', StoreSchema
