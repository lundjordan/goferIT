// Generated by CoffeeScript 1.4.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQuery(function() {
    var CustomerControllerView, createNewCustomer, isUniqueCustomer, updateExistingCustomer, _ref;
    CustomerControllerView = (function(_super) {

      __extends(CustomerControllerView, _super);

      function CustomerControllerView() {
        return CustomerControllerView.__super__.constructor.apply(this, arguments);
      }

      CustomerControllerView.prototype.el = '#people-main-content';

      CustomerControllerView.prototype.events = {
        'click #customers-menu-pill': 'renderCustomersListView',
        'click #customers-list-tab': 'renderCustomersListView',
        'click #customer-item-tab': 'renderCustomerDefaultItemView',
        'click #customer-create-tab': 'renderCustomerCreateView'
      };

      CustomerControllerView.prototype.initialize = function() {
        return this.currentView = null;
      };

      CustomerControllerView.prototype.renderCustomersListView = function() {
        $("#root-backbone-view-head").remove();
        $("#root-backbone-view-body").remove();
        this.currentView = new app.GenericListView({
          collection: app.Customers,
          el: "#customers-list-view-content",
          tableTemplate: "#customers-table-template",
          tableListID: "#customers-table-list",
          itemTrTemplate: "#customer-tr-template",
          deleteModalTemplate: "#customer-view-delete-template",
          itemControllerView: this
        });
        return this.currentView.render();
      };

      CustomerControllerView.prototype.renderCustomerDefaultItemView = function() {
        $("#root-backbone-view-head").remove();
        $("#root-backbone-view-body").remove();
        this.currentView = new app.GenericSingleView({
          collection: app.Customers,
          el: "#customer-item-view-content",
          singleLayoutTemplate: "#single-item-view-template",
          singleContentTemplate: "#customer-view-content-template",
          deleteModalTemplate: "#customer-view-delete-template",
          itemControllerView: this
        });
        return this.currentView.render(app.Customers.models[0]);
      };

      CustomerControllerView.prototype.renderSpecificItemView = function(model) {
        $("#root-backbone-view-head").remove();
        $("#root-backbone-view-body").remove();
        $('#customer-item-tab a').tab('show');
        this.currentView = new app.GenericSingleView({
          collection: app.Customers,
          el: "#customer-item-view-content",
          singleLayoutTemplate: "#single-item-view-template",
          singleContentTemplate: "#customer-view-content-template",
          deleteModalTemplate: "#customer-view-delete-template",
          itemControllerView: this
        });
        return this.currentView.render(model);
      };

      CustomerControllerView.prototype.renderCustomerCreateView = function() {
        $("#root-backbone-view-head").remove();
        $("#root-backbone-view-body").remove();
        if (this.currentView) {
          this.currentView.$el.html("");
        }
        this.currentView = new app.GenericCreateView({
          el: "#customer-create-view-content",
          createFormTemplate: "#customer-create-template",
          formRules: {
            firstName: {
              required: true
            },
            lastName: {
              required: true
            },
            email: {
              required: true,
              email: true
            }
          },
          isValidMongoEntryFunction: isUniqueCustomer,
          commitFormSubmitFunction: createNewCustomer
        });
        return this.currentView.render();
      };

      CustomerControllerView.prototype.renderSpecificEditView = function(model) {
        $("#root-backbone-view-head").remove();
        $("#root-backbone-view-body").remove();
        $('#customer-create-tab a').tab('show');
        this.currentView = new app.GenericCreateView({
          model: model,
          el: "#customer-create-view-content",
          createFormTemplate: "#customer-edit-template",
          formRules: {
            firstName: {
              required: true
            },
            lastName: {
              required: true
            },
            email: {
              required: true,
              email: true
            }
          },
          isValidMongoEntryFunction: function() {
            return true;
          },
          commitFormSubmitFunction: updateExistingCustomer
        });
        return this.currentView.render();
      };

      return CustomerControllerView;

    })(Backbone.View);
    isUniqueCustomer = function() {
      var alertWarning, isUniqueItem, message;
      isUniqueItem = app.Customers.where({
        email: $('#email-input').val()
      }).length < 1;
      if (isUniqueItem) {
        return true;
      } else {
        message = "You already have a customer by this email.";
        alertWarning = new app.AlertView({
          alertType: 'warning'
        });
        $("#root-backbone-alert-view").html(alertWarning.render("alert-error", message).el);
        return false;
      }
    };
    createNewCustomer = function() {
      var alertWarning, customerModel, message;
      customerModel = {
        name: {
          first: $("#first-name-input").val(),
          last: $("#last-name-input").val()
        },
        email: $("#email-input").val(),
        phone: $("#phone-input").val(),
        address: {
          street: $("#address-input").val(),
          postalCode: $("#zip-input").val(),
          city: $("#city-input").val(),
          state: $("#state-select").val(),
          country: BFHCountriesList[$("#countries_input")]
        },
        dob: $("#dob-input").val(),
        sex: $('input[name=sexRadio]:checked').val()
      };
      app.Customers.create(customerModel);
      message = "You have added a new customer!";
      alertWarning = new app.AlertView({
        alertType: 'success'
      });
      return $("#root-backbone-alert-view").html(alertWarning.render("alert-success", message).el);
    };
    updateExistingCustomer = function() {
      var alertWarning, customerModel, message;
      customerModel = {
        name: {
          first: $("#first-name-input").val(),
          last: $("#last-name-input").val()
        },
        phone: $("#phone-input").val(),
        address: {
          street: $("#address-input").val(),
          postalCode: $("#zip-input").val(),
          city: $("#city-input").val(),
          state: $("#state-select").val(),
          country: BFHCountriesList[$("#countries_input")]
        },
        dob: $("#dob-input").val(),
        sex: $('input[name=sexRadio]:checked').val()
      };
      this.model.save(customerModel);
      message = "Your changes, if any, have been saved!";
      alertWarning = new app.AlertView({
        alertType: 'success'
      });
      return $("#root-backbone-alert-view").html(alertWarning.render("alert-success", message).el);
    };
    this.app = (_ref = window.app) != null ? _ref : {};
    return this.app.CustomerControllerView = CustomerControllerView;
  });

}).call(this);
