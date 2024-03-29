mongoose = require 'mongoose'
Employee = require '../models/employee-mongo'
Company = require '../models/company-mongo'

describe "employee model CRUD", ->
    employee = null
    company = null
    mongoUrl = 'mongodb://localhost/gofer-test'

    before (done) ->
        mongoose.connect mongoUrl, ->
            (Employee.remove {}).exec()
            (Company.remove {}).exec()
            company = new Company
                name: "Nad's Hardware"
                subscriptionType: "trial"
            company.save (err) ->
                if err
                    throw err
                done()

    describe "should create a valid Employee", ->
        it "and save newly created employee", (done) ->
            employee = new Employee
                email: 'nadroj@gmail.com'
                _company: company._id
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
            employee.save (err) ->
                if err
                    throw err
                done()

        it "then retrieve email and first name from new employee", (done) ->
            Employee.findOne _id: employee.id, (err, resEmployee) ->
                resEmployee.email.should.equal 'nadroj@gmail.com'
                resEmployee.name.first.should.equal 'Nadroj'
            done()
        it "then retrieve company name from new employee", (done) ->
            (Employee.findOne _id: employee.id)
                .populate('_company').exec (err, resEmployee) ->
                    resEmployee._company.name.should.equal "Nad's Hardware"
            done()

    after (done) ->
        (Employee.remove {}).exec()
        (Company.remove {}).exec()
        mongoose.connection.close()
        done()
