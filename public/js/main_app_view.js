// Generated by CoffeeScript 1.4.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQuery(function() {
    var AppControllerView, InventoryControllerView, POSControllerView, PeopleControllerView, _ref;
    AppControllerView = (function(_super) {

      __extends(AppControllerView, _super);

      function AppControllerView() {
        return AppControllerView.__super__.constructor.apply(this, arguments);
      }

      AppControllerView.prototype.el = '#main';

      AppControllerView.prototype.events = {
        'click #dashboard-link': "dashboardRender",
        'click #inventory-link': "inventoryRender",
        'click #people-link': "peopleRender",
        'click #pos-link': "posRender"
      };

      AppControllerView.prototype.initialize = function() {
        this.inventoryControllerView = this.options.inventoryControllerView;
        this.peopleControllerView = this.options.peopleControllerView;
        this.posControllerView = this.options.posControllerView;
        return this.currentMenuView = this.inventoryControllerView;
      };

      AppControllerView.prototype.inventoryRender = function() {
        this.currentMenuView.removeCurrentContentView();
        $('#product-menu-pill a').tab('show');
        $('#products-list-tab a').tab('show');
        this.currentMenuView = this.inventoryControllerView;
        return this.currentMenuView.renderProductsInitView();
      };

      AppControllerView.prototype.peopleRender = function() {
        this.currentMenuView.removeCurrentContentView();
        $('#customers-menu-pill a').tab('show');
        $('#customers-list-tab a').tab('show');
        this.currentMenuView = this.peopleControllerView;
        return this.currentMenuView.renderCustomersInitView();
      };

      AppControllerView.prototype.posRender = function() {
        this.currentMenuView.removeCurrentContentView();
        this.currentMenuView = this.posControllerView;
        return this.currentMenuView.renderPOSInitView();
      };

      AppControllerView.prototype.dashboardRender = function() {
        return this.currentMenuView = this.inventoryControllerView;
      };

      return AppControllerView;

    })(Backbone.View);
    POSControllerView = (function(_super) {

      __extends(POSControllerView, _super);

      function POSControllerView() {
        return POSControllerView.__super__.constructor.apply(this, arguments);
      }

      POSControllerView.prototype.el = '#sales-main-content';

      POSControllerView.prototype.initialize = function() {
        this.salesControllerView = this.options.salesControllerView;
        return this.currentPOSView = this.salesControllerView;
      };

      POSControllerView.prototype.renderPOSInitView = function() {
        this.currentPOSView = this.salesControllerView;
        return this.currentPOSView.renderInitSalesConstructView();
      };

      POSControllerView.prototype.removeCurrentContentView = function() {
        return this.currentPOSView.removeCurrentContentView();
      };

      return POSControllerView;

    })(Backbone.View);
    PeopleControllerView = (function(_super) {

      __extends(PeopleControllerView, _super);

      function PeopleControllerView() {
        return PeopleControllerView.__super__.constructor.apply(this, arguments);
      }

      PeopleControllerView.prototype.el = '#people-main-content';

      PeopleControllerView.prototype.events = {
        'click #customers-menu-pill': 'renderCustomersInitView',
        'click #employees-menu-pill': 'renderEmployeesInitView',
        'click #suppliers-menu-pill': 'renderSuppliersInitView'
      };

      PeopleControllerView.prototype.initialize = function() {
        this.customerControllerView = this.options.customerControllerView;
        this.employeeControllerView = this.options.employeeControllerView;
        this.supplierControllerView = this.options.supplierControllerView;
        return this.currentPeopleView = this.customerControllerView;
      };

      PeopleControllerView.prototype.renderCustomersInitView = function() {
        this.currentPeopleView.removeCurrentContentView();
        this.currentPeopleView = this.customerControllerView;
        $('#customers-list-tab a').tab('show');
        return this.currentPeopleView.renderCustomersListView();
      };

      PeopleControllerView.prototype.renderEmployeesInitView = function() {
        this.currentPeopleView.removeCurrentContentView();
        this.currentPeopleView = this.employeeControllerView;
        $('#employees-list-tab a').tab('show');
        return this.currentPeopleView.renderEmployeesListView();
      };

      PeopleControllerView.prototype.renderSuppliersInitView = function() {
        this.currentPeopleView.removeCurrentContentView();
        this.currentPeopleView = this.supplierControllerView;
        $('#suppliers-list-tab a').tab('show');
        return this.currentPeopleView.renderSuppliersListView();
      };

      PeopleControllerView.prototype.removeCurrentContentView = function() {
        return this.currentPeopleView.removeCurrentContentView();
      };

      return PeopleControllerView;

    })(Backbone.View);
    InventoryControllerView = (function(_super) {

      __extends(InventoryControllerView, _super);

      function InventoryControllerView() {
        return InventoryControllerView.__super__.constructor.apply(this, arguments);
      }

      InventoryControllerView.prototype.el = '#inventory-main-content';

      InventoryControllerView.prototype.events = {
        'click #product-menu-pill': 'renderProductsInitView',
        'click #order-menu-pill': 'renderOrderInitView'
      };

      InventoryControllerView.prototype.initialize = function() {
        this.productControllerView = this.options.productControllerView;
        this.orderControllerView = this.options.orderControllerView;
        return this.currentInventoryView = this.productControllerView;
      };

      InventoryControllerView.prototype.renderProductsInitView = function() {
        this.currentInventoryView.removeCurrentContentView();
        this.currentInventoryView = this.productControllerView;
        $('#products-list-tab a').tab('show');
        return this.currentInventoryView.renderProductsListView();
      };

      InventoryControllerView.prototype.renderOrderInitView = function() {
        this.currentInventoryView.removeCurrentContentView();
        this.currentInventoryView = this.orderControllerView;
        $('#orders-list-tab a').tab('show');
        return this.currentInventoryView.renderOrdersListView();
      };

      InventoryControllerView.prototype.removeCurrentContentView = function() {
        return this.currentInventoryView.removeCurrentContentView();
      };

      return InventoryControllerView;

    })(Backbone.View);
    this.app = (_ref = window.app) != null ? _ref : {};
    this.app.AppControllerView = AppControllerView;
    this.app.InventoryControllerView = InventoryControllerView;
    this.app.PeopleControllerView = PeopleControllerView;
    return this.app.POSControllerView = POSControllerView;
  });

}).call(this);
