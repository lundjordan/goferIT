// Generated by CoffeeScript 1.4.0
(function() {
  var Company, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Company = (function(_super) {

    __extends(Company, _super);

    function Company() {
      return Company.__super__.constructor.apply(this, arguments);
    }

    Company.prototype.idAttribute = "_id";

    return Company;

  })(Backbone.Model);

  this.app = (_ref = window.app) != null ? _ref : {};

  this.app.Company = Company;

}).call(this);
