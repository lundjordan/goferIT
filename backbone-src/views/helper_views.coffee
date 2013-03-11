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
        events:
            'change #store-name-select': 'renderItemsTable'
        initialize: ->
            @el = @options.el
            @template = _.template ($ @options.template).html()
            if @options.storeSelectView
                @storeSelectView = new ItemsListStoreSelectView()
            @itemsTable = new ItemsTable
                collection: @options.collection
                template: @options.tableTemplate
                tableListID: @options.tableListID
                itemTrTemplate: @options.itemTrTemplate
        render: ->
            @$el.html this.template({})
            if @storeSelectView
                $("#item-view-head").html @storeSelectView.render().el
            $("#item-view-body").html @itemsTable.render().el
        renderItemsTable: ->
            if @storeSelectView
                @itemsTable.render()
    class ItemsTable extends Backbone.View
        initialize: ->
            @template = _.template ($ @options.template).html()
            @tableListID = @options.tableListID
            @itemTrTemplate = @options.itemTrTemplate
        render: ->
            @$el.html this.template({})
            @addAll()
            @
        addOne: (item) ->
            view = new ItemListItemView
                model: item
                template: @itemTrTemplate
            (@$ @tableListID).append view.render().el
        addAll: ->
            @collection.each @addOne, @
    class ItemListItemView extends Backbone.View
        tagName: 'tr'
        events:
            'mouseover': 'showItemOptions'
            'mouseout': 'hideItemOptions'
            'click #item-view-eye-link': 'renderItemItemView'
        initialize: ->
            @template = _.template ($ @options.template).html()
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
        renderItemItemView: ->
            # app.appControllerView.itemControllerView
            #     .renderItemSpecificItemView @model
    # ###############

    @app = window.app ? {}
    @app.AlertView = AlertView
    @app.ItemListView = ItemListView
