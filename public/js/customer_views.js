// Generated by CoffeeScript 1.4.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQuery(function() {
    var CustomerControllerView, _ref;
    CustomerControllerView = (function(_super) {

      __extends(CustomerControllerView, _super);

      function CustomerControllerView() {
        return CustomerControllerView.__super__.constructor.apply(this, arguments);
      }

      CustomerControllerView.prototype.el = '#people-main-content';

      CustomerControllerView.prototype.events = {
        'click #customer-menu-pill': 'renderCustomersListView',
        'click #customers-list-tab': 'renderCustomersListView',
        'click #customer-item-tab': 'renderCustomerDefaultItemView',
        'click #customer-create-tab': 'renderCustomerCreateView'
      };

      CustomerControllerView.prototype.initialize = function() {
        return this.currentView = null;
      };

      CustomerControllerView.prototype.renderCustomersListView = function() {
        if (this.currentView) {
          this.currentView.$el.html("");
        }
        this.currentView = new app.GenericListView({
          collection: app.Customers,
          el: "#customers-list-view-content",
          tableTemplate: '#customers-table-template',
          tableListID: '#customers-table-list',
          itemTrTemplate: '#customer-tr-template',
          itemControllerView: this
        });
        return this.currentView.render();
      };

      CustomerControllerView.prototype.renderCustomerDefaultItemView = function() {
        if (this.currentView) {
          this.currentView.$el.html("");
        }
        this.currentView = new app.GenericSingleView({
          collection: app.Customers,
          el: "#customer-item-view-content",
          singleLayoutTemplate: "#single-item-view-template",
          singleContentTemplate: "#customer-view-content-template"
        });
        return this.currentView.render(app.Customers.models[0]);
      };

      CustomerControllerView.prototype.renderSpecificItemView = function(model) {
        if (this.currentView) {
          this.currentView.$el.html("");
        }
        $('#customer-item-tab a').tab('show');
        this.currentView = new app.GenericSingleView({
          collection: app.Customers,
          el: "#customer-item-view-content",
          singleLayoutTemplate: "#single-item-view-template",
          singleContentTemplate: "#customer-view-content-template"
        });
        return this.currentView.render(model);
      };

      CustomerControllerView.prototype.renderCustomerCreateView = function() {
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
          }
        });
        return this.currentView.render();
      };

      return CustomerControllerView;

    })(Backbone.View);
    this.app = (_ref = window.app) != null ? _ref : {};
    return this.app.CustomerControllerView = CustomerControllerView;
  });

}).call(this);
