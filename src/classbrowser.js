(function () {
  "use strict";
  var SbModel, SbCollection, SbView;
  SbModel = Sebone.Model;
  SbCollection = Sebone.Collection;
  SbView = Sebone.View;
  var ClassCollection;
  ClassCollection = function () {
    if (this.init) {
      this.init.apply(this, arguments);
    }
  };
  ClassCollection.__super = SbCollection.prototype;
  ClassCollection.prototype = new SbCollection();
  ClassCollection.prototype.fetch = function () {
    var _this = this;
    return window.classes.forEach(function (cl) {
      return _this.add(cl);
    });
  };
  var ClassPaneView;
  ClassPaneView = function () {
    this.selectedRow = null;
    if (this.init) {
      this.init.apply(this, arguments);
    }
  };
  ClassPaneView.__super = SbView.prototype;
  ClassPaneView.prototype = new SbView();
  ClassPaneView.prototype.init = function () {
    var _this = this;
    return _this.setUIConstructor(function () {
      return $("#class-pane");
    });
  };
  ClassPaneView.prototype.render = function () {
    var _this = this;
    _this.el().html("");
    return _this.model().each(function (cl) {
      var row;
      row = $("<li>");
      row.text(cl.className);
      _this.bindClickmodel(row, cl);
      return row.appendTo(_this.el());
    });
  };
  ClassPaneView.prototype.onAdd = function (cl) {
    var _this = this;
    var row;
    row = $("<li>");
    row.text(cl.className);
    _this.bindClickmodel(row, cl);
    return row.appendTo(_this.el());
  };
  ClassPaneView.prototype.bindClickmodel = function (row, m) {
    var _this = this;
    return row.on("click", function () {
      var mpv, edv;
      _this.selectedRow ? (function () {
        return _this.selectedRow.css({
          "backgroundColor": "#fff",
          "color": "#000"
        });
      })() : void 0;
      row.css({
        "backgroundColor": "#3261AB",
        "color": "#fff"
      });
      _this.selectedRow = row;
      mpv = new MethodPaneView();
      mpv.setModel(m);
      mpv.render();
      edv = new EditorView();
      edv.setModel(m);
      return edv.render();
    });
  };
  var MethodPaneView;
  MethodPaneView = function () {
    this.selectedRow = null;
    if (this.init) {
      this.init.apply(this, arguments);
    }
  };
  MethodPaneView.__super = SbView.prototype;
  MethodPaneView.prototype = new SbView();
  MethodPaneView.prototype.init = function () {
    var _this = this;
    return _this.setUIConstructor(function () {
      return $("#method-pane");
    });
  };
  MethodPaneView.prototype.render = function () {
    var _this = this;
    _this.el().html("");
    return _this.model().instanceMethods.forEach(function (im) {
      var row;
      row = $("<li>");
      row.text(im.methodName);
      _this.bindClickmodel(row, im);
      return row.appendTo(_this.el());
    });
  };
  MethodPaneView.prototype.bindClickmodel = function (row, m) {
    var _this = this;
    return row.on("click", function () {
      var edv;
      _this.selectedRow ? (function () {
        return _this.selectedRow.css({
          "backgroundColor": "#fff",
          "color": "#000"
        });
      })() : void 0;
      row.css({
        "backgroundColor": "#3261AB",
        "color": "#fff"
      });
      _this.selectedRow = row;
      edv = new EditorView();
      edv.setModel(m);
      return edv.render();
    });
  };
  var EditorView;
  EditorView = function () {
    if (this.init) {
      this.init.apply(this, arguments);
    }
  };
  EditorView.__super = SbView.prototype;
  EditorView.prototype = new SbView();
  EditorView.prototype.init = function () {
    var _this = this;
    return _this.setUIConstructor(function () {
      return $("#editor");
    });
  };
  EditorView.prototype.render = function () {
    var _this = this;
    return _this.el().text(_this.model().raw.toString());
  };
  EditorView.prototype.updateto = function (prop, val) {
    var _this = this;
    return _this.render();
  };
  var AppView;
  AppView = function () {
    if (this.init) {
      this.init.apply(this, arguments);
    }
  };
  AppView.__super = SbView.prototype;
  AppView.prototype = new SbView();
  AppView.prototype.init = function () {
    var _this = this;
    var clColl, clPane;
    clColl = new ClassCollection();
    clPane = new ClassPaneView();
    clPane.setModel(clColl);
    return clColl.fetch();
  };
  return $(function () {
    return new AppView();
  });
}).call(this);