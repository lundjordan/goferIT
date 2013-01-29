mongoose = require 'mongoose'
bcrypt = require 'bcrypt'

EmployeeSchema = new mongoose.Schema
    _company:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Company'
        required: true
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
    startDate: Date

virtualPassword = (EmployeeSchema.virtual 'password').get ->
    return this._password

virtualPassword.set (password) ->
    this._password = password
    salt = this.salt = bcrypt.genSaltSync 10
    this.hash = bcrypt.hashSync password, salt

EmployeeSchema.method 'verifyPassword', (password, callback) ->
    bcrypt.compare password, this.hash, callback

EmployeeSchema.statics.authenticate = (email, password, callback) ->
    this.findOne email: email, (err, employee) ->
        if err
            return callback err
        if !employee
            return callback null, false, { message: "Email or Password is incorrect" }
        employee.verifyPassword password, (err, passwordCorrect) ->
            if err
                return callback err
            if !passwordCorrect
                return callback null, false, { message: 'Email or Password is incorrect' }
            return callback null, employee # email and password are correct!

module.exports = mongoose.model 'Employee', EmployeeSchema
