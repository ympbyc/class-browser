(function () {
  "use strict";
  var isFunction, classAnalysis, instanceMethodsAnalysis, classMethodsAnalysis, classes, SbModel;
  SbModel = Sebone.Model;
  var JsClass;
  JsClass = function () {
    this.className = null;
    this.superClass = null;
    this.instanceVariables = null;
    this.instanceMethods = null;
    this.classMethods = null;
    this.classVariables = null;
    this.raw = null;
    if (this.init) {
      this.init.apply(this, arguments);
    }
  };
  JsClass.__super = SbModel.prototype;
  JsClass.prototype = new SbModel();
  JsClass.prototype.init = function () {
    var _this = this;
    _this.instanceVariables = [];
    _this.instanceMethods = [];
    _this.classVariables = [];
    return _this.classMethods = [];
  };
  var JsMethod;
  JsMethod = function () {
    this.methodName = null;
    this.raw = null;
    if (this.init) {
      this.init.apply(this, arguments);
    }
  };
  JsMethod.__super = SbModel.prototype;
  JsMethod.prototype = new SbModel();
  classes = [];
  isFunction = function (obj) {
    return ((typeof obj === "function") || obj instanceof Function);
  };
  classAnalysis = function (obj) {
    return Object.keys(obj).forEach(function (key) {
      var aClass;
      return (key.charAt(0).toUpperCase() === key.charAt(0)) ? (function () {
        aClass = new JsClass();
        aClass.className = key;
        aClass.raw = obj[key];
        aClass.superClass = (obj[key].constructor || function () {
          return null;
        });
        instanceMethodsAnalysis(aClass);
        classMethodsAnalysis(aClass);
        return classes.push(aClass);
      })() : void 0;
    });
  };
  instanceMethodsAnalysis = function (aClass) {
    var proto;
    proto = (aClass.raw.prototype || {});
    return Object.keys(proto).forEach(function (key) {
      return isFunction(proto[key]) ? ((function () {
        return aClass.instanceMethods.push((function () {
          var _receiver = new JsMethod();
          _receiver.methodName = key;
          _receiver.raw = proto[key];
          return _receiver;
        })());
      }))() : (function () {
        return aClass.instanceVariables.push(key);
      })();
    });
  };
  classMethodsAnalysis = function (aClass) {
    var rawClass;
    rawClass = aClass.raw;
    return Object.keys(rawClass).forEach(function (key) {
      return isFunction(rawClass[key]) ? ((function () {
        return aClass.classMethods.push((function () {
          var _receiver = new JsMethod();
          _receiver.methodName = key;
          _receiver.raw = rawClass[key];
          return _receiver;
        })());
      }))() : (function () {
        return aClass.classVariables.push(key);
      })();
    });
  };
  classAnalysis(window);
  window.classes = classes;
  return classes;
}).call(this);