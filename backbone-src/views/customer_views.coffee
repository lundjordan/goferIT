# Customer Views

jQuery ->
    class CustomerControllerView extends Backbone.View
        el: '#customer-main-content'
        events:
            'click #customer-menu-pill': 'renderCustomersListView'
            'click #customer-list-tab': 'renderCustomersListView'
            'click #customer-item-tab': 'renderCustomerDefaultItemView'
            'click #customer-create-tab': 'renderCustomerCreateView'
            'click #order-menu-pill': 'renderOrderListView'
        initialize: ->
            @currentView = null
        renderCustomersListView: ->
            if @currentView
                @currentView.$el.html("")
            @currentView = new CustomersListView()
            @currentView.render()
        renderCustomerDefaultItemView: ->
            if @currentView
                @currentView.$el.html("")
            @currentView = new CustomerItemView()
            @currentView.render app.Customers.models[0]
        renderCustomerSpecificItemView: (model) ->
            if @currentView
                @currentView.$el.html("")
            # $('#customer-list-tab').removeClass('active')
            # $('#customer-item-tab').addClass('active')
            $('#customer-item-tab a').tab('show')
            @currentView = new CustomerItemView()
            @currentView.render model
        renderCustomerCreateView: ->
            if @currentView
                @currentView.$el.html("")
            @currentView = new CustomerCreateView()
            @currentView.render()
        renderOrderListView: ->
            if @currentView
                @currentView.$el.html("")
            @currentView = new OrderListView()
            @currentView.render()

    # ###############
    # Customers List View Section
    class CustomersListView extends Backbone.View
        el: '#customers-list-view-content'
        events:
            'change #store-name-select': 'renderCustomersTable'
        template: _.template ($ '#customer-content-template').html()
        initialize: (options) ->
            @storeSelectView = new CustomersListStoreSelectView()
            @customersTable = new CustomersTable()
        render: ->
            @$el.html this.template({})
            $("#customer-view-head").html @storeSelectView.render().el
            $("#customer-view-body").html @customersTable.render().el
        renderCustomersTable: ->
            @customersTable.render()
    # Customers List View Section
    class CustomersTable extends Backbone.View
        # el: '#customers-view-body'
        template: _.template ($ '#customers-table-template').html()
        render: ->
            @$el.html this.template({})
            @addAll()
            @
        addOne: (customer) ->
            if $('#store-name-select').val() is customer.get('storeName')
                view = new CustomerListItemView model: customer
                (@$ "#customers-table-list").append view.render().el
        addAll: ->
            app.Customers.each @addOne, @
    # Customers List View Section
    class CustomerListItemView extends Backbone.View
        tagName: 'tr'
        events:
            'mouseover': 'showCustomerOptions'
            'mouseout': 'hideCustomerOptions'
            'click #customer-view-eye-link': 'renderCustomerItemView'
        template: _.template ($ '#customer-tr-template').html()
        render: ->
            @$el.html this.template @model.attributes
            $(@el).find('i').hide()
            @
        showCustomerOptions: (event) ->
            # $('#item-options').prepend("<i class='icon-search'></i>")
            $(@el).find('i').show()
        hideCustomerOptions: (event) ->
            # $('#item-options').html()
            $(@el).find('i').hide()
        renderCustomerItemView: ->
            app.appControllerView.customerControllerView
                .renderCustomerSpecificItemView @model
    # ###############

    @app = window.app ? {}
    @app.CustomerControllerView = CustomerControllerView
