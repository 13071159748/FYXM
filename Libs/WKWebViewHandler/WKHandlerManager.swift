//
//  WKHandlerManager.swift
//  WKWebViewSDK
//
//  Created by CQSC  on 2018/4/25.
//  Copyright © 2018年 moqing. All rights reserved.
//

import Foundation
import WebKit
import JavaScriptCore
import Toast_Swift
class WKHandlerManager{
    fileprivate static var __once: () = {
        Inner.instance = WKHandlerManager()
    }()
    struct Inner {
        static var instance: WKHandlerManager?
    }
    public class var shared: WKHandlerManager {
        _ = WKHandlerManager.__once
        return Inner.instance!
    }
    
    
    //注入swift对象到js
    public func loadObjToJs(webView:WKWebView,objName:String,delegateObj:WKScriptMessageHandler){
        WKHandlerManager.shared.removeObj(webView: webView, objName: objName)
        webView.configuration.userContentController.add(delegateObj, name: objName)
    }
    
    
    //swift执行js文件代码
    public func loadJsCode(webView:WKWebView) {
        let jsonPath = Bundle.main.path(forResource:"interactor_proxy", ofType: "js")
        let data = NSData.init(contentsOfFile: jsonPath!)
        if data != nil{
            let str = String.init(data: data! as Data, encoding:String.Encoding.utf8)
            webView.evaluateJavaScript(str! as String, completionHandler:{ (obj, error) in
                mqLog(error)
            })
        }
    }
    //swift执行js代码(版本信息以及注册)
    public func loadJs(webView:WKWebView,appInfo:String) {
        webView.evaluateJavaScript("InteractorProxy.registerHandler(\(appInfo))", completionHandler:{ (obj, error) in
          mqLog(error)
        })
    }
    public func loadJsTest(webView:WKWebView,appInfo:String) {
        webView.evaluateJavaScript("InteractorProxy.showMessageToast(\(appInfo))", completionHandler:{ (obj, error) in
           mqLog(error)
        })
    }
    //清除对象
    public func removeObj(webView:WKWebView,objName:String) {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: objName)
    }
    //callback
    public func callbackToJs(webView:WKWebView,funcName:String) {
        webView.evaluateJavaScript("InteractorProxy.callbackHandler(\(funcName))", completionHandler: { (obj, error) in
         mqLog(error)
        })
    }
    //callback
    public func returnUserInfo()->String {
        if MQIUserManager.shared.checkIsLogin() == true{
            let user = MQIUserManager.shared.user
            let app = ["id":user?.user_id ?? "-1","name":user?.user_nick ?? ""]
            let str = dictionaryToJsonString(app)
//           let str = "{'id' : '\(user?.user_id)','name' : '1'}"
            return str
        }else{
            let app = ["id":"-1","name":"-1"]
            let str = dictionaryToJsonString(app)
            return str
        }
    }
    public func makeToast(_ message: String,view:UIView) {
        view.makeToast(message, duration: 1.5, position: .center)
    }
    
    public func  jumpFromData(_ message:WKScriptMessage,jumpBlock:((_ type:WKJumpType,_ params:[String:Any]? ) ->(Void))?) {
        
        if message.name == "NativeMethod" {
            
            if let  data = message.body as? [String:Any] {
                var type:WKJumpType = .None
                //                var params:[String:Any] = [:]
                let name = data["name"] as! String
                
                switch name {
                case "showMessageToast":
                    type = .ShowToast
                    break
                case "openPage":
                    type = .OpenPage
                    break
                case "login":
                    type = .ToLogin
                    break
                case "startWechatPay":
                    type = .Wechat
                    break
                case "startzfubao":
                    type = .zfubao
                    break
                case "showMessageToastCalBack":
                    type = .showToastCallBack
                    break
                default:
                    type = .None
                    break
                }
                guard let params = data["params"]  else {
                    jumpBlock?(type,[:])
                    return
                }
                jumpBlock?(type,getDicFromJSONString(jsonString: params as! String))
            }
        }
    }
    
    func getDicFromJSONString(jsonString:String) ->[String:Any]{
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! [String:Any]
        }
        return [:]
        
    }
}

enum WKJumpType {
    case None /// 未定义
    case ToLogin /// 登录
    case OpenPage /// 打开定义好的页面
    case ShowToast/// 展示Alert
    case showToastCallBack/// 展示Alert 需要回调
    case Wechat /// 打开微信
    case zfubao /// zfb
    
    
}
