express = require 'express'
path = require 'path'
util = require 'util'
passport = require 'passport'
LocalStrategy = (require 'passport-local').Strategy

## models
Employee = require './models/employee-mongo'
Supplier = require './models/supplier-mongo'
Customer = require './models/customer-mongo'
Order = require './models/order-mongo'
Store = require './models/store-mongo'
Product = require './models/product-mongo'
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
(require './routes/customers') app, restify, Customers
(require './routes/companies') app, restify, Companies
(require './routes/stores') app, restify, Stores
(require './routes/employees') app, restify, Employees
(require './routes/suppliers') app, restify, Supplier
(require './routes/orders') app, restify, Orders
(require './routes/products') app, restify, Product
(require './routes/sales') app, restify, Sales
##

server = app.listen app.settings.port
console.log "Express server listening on port #{app.settings.port} in #{app.settings.env} mode"
