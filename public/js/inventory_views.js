// Generated by CoffeeScript 1.4.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQuery(function() {
    var InventoryControllerView, OrderListView, ProductCreateBodyView, ProductCreateView, ProductItemBodyView, ProductItemContentView, ProductItemSubQuantityView, ProductItemSupplierNameView, ProductItemView, ProductsListStoreSelectView, StoreSelectView, SupplierSelectView, _ref;
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
        this.currentView = new app.GenericListView({
          collection: app.Products,
          el: "#products-list-view-content",
          storeSelectView: ProductsListStoreSelectView,
          tableTemplate: '#products-table-template',
          tableListID: '#products-table-list',
          itemTrTemplate: '#product-tr-template',
          itemControllerView: this
        });
        return this.currentView.render();
      };

      InventoryControllerView.prototype.renderProductDefaultItemView = function() {
        if (this.currentView) {
          this.currentView.$el.html("");
        }
        this.currentView = new ProductItemView();
        return this.currentView.render(app.Products.models[0]);
      };

      InventoryControllerView.prototype.renderSpecificItemView = function(model) {
        if (this.currentView) {
          this.currentView.$el.html("");
        }
        $('#inventory-item-tab a').tab('show');
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

      ProductItemView.prototype.template = _.template(($('#root-backbone-content-template')).html());

      ProductItemView.prototype.initialize = function(options) {
        return this.productView = new ProductItemBodyView();
      };

      ProductItemView.prototype.render = function(productModel) {
        this.model = productModel;
        this.$el.html(this.template({}));
        return $("#root-backbone-view-body").html(this.productView.render(this.model).el);
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
        if (productModel.attributes.subTotalQuantity.length) {
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

      ProductCreateView.prototype.template = _.template(($('#root-backbone-content-template')).html());

      ProductCreateView.prototype.initialize = function() {
        this.productCreateBodyView = new ProductCreateBodyView();
        this.storeSelectView = new StoreSelectView();
        this.supplierSelectView = new SupplierSelectView();
        return this.storeSelectView.template = _.template(($('#product-create-store-names-template')).html());
      };

      ProductCreateView.prototype.render = function() {
        this.$el.html(this.template({}));
        $("#root-backbone-view-head").html(this.productCreateBodyView.render().el);
        $("#root-backbone-view-body").html(this.productCreateBodyView.render().el);
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
        "click #create-new-product-button": "checkValidityAndCreateNewProduct"
      };

      ProductCreateBodyView.prototype.template = _.template(($('#product-create-template')).html());

      ProductCreateBodyView.prototype.render = function() {
        return this.$el.html(this.template({}));
      };

      return ProductCreateBodyView;

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
        "click #create-new-product-button": "checkValidityAndCreateNewProduct"
      };

      ProductCreateBodyView.prototype.template = _.template(($('#product-create-template')).html());

      ProductCreateBodyView.prototype.render = function() {
        this.$el.html(this.template({}));
        this.setJQueryValidityRules();
        return this;
      };

      ProductCreateBodyView.prototype.setJQueryValidityRules = function() {
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

      ProductCreateBodyView.prototype.checkValidityAndCreateNewProduct = function(e) {
        var alertWarning, hasSubQuants, isExistingProduct, message, passesJQueryValidation, subQuantTypes, subQuantValues;
        e.preventDefault();
        $("#main-alert-div").html("");
        passesJQueryValidation = this.$("#create-product-form").valid();
        if (passesJQueryValidation) {
          isExistingProduct = app.Products.ifModelExists($('#name-input').val(), $('#brand-input').val());
          hasSubQuants = $("#grand-total-quantity-content").is(":hidden");
          if (isExistingProduct) {
            message = "You already have a product by this name. " + "Please Change the product name and/or brand";
            alertWarning = new app.AlertView;
            $("#main-alert-div").html(alertWarning.render("alert-error", message).el);
            return;
          }
          if (hasSubQuants) {
            subQuantTypes = [];
            subQuantValues = [];
            $("th").each(function() {
              return subQuantTypes.push($(this).html());
            });
            $("td").each(function() {
              if ($(this).html() !== "Totals") {
                return subQuantValues.push($(this).find("input").val());
              }
            });
            if (!this.subQuantTotalValid(subQuantTypes, subQuantValues)) {
              return;
            }
            return this.createNewProduct({
              subQuantTypes: subQuantTypes,
              subQuantValues: subQuantValues
            });
          }
          return this.createNewProduct();
        } else {

        }
      };

      ProductCreateBodyView.prototype.createNewProduct = function(subQuants) {
        var brand, category, cost, i, name, price, productModel, quant, quantity, storeName, subTotalQuantity, totalQuantity, _i, _j, _len, _len1, _ref, _ref1;
        name = $("#name-input").val();
        brand = $("#brand-input").val();
        category = $("#category-input").val();
        price = parseFloat($("#price-input").val(), 10) * 100;
        cost = parseFloat($("#cost-input").val(), 10) * 100;
        storeName = $("#store-name-select").val();
        totalQuantity = 0;
        subTotalQuantity = [];
        if (subQuants) {
          _ref = subQuants.subQuantValues;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            quant = _ref[_i];
            totalQuantity += parseInt(quant, 10);
          }
          _ref1 = subQuants.subQuantValues;
          for (i = _j = 0, _len1 = _ref1.length; _j < _len1; i = ++_j) {
            quantity = _ref1[i];
            subTotalQuantity.push({
              measurementName: subQuants.subQuantTypes[0],
              measurementValue: subQuants.subQuantTypes[i + 1],
              quantity: quantity
            });
          }
        } else {
          totalQuantity = parseInt($("#grand-total-input").val(), 10);
        }
        productModel = {
          description: {
            name: name,
            brand: brand
          },
          storeName: storeName,
          category: category,
          price: price,
          cost: cost,
          totalQuantity: totalQuantity,
          subTotalQuantity: subTotalQuantity
        };
        console.log(productModel);
        return app.Products.create(productModel);
      };

      ProductCreateBodyView.prototype.subQuantTotalValid = function(types, values) {
        var alertWarning, anyValuesLessThan0, message, oneValueMoreThan0, value, _i, _len;
        oneValueMoreThan0 = false;
        anyValuesLessThan0 = false;
        for (_i = 0, _len = values.length; _i < _len; _i++) {
          value = values[_i];
          if (parseInt(value, 10) > 0) {
            oneValueMoreThan0 = true;
          }
          if (parseInt(value, 10) < 0) {
            anyValuesLessThan0 = true;
          }
        }
        if (!oneValueMoreThan0 || anyValuesLessThan0) {
          message = "For sub quantity totals, you must have at" + " least one value higher than 0. Only numbers are" + " accepted.";
          alertWarning = new app.AlertView;
          $("#main-alert-div").html(alertWarning.render("alert-error alert-block", message).el);
          return false;
        }
        return true;
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
            quantity: '<input class="input-mini" type="text" value="0">'
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

      return OrderListView;

    })(Backbone.View);
    this.app = (_ref = window.app) != null ? _ref : {};
    return this.app.InventoryControllerView = InventoryControllerView;
  });

}).call(this);
