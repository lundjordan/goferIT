mongoose = require 'mongoose'

CompanySchema = new mongoose.Schema
    name:
        type: String, required: true
    _adminEmployee:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Employee'
        required: false
    employees: [{type: mongoose.Schema.Types.ObjectId, ref: 'Employee'}]
    stores: [{type: mongoose.Schema.Types.ObjectId, ref: 'Store'}]
    subscriptionType: String
    dateCreated: Date

module.exports = mongoose.model 'Company', CompanySchema
