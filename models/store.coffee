mongoose = require 'mongoose'

StoreSchema = new mongoose.Schema
    _company:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Company'
        required: true
    products: [{type: mongoose.Schema.Types.ObjectId, ref: 'Product'}]
    terminals: [{type: mongoose.Schema.Types.ObjectId, ref: 'Terminal'}]
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
