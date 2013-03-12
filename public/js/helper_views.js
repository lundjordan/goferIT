// Generated by CoffeeScript 1.4.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQuery(function() {
    var AlertView, ItemBodyView, ItemContentView, ItemListItemView, ItemListView, ItemView, ItemsTable, _ref;
    AlertView = (function(_super) {

      __extends(AlertView, _super);

      function AlertView() {
        return AlertView.__super__.constructor.apply(this, arguments);
      }

      AlertView.prototype.template = _.template(($('#alert-message-warning')).html());

      AlertView.prototype.render = function(alertType, message) {
        this.$el.html(this.template({
          alertType: alertType,
          message: message
        }));
        return this;
      };

      return AlertView;

    })(Backbone.View);
    ItemListView = (function(_super) {

      __extends(ItemListView, _super);

      function ItemListView() {
        return ItemListView.__super__.constructor.apply(this, arguments);
      }

      ItemListView.prototype.template = _.template(($('#root-backbone-content-template')).html());

      ItemListView.prototype.events = {
        'change #store-name-select': 'renderItemsTable'
      };

      ItemListView.prototype.initialize = function() {
        this.el = this.options.el;
        if (this.options.storeSelectView) {
          this.storeSelectView = new this.options.storeSelectView();
        }
        return this.itemsTable = new ItemsTable({
          collection: this.options.collection,
          template: this.options.tableTemplate,
          tableListID: this.options.tableListID,
          itemTrTemplate: this.options.itemTrTemplate,
          itemControllerView: this.options.itemControllerView
        });
      };

      ItemListView.prototype.render = function() {
        this.$el.html(this.template({}));
        if (this.storeSelectView) {
          $("#root-backbone-view-head").html(this.storeSelectView.render().el);
        }
        return $("#root-backbone-view-body").html(this.itemsTable.render().el);
      };

      ItemListView.prototype.renderItemsTable = function() {
        if (this.storeSelectView) {
          return this.itemsTable.render();
        }
      };

      return ItemListView;

    })(Backbone.View);
    ItemsTable = (function(_super) {

      __extends(ItemsTable, _super);

      function ItemsTable() {
        return ItemsTable.__super__.constructor.apply(this, arguments);
      }

      ItemsTable.prototype.initialize = function() {
        this.template = _.template(($(this.options.template)).html());
        this.tableListID = this.options.tableListID;
        this.itemTrTemplate = this.options.itemTrTemplate;
        return this.itemControllerView = this.options.itemControllerView;
      };

      ItemsTable.prototype.render = function() {
        this.$el.html(this.template({}));
        this.addAll();
        return this;
      };

      ItemsTable.prototype.addOne = function(item) {
        var view;
        view = new ItemListItemView({
          model: item,
          template: this.itemTrTemplate,
          itemControllerView: this.itemControllerView
        });
        return (this.$(this.tableListID)).append(view.render().el);
      };

      ItemsTable.prototype.addAll = function() {
        return this.collection.each(this.addOne, this);
      };

      return ItemsTable;

    })(Backbone.View);
    ItemListItemView = (function(_super) {

      __extends(ItemListItemView, _super);

      function ItemListItemView() {
        return ItemListItemView.__super__.constructor.apply(this, arguments);
      }

      ItemListItemView.prototype.tagName = 'tr';

      ItemListItemView.prototype.events = {
        'mouseover': 'showItemOptions',
        'mouseout': 'hideItemOptions',
        'click #item-view-eye-link': 'renderSpecificItemView'
      };

      ItemListItemView.prototype.initialize = function() {
        this.template = _.template(($(this.options.template)).html());
        this.itemView = this.options.itemView;
        return this.itemControllerView = this.options.itemControllerView;
      };

      ItemListItemView.prototype.render = function() {
        this.$el.html(this.template(this.model.attributes));
        $(this.el).find('i').hide();
        return this;
      };

      ItemListItemView.prototype.showItemOptions = function(event) {
        return $(this.el).find('i').show();
      };

      ItemListItemView.prototype.hideItemOptions = function(event) {
        return $(this.el).find('i').hide();
      };

      ItemListItemView.prototype.renderSpecificItemView = function() {
        console.log("made it to  renderSpecificItemView");
        return this.itemControllerView.renderSpecificItemView(this.model);
      };

      return ItemListItemView;

    })(Backbone.View);
    ItemView = (function(_super) {

      __extends(ItemView, _super);

      function ItemView() {
        return ItemView.__super__.constructor.apply(this, arguments);
      }

      ItemView.prototype.template = _.template(($('#root-backbone-content-template')).html());

      ItemView.prototype.events = {
        'click #single-item-prev-link': 'renderSingleItemPrevView',
        'click #single-item-next-link': 'renderSingleItemNextView'
      };

      ItemView.prototype.initialize = function(options) {
        this.el = this.options.el;
        return this.singleView = new ItemBodyView({
          template: this.options.singleLayoutTemplate,
          singleContentTemplate: this.options.singleContentTemplate
        });
      };

      ItemView.prototype.render = function(currentModel) {
        this.currentModel = currentModel;
        this.$el.html(this.template({}));
        return $("#root-backbone-view-body").html(this.singleView.render(this.currentModel).el);
      };

      ItemView.prototype.renderSingleItemPrevView = function(event) {
        this.currentModel = this.collection.findPrev(this.currentModel);
        return this.singleView.render(this.currentModel);
      };

      ItemView.prototype.renderSingleItemNextView = function(event) {
        this.currentModel = this.collection.findNext(this.currentModel);
        return this.singleView.render(this.currentModel);
      };

      return ItemView;

    })(Backbone.View);
    ItemBodyView = (function(_super) {

      __extends(ItemBodyView, _super);

      function ItemBodyView() {
        return ItemBodyView.__super__.constructor.apply(this, arguments);
      }

      ItemBodyView.prototype.initialize = function() {
        this.template = _.template(($(this.options.template)).html());
        this.singleContentTemplate = this.options.singleContentTemplate;
        return this.currentModelView = null;
      };

      ItemBodyView.prototype.render = function(currentModel) {
        this.$el.html(this.template({}));
        this.renderSingleContent(currentModel);
        return this;
      };

      ItemBodyView.prototype.renderSingleContent = function(currentModel) {
        this.currentModelView = new ItemContentView({
          template: this.singleContentTemplate
        });
        return this.$('#single-item-view-content').html(this.currentModelView.render(currentModel).el);
      };

      return ItemBodyView;

    })(Backbone.View);
    ItemContentView = (function(_super) {

      __extends(ItemContentView, _super);

      function ItemContentView() {
        return ItemContentView.__super__.constructor.apply(this, arguments);
      }

      ItemContentView.prototype.className = 'container-fluid';

      ItemContentView.prototype.initialize = function() {
        return this.template = _.template(($(this.options.template)).html());
      };

      ItemContentView.prototype.render = function(currentModel) {
        this.$el.html(this.template(currentModel.attributes));
        return this;
      };

      return ItemContentView;

    })(Backbone.View);
    this.app = (_ref = window.app) != null ? _ref : {};
    this.app.AlertView = AlertView;
    this.app.ItemListView = ItemListView;
    return this.app.ItemView = ItemView;
  });

}).call(this);
