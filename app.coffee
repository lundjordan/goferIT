express = require 'express'
path = require 'path'
util = require 'util'
passport = require 'passport'
LocalStrategy = (require 'passport-local').Strategy

## models
Employee = require './models/employee'
Supplier = require './models/supplier'
Customer = require './models/customer'
Order = require './models/order'
Store = require './models/store'
Terminal = require './models/terminal'
Product = require './models/product'
Sale = require './models/sale'
##

# authentication setup
passport = (require './utils/authenticateUtils') Employee, passport

# RESTUtils
restify = require './utils/RESTUtils'

# kick off the app/express
app = module.exports = express()

# configure express
(require './configure_app') app, passport

## Routes
(require './routes/index') app
(require './routes/authentication') app, passport
(require './routes/suppliers') app, restify, Supplier
##

server = app.listen app.settings.port
console.log "Express server listening on port #{app.settings.port} in #{app.settings.env} mode"
