# Customer Views

jQuery ->
    # helper functions for creating a new Customers
    isUniqueCustomer = ->
        isUniqueItem = app.Customers.
            where(email: $('#email-input')).length < 1
        if not isUniqueItem
            message = "You already have a customer by this email."
            alertWarning = new app.AlertView
            $("#main-alert-div").html(alertWarning.render( "alert-error", message).el)
            return false # not unique
        return true # unique
    createNewCustomer = (subQuants) ->
        # bootstrapFormHelper makes getting country string annoying
        countrySpanHTML = $("#country-span").html()
        country = countrySpanHTML.slice(countrySpanHTML.search('</i>')+4).
                replace(/^\s\s*/, '').replace(/\s\s*$/, '')

        customerModel =
            firstName: $("#first-name-input").val()
            lastName: $("#last-name-input").val()
            email: $("#email-input").val()
            address: $("#address-input").val()
            city: $("#city-input").val()
            country: country
            state: $("#state-select").val()
            zip: $("#zip-input").val()
            phone: $("#phone-input").val()
            dob: $("#dob-input").val()
            sex: $('input[name=sexRadio]:checked').val()
        console.log customerModel
        # app.Items.create itemModel

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
                isUniqueItemFunction: isUniqueCustomer
                createNewItemFunction: createNewCustomer
            @currentView.render()

    # # ###############
    # Customers List View Section
    # -> comes from ItemListVIew in # generic_views.coffee
    # ###############


    @app = window.app ? {}
    @app.CustomerControllerView = CustomerControllerView
