# Employees Collection

class Employees extends Backbone.Collection
    model: app.Employee
    url: '/employees'
    initialize: ->
        @comparator = (employee) ->
            employee.get('name').last.toLowerCase()
    findPrev: (currentModel) ->
        indexCurrentModel = @indexOf(currentModel)
        if indexCurrentModel is 0
            return @at @length-1
        @at indexCurrentModel-1
    findNext: (currentModel) ->
        indexCurrentModel = @indexOf(currentModel)
        if @length is indexCurrentModel+1
            return this.at 0
        @at indexCurrentModel+1

@app = window.app ? {}
@app.Employees = new Employees

