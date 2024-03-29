mongoose = require 'mongoose'

CustomerSchema = new mongoose.Schema
    _company:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Company'
        required: true
    sales: [{type: mongoose.Schema.Types.ObjectId, ref: 'Sale'}]
    email:
        type: String, unique: true, required: true
    name :
        first:
            type: String, required: true
        last:
            type: String, required: true
    phone: String
    address:
        street: String
        postalCode: String
        city: String
        state: String
        country: String
    dob: String
    sex: String
    dateCreated:
        type: Date
        default: new Date().toISOString()

module.exports = mongoose.model 'Customer', CustomerSchema
