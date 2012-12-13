mongoose = require 'mongoose'

ProductSchema = new mongoose.Schema
    _store:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Store'
        required: true
    _order:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Order'
        required: true
    serialID:
        type: String, required: true
    description:
        brand: String
        name:
            type: String, required: true
    category: String
    cost: Number
    price: Number
    dateCreated: Date

module.exports = mongoose.model 'Product', ProductSchema


