mongoose = require 'mongoose'
Company = require '../models/company'
Store = require '../models/store'
Employee = require '../models/employee'

describe "company model mongo CRUD", ->
    company = null
    employee = null
    mongoUrl = 'mongodb://localhost/gofer-test'

    before (done) ->
        mongoose.connect mongoUrl, ->
            (Company.remove {}).exec()
            (Employee.remove {}).exec()
            employee = new Employee
                email: 'nadroj@gmail.com'
                password: 'secretpassword'
                name:
                    first: 'Nadroj'
                    last: 'dnul'
                phone: '16049291111'
                address:
                    street: '1234 sesame street'
                    postalCode: 'v7w4c9'
                    city: 'West Vancouver'
                    country: 'Canada'
                dob: '1986-09-20'
                title: 'employee'
                startDate: new Date().toISOString()
            employee.save (err) ->
                if err
                    throw err
                else
                    done()

    describe "should create a valid Company", ->
        it "and save newly created company", (done) ->
            company = new Company
                _adminEmployee: employee.id
                name: "Nad's Hardware"
                subscriptionType: "trial"
                dateCreated: new Date().toISOString()
            company.save (err) ->
                if err
                    throw err
                else
                    done()

        it "then retrieve comp name and associated employee name from new company", (done) ->
            Company.findOne _id: company.id, (err, resCompany) ->
                resCompany.name.should.equal "Nad's Hardware"
            (Company.findOne _id: company.id)
                .populate('_adminEmployee').exec (err, emp) ->
                    emp.name.first.should.equal 'Nadroj'
            done()

    after (done) ->
        (Company.remove {}).exec()
        (Employee.remove {}).exec()
        mongoose.connection.close()
        done()

