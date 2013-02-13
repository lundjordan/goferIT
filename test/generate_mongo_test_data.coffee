mongoose = require 'mongoose'
Company = require '../models/company-mongo'
Customer = require '../models/customer-mongo'
Employee = require '../models/employee-mongo'
Store = require '../models/store-mongo'
Supplier = require '../models/supplier-mongo'
Order = require '../models/order-mongo'
Product = require '../models/product-mongo'
Sale = require '../models/sale-mongo'

mongoUrl = 'mongodb://localhost/gofer-test'

mongoose.connect mongoUrl, ->
    (Sale.remove {}).exec()
    (Product.remove {}).exec()
    (Employee.remove {}).exec()
    (Order.remove {}).exec()
    (Store.remove {}).exec()
    (Supplier.remove {}).exec()
    (Customer.remove {}).exec()
    (Company.remove {}).exec()

companyObjs = []
companyDocs = []

employeeObjs = []
employeeDocs = []

storeObjs = []
storeDocs = []

orderObjs = []
orderDocs = []

supplierObjs = []
supplierDocs = []

customerObjs = []
customerDocs = []

productObjs = []
productDocs = []

saleObjs = []
saleDocs = []



#######
# companies

companyObjs.push
    name: "Nad's Sports"
    subscriptionType: "trial"
    dateCreated: new Date().toISOString()

for company in companyObjs
    companyDoc = new Company company
    companyDoc.save (err) ->
        if err
            throw err
        console.log companyDoc
        mongoose.connection.close()

#######
# employees
# 
# employeeObjs.push
#     email: 'nadroj@gmail.com'
#     _company: companyDocs[0]
#     password: 'password'
#     name:
#         first: 'Nadroj'
#         last: 'dnul'
#     phone: '16049291111'
#     address:
#         street: '1234 sesame street'
#         postalCode: 'v7w4c9'
#         city: 'West Vancouver'
#         country: 'Canada'
#     dob: '1986-09-20'
#     title: 'admin'
# employeeObjs.push
#     email: 'employee1@gmail.com'
#     _company: companyDocs[0]
#     password: 'password'
#     name:
#         first: 'Connor'
#         last: 'Fitzpatrick'
#     phone: '16049291111'
#     address:
#         street: '1234 sesame street'
#         postalCode: 'v7w4c9'
#         city: 'West Vancouver'
#         country: 'Canada'
#     dob: '1986-09-20'
#     title: 'employee'
# employeeObjs.push
#     email: 'rookie@gmail.com'
#     _company: companyDocs[0]
#     password: 'password'
#     name:
#         first: 'Jennifer'
#         last: 'Hayes'
#     phone: '16049291111'
#     address:
#         street: '1234 sesame street'
#         postalCode: 'v7w4c9'
#         city: 'West Vancouver'
#         country: 'Canada'
#     dob: '1986-09-20'
#     title: 'employee'
# 
# for employee in employeeObjs
#     employeeDoc = new Employee employee
#     employeeDoc.save (err) ->
#         if err
#             throw err
#         employeeDocs.push employeeDoc

#######
# stores
# stores = []
# stores.push
# stores.push
# stores.push
# 
# # customers
# customers = []
# customers.push
# customers.push
# customers.push
# customers.push
# 
# # suppliers
# suppliers = []
# suppliers.push
# suppliers.push
# suppliers.push
# suppliers.push
# 
# # orders
# orders = []
# orders.push
# orders.push
# orders.push
# orders.push
# orders.push
# orders.push
# 
# # products
# products = []
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# products.push
# 
# # sales
# sales = []
# sales.push
# sales.push
# sales.push
# sales.push
# sales.push
# sales.push
# sales.push
# sales.push
# sales.push
# sales.push
# sales.push
# sales.push
# sales.push
# sales.push
# sales.push
# sales.push
# sales.push
# sales.push
# sales.push
