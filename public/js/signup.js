// Generated by CoffeeScript 1.3.3

($(document)).ready(function(response) {
    window.setTimeout(function() {
      $("#demo-button").popover("show");
    }, 2000);
  $("#demo-button").click(function() {
    $("#username").val("nadroj@gmail.com");
    $("#password").val("password");
    $("#login-button").click();
  });
  $.validator.addMethod("uniqueEmail", (function(value, element) {
    response = void 0;
    $.ajax({
      type: "POST",
      url: '/uniqueEmail',
      data: "email=" + value,
      async: false,
      success: function(data) {
        return response = data;
      }
    });
    if (response === true) {
      return true;
    } else if (response === false) {
      return false;
    } else {
      if (response === 'logout') {
        return false;
      }
    }
  }), "Email is already taken");
  ($('#register-form')).validate({
    rules: {
      email: {
        required: true,
        email: true,
        uniqueEmail: true
      },
      password: {
        minlength: 6,
        required: true
      },
      password2: {
        minlength: 6,
        required: true,
        equalTo: "#inputPassword"
      },
      fullName: {
        minlength: 2,
        required: true
      },
      companyName: {
        minlength: 2,
        required: true
      }
    },
    errorElement: "span",
    errorClass: "help-block",
    highlight: function(input) {
      return ($(input)).closest(".control-group").addClass("error").removeClass("success");
    },
    success: function(span) {
      return ($(span)).closest(".control-group").addClass("success");
    }
  });
  return ($('#signupConfirm')).on('click', function(e) {
    e.preventDefault();
    return ($('#register-form')).submit();
  });
});
