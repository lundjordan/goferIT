# Customer Views

jQuery ->

    class CustomerControllerView extends Backbone.View
        el: '#customers-main-view'
        events:
            'click #customers-list-tab': 'renderCustomersListView'
            'click #customer-item-tab': 'renderCustomerDefaultItemView'
            'click #customer-create-tab': 'renderCustomerCreateView'
        initialize: ->
            @currentView = null
        renderCustomersListView: ->
            @removeCurrentContentView()
            @currentView = new app.GenericListView
                collection: app.Customers
                tableTemplate: "#customers-table-template"
                tableListID: "#customers-table-list"
                itemTrTemplate: "#customer-tr-template"
                deleteModalTemplate: "#customer-view-delete-template"
                itemControllerView: @
            $("#customers-list-view-content").html @currentView.render().el
        renderCustomerDefaultItemView: ->
            @removeCurrentContentView()
            @currentView = new app.GenericSingleView
                collection: app.Customers
                singleLayoutTemplate: "#single-item-view-template"
                singleContentTemplate: "#customer-view-content-template"
                deleteModalTemplate: "#customer-view-delete-template"
                itemControllerView: @
            $("#customer-item-view-content").html(
                (@currentView.render app.Customers.models[0]).el)
        renderSpecificItemView: (model) ->
            @removeCurrentContentView()
            $('#customer-item-tab a').tab('show')
            @currentView = new app.GenericSingleView
                collection: app.Customers
                singleLayoutTemplate: "#single-item-view-template"
                singleContentTemplate: "#customer-view-content-template"
                deleteModalTemplate: "#customer-view-delete-template"
                itemControllerView: @
            $("#customer-item-view-content").html (@currentView.render model).el
        renderCreateView: ->
            # we use this in generic views for when clicking on create
            # it is a generic method name so it can be more agnostic
            @renderCustomerCreateView()
        renderCustomerCreateView: ->
            @removeCurrentContentView()
            # need to explicitly show, in case user clicked create in listView
            $('#customer-create-tab a').tab('show')
            @currentView = new app.GenericCreateView
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
            $("#customer-create-view-content").html @currentView.render().el
        renderSpecificEditView: (model) ->
            @removeCurrentContentView()
            $('#customer-create-tab a').tab('show')
            @currentView = new app.GenericCreateView
                model: model
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
            $("#customer-create-view-content").html @currentView.render().el
        # helpers
        removeCurrentContentView: ->
            if @currentView
                @currentView.remove()
            # $("#root-backbone-alert-view").remove()
            # $("#root-backbone-view-head").remove()
            # $("#root-backbone-view-body").remove()
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
                country: BFHCountriesList[$("#countries_input").val()]
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
                country: BFHCountriesList[$("#countries_input").val()]
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
