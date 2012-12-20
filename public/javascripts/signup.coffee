($ document).ready (response) ->
    ($ '#register-modal').modal(
        backdrop: 'static',
        keyboard: 'true')

    ($ '#register').modal 'toggle'

    ($ '#signupConfirm').on 'click', (e) ->
        ($ '#register-form').submit()
