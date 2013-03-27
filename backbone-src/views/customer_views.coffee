# Customer Views

jQuery ->

    class CustomerControllerView extends Backbone.View
        el: '#people-main-content'
        events:
            'click #customer-menu-pill': 'renderCustomersListView'
            'click #customers-list-tab': 'renderCustomersListView'
            'click #customer-item-tab': 'renderCustomerDefaultItemView'
            'click #customer-create-tab': 'renderCustomerCreateView'
        initialize: ->
            @currentView = null
        renderCustomersListView: ->
            if @currentView
                @currentView.$el.html("")
            @currentView = new app.GenericListView
                collection: app.Customers
                el: "#customers-list-view-content"
                tableTemplate: '#customers-table-template'
                tableListID: '#customers-table-list'
                itemTrTemplate: '#customer-tr-template'
                itemControllerView: @
            @currentView.render()
        renderCustomerDefaultItemView: ->
            if @currentView
                @currentView.$el.html("")
            @currentView = new app.GenericSingleView
                collection: app.Customers
                el: "#customer-item-view-content"
                singleLayoutTemplate: "#single-item-view-template"
                singleContentTemplate: "#customer-view-content-template"
            @currentView.render app.Customers.models[0]
        renderSpecificItemView: (model) ->
            if @currentView
                @currentView.$el.html("")
            $('#customer-item-tab a').tab('show')
            @currentView = new app.GenericSingleView
                collection: app.Customers
                el: "#customer-item-view-content"
                singleLayoutTemplate: "#single-item-view-template"
                singleContentTemplate: "#customer-view-content-template"
            @currentView.render model
        renderCustomerCreateView: ->
            if @currentView
                @currentView.$el.html("")
            @currentView = new app.GenericCreateView
                el: "#customer-create-view-content"
                createFormTemplate: "#customer-create-template"
                formRules:
                    firstName:
                        required: true
                    lastName:
                        required: true
                    email:
                        required: true
                        email: true
                isValidMongoEntryFunction: isUniqueCustomer
                commitFormSubmitFunction: createNewCustomer
            @currentView.render()
        renderSpecificEditView: (model) ->
            if @currentView
                @currentView.$el.html("")
            $('#customer-create-tab a').tab('show')
            @currentView = new app.GenericCreateView
                model: model
                el: "#customer-create-view-content"
                createFormTemplate: "#customer-edit-template"
                formRules:
                    firstName:
                        required: true
                    lastName:
                        required: true
                    email:
                        required: true
                        email: true
                isValidMongoEntryFunction: ->
                    return true # if it passes form validation, that's fine
                commitFormSubmitFunction: updateExistingCustomer
            @currentView.render()

    # # ###############
    # Customers List View Section
    # -> comes from ItemListVIew in # generic_views.coffee
    # ###############

    # helper functions for creating a new Customers
    isUniqueCustomer = ->
        isUniqueItem = app.Customers.
            where(email: $('#email-input').val()).length < 1
        if isUniqueItem
            return true # unique
        else
            message = "You already have a customer by this email."
            alertWarning = new app.AlertView
                alertType: 'warning'
            $("#root-backbone-alert-view").
                html(alertWarning.render( "alert-error", message).el)
            return false # not unique
    createNewCustomer = ->
        customerModel =
            name:
                first: $("#first-name-input").val()
                last: $("#last-name-input").val()
            email: $("#email-input").val()
            phone: $("#phone-input").val()
            address:
                street: $("#address-input").val()
                postalCode: $("#zip-input").val()
                city: $("#city-input").val()
                state: $("#state-select").val()
                country: BFHCountriesList[$("#countries_input")]
            dob: $("#dob-input").val()
            sex: $('input[name=sexRadio]:checked').val()
        app.Customers.create customerModel
        message = "You have added a new customer!"
        alertWarning = new app.AlertView
            alertType: 'success'
        $("#root-backbone-alert-view").
            html(alertWarning.render( "alert-success", message).el)

    updateExistingCustomer = ->
        customerModel =
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
        @model.save customerModel
        message = "Your changes, if any, have been saved!"
        alertWarning = new app.AlertView
            alertType: 'success'
        $("#root-backbone-alert-view").
            html(alertWarning.render( "alert-success", message).el)

    @app = window.app ? {}
    @app.CustomerControllerView = CustomerControllerView
