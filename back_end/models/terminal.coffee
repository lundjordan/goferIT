mongoose = require 'mongoose'

TerminalSchema = new mongoose.Schema
    _store: 
        type: mongoose.Schema.Types.ObjectId
        ref: 'Supplier'
        required: true
    referenceNum:
        type: Number, required: true

module.exports = mongoose.model 'Terminal', TerminalSchema
