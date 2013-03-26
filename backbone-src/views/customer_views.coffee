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
            @currentView = new CustomerCreateView
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
            @currentView.render()

    # # ###############
    # Customers List View Section
    # -> comes from ItemListVIew in # generic_views.coffee
    # ###############

    class CustomerCreateView extends app.GenericCreateView
        initialize: ->
            @el = @options.el
            @itemCreateBodyView = new CustomerCreateBodyView
                template: @options.createFormTemplate
                formRules: @options.formRules
    class CustomerCreateBodyView extends app.ItemCreateBodyView
        isUniqueItem: ->
            isUniqueItem = app.Customers.
                where(email: $('#email-input')).length > 0

            if not isUniqueItem
                message = "You already have a customer by this email. " +
                alertWarning = new app.AlertView
                $("#main-alert-div").html(alertWarning.render( "alert-error", message).el)
                console.log "didn't pass existing customer check"
                return false # not unique
            return true # unique

        createNewItem: (subQuants) ->
            customerModel =
                firstName: $("#first-name-input").val() or null
                lastName: $("#last-name-input").val() or null
                email: $("#email-input").val() or null
                address: $("#address-input").val() or null
                city: $("#city-input").val() or null
                country: $("#country-input").val() or null
                state: $("#state-input").val() or null
                zip: $("#zip-input").val() or null
                phone: $("#phone-input").val() or null
                dob: $("#dob-input").val() or null
                sex: $('input[name=sexRadio]:checked').val() or null
            console.log customerModel
            # app.Items.create itemModel

    @app = window.app ? {}
    @app.CustomerControllerView = CustomerControllerView
