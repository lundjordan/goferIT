# Alert View

jQuery ->
    class AlertView extends Backbone.View
        initialize: ->
            @template = _.template ($ "#alert-message-#{@options.alertType}").html()
        render: (alertType, message) ->
            @$el.html this.template
                alertType: alertType
                message: message
            @


    # ###############
    # Items List View Section
    class GenericListView extends Backbone.View
        template: _.template ($ '#root-backbone-content-template').html()
        events:
            'change #store-name-select': 'renderItemsTable'
        initialize: ->
            @el = @options.el
            if @options.storeSelectView
                @storeSelectView = new @options.storeSelectView()
            @itemsTable = new ItemsTable
                collection: @options.collection
                template: @options.tableTemplate
                tableListID: @options.tableListID
                itemTrTemplate: @options.itemTrTemplate
                itemControllerView: @options.itemControllerView
        render: ->
            @$el.html this.template({})
            if @storeSelectView
                $("#root-backbone-view-head").html @storeSelectView.render().el
            $("#root-backbone-view-body").html @itemsTable.render().el
        renderItemsTable: ->
            if @storeSelectView
                @itemsTable.render()
    class ItemsTable extends Backbone.View
        initialize: ->
            @template = _.template ($ @options.template).html()
            @tableListID = @options.tableListID
            @itemTrTemplate = @options.itemTrTemplate
            @itemControllerView = @options.itemControllerView
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
                    (@$ @tableListID).append view.render().el
            else
                view = new SingleListItemView
                    model: item
                    template: @itemTrTemplate
                    itemControllerView: @itemControllerView
                (@$ @tableListID).append view.render().el

        addAll: ->
            @collection.each @addOne, @
    class SingleListItemView extends Backbone.View
        tagName: 'tr'
        events:
            'mouseover': 'showItemOptions'
            'mouseout': 'hideItemOptions'
            'click #item-view-eye-link': 'renderSpecificItemView'
        initialize: ->
            @template = _.template ($ @options.template).html()
            @itemView = @options.itemView 
            @itemControllerView = @options.itemControllerView
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
    # ###############

    # ###############
    # Single Item View Section
    class GenericSingleView extends Backbone.View
        template: _.template ($ '#root-backbone-content-template').html()
        events:
            'click #single-item-prev-link': 'renderSingleItemPrevView'
            'click #single-item-next-link': 'renderSingleItemNextView'
        initialize: (options) ->
            @el = @options.el
            # @storeSelectView = new SinglesListStoreSelectView()
            @singleView =  new ItemLayoutView
                template: @options.singleLayoutTemplate
                singleContentTemplate: @options.singleContentTemplate
        render: (currentModel) ->
            @currentModel = currentModel
            @$el.html this.template({})
            # @$("#root-backbone-view-head").html @storeSelectView.render().el
            # @storeSelectView.render()
            $("#root-backbone-view-body").html @singleView.render(@currentModel).el
        renderSingleItemPrevView: (event) ->
            @currentModel = @collection.findPrev @currentModel
            @singleView.render @currentModel
        renderSingleItemNextView: (event) ->
            @currentModel = @collection.findNext @currentModel
            @singleView.render @currentModel
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
            @el = @options.el
            @itemCreateBodyView = new ItemCreateBodyView
                template: @options.createFormTemplate
                formRules: @options.formRules
                isUniqueItemFunction: @options.isUniqueItemFunction
                createNewItemFunction: @options.createNewItemFunction
        render: ->
            @$el.html this.template({})
            $("#root-backbone-view-body").html @itemCreateBodyView.render().el
    class ItemCreateBodyView extends Backbone.View
        events:
            "click #create-new-item-button": "checkValidityAndCreateNewItem"
        initialize: ->
            @template = _.template ($ @options.template).html()
            @formRules = @options.formRules
            @isUniqueItem = @options.isUniqueItemFunction
            @createNewItem = @options.createNewItemFunction
        render: ->
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
                if @isUniqueItem()
                    return @createNewItem()
            return




    # ###############
    @app = window.app ? {}
    @app.AlertView = AlertView
    @app.GenericListView = GenericListView
    @app.GenericSingleView = GenericSingleView
    @app.GenericCreateView = GenericCreateView
