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
            @companyContentView = new CompanyContentView
                model: @model
        render: ->
            @$el.html this.template({})
            @$("#root-backbone-view-body").
                html @companyContentView.render(@model).el
            @
    class CompanyContentView extends Backbone.View
        template: _.template ($ '#company-content-template').html()
        events:
            'click #upgrade-btn': 'showUpgradeModal'
            'click #store-btn': 'addNewStore'
            'click #store-cancel-btn': 'cancelStoreAdd'
            'click #tax-btn': 'changeTaxRate'
            'click #tax-cancel-btn': 'cancelTaxChange'
            'change #new-store-input': 'toggleStoreButton'
            'keyup #new-store-input': 'toggleStoreButton'
            'change #tax-rate-input': 'toggleTaxButton'
            'keyup #tax-rate-input': 'toggleTaxButton'
        toggleTaxButton: (e) ->
            targ = $(e.target).val()
            hasFocus = $(e.target).is(":focus")
            valid = (hasFocus or targ.length) and
                targ isnt (@model.get 'taxRate').toString()
            if valid
                $("#tax-btn").removeAttr('disabled')
            else
                @cancelTaxChange()
        cancelTaxChange: ->
                $("#tax-btn").attr 'disabled','disabled'
                $("#tax-rate-input").val @model.get 'taxRate'
        changeTaxRate: ->
            newValue = parseFloat($("#tax-rate-input").val())
            if 100 >= newValue >= 0
                @model.save
                    taxRate: newValue
                @alertTaxRateChangeSaved()
            else
                @alertTaxRateNotValid()
                @cancelTaxChange()
        toggleStoreButton: ->
            if $("#new-store-input").val().length
                $("#store-btn").removeAttr('disabled')
            else
                $("#store-btn").attr 'disabled','disabled'
        cancelStoreAdd: ->
            $("#store-btn").attr 'disabled','disabled'
            $("#new-store-input").val("")
        addNewStore: ->
            newStore= {name: $("#new-store-input").val()}
            currentStores = @model.get 'stores'
            currentStores.push newStore
            console.log currentStores
            @model.save
                stores: currentStores
            @render()
            @alertNewStoreAdded()
        showUpgradeModal: ->
            console.log 'made it here'
            upgradeModal = new TrialUpgradeModal()
            @$el.append upgradeModal.render().el
            @$("#upgrade-modal").modal 'show'
            $('#upgrade-modal').on 'hidden', ->
                upgradeModal.remove()
        render: ->
            totalsAttrs =
                custTotal: app.Customers.length
                empTotal: app.Employees.length
                suppliersTotal: app.Suppliers.length
                productsTotal: app.Products.length
            tmlAttrs = _.extend totalsAttrs, @model.attributes
            @$el.html this.template tmlAttrs
            @addStores()
            @
        addStores: ->
            _.each @model.get("stores"), @addStore, @
        addStore: (store) ->
            tdHTML = "<tr><td> #{store.name} </td></tr>"
            @$("#stores-table-body").prepend tdHTML
        alertNewStoreAdded: ->
            message = "New Store Added"
            alertWarningView = new app.AlertView
                alertType: 'success'
            alertHTML = alertWarningView.render("alert-success", message).el
            $("#root-backbone-alert-view").html(alertHTML)
        alertTaxRateChangeSaved: ->
            message = "Tax changes saved."
            alertWarningView = new app.AlertView
                alertType: 'success'
            alertHTML = alertWarningView.render("alert-success", message).el
            $("#root-backbone-alert-view").html(alertHTML)
        alertTaxRateNotValid: ->
            message = "Tax rates must be in percentage between 0 and 100."
            alertWarningView = new app.AlertView
                alertType: 'warning'
            alertHTML = alertWarningView.render("alert-error", message).el
            $("#root-backbone-alert-view").html(alertHTML)

    class TrialUpgradeModal extends Backbone.View
        events:
            "click #close-upgrade-modal": "closeModal"
        template: _.template ($ '#trial-upgrade-template').html()
        render: ->
            @$el.html @template({})
            @
        closeModal: ->
            $("#upgrade-modal").modal 'hide'



    @app = window.app ? {}
    @app.CompanyProfileControllerView = CompanyProfileControllerView
