# Employee Views

jQuery ->

    class EmployeeControllerView extends Backbone.View
        el: '#employees-main-view'
        events:
            'click #employees-list-tab': 'renderEmployeesListView'
            'click #employee-item-tab': 'renderEmployeeDefaultItemView'
            'click #employee-create-tab': 'renderEmployeeCreateView'
        initialize: ->
            @currentView = null
        renderEmployeesListView: ->
            @removeCurrentContentView()
            @currentView = new app.GenericListView
                collection: app.Employees
                tableTemplate: '#employees-table-template'
                tableListID: '#employees-table-list'
                itemTrTemplate: '#employee-tr-template'
                deleteModalTemplate: "#employee-view-delete-template"
                itemControllerView: @
            $("#employees-list-view-content").html @currentView.render().el
        renderEmployeeDefaultItemView: ->
            @removeCurrentContentView()
            @currentView = new app.GenericSingleView
                collection: app.Employees
                singleLayoutTemplate: "#single-item-view-template"
                singleContentTemplate: "#employee-view-content-template"
                deleteModalTemplate: "#employee-view-delete-template"
                itemControllerView: @
            $("#employee-item-view-content").html(
                (@currentView.render app.Employees.models[0]).el)
        renderSpecificItemView: (model) ->
            @removeCurrentContentView()
            $('#employee-item-tab a').tab('show')
            @currentView = new app.GenericSingleView
                collection: app.Employees
                singleLayoutTemplate: "#single-item-view-template"
                singleContentTemplate: "#employee-view-content-template"
                deleteModalTemplate: "#employee-view-delete-template"
                itemControllerView: @
            $("#employee-item-view-content").html (@currentView.render model).el
        renderEmployeeCreateView: ->
            @removeCurrentContentView()
            @currentView = new app.GenericCreateView
                createFormTemplate: "#employee-create-template"
                formRules:
                    firstName:
                        required: true
                    lastName:
                        required: true
                    email:
                        required: true
                        email: true
                    password:
                        minlength: 6
                        required: true
                    password2:
                        minlength: 6
                        required: true
                        equalTo: "#password-input"
                isValidMongoEntryFunction: isUniqueEmployee
                commitFormSubmitFunction: createNewEmployee
            $("#employee-create-view-content").html @currentView.render().el
        renderSpecificEditView: (model) ->
            @removeCurrentContentView()
            $('#employee-create-tab a').tab('show')
            @currentView = new app.GenericCreateView
                model: model
                createFormTemplate: "#employee-edit-template"
                formRules:
                    firstName:
                        required: true
                    lastName:
                        required: true
                    email:
                        required: true
                        email: true
                    password:
                        minlength: 6
                        required: true
                    password2:
                        minlength: 6
                        required: true
                        equalTo: "#password-input"
                isValidMongoEntryFunction: ->
                    return true # if it passes form validation, that's fine
                commitFormSubmitFunction: updateExistingEmployee
            $("#employee-create-view-content").html @currentView.render().el

        removeCurrentContentView: ->
            if @currentView
                @currentView.remove()
            # $("#root-backbone-alert-view").remove()
            # $("#root-backbone-view-head").remove()
            # $("#root-backbone-view-body").remove()

    # # ###############
    # Employees List View Section
    # -> comes from ItemListVIew in # generic_views.coffee
    # ###############

    # helper functions for creating a new Employees

    isUniqueEmployee = ->
        isUniqueItem = app.Employees.
            where(email: $('#email-input').val()).length < 1
        if isUniqueItem
            return true # unique
        else
            message = "You already have an employee by this email."
            alertWarning = new app.AlertView
                alertType: 'warning'
            $("#root-backbone-alert-view").
                html(alertWarning.render( "alert-error", message).el)
            return false # not unique
    createNewEmployee = ->
        employeeModel =
            name:
                first: $("#first-name-input").val()
                last: $("#last-name-input").val()
            email: $("#email-input").val()
            password: $("#password-input").val()
            phone: $("#phone-input").val()
            address:
                street: $("#address-input").val()
                postalCode: $("#zip-input").val()
                city: $("#city-input").val()
                state: $("#state-select").val()
                country: BFHCountriesList[$("#countries_input")]
            dob: $("#dob-input").val()
            title: $('#title-input').val()
        app.Employees.create employeeModel
        message = "You have added a new employee!"
        alertWarning = new app.AlertView
            alertType: 'success'
        $("#root-backbone-alert-view").
            html(alertWarning.render( "alert-success", message).el)

    updateExistingEmployee = ->
        employeeModel =
            name:
                first: $("#first-name-input").val()
                last: $("#last-name-input").val()
            phone: $("#phone-input").val()
            password: $("#password-input").val()
            address:
                street: $("#address-input").val()
                postalCode: $("#zip-input").val()
                city: $("#city-input").val()
                state: $("#state-select").val()
                country: BFHCountriesList[$("#countries_input")]
            dob: $("#dob-input").val()
            title: $('#title-input').val()
        @model.save employeeModel
        message = "Your changes, if any, have been saved!"
        alertWarning = new app.AlertView
            alertType: 'success'
        $("#root-backbone-alert-view").
            html(alertWarning.render( "alert-success", message).el)


    @app = window.app ? {}
    @app.EmployeeControllerView = EmployeeControllerView

