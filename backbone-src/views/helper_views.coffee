# Alert View

jQuery ->
    class AlertView extends Backbone.View
        template: _.template ($ '#alert-message-warning').html()
        render: (alertType, message) ->
            @$el.html this.template
                alertType: alertType
                message: message
            @

    @app = window.app ? {}
    @app.AlertView = AlertView
