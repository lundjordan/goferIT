express = require 'express'
path = require 'path'
util = require 'util'
passport = require 'passport'
LocalStrategy = (require 'passport-local').Strategy

## models
Company = require './models/company-mongo'
Employee = require './models/employee-mongo'
Supplier = require './models/supplier-mongo'
Customer = require './models/customer-mongo'
Order = require './models/order-mongo'
Stock = require './models/stock-mongo'
Sale = require './models/sale-mongo'
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
(require './routes/companies') app, restify, Company
(require './routes/customers') app, restify, Customer
(require './routes/employees') app, restify, Employee
(require './routes/suppliers') app, restify, Supplier
# (require './routes/orders') app, restify, Order
(require './routes/products') app, restify, Stock
# (require './routes/sales') app, restify, Sale
##

server = app.listen app.settings.port
console.log "Express server listening on port #{app.settings.port} in #{app.settings.env} mode"
