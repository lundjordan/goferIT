# Customer Views

jQuery ->
    class CustomerControllerView extends Backbone.View
        el: '#item-main-content'
        events:
            'click #customer-menu-pill': 'renderCustomersListView'
            'click #customer-list-tab': 'renderCustomersListView'
            # 'click #customer-item-tab': 'renderCustomerDefaultItemView'
            # 'click #customer-create-tab': 'renderCustomerCreateView'
        initialize: ->
            @currentView = null
        renderCustomersListView: ->
            if @currentView
                @currentView.$el.html("")
            @currentView = new app.ItemListView
                collection: app.Customers
                el: "#customers-list-view-content"
                template: "#item-content-template"
                tableTemplate: '#customers-table-template'
                tableListID: '#customers-table-list'
                itemTrTemplate: '#customer-tr-template'
            @currentView.render()
        # renderCustomerDefaultItemView: ->
        #     if @currentView
        #         @currentView.$el.html("")
        #     @currentView = new CustomerItemView()
        #     @currentView.render app.Customers.models[0]
        # renderCustomerSpecificItemView: (model) ->
        #     if @currentView
        #         @currentView.$el.html("")
        #     # $('#customer-list-tab').removeClass('active')
        #     # $('#customer-item-tab').addClass('active')
        #     $('#customer-item-tab a').tab('show')
        #     @currentView = new CustomerItemView()
        #     @currentView.render model
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
