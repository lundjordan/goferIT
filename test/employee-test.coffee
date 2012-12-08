mongoose = require 'mongoose'
Employee = require '../back_end/models/employee'

describe "employee model CRUD", ->
    employee = null
    mongoUrl = 'mongodb://localhost/gofer-test'

    before (done) ->
        (mongoose.connect mongoUrl)
        (Employee.remove {}).exec()
        done()

    describe "should create a valid Employee", ->
        it "and save newly created employee", (done) ->
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
        it "then retrieve email and first name from new employee", (done) ->
            Employee.findOne _id: employee.id, (err, resEmployee) ->
                resEmployee.email.should.equal 'nadroj@gmail.com'
                resEmployee.name.first.should.equal 'Nadroj'
            done()

    after (done) ->
        (Employee.remove {}).exec()
        mongoose.connection.close()
        done()
