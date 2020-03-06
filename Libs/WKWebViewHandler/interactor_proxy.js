 (function () {
  var callbackSet = {}
  window.InteractorProxy = {
  callbackHandler: callbackHandler,
  registerHandler: registerHandler,
  version: 2
  };
  
  function callbackHandler(data) {
  var callback = callbackSet[data.name];
  if (callback) {
  callback(data.params);
  delete callbackSet[data.name]
  }
  }
  
  function registerHandler(appinfo) {
  InteractorProxy.app = appinfo
  var interactorReadyEvent = document.createEvent("Event");
  interactorReadyEvent.initEvent("onInteractorReady");
  interactorReadyEvent.InteractorProxy = InteractorProxy;
  document.dispatchEvent(interactorReadyEvent);
  }
  
  InteractorProxy.showMessageToast = function (message) {
  //     var request = {
  //     "message": message,
  //     "name":"showMessageToast"
  //     }
  //     dispatchMethodName(request)
  var params = {
  "message":message
  }
  var data = {
  "name": "showMessageToast",
  "params": JSON.stringify(params)
  
  }
  dispatchMethodName(data)
  }
  //  /**
  //   * {id: 111, nick: "tom"}
  //   */
  InteractorProxy.getUserInfo = function () {
  var user = prompt("getUserInfo")
  return JSON.parse(user)
  }
  InteractorProxy.postUrl = function () {
  var url = prompt("postUrl")
  }
  InteractorProxy.startWechatPay = function (amount,channel,type) {
  
  var params = {
  "amount":amount,
  "channel":channel,
  "type":type
  }
  var data = {
  "name": "startWechatPay",
  "params": JSON.stringify(params)
  }
  dispatchMethodName(data)
  }
  InteractorProxy.startAlipay = function (amount,channel,type) {
  var params = {
  "amount":amount,
  "channel":channel,
  "type":type
  }
  var data = {
  "name": "startzfubao",
  "params": JSON.stringify(params)
  }
  dispatchMethodName(data)
  }
  InteractorProxy.getUrl = function (name, params, callback) {
  var data = {
  "name": name,
  "params": JSON.stringify(params)
  }
  dispatchMethodName(data)
  }
  InteractorProxy.login = function (){
  var data = {
  "name": "login"
  }
  dispatchMethodName(data)
  }
  
  InteractorProxy.open = function(path, params) {
  if(path == undefined) return;
  
  if(arguments.length <= 1){
  params = {}
  }
  var paramsNEW = {
  "path":path,
  "params":JSON.stringify(params),
  }
  var data = {
  "name": "openPage",
  "params":JSON.stringify(paramsNEW)
  }
  dispatchMethodName(data)
  }
  
  function dispatchMethodName(data) {
  switch (data.name) {
  case "showMessageToast": return window.webkit.messageHandlers.NativeMethod.postMessage(data);
  case "showMessageToastCallBack": return window.webkit.messageHandlers.NativeMethod.postMessage(data);
  case "getUserInfo": return InteractorProxy.getUserInfo();
  case "postUrl": return InteractorProxy.postUrl();
  case "getUrl":return window.webkit.messageHandlers.NativeMethod.postMessage(data);
  case "startWechatPay":return window.webkit.messageHandlers.NativeMethod.postMessage(data);
  case "startzfubao":return window.webkit.messageHandlers.NativeMethod.postMessage(data);
  case "login":return window.webkit.messageHandlers.NativeMethod.postMessage(data);
  //  window.webkit.messageHandlers.NativeMethod.login(data);
  case "openPage":  return window.webkit.messageHandlers.NativeMethod.postMessage(data);
  default: return function () { }
  }
  }
  })();


