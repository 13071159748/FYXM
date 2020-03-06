//
//  MQIPayWebVC.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/6.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

enum PayWebType {
    case zfbao
    case wx
}

class MQIPayWebVC: MQIWebVC {
    public var payType: PayWebType!
  
    var payWebcompletion:(() -> ())?//返回的时候刷新券
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func request() {
        if url.hasPrefix("https://") || url.hasPrefix("www.") || url.hasPrefix("http://") {
            if let url = URL(string: url) {
                let requesta = NSMutableURLRequest(url: url)
                webView.load(requesta as URLRequest)
            }else {
                dismissPreloadView()
            }
        }else {
            dismissPreloadView()
        }
    }
    
    //MARK: WKNavigationDelegate
    /** 页面开始加载时调用 */
    override func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    /** 当内容开始返回时调用 */
    override func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    /** 页面加载完成之后调用 */
    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if payType == .zfbao {
            webView.evaluateJavaScript("history.length", completionHandler: { (obj, error) in
                if let num = (obj as? NSNumber)?.int32Value {
                    if num > 1 {
                        self.removeNav()
                    }
                }
            })
        }
        if let url = webView.url {
            if url.absoluteString.hasPrefix(BASEHTTPURL+"book/") == true {
                
            }
            
        }
        
        webView.scrollView.mj_header.endRefreshing()
        dismissPreloadView()
        dismissWrongView()
    }
    
    /** 在发送请求之前，决定是否跳转 */
    override func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //        if let requestURL11 = navigationAction.request.url{
        //            MQLog(requestURL11)
        //        }
        if payType == .wx {
            if let requestURL = navigationAction.request.url {
                if requestURL.absoluteString.hasPrefix("weixin://") == true {
                    if UIApplication.shared.openURL(requestURL) == true {
                        decisionHandler(.cancel)
                        return
                    }else {
                        decisionHandler(.allow)
                        return
                    }
                }
            }
            
            decisionHandler(.allow)
            return
        }else {
            if let requestURL = navigationAction.request.url {
                
                if requestURL.absoluteString.hasPrefix("alipay://") == true {
                    if UIApplication.shared.openURL(requestURL) == true {
                        decisionHandler(.cancel)
                        return
                    }else {
                        decisionHandler(.allow)
                        return
                    }
                    
                }
                
                if requestURL.absoluteString == url {
                    decisionHandler(.allow)
                    return
                }
               
                
                let urlPath  = navigationAction.request.url?.path
                if urlPath == "/alipay_back"{
                    decisionHandler(.cancel)
                    UserNotifier.postNotification(.refresh_coin)
                    popVC()
                    return
                } else if urlPath == "/alipay_return"{
                    decisionHandler(.cancel)
                    UserNotifier.postNotification(.refresh_coin)
                    //                GYLoadManager.shared.makeToast("充值成功")
                    after(1.0, block: {[weak self]() -> Void in
                        if let weakSelf = self {
                            weakSelf.popVC()
                            weakSelf.payWebcompletion?()
                        }
                    })
                    return
                    
                }else{
                    decisionHandler(.allow)
                    return
                }
                
                
            }else {
                decisionHandler(.cancel)
                return
            }
        }
    }
    func alipayRequest(_ requestUrl:String) {
        if requestUrl.hasPrefix("https://") || requestUrl.hasPrefix("www.") || requestUrl.hasPrefix("http://") {
            if let url = URL(string: requestUrl) {
                let request = NSMutableURLRequest(url: url)
                request.setValue("\(TARGET_NAME_EN)/ios \(UIDevice.current.modelName)", forHTTPHeaderField: "User-Agent")
                request.setValue(getCurrentVersion(), forHTTPHeaderField: "X-App-Version")
                request.setValue("apple", forHTTPHeaderField: "X-App-Channel")
                request.setValue("1", forHTTPHeaderField: "X-APP-FC")
                request.setValue("1", forHTTPHeaderField: "X-APP-FC2")
                request.setValue(GetCurrent_millisecondIntervalSince1970String(), forHTTPHeaderField: "X-Device-Time")
                
                let token = MQIUserManager.shared.user == nil ? "" : MQIUserManager.shared.user!.access_token
                
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                webView.load(request as URLRequest)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //        payWebcompletion?()
    }

}
