# Customer Views

jQuery ->

    class CompanyProfileControllerView extends Backbone.View
        el: '#company-main-view'
        initialize: ->
            @currentView = null
        renderCompanyProfileView: ->
            @removeCurrentContentView()
            @currentView = new CompanyLayoutView
                model: app.Companies.at(0)
            @$el.html @currentView.render().el
        # helpers
        removeCurrentContentView: ->
            if @currentView
                @currentView.remove()

    class CompanyLayoutView extends Backbone.View
        template: _.template ($ '#root-backbone-content-template').html()
        initialize: (options) ->
            @companyContentView = new CompanyContentView()
        render: ->
            @$el.html this.template({})
            @$("#root-backbone-view-body").
                html @companyContentView.render(@model).el
            @
    class CompanyContentView extends Backbone.View
        template: _.template ($ '#company-content-template').html()
        # events:
        #     'click #upgrade-btn': 'showUpgradeModal'
        #     'click #store-btn': 'addStore'
        #     'click #tax-btn': 'changeTaxRate'
        render: (model) ->
            @$el.html this.template(model.attributes)
            storeSelectView = new app.StoreSelectView()
            storeSelectView.template =
                _.template ($ '#product-create-store-names-template').html()
            @$("#store-names-div").html storeSelectView.render().el
            @

    @app = window.app ? {}
    @app.CompanyProfileControllerView = CompanyProfileControllerView
