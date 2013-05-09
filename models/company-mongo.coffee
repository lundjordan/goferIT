mongoose = require 'mongoose'

CompanySchema = new mongoose.Schema
    name:
        type: String, required: true
    stores: [
        name:
            type: String
        phone: Number
        address:
            street: String
            postalCode: String
            city: String
            country: String
        dateCreated: Date
    ]
    employees: [{type: mongoose.Schema.Types.ObjectId, ref: 'Employee'}]
    suppliers: [{type: mongoose.Schema.Types.ObjectId, ref: 'Supplier'}]
    customers: [{type: mongoose.Schema.Types.ObjectId, ref: 'Customer'}]
    subscriptionType: String
    taxRate:
        type: Number
        default: 22.5
    dateCreated:
        type: Date
        default: new Date().toISOString()

module.exports = mongoose.model 'Company', CompanySchema
