# Alert View

jQuery ->
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
            custName = "#{@model.get('name').first} #{@model.get('name').last}"
            $("#delete-item-modal").modal 'hide'
            @model.destroy()
            message = "You have successfully removed: #{custName}"
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
    # ###############

    # ###############
    # Items List View Section
    class GenericListView extends Backbone.View
        template: _.template ($ '#root-backbone-content-template').html()
        events:
            'change #store-name-select': 'renderItemsTable'
        initialize: ->
            if @options.storeSelectView
                @storeSelectView = new @options.storeSelectView()
            @itemsTable = new ItemsTable
                collection: @options.collection
                template: @options.tableTemplate
                tableListID: @options.tableListID
                itemTrTemplate: @options.itemTrTemplate
                itemControllerView: @options.itemControllerView
                deleteModalTemplate: @options.deleteModalTemplate
        render: ->
            @$el.html this.template({})
            if @storeSelectView
                $("#root-backbone-view-head").html @storeSelectView.render().el
            $("#root-backbone-view-body").html @itemsTable.render().el
            @
        renderItemsTable: ->
            if @storeSelectView
                @itemsTable.render()
    class ItemsTable extends Backbone.View
        initialize: ->
            @listenTo @collection, 'remove', @rendor
            @template = _.template ($ @options.template).html()
            @tableListID = @options.tableListID
            @itemTrTemplate = @options.itemTrTemplate
            @itemControllerView = @options.itemControllerView
            @deleteModalTemplate = @options.deleteModalTemplate
        render: ->
            @$el.html this.template({})
            @addAll()
            @
        addOne: (item) ->
            if $('#store-name-select')
                if $('#store-name-select').val() is item.get('storeName')
                    view = new SingleListItemView
                        model: item
                        template: @itemTrTemplate
                        itemControllerView: @itemControllerView
                        deleteModalTemplate: @deleteModalTemplate
                    (@$ @tableListID).append view.render().el
            else
                view = new SingleListItemView
                    model: item
                    template: @itemTrTemplate
                    itemControllerView: @itemControllerView
                    deleteModalTemplate: @deleteModalTemplate
                (@$ @tableListID).append view.render().el

        addAll: ->
            @collection.each @addOne, @
    class SingleListItemView extends Backbone.View
        tagName: 'tr'
        events:
            'mouseover': 'showItemOptions'
            'mouseout': 'hideItemOptions'
            'click #item-view-eye-link': 'renderSpecificItemView'
            'click #item-view-edit-link': 'renderSpecificEditView'
            'click #item-view-delete-link': 'renderSpecificDeleteView'
        initialize: ->
            @template = _.template ($ @options.template).html()
            @itemView = @options.itemView 
            @itemControllerView = @options.itemControllerView
            @deleteModalTemplate = @options.deleteModalTemplate
        render: ->
            @$el.html this.template @model.attributes
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
            @deleteView =  new ConfirmDeleteModal
                model: @model
                template: @deleteModalTemplate
            $("#root-backbone-view-body").append @deleteView.render().el
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
            # @listenTo @collection, 'remove', @renderNextAvailableModel
            @itemControllerView = @options.itemControllerView
            @deleteModalTemplate = @options.deleteModalTemplate
            # @storeSelectView = new SinglesListStoreSelectView()
            @singleView =  new ItemLayoutView
                template: @options.singleLayoutTemplate
                singleContentTemplate: @options.singleContentTemplate
        renderNextAvailableModel: ->
            @render @collection.models[0]
        render: (currentModel) ->
            @currentModel = currentModel
            @$el.html this.template({})
            # @$("#root-backbone-view-head").html @storeSelectView.render().el
            # @storeSelectView.render()
            $("#root-backbone-view-body").html @singleView.render(@currentModel).el
            @
        renderSingleItemPrevView: (event) ->
            @currentModel = @collection.findPrev @currentModel
            @singleView.render @currentModel
        renderSingleItemNextView: (event) ->
            @currentModel = @collection.findNext @currentModel
            @singleView.render @currentModel
        renderSpecificEditView: (model) ->
            @itemControllerView.renderSpecificEditView @currentModel
        renderSpecificDeleteView: ->
            @deleteView =  new ConfirmDeleteModal
                model: @currentModel
                template: @deleteModalTemplate
            $("#root-backbone-view-body").append @deleteView.render().el
            $("#delete-customer-modal").modal 'show'
    # Single Item View Section
    class ItemLayoutView extends Backbone.View
        initialize: ->
            @template = _.template ($ @options.template).html()
            @singleContentTemplate = @options.singleContentTemplate
            @currentModelView = null
        render: (currentModel) ->
            @$el.html this.template({})
            @renderSingleContent(currentModel)
            @
        renderSingleContent: (currentModel) ->
            @currentModelView = new ItemContentView
                template: @singleContentTemplate
            @$('#single-item-view-content')
                .html @currentModelView.render(currentModel).el
    class ItemContentView extends Backbone.View
        className: 'container-fluid'
        initialize: ->
            @template = _.template ($ @options.template).html()
        render: (currentModel) ->
            @$el.html this.template(currentModel.attributes)
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
            $("#root-backbone-view-body").html @itemCreateBodyView.render().el
            @
    class ItemCreateBodyView extends Backbone.View
        events:
            "click #create-new-item-button": "checkValidityAndCreateNewItem"
        initialize: ->
            @template = _.template ($ @options.template).html()
            @formRules = @options.formRules
            @isValidMongoEntryFunction = @options.isValidMongoEntryFunction
            @commitFormSubmitFunction = @options.commitFormSubmitFunction
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
    @app = window.app ? {}
    @app.AlertView = AlertView
    @app.GenericListView = GenericListView
    @app.GenericSingleView = GenericSingleView
    @app.GenericCreateView = GenericCreateView
