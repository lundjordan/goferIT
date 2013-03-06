jQuery ->
    $.validator.addMethod "decimalTwo", (value, element) ->
          this.optional(element) || /^(\d{1,3})(\.\d{2})$/.test(value)
    , "Must be in currency format 0.99"

    _.extend Backbone.View.prototype,
        validateForm: (form, rules) ->
            form.validate
                errorElement: "span"
                errorClass: "help-block"
                highlight: (input) ->
                    ($(input)).closest(".control-group").addClass("error")
                        .removeClass("success")
                success: (span) ->
                    ($(span)).closest(".control-group").addClass "success"
                    span.text("OK!").addClass("success")
                        .closest(".control-group").addClass "success"
                rules: rules
