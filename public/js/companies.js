// Generated by CoffeeScript 1.4.0
(function() {
  var Companies, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Companies = (function(_super) {

    __extends(Companies, _super);

    function Companies() {
      return Companies.__super__.constructor.apply(this, arguments);
    }

    Companies.prototype.model = app.Company;

    Companies.prototype.url = '/companies';

    return Companies;

  })(Backbone.Collection);

  this.app = (_ref = window.app) != null ? _ref : {};

  this.app.Companies = new Companies;

}).call(this);