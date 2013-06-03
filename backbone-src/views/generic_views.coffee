# Alert View

jQuery ->

    # ###############
    # Items List View Section
    class GenericListView extends Backbone.View
        template: _.template ($ '#root-backbone-content-template').html()
        events:
            'change #store-name-select': 'renderItemsTable'
        initialize: ->
            @headView = @options.HeadView
            @itemControllerView = @options.itemControllerView
            # below is not the cleanest but it allows GenericItemsTable
            # to be overridden by a subclass. For example products does this
            # so that it can manage how products based on storename and
            # subquants are viewed
            if @options.ItemsTableView
                @ItemsTableView = @options.ItemsTableView
            else
                @ItemsTableView = GenericItemsTable
            @itemsTable = new @ItemsTableView
                collection: @options.collection
                template: @options.tableTemplate
                tableListID: @options.tableListID
                itemTrTemplate: @options.itemTrTemplate
                itemControllerView: @itemControllerView
                deleteModalTemplate: @options.deleteModalTemplate
        render: ->
            @$el.html this.template({})
            if @headView
                headView = new @headView
                    itemControllerView: @itemControllerView
                    itemsTable: @itemsTable # used by finance views
                @$("#root-backbone-view-head").html headView.render().el
                @itemsTable.setItemsToBeStoreSpecificBy(
                    @$('#store-name-select option:selected').val())
            @$("#root-backbone-view-body").html @itemsTable.render().el
            @
        renderItemsTable: ->
            @itemsTable.setItemsToBeStoreSpecificBy(
                @$('#store-name-select option:selected').val())
            @itemsTable.render()
    class GenericItemsTable extends Backbone.View
        events:
            'click #create-item-button': 'createNewButton'
        initialize: ->
            @listenTo @collection, 'remove', @render
            @template = _.template ($ @options.template).html()
            @tableListID = @options.tableListID
            @itemTrTemplate = @options.itemTrTemplate
            @itemControllerView = @options.itemControllerView
            @deleteModalTemplate = @options.deleteModalTemplate
            @storeName = null
        render: ->
            @$el.html this.template({})
            @addAll()
            @
        createNewButton: ->
            @itemControllerView.renderCreateView()
        setItemsToBeStoreSpecificBy: (storeName) ->
            @storeName = storeName
        addOne: (item) ->
            if @storeName
                @addBasedByStoreName(item) # this should be overrided
            else
                view = new SingleListItemView
                    model: item
                    template: @itemTrTemplate
                    itemControllerView: @itemControllerView
                    deleteModalTemplate: @deleteModalTemplate
                (@$ @tableListID).append view.render().el

        addAll: ->
            if @collection.length
                @collection.each @addOne, @
            else
                message = "It looks like you don't have anything in this list " +
                    "yet. Click on the green create button or the " +
                    "'Create/Edit' tab to get populating."
                alertWarning = new app.AlertView
                    alertType: 'info'
                @$el.append alertWarning.render( "alert-info", message).el
    class SingleListItemView extends Backbone.View
        tagName: 'tr'
        events: ->
            'mouseover': 'showItemOptions'
            'mouseout': 'hideItemOptions'
            'click #item-view-eye-link': 'renderSpecificItemView'
            'click #item-view-edit-link': 'renderSpecificEditView'
            'click #item-view-delete-link': 'renderSpecificDeleteView'
        initialize: ->
            @template = _.template ($ @options.template).html()
            @itemControllerView = @options.itemControllerView
            @deleteModalTemplate = @options.deleteModalTemplate
        render: ->
            templateAttrs = null
            if @itemControllerView.preSingleListItemHook
                templateAttrs = @itemControllerView.preSingleListItemHook(@model)
            else
                templateAttrs = @model.attributes
            @$el.html this.template templateAttrs
            $(@el).find('i').hide()
            @
        showItemOptions: (event) ->
            # $('#item-options').prepend("<i class='icon-search'></i>")
            $(@el).find('i').show()
        hideItemOptions: (event) ->
            # $('#item-options').html()
            $(@el).find('i').hide()
        renderSpecificItemView: ->
            @itemControllerView.renderSpecificItemView @model
        renderSpecificEditView: ->
            @itemControllerView.renderSpecificEditView @model
        renderSpecificDeleteView: ->
            passesCondition = true
            if @itemControllerView.deleteConditionHook
                passesCondition = @itemControllerView.deleteConditionHook(@model)
            if passesCondition
                @deleteView =  new ConfirmDeleteModal
                    model: @model
                    template: @deleteModalTemplate
                $("#root-backbone-view-body").append @deleteView.render().el
                $('#delete-item-modal').on 'hidden', =>
                    @deleteView.remove()
                $("#delete-item-modal").modal 'show'
    # ###############


    # ###############
    # Single Item View Section
    class GenericSingleView extends Backbone.View
        template: _.template ($ '#root-backbone-content-template').html()
        events:
            'click #single-item-prev-link': 'renderSingleItemPrevView'
            'click #single-item-next-link': 'renderSingleItemNextView'
            'click #item-view-edit-link': 'renderSpecificEditView'
            'click #item-view-delete-link': 'renderSpecificDeleteView'
        initialize: (options) ->
            @listenTo @collection, 'remove', @renderNextAvailableModel
            @itemControllerView = @options.itemControllerView
            @deleteModalTemplate = @options.deleteModalTemplate
            @singleView =  new ItemLayoutView
                template: @options.singleLayoutTemplate
                singleContentTemplate: @options.singleContentTemplate
                itemControllerView: @options.itemControllerView
        renderNextAvailableModel: ->
            @render @collection.models[0]
        render: (currentModel) ->
            @currentModel = currentModel
            @$el.html this.template({})
            @$("#root-backbone-view-body").html @singleView.render(@currentModel).el
            @
        renderSingleItemPrevView: (event) ->
            @currentModel = @collection.findPrev @currentModel
            @singleView.render @currentModel
        renderSingleItemNextView: (event) ->
            @currentModel = @collection.findNext @currentModel
            @singleView.render @currentModel
        renderSpecificEditView: (model) ->
            if @currentModel
                @itemControllerView.renderSpecificEditView @currentModel
        renderSpecificDeleteView: ->
            if @currentModel
                @deleteView =  new ConfirmDeleteModal
                    model: @currentModel
                    template: @deleteModalTemplate
                $("#root-backbone-view-body").append @deleteView.render().el
                $("#delete-item-modal").modal 'show'
    # Single Item View Section
    class ItemLayoutView extends Backbone.View
        initialize: ->
            @template = _.template ($ @options.template).html()
            @singleContentTemplate = @options.singleContentTemplate
            @itemControllerView = @options.itemControllerView
            @currentModelView = null
        render: (currentModel) ->
            if currentModel
                @$el.html this.template(currentModel.attributes)
                @renderSingleContent(currentModel)
            else
                @$el.html this.template()
                message = "It looks like you don't have anything for this yet. " +
                    "Click on the 'create/edit' tab to start populating your" +
                    " company with everything it cares about."
                alertWarning = new app.AlertView
                    alertType: 'info'
                @$("#single-item-view-content").
                    html(alertWarning.render( "alert-info", message).el)
            @
        renderSingleContent: (currentModel) ->
            @currentModelView = new ItemContentView
                template: @singleContentTemplate
                itemControllerView: @options.itemControllerView
            @$('#single-item-view-content')
                .html @currentModelView.render(currentModel).el
    class ItemContentView extends Backbone.View
        className: 'container-fluid'
        initialize: ->
            @template = _.template ($ @options.template).html()
            @itemControllerView = @options.itemControllerView
        render: (currentModel) ->
            templateAttrs = null
            if @itemControllerView.preSingleListItemHook
                templateAttrs = @itemControllerView.
                    preSingleListItemHook(currentModel)
            else
                templateAttrs = currentModel.attributes
            @$el.html @template templateAttrs
            @
    # ###############

    # ###############
    # Item Create Section
    class GenericCreateView extends Backbone.View
        template: _.template ($ '#root-backbone-content-template').html()
        initialize: ->
            @itemCreateBodyView = new ItemCreateBodyView
                model: @options.model
                template: @options.createFormTemplate
                formRules: @options.formRules
                isValidMongoEntryFunction: @options.isValidMongoEntryFunction
                commitFormSubmitFunction: @options.commitFormSubmitFunction
        render: ->
            @$el.html this.template()
            @$("#root-backbone-view-body").html @itemCreateBodyView.render().el
            @
    class ItemCreateBodyView extends Backbone.View
        events:
            "click #create-new-item-button": "checkValidityAndCreateNewItem"
            "click #clear-new-item-button": "clearNewItemFields"
        initialize: ->
            @template = _.template ($ @options.template).html()
            @formRules = @options.formRules
            @isValidMongoEntryFunction = @options.isValidMongoEntryFunction
            @commitFormSubmitFunction = @options.commitFormSubmitFunction
        clearNewItemFields: ->
            @render()
        render: ->
            if @model
                @$el.html this.template(@model.attributes)
            else
                @$el.html this.template({})
            @setBootstrapFormHelperInputs()
            @setJQueryValidityRules()
            @
        setBootstrapFormHelperInputs: ->
            @$('form select.bfh-countries, span.bfh-countries, div.bfh-countries').each ->
                inputField = $(this)
                inputField.bfhcountries inputField.data()
            @$('form select.bfh-states, span.bfh-states, div.bfh-states').each ->
                inputField = $(this)
                inputField.bfhstates inputField.data()
            @$('div.bfh-datepicker').each ->
                inputField = $(this)
                inputField.bfhdatepicker inputField.data()
            @$('form input:text.bfh-phone, span.bfh-phone').each ->
                inputField = $(this)
                inputField.bfhphone inputField.data()
        setJQueryValidityRules: ->
            @validateForm @$("#create-item-form"), @formRules
        checkValidityAndCreateNewItem: (e) ->
            e.preventDefault()
            $("#main-alert-div").html("")
            passesJQueryValidation = @$("#create-item-form").valid()

            if passesJQueryValidation
                if @isValidMongoEntryFunction()
                    return @commitFormSubmitFunction()
            return


    # ###############
    # Helper Generic Views
    class ConfirmDeleteModal extends Backbone.View
        events:
            'click #delete-confirmed-button': 'confirmedDeletion'
        initialize: ->
            @template = _.template ($ @options.template).html()
        render: ->
            @$el.html this.template @model.attributes
            @
        confirmedDeletion: ->
            $("#delete-item-modal").modal 'hide'
            @model.destroy()
            message = "removed..."
            alertInfo = new AlertView
                alertType: 'info'
            $("#root-backbone-alert-view").
                html(alertInfo.render( "alert-info", message).el)
    class AlertView extends Backbone.View
        initialize: ->
            @template = _.template ($ "#alert-message-#{@options.alertType}").html()
        render: (alertType, message) ->
            @$el.html this.template
                alertType: alertType
                message: message
            @
    class StoreSelectView extends Backbone.View
        initialize: ->
            @itemControllerView = @options.itemControllerView
        render: ->
            @$el.html this.template({})
            storeNames = app.Companies.models[0].get 'stores'
            @addToSelect(store.name) for store in storeNames
            if @model
                # incase we are in edit mode, set the select tag to 
                # whatever the model's store name is
                @$("select[id=store-name-select]").val(@model.attributes.storeName)
            @
        addToSelect: (storeName) ->
            @$('#store-name-select').append(
                "<option value='#{storeName}'>#{storeName}</option>")
    # ###############


    # ###############
    @app = window.app ? {}
    @app.AlertView = AlertView
    @app.GenericListView = GenericListView
    @app.GenericItemsTable = GenericItemsTable
    @app.GenericSingleListItemView = SingleListItemView
    @app.GenericSingleView = GenericSingleView
    @app.GenericCreateView = GenericCreateView
    @app.GenericSingleItemContentView = ItemContentView
    @app.ConfirmDeleteModal = ConfirmDeleteModal
    @app.StoreSelectView = StoreSelectView
