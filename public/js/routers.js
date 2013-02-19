// Generated by CoffeeScript 1.4.0
(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.app = (_ref = window.app) != null ? _ref : {};

  jQuery(function() {
    var GoferRouter;
    GoferRouter = (function(_super) {

      __extends(GoferRouter, _super);

      function GoferRouter() {
        return GoferRouter.__super__.constructor.apply(this, arguments);
      }

      GoferRouter.prototype.routes = {
        '': 'dashboard',
        'inventory': 'inventory'
      };

      GoferRouter.prototype.initialize = function() {
        app.Products.fetch();
        return app.appControllerView = new app.AppControllerView({
          inventoryControllerView: new app.InventoryControllerView
        });
      };

      GoferRouter.prototype.dashboard = function() {};

      GoferRouter.prototype.inventory = function() {
        return app.appView.inventoryRender();
      };

      return GoferRouter;

    })(Backbone.Router);
    this.app.GoferRouter = GoferRouter;
    this.app.router = new app.GoferRouter;
    return Backbone.history.start();
  });

}).call(this);
