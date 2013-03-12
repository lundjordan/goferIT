# Customer Views

jQuery ->
    class CustomerControllerView extends Backbone.View
        el: '#people-main-content'
        events:
            'click #customer-menu-pill': 'renderCustomersListView'
            'click #customers-list-tab': 'renderCustomersListView'
            'click #customer-item-tab': 'renderCustomerDefaultItemView'
            # 'click #customer-create-tab': 'renderCustomerCreateView'
        initialize: ->
            @currentView = null
        renderCustomersListView: ->
            if @currentView
                @currentView.$el.html("")
            @currentView = new app.ItemListView
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
            @currentView = new app.ItemView
                collection: app.Customers
                el: "#customer-item-view-content"
                singleLayoutTemplate: "#single-item-view-template"
                singleContentTemplate: "#customer-view-content-template"
            @currentView.render app.Customers.models[0]
        renderSpecificItemView: (model) ->
            console.log "made it here"
            if @currentView
                @currentView.$el.html("")
            $('#customer-item-tab a').tab('show')
            @currentView = new app.ItemView
                collection: app.Customers
                el: "#customer-item-view-content"
                singleLayoutTemplate: "#single-item-view-template"
                singleContentTemplate: "#customer-view-content-template"
            @currentView.render model
        # renderCustomerCreateView: ->
        #     if @currentView
        #         @currentView.$el.html("")
        #     @currentView = new CustomerCreateView()
        #     @currentView.render()

    # # ###############
    # Customers List View Section
    # -> comes from ItemListVIew in # helper_views.coffee
    # ###############

    # ###############

    @app = window.app ? {}
    @app.CustomerControllerView = CustomerControllerView
