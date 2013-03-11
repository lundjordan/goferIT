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

      CustomerControllerView.prototype.el = '#item-main-content';

      CustomerControllerView.prototype.events = {
        'click #customer-menu-pill': 'renderCustomersListView',
        'click #customer-list-tab': 'renderCustomersListView'
      };

      CustomerControllerView.prototype.initialize = function() {
        return this.currentView = null;
      };

      CustomerControllerView.prototype.renderCustomersListView = function() {
        if (this.currentView) {
          this.currentView.$el.html("");
        }
        this.currentView = new app.ItemListView({
          collection: app.Customers,
          el: "#customers-list-view-content",
          template: "#root-backbone-content-template",
          tableTemplate: '#customers-table-template',
          tableListID: '#customers-table-list',
          itemTrTemplate: '#customer-tr-template'
        });
        return this.currentView.render();
      };

      return CustomerControllerView;

    })(Backbone.View);
    this.app = (_ref = window.app) != null ? _ref : {};
    return this.app.CustomerControllerView = CustomerControllerView;
  });

}).call(this);
