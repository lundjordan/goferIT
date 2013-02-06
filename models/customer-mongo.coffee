mongoose = require 'mongoose'

CustomerSchema = new mongoose.Schema
    sales: [{type: mongoose.Schema.Types.ObjectId, ref: 'Sale'}]
    email:
        type: String, unique: true, required: true
    name :
        first:
            type: String, required: true
        last:
            type: String, required: true
    phone: Number
    address:
        street: String
        postalCode: String
        city: String
        country: String
    dob: String
    startDate: Date

module.exports = mongoose.model 'Customer', CustomerSchema
