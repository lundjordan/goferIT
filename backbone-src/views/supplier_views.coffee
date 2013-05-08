# Supplier Views

jQuery ->

    class SupplierControllerView extends Backbone.View
        el: '#suppliers-main-view'
        events:
            'click #suppliers-list-tab': 'renderSuppliersListView'
            'click #supplier-item-tab': 'renderSupplierDefaultItemView'
            'click #supplier-create-tab': 'renderSupplierCreateView'
        initialize: ->
            @currentView = null
        renderSuppliersListView: ->
            @removeCurrentContentView()
            @currentView = new app.GenericListView
                collection: app.Suppliers
                tableTemplate: "#suppliers-table-template"
                tableListID: "#suppliers-table-list"
                itemTrTemplate: "#supplier-tr-template"
                deleteModalTemplate: "#supplier-view-delete-template"
                itemControllerView: @
            $("#suppliers-list-view-content").html @currentView.render().el
        renderSupplierDefaultItemView: ->
            @removeCurrentContentView()
            @currentView = new app.GenericSingleView
                collection: app.Suppliers
                singleLayoutTemplate: "#single-item-view-template"
                singleContentTemplate: "#supplier-view-content-template"
                deleteModalTemplate: "#supplier-view-delete-template"
                itemControllerView: @
            $("#supplier-item-view-content").html(
                (@currentView.render app.Suppliers.models[0]).el)
        renderSpecificItemView: (model) ->
            @removeCurrentContentView()
            $('#supplier-item-tab a').tab('show')
            @currentView = new app.GenericSingleView
                collection: app.Suppliers
                singleLayoutTemplate: "#single-item-view-template"
                singleContentTemplate: "#supplier-view-content-template"
                deleteModalTemplate: "#supplier-view-delete-template"
                itemControllerView: @
            $("#supplier-item-view-content").html (@currentView.render model).el
        renderCreateView: ->
            # we use this in generic views for when clicking on create
            # it is a generic method name so it can be more agnostic
            @renderSupplierCreateView()
        renderSupplierCreateView: ->
            @removeCurrentContentView()
            # need to explicitly show, in case user clicked create in listView
            $('#supplier-create-tab a').tab('show')
            @currentView = new app.GenericCreateView
                createFormTemplate: "#supplier-create-template"
                formRules:
                    firstName:
                        required: true
                    lastName:
                        required: true
                    email:
                        required: true
                        email: true
                isValidMongoEntryFunction: isUniqueSupplier
                commitFormSubmitFunction: createNewSupplier
            $("#supplier-create-view-content").html @currentView.render().el
        renderSpecificEditView: (model) ->
            @removeCurrentContentView()
            $('#supplier-create-tab a').tab('show')
            @currentView = new app.GenericCreateView
                model: model
                createFormTemplate: "#supplier-edit-template"
                formRules:
                    name:
                        required: true
                    email:
                        required: true
                        email: true
                isValidMongoEntryFunction: ->
                    return true # if it passes form validation, that's fine
                commitFormSubmitFunction: updateExistingSupplier
            $("#supplier-create-view-content").html @currentView.render().el
        # helpers
        removeCurrentContentView: ->
            if @currentView
                @currentView.remove()
            # $("#root-backbone-alert-view").remove()
            # $("#root-backbone-view-head").remove()
            # $("#root-backbone-view-body").remove()
    # # ###############
    # Suppliers List View Section
    # -> comes from ItemListVIew in # generic_views.coffee
    # ###############

    # helper functions for creating a new Suppliers

    isUniqueSupplier = ->
        isUniqueItem = app.Suppliers.
            where(email: $('#email-input').val()).length < 1
        if isUniqueItem
            return true # unique
        else
            message = "You already have a supplier by this email."
            alertWarning = new app.AlertView
                alertType: 'warning'
            $("#root-backbone-alert-view").
                html(alertWarning.render( "alert-error", message).el)
            return false # not unique
    createNewSupplier = ->
        supplierModel =
            name: $("#name-input").val()
            email: $("#email-input").val()
            phone: $("#phone-input").val()
            address:
                street: $("#address-input").val()
                postalCode: $("#zip-input").val()
                city: $("#city-input").val()
                state: $("#state-select").val()
                country: BFHCountriesList[$("#countries_input").val()]
        app.Suppliers.create supplierModel
        message = "You have added a new supplier!"
        alertWarning = new app.AlertView
            alertType: 'success'
        $("#root-backbone-alert-view").
            html(alertWarning.render( "alert-success", message).el)

    updateExistingSupplier = ->
        supplierModel =
            name: $("#name-input").val()
            phone: $("#phone-input").val()
            address:
                street: $("#address-input").val()
                postalCode: $("#zip-input").val()
                city: $("#city-input").val()
                state: $("#state-select").val()
                country: BFHCountriesList[$("#countries_input").val()]
        @model.save supplierModel
        message = "Your changes, if any, have been saved!"
        alertWarning = new app.AlertView
            alertType: 'success'
        $("#root-backbone-alert-view").
            html(alertWarning.render( "alert-success", message).el)

    @app = window.app ? {}
    @app.SupplierControllerView = SupplierControllerView
