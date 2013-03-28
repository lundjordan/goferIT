# Employee Views

jQuery ->

    class EmployeeControllerView extends Backbone.View
        el: '#people-main-content'
        events:
            'click #employees-menu-pill': 'renderEmployeesFirstView'
            'click #employees-list-tab': 'renderEmployeesListView'
            'click #employee-item-tab': 'renderEmployeeDefaultItemView'
            'click #employee-create-tab': 'renderEmployeeCreateView'
        initialize: ->
            @currentView = null
        renderEmployeesFirstView: ->
            $('#employees-list-tab a').tab('show')
            @renderEmployeesListView()
        renderEmployeesListView: ->
            $("#root-backbone-alert-view").remove()
            $("#root-backbone-view-head").remove()
            $("#root-backbone-view-body").remove()

            @currentView = new app.GenericListView
                collection: app.Employees
                el: "#employees-list-view-content"
                tableTemplate: '#employees-table-template'
                tableListID: '#employees-table-list'
                itemTrTemplate: '#employee-tr-template'
                deleteModalTemplate: "#employee-view-delete-template"
                itemControllerView: @
            @currentView.render()
        renderEmployeeDefaultItemView: ->
            $("#root-backbone-alert-view").remove()
            $("#root-backbone-view-head").remove()
            $("#root-backbone-view-body").remove()

            @currentView = new app.GenericSingleView
                collection: app.Employees
                el: "#employee-item-view-content"
                singleLayoutTemplate: "#single-item-view-template"
                singleContentTemplate: "#employee-view-content-template"
                deleteModalTemplate: "#employee-view-delete-template"
                itemControllerView: @
            @currentView.render app.Employees.models[0]
        renderSpecificItemView: (model) ->
            $("#root-backbone-alert-view").remove()
            $("#root-backbone-view-head").remove()
            $("#root-backbone-view-body").remove()

            $('#employee-item-tab a').tab('show')
            @currentView = new app.GenericSingleView
                collection: app.Employees
                el: "#employee-item-view-content"
                singleLayoutTemplate: "#single-item-view-template"
                singleContentTemplate: "#employee-view-content-template"
                deleteModalTemplate: "#employee-view-delete-template"
                itemControllerView: @
            @currentView.render model
        renderEmployeeCreateView: ->
            $("#root-backbone-alert-view").remove()
            $("#root-backbone-view-head").remove()
            $("#root-backbone-view-body").remove()

            @currentView = new app.GenericCreateView
                el: "#employee-create-view-content"
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
            @currentView.render()
        renderSpecificEditView: (model) ->
            $("#root-backbone-alert-view").remove()
            $("#root-backbone-view-head").remove()
            $("#root-backbone-view-body").remove()

            $('#employee-create-tab a').tab('show')
            @currentView = new app.GenericCreateView
                model: model
                el: "#employee-create-view-content"
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
            @currentView.render()

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
            address:
                street: $("#address-input").val()
                postalCode: $("#zip-input").val()
                city: $("#city-input").val()
                state: $("#state-select").val()
                country: BFHCountriesList[$("#countries_input")]
            dob: $("#dob-input").val()
            sex: $('input[name=sexRadio]:checked').val()
        @model.save employeeModel
        message = "Your changes, if any, have been saved!"
        alertWarning = new app.AlertView
            alertType: 'success'
        $("#root-backbone-alert-view").
            html(alertWarning.render( "alert-success", message).el)

    @app = window.app ? {}
    @app.EmployeeControllerView = EmployeeControllerView

