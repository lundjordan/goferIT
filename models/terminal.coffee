mongoose = require 'mongoose'

TerminalSchema = new mongoose.Schema
    _store:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Supplier'
        required: true
    _employee:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Employee'
        required: false
    referenceNum:
        type: Number, required: true

module.exports = mongoose.model 'Terminal', TerminalSchema
