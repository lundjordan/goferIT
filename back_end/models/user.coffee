mongoose = require 'mongoose'
bcrypt = require 'bcrypt'

UserSchema = new mongoose.Schema
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

virtualPassword = (UserSchema.virtual 'password').get ->
    return this._password

virtualPassword.set (password) ->
    this._password = password
    salt = this.salt = bcrypt.genSaltSync 10
    this.hash = bcrypt.hashSync password, salt

UserSchema.method 'verifyPassword', (password, callback) ->
    bcrypt.compare password, this.hash, callback

UserSchema.statics.authenticate = (email, password, callback) ->
    this.findOne email: email, (err, user) ->
        if err
            console.log 'err: ' + err
            return callback err
        if !user
            console.log '!user: ' + email
            return callback null, false, { message: "Unknown user #{email}" }
        user.verifyPassword password, (err, passwordCorrect) ->
            if err
                console.log 'err under password: ' + err
                return callback err
            if !passwordCorrect
                console.log 'incorrect password: '
                return callback null, false, { message: 'Invalid password' }
            return callback null, user # email and password are correct!

module.exports = mongoose.model 'User', UserSchema
