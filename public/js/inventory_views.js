// Generated by CoffeeScript 1.4.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQuery(function() {
    var InventoryControllerView, OrderListView, ProductCreateBodyView, ProductCreateView, ProductItemBodyView, ProductItemContentView, ProductItemSubQuantityView, ProductItemSupplierNameView, ProductItemView, ProductListItemView, ProductsListStoreSelectView, ProductsListView, ProductsTable, StoreSelectView, SupplierSelectView, _ref;
    InventoryControllerView = (function(_super) {

      __extends(InventoryControllerView, _super);

      function InventoryControllerView() {
        return InventoryControllerView.__super__.constructor.apply(this, arguments);
      }

      InventoryControllerView.prototype.el = '#inventory-main-content';

      InventoryControllerView.prototype.events = {
        'click #product-menu-pill': 'renderProductsListView',
        'click #inventory-list-tab': 'renderProductsListView',
        'click #inventory-item-tab': 'renderProductDefaultItemView',
        'click #inventory-create-tab': 'renderProductCreateView',
        'click #order-menu-pill': 'renderOrderListView'
      };

      InventoryControllerView.prototype.initialize = function() {
        return this.currentView = null;
      };

      InventoryControllerView.prototype.renderProductsListView = function() {
        if (this.currentView) {
          this.currentView.$el.html("");
        }
        this.currentView = new ProductsListView();
        return this.currentView.render();
      };

      InventoryControllerView.prototype.renderProductDefaultItemView = function() {
        if (this.currentView) {
          this.currentView.$el.html("");
        }
        this.currentView = new ProductItemView();
        return this.currentView.render(app.Products.models[0]);
      };

      InventoryControllerView.prototype.renderProductSpecificItemView = function(model) {
        if (this.currentView) {
          this.currentView.$el.html("");
        }
        this.currentView = new ProductItemView();
        return this.currentView.render(model);
      };

      InventoryControllerView.prototype.renderProductCreateView = function() {
        if (this.currentView) {
          this.currentView.$el.html("");
        }
        this.currentView = new ProductCreateView();
        return this.currentView.render();
      };

      InventoryControllerView.prototype.renderOrderListView = function() {
        if (this.currentView) {
          this.currentView.$el.html("");
        }
        this.currentView = new OrderListView();
        return this.currentView.render();
      };

      return InventoryControllerView;

    })(Backbone.View);
    StoreSelectView = (function(_super) {

      __extends(StoreSelectView, _super);

      function StoreSelectView() {
        return StoreSelectView.__super__.constructor.apply(this, arguments);
      }

      StoreSelectView.prototype.render = function() {
        var store, storeNames, _i, _len;
        this.$el.html(this.template({}));
        storeNames = app.Companies.models[0].get('stores');
        for (_i = 0, _len = storeNames.length; _i < _len; _i++) {
          store = storeNames[_i];
          this.addToSelect(store.name);
        }
        return this;
      };

      StoreSelectView.prototype.addToSelect = function(storeName) {
        return this.$('#store-name-select').append("<option>" + storeName + "</option>");
      };

      return StoreSelectView;

    })(Backbone.View);
    ProductsListStoreSelectView = (function(_super) {

      __extends(ProductsListStoreSelectView, _super);

      function ProductsListStoreSelectView() {
        return ProductsListStoreSelectView.__super__.constructor.apply(this, arguments);
      }

      ProductsListStoreSelectView.prototype.template = _.template(($('#store-names-template')).html());

      return ProductsListStoreSelectView;

    })(StoreSelectView);
    ProductItemSubQuantityView = (function(_super) {

      __extends(ProductItemSubQuantityView, _super);

      function ProductItemSubQuantityView() {
        return ProductItemSubQuantityView.__super__.constructor.apply(this, arguments);
      }

      ProductItemSubQuantityView.prototype.className = 'container-fluid';

      ProductItemSubQuantityView.prototype.template = _.template(($('#product-view-sub-quantity-template')).html());

      ProductItemSubQuantityView.prototype.render = function(productSubQuants) {
        var tableHeaderValues, tableRow1Values;
        this.$el.html(this.template({}));
        tableHeaderValues = "<th>" + productSubQuants[0].measurementName + "</th>";
        tableRow1Values = "<td>Totals</td>";
        _.each(productSubQuants, function(elem) {
          tableHeaderValues += "<th>" + elem.measurementValue + "</th>";
          return tableRow1Values += "<td>" + elem.quantity + "</td>";
        });
        this.$('#product-sub-quantity-thead-tr').append(tableHeaderValues);
        this.$('#product-sub-quantity-tbody-td').append(tableRow1Values);
        return this;
      };

      return ProductItemSubQuantityView;

    })(Backbone.View);
    ProductsListView = (function(_super) {

      __extends(ProductsListView, _super);

      function ProductsListView() {
        return ProductsListView.__super__.constructor.apply(this, arguments);
      }

      ProductsListView.prototype.el = '#products-list-view-content';

      ProductsListView.prototype.events = {
        'change #store-name-select': 'renderProductsTable'
      };

      ProductsListView.prototype.template = _.template(($('#inventory-content-template')).html());

      ProductsListView.prototype.initialize = function(options) {
        this.storeSelectView = new ProductsListStoreSelectView();
        return this.productsTable = new ProductsTable();
      };

      ProductsListView.prototype.render = function() {
        this.$el.html(this.template({}));
        $("#inventory-view-head").html(this.storeSelectView.render().el);
        return $("#inventory-view-body").html(this.productsTable.render().el);
      };

      ProductsListView.prototype.renderProductsTable = function() {
        return this.productsTable.render();
      };

      return ProductsListView;

    })(Backbone.View);
    ProductsTable = (function(_super) {

      __extends(ProductsTable, _super);

      function ProductsTable() {
        return ProductsTable.__super__.constructor.apply(this, arguments);
      }

      ProductsTable.prototype.template = _.template(($('#products-table-template')).html());

      ProductsTable.prototype.render = function() {
        this.$el.html(this.template({}));
        this.addAll();
        return this;
      };

      ProductsTable.prototype.addOne = function(product) {
        var view;
        if ($('#store-name-select').val() === product.get('storeName')) {
          view = new ProductListItemView({
            model: product
          });
          return (this.$("#products-table-list")).append(view.render().el);
        }
      };

      ProductsTable.prototype.addAll = function() {
        return app.Products.each(this.addOne, this);
      };

      return ProductsTable;

    })(Backbone.View);
    ProductListItemView = (function(_super) {

      __extends(ProductListItemView, _super);

      function ProductListItemView() {
        return ProductListItemView.__super__.constructor.apply(this, arguments);
      }

      ProductListItemView.prototype.tagName = 'tr';

      ProductListItemView.prototype.events = {
        'mouseover': 'showProductOptions',
        'mouseout': 'hideProductOptions',
        'click #product-view-eye-link': 'renderProductItemView'
      };

      ProductListItemView.prototype.template = _.template(($('#product-tr-template')).html());

      ProductListItemView.prototype.render = function() {
        this.$el.html(this.template(this.model.attributes));
        $(this.el).find('i').hide();
        return this;
      };

      ProductListItemView.prototype.showProductOptions = function(event) {
        return $(this.el).find('i').show();
      };

      ProductListItemView.prototype.hideProductOptions = function(event) {
        return $(this.el).find('i').hide();
      };

      ProductListItemView.prototype.renderProductItemView = function() {
        return app.appControllerView.inventoryControllerView.renderProductSpecificItemView(this.model);
      };

      return ProductListItemView;

    })(Backbone.View);
    ProductItemView = (function(_super) {

      __extends(ProductItemView, _super);

      function ProductItemView() {
        return ProductItemView.__super__.constructor.apply(this, arguments);
      }

      ProductItemView.prototype.el = '#product-item-view-content';

      ProductItemView.prototype.events = {
        'click #product-item-prev-link': 'renderProductItemPrevView',
        'click #product-item-next-link': 'renderProductItemNextView'
      };

      ProductItemView.prototype.template = _.template(($('#inventory-content-template')).html());

      ProductItemView.prototype.initialize = function(options) {
        return this.productView = new ProductItemBodyView();
      };

      ProductItemView.prototype.render = function(productModel) {
        this.model = productModel;
        this.$el.html(this.template({}));
        return $("#inventory-view-body").html(this.productView.render(this.model).el);
      };

      ProductItemView.prototype.renderProductItemPrevView = function(event) {
        this.model = app.Products.findPrev(this.model);
        return this.productView.render(this.model);
      };

      ProductItemView.prototype.renderProductItemNextView = function(event) {
        this.model = app.Products.findNext(this.model);
        return this.productView.render(this.model);
      };

      return ProductItemView;

    })(Backbone.View);
    ProductItemBodyView = (function(_super) {

      __extends(ProductItemBodyView, _super);

      function ProductItemBodyView() {
        return ProductItemBodyView.__super__.constructor.apply(this, arguments);
      }

      ProductItemBodyView.prototype.template = _.template(($('#product-view-template')).html());

      ProductItemBodyView.prototype.initialize = function() {
        return this.currentProduct = null;
      };

      ProductItemBodyView.prototype.render = function(productModel) {
        this.$el.html(this.template({}));
        this.renderProductContent(productModel);
        return this;
      };

      ProductItemBodyView.prototype.renderProductContent = function(productModel) {
        var productSubQuants;
        this.currentProduct = new ProductItemContentView();
        this.currentProductSupplier = new ProductItemSupplierNameView();
        this.currentProductItemSubQuantity = new ProductItemSubQuantityView();
        this.$('#product-view-content').html(this.currentProduct.render(productModel).el);
        this.$('#product-view-supplier-name').html(this.currentProductSupplier.render(productModel).el);
        if (productModel.attributes.subTotalQuantity) {
          productSubQuants = productModel.attributes.subTotalQuantity;
          _.sortBy(productSubQuants, function(el) {
            return el.measurementValue;
          });
          return this.$('#sub-quantity-totals').html(this.currentProductItemSubQuantity.render(productSubQuants).el);
        }
      };

      return ProductItemBodyView;

    })(Backbone.View);
    ProductItemContentView = (function(_super) {

      __extends(ProductItemContentView, _super);

      function ProductItemContentView() {
        return ProductItemContentView.__super__.constructor.apply(this, arguments);
      }

      ProductItemContentView.prototype.className = 'container-fluid';

      ProductItemContentView.prototype.template = _.template(($('#product-view-content-template')).html());

      ProductItemContentView.prototype.render = function(productModel) {
        this.$el.html(this.template(productModel.attributes));
        return this;
      };

      return ProductItemContentView;

    })(Backbone.View);
    ProductItemSupplierNameView = (function(_super) {

      __extends(ProductItemSupplierNameView, _super);

      function ProductItemSupplierNameView() {
        return ProductItemSupplierNameView.__super__.constructor.apply(this, arguments);
      }

      ProductItemSupplierNameView.prototype.template = _.template(($('#product-view-supplier-name-template')).html());

      ProductItemSupplierNameView.prototype.render = function(productModel) {
        var supplierID, supplierName;
        if (productModel.attributes._order) {
          supplierID = productModel.attributes._order._supplier;
          supplierName = app.Suppliers.get(supplierID);
          this.$el.html(this.template(supplierName.attributes));
        } else {
          this.$el.html(this.template({
            name: 'N/A'
          }));
        }
        return this;
      };

      return ProductItemSupplierNameView;

    })(Backbone.View);
    ProductCreateView = (function(_super) {

      __extends(ProductCreateView, _super);

      function ProductCreateView() {
        return ProductCreateView.__super__.constructor.apply(this, arguments);
      }

      ProductCreateView.prototype.el = '#product-create-view-content';

      ProductCreateView.prototype.template = _.template(($('#inventory-content-template')).html());

      ProductCreateView.prototype.initialize = function() {
        this.productCreateBodyView = new ProductCreateBodyView();
        this.storeSelectView = new StoreSelectView();
        this.supplierSelectView = new SupplierSelectView();
        return this.storeSelectView.template = _.template(($('#product-create-store-names-template')).html());
      };

      ProductCreateView.prototype.render = function() {
        this.$el.html(this.template({}));
        $("#inventory-view-body").html(this.productCreateBodyView.render().el);
        $("#product-create-store-names").html(this.storeSelectView.render().el);
        return $("#product-create-supplier-names").html(this.supplierSelectView.render().el);
      };

      return ProductCreateView;

    })(Backbone.View);
    ProductCreateBodyView = (function(_super) {

      __extends(ProductCreateBodyView, _super);

      function ProductCreateBodyView() {
        return ProductCreateBodyView.__super__.constructor.apply(this, arguments);
      }

      ProductCreateBodyView.prototype.events = {
        "click input[type=radio]": "quantityOptionInput",
        "click #cancel-sub-total-options": "cancelSubTotalOptions",
        "click #save-sub-total-options": "saveSubTotalOptions",
        "submit #create-new-product-button": "createNewProduct"
      };

      ProductCreateBodyView.prototype.template = _.template(($('#product-create-template')).html());

      ProductCreateBodyView.prototype.render = function() {
        this.$el.html(this.template({}));
        this.validateCreateProductForm();
        return this;
      };

      ProductCreateBodyView.prototype.validateCreateProductForm = function() {
        return this.validateForm(this.$("#create-product-form"), {
          productName: {
            required: true
          },
          brand: {
            required: true
          },
          category: {
            required: true
          },
          price: {
            required: true,
            decimalTwo: true,
            min: 0.01
          },
          cost: {
            required: true,
            decimalTwo: true,
            min: 0.01
          },
          grandTotal: {
            required: true,
            min: 1
          }
        });
      };

      ProductCreateBodyView.prototype.createNewProduct = function(e) {
        e.preventDefault();
        return console.log("made it here");
      };

      ProductCreateBodyView.prototype.quantityOptionInput = function(e) {
        if ($(e.currentTarget).val() === "sub-total-selected") {
          $("#sub-total-quantity-modal").modal("toggle");
        }
        $('#grand-total-quantity-content').toggle();
        return $('#sub-total-quantity-content').toggle();
      };

      ProductCreateBodyView.prototype.cancelSubTotalOptions = function(e) {
        $("#sub-total-quantity-modal").modal("toggle");
        $('input[name=totalOptionsRadio][value="grand-total-selected"]').prop('checked', true);
        $('#grand-total-quantity-content').show();
        return $('#sub-total-quantity-content').hide();
      };

      ProductCreateBodyView.prototype.saveSubTotalOptions = function(e) {
        var columnName, columnNamesArray, columnNamesString, i, measurementType, name, productSubQuants, _i, _j, _len, _len1;
        $("#sub-total-quantity-modal").modal("toggle");
        $('#sub-total-quantity-content').show();
        $('#grand-total-quantity-content').hide();
        measurementType = $("#measurement-type-input").val();
        columnNamesString = $("#measurement-values-input").val();
        columnNamesArray = columnNamesString.split(',');
        for (i = _i = 0, _len = columnNamesArray.length; _i < _len; i = ++_i) {
          name = columnNamesArray[i];
          columnNamesArray[i] = name.replace(/(^\s+|\s+$)/g, '');
        }
        productSubQuants = [];
        for (_j = 0, _len1 = columnNamesArray.length; _j < _len1; _j++) {
          columnName = columnNamesArray[_j];
          productSubQuants.push({
            measurementName: measurementType,
            measurementValue: columnName,
            quantity: '<input class="input-mini" type="text">'
          });
        }
        return $('#sub-total-quantity-content').html((new ProductItemSubQuantityView()).render(productSubQuants).el);
      };

      return ProductCreateBodyView;

    })(Backbone.View);
    SupplierSelectView = (function(_super) {

      __extends(SupplierSelectView, _super);

      function SupplierSelectView() {
        return SupplierSelectView.__super__.constructor.apply(this, arguments);
      }

      SupplierSelectView.prototype.template = _.template(($('#product-create-supplier-names-template')).html());

      SupplierSelectView.prototype.render = function() {
        var name, supplierNames, _i, _len;
        this.$el.html(this.template({}));
        supplierNames = app.Suppliers.pluck("name");
        for (_i = 0, _len = supplierNames.length; _i < _len; _i++) {
          name = supplierNames[_i];
          this.addToSelect(name);
        }
        return this;
      };

      SupplierSelectView.prototype.addToSelect = function(supplierName) {
        return this.$('#supplier-name-select').append("<option>" + supplierName + "</option>");
      };

      return SupplierSelectView;

    })(Backbone.View);
    OrderListView = (function(_super) {

      __extends(OrderListView, _super);

      function OrderListView() {
        return OrderListView.__super__.constructor.apply(this, arguments);
      }

      OrderListView.prototype.el = '#order-list-view';

      OrderListView.prototype.template = _.template(($('#order-list-template')).html());

      OrderListView.prototype.render = function() {
        return this.$el.html(this.template({}));
      };

      return OrderListView;

    })(Backbone.View);
    this.app = (_ref = window.app) != null ? _ref : {};
    return this.app.InventoryControllerView = InventoryControllerView;
  });

}).call(this);
