mongoose = require 'mongoose'

ProductSchema = new mongoose.Schema
    _store:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Store'
    _order:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Order'
    serialID:
        type: String
    description:
        brand: String
        name: String
    category: String
    cost: Number
    price: Number
    dateCreated: Date
    # TODO - figure out if we need a sold check here or just go through Sale
    # collection's products
    # isSold:
    #     type: Boolean
    #     required: true
    #     default: true

module.exports = mongoose.model 'Product', ProductSchema
