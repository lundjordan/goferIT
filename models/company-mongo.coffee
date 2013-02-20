mongoose = require 'mongoose'

CompanySchema = new mongoose.Schema
    name:
        type: String, required: true
    _adminEmployee:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Employee'
        required: false
    employees: [
        email:
            type: String, unique: true, required: true
        name :
            first:
                type: String, required: true
            last:
                type: String, required: true
        salt:
            type: String, required: true
        hash:
            type: String, required: true
        phone: Number
        address:
            street: String
            postalCode: String
            city: String
            country: String
        dob: String
        title: String
        dateCreated:
            type: Date
            default: new Date().toISOString()
    ]
    stores: [
        name:
            type: String, default: "Main Store", unique: true
        phone: Number
        address:
            street: String
            postalCode: String
            city: String
            country: String
        dateCreated: Date
    ]
    suppliers: [
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
        dateCreated:
            type: Date
            default: new Date().toISOString()
    ]
    customers: [
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
        dateCreated:
            type: Date
            default: new Date().toISOString()
    ]
    subscriptionType: String
    dateCreated:
        type: Date
        default: new Date().toISOString()

module.exports = mongoose.model 'Company', CompanySchema
