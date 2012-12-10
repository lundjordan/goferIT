express = require 'express'
path = require 'path'
util = require 'util'
passport = require 'passport'
LocalStrategy = (require 'passport-local').Strategy

## models
Employee = require './back_end/models/employee'
Supplier = require './back_end/models/supplier'
Customer = require './back_end/models/customer'
Order = require './back_end/models/order'
Store = require './back_end/models/store'
Terminal = require './back_end/models/terminal'
Product = require './back_end/models/product'
Sale = require './back_end/models/sale'
##

# authentication setup
passport = (require './back_end/utils/authenticateUtils') Employee, passport

# RESTUtils
restify = require './back_end/utils/RESTUtils'

# kick off the app/express
app = module.exports = express()

# configure express
(require './back_end/configure') app, passport

## Routes
(require './back_end/routes/index') app
(require './back_end/routes/authentication') app, passport
(require './back_end/routes/suppliers') app, restify, Supplier
##

server = app.listen app.settings.port
console.log "Express server listening on port #{app.settings.port} in #{app.settings.env} mode"
