# Alert View

jQuery ->
    class AlertView extends Backbone.View
        template: _.template ($ '#alert-message-warning').html()
        render: (alertType, message) ->
            @$el.html this.template
                alertType: alertType
                message: message
            @

    # ###############
    # Items List View Section
    class ItemListView extends Backbone.View
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
            view = new ItemListItemView
                model: item
                template: @itemTrTemplate
                itemControllerView: @itemControllerView
            (@$ @tableListID).append view.render().el
        addAll: ->
            @collection.each @addOne, @
    class ItemListItemView extends Backbone.View
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
            console.log "made it to  renderSpecificItemView"
            @itemControllerView.renderSpecificItemView @model
    # ###############

    # ###############
    # Single Item View Section
    class ItemView extends Backbone.View
        template: _.template ($ '#root-backbone-content-template').html()
        events:
            'click #single-item-prev-link': 'renderSingleItemPrevView'
            'click #single-item-next-link': 'renderSingleItemNextView'
        initialize: (options) ->
            @el = @options.el
            # @storeSelectView = new SinglesListStoreSelectView()
            @singleView =  new ItemBodyView
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
    class ItemBodyView extends Backbone.View
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

    @app = window.app ? {}
    @app.AlertView = AlertView
    @app.ItemListView = ItemListView
    @app.ItemView = ItemView
