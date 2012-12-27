($ document).ready (response) ->

    jQuery.validator.addMethod "uniqueMobile", ((value, element) ->
        response = undefined
        $.ajax
            type: "POST",
            url: '/uniqueEmail'
            data:"email=#{value}"
            async: false,
            success: (data) ->
                response = data
        if response is 0
            true
        else if response is 1
            false
        else false if response is 'logout'
    ), "Email is Already Taken"

    ($ '#register-form').validate(
        rules:
            email:
                required: true
                email: true
            password:
                minlength: 6
                required: true
            password2:
                minlength: 6
                required: true
                equalTo: "#inputPassword"
            fullName:
                minlength: 2
                required: true
            companyName:
                minlength: 2
                required: true
        highlight: (label) ->
            ($ label).closest('.control-group').addClass('error')
        success: (label) ->
            label
                .text('OK!').addClass('valid')
                .closest('.control-group').addClass('success'))

    ($ '#signupConfirm').on 'click', (e) ->
        e.preventDefault()
        ($ '#register-form').submit()

    # ($ '#register-modal').modal(
    #     backdrop: 'static',
    #     keyboard: 'true')

    # ($ '#register').modal 'toggle'

