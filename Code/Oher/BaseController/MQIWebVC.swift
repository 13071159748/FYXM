//
//  MQIWebVC.swift
//  UXinyong
//
//  Created by _CHK_  on 15/3/17.
//  Copyright (c) 2015年 _xinmo_. All rights reserved.
//

import UIKit

import MJRefresh
import JavaScriptCore
class MQIWebVC: MQIBaseViewController, WKNavigationDelegate, WKUIDelegate,UIScrollViewDelegate,WKScriptMessageHandler
{
    
    var webView: WKWebView!
    var compBlock:((_ suc:Bool) -> ())? // 充值成功回调
    var isAc: Bool = false
    var url: String = "" {
        didSet {
            //            if let str = NSString(string: url).addingPercentEscapes(using: String.Encoding.utf8.rawValue) {
            //                url = str
            //            }
            if let str = NSString(string:url).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.init(charactersIn: "").inverted){
                url = str
            }
        }
    }
    deinit {
        if webView == nil {return}
        WKHandlerManager.shared.removeObj(webView: webView, objName: "NativeMethod")
        if (webView.scrollView.delegate != nil) {
            webView.scrollView.delegate = nil
        }
        mqLog("webView 销毁啦-====")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let configuretion = WKWebViewConfiguration()
        configuretion.preferences = WKPreferences()
        
        configuretion.preferences.javaScriptEnabled = true
        configuretion.preferences.javaScriptCanOpenWindowsAutomatically = false
        configuretion.userContentController = WKUserContentController()
        if #available(iOS 10.0, *) {
            configuretion.ignoresViewportScaleLimits = true
        } else {
            // Fallback on earlier versions
        }
        
        
        webView = WKWebView(frame: contentView.bounds, configuration: configuretion)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.scrollView.delegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.webView.reload()
            }
        })
        
        contentView.addSubview(webView)
        addPreloadView()
        request()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
    
    
    func request() {
        if url.hasPrefix("https://") || url.hasPrefix("www.") || url.hasPrefix("http://") {
            if let url = URL(string: url) {
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
            }else {
                dismissPreloadView()
            }
        }else {
            dismissPreloadView()
        }
    }
    
    //MARK: WKNavigationDelegate
    /** 页面开始加载时调用 */
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    /** 当内容开始返回时调用 */
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    /** 页面加载完成之后调用 */
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.scrollView.frame = contentView.bounds
        webView.evaluateJavaScript("document.title") { (obj, error) in
            if let obj = obj {
                if self.title != kLocalized("free") {
                    self.title = "\(obj)"
                }
            }
        }
        if let url = webView.url {
            if url.absoluteString.hasPrefix(BASEHTTPURL+"book/") == true {
                //判断书架
                var str = url.absoluteString.replacingOccurrences(of: BASEHTTPURL+"book/", with: "")
                str = str.replacingOccurrences(of: ".html", with: "")
                if NSString(string: str).intValue > 0 {
                    if MQIShelfManager.shared.checkIsExist("\(str)") == true {
                        after(1, block: {
                            webView.evaluateJavaScript("addShelfSuccess()", completionHandler: nil)
                        })
                        
                    }
                }
            }else{
                weak var weakSelf = self
                WKHandlerManager.shared.loadObjToJs(webView: webView, objName: "NativeMethod",delegateObj:weakSelf!)
                //这是充值
                let dict = "{'version' : '\(getCurrentVersion())'}"
                webView.evaluateJavaScript("init(\(dict))", completionHandler: { (obj, error) in
                })
                WKHandlerManager.shared.loadJsCode(webView: webView)
                let app = "{'version' : '\(getCurrentVersion())','scheme' : '\(JSBRIDGEHEADER)','platform' : 'iOS','system' : '\(UIDevice.current.systemVersion)'}"
                WKHandlerManager.shared.loadJs(webView:webView, appInfo: app)
                
            }
            
            //            else if url.absoluteString.hasPrefix(payHttpURL()) == true {
            //                weak var weakSelf = self
            //                WKHandlerManager.shared.loadObjToJs(webView: webView, objName: "NativeMethod",delegateObj:weakSelf!)
            //                //这是充值
            //                let dict = "{'version' : '\(getCurrentVersion())'}"
            //                webView.evaluateJavaScript("init(\(dict))", completionHandler: { (obj, error) in
            //                })
            //                WKHandlerManager.shared.loadJsCode(webView: webView)
            //                let app = "{'version' : '\(getCurrentVersion())','scheme' : '\(JSBRIDGEHEADER)','platform' : 'iOS','system' : '\(UIDevice.current.systemVersion)'}"
            //                WKHandlerManager.shared.loadJs(webView:webView, appInfo: app)
            //            }
            WKHandlerManager.shared.loadJsCode(webView: webView)
            let app = "{'version' : '\(getCurrentVersion())','scheme' : '\(JSBRIDGEHEADER)','platform' : 'iOS','system' : '\(UIDevice.current.systemVersion)'}"
            WKHandlerManager.shared.loadJs(webView:webView, appInfo: app)
        }
        
        webView.scrollView.mj_header.endRefreshing()
        dismissPreloadView()
        dismissWrongView()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        
        webView.scrollView.mj_header.endRefreshing()
        dismissPreloadView()
        if (error as NSError).code == NSURLErrorCancelled {
            return
        }
        addWrongView(kLocalized("TheNetworkIsOff"), refresh: { () -> () in
            self.wrongView?.setLoading()
            let request = URLRequest(url: URL(string: self.url)!)
            self.webView.load(request)
        })
    }
    
    /** 页面加载失败时调用 */
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webView.scrollView.mj_header.endRefreshing()
        dismissPreloadView()
        if (error as NSError).code == NSURLErrorCancelled {
            return
        }
        addWrongView(kLocalized("TheNetworkIsOff"), refresh: { () -> () in
            self.wrongView?.setLoading()
            let request = URLRequest(url: URL(string: self.url)!)
            self.webView.load(request)
        })
    }
    /** 接收到服务器跳转请求之后调用 */
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        /// 跳转请求
        decisionHandler(.allow)
    }
    
    
    
    /** 在发送请求之前，决定是否跳转 */
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let requestURL = navigationAction.request.url {
            if requestURL.absoluteString == url {
                decisionHandler(.allow)
                return
            }
            //26    93min
            let absoluteString = requestURL.absoluteString
            //            MQLog("--------- \(absoluteString)")
            if absoluteString == BASEHTTPURL {
                popVC()
                decisionHandler(.cancel)
                //返回的是mqappjsbridge://MethodCall/interactProxy#s导致
            }else if absoluteString.hasPrefix(JSBRIDGEHEADER) {
                
                if absoluteString.urlDecoded().range(of: "\(JSBRIDGEHEADER)MethodCall/interactProxy#") != nil{
                    let dicStr = absoluteString.urlDecoded().replacingOccurrences(of: "\(JSBRIDGEHEADER)MethodCall/interactProxy#", with: "")
                    let a = convertStringToDictionary(dicStr)
                    if let action = a?["action"], let params = a?["params"] ,let success = a?["success"] ,let failed = a?["failed"]{
                        
                        New_payRequestServer("\(action)", params:  "\(params)", success:  "\(success)", failed:  "\(failed)", complete: {(suc,jsonString) in
                            if suc {
                                webView.evaluateJavaScript("\(success)(\(jsonString))", completionHandler: { (obj, error) in
                                    
                                })
                                
                            }else {
                                webView.evaluateJavaScript("\(failed)(\(jsonString))", completionHandler: { (obj, error) in
                                    //                                    MQLog("\(String(describing: error))   \(String(describing: obj))")
                                })
                                
                            }
                            
                        })
                        
                    }
                    
                    decisionHandler(.cancel)
                }else if absoluteString.urlDecoded().range(of: "\(JSBRIDGEHEADER)MethodCall/pay#") != nil {
                    let dictStr = absoluteString.urlDecoded().replacingOccurrences(of: "\(JSBRIDGEHEADER)MethodCall/pay#", with: "")
                    let a = convertStringToDictionary(dictStr)
                    //                    MQLog(a)
                    if let order_fee = a?["order_fee"],
                        let channel_id = a?["channel_id"],
                        let type = a?["type"], let user_coupon_id = a?["user_coupon_id"]{
                        //                        MQLog(absoluteString)
                        
                        MQIUserOperateManager.shared.userPay("\(type)", order_fee: "\(order_fee)", channel_id: "\(channel_id)",user_coupon_id:"\(user_coupon_id)", completion: { [weak self](suc, msg) in
                            if let weakSelf = self {
                                if suc {
                                    if MQIUserOperateManager.shared.userPayChannel == .readerToPay {
                                        MQILoadManager.shared.addProgressHUD(kLocalized("BalanceRefresh"))
                                        MQIUserOperateManager.shared.paySuccess_UpdateCoin({ (suc) in
                                            MQILoadManager.shared.dismissProgressHUD()
                                            //                                            weakSelf.popVC()//MARK: 只适用于微信支付为一级页面
                                            weakSelf.popBlock?()//MARK: 只适用微信支付为二级支付
                                            weakSelf.compBlock?(suc)
                                        })
                                    }else {
                                        weakSelf.webView.reload()
                                    }
                                    
                                }
                            }
                            
                        })
                        
                        decisionHandler(.cancel)
                    }else {
                        decisionHandler(.allow)
                    }
                }
                else if absoluteString.urlDecoded().range(of: "\(JSBRIDGEHEADER)MethodCall/showMessage#") != nil {
                    let dicStr = absoluteString.urlDecoded().replacingOccurrences(of: "\(JSBRIDGEHEADER)MethodCall/showMessage#", with: "")
                    let a = convertStringToDictionary(dicStr)
                    if let message = a?["message"]{
                        MQILoadManager.shared.addAlert_oneBtn(kLocalized("Warn"), msg: "\(message)", block: {
                            
                        })
                    }
                    decisionHandler(.cancel)
                    
                }
                    
                else if absoluteString.urlDecoded().range(of: "\(JSBRIDGEHEADER)Navigator/reader#") != nil {
                    let dictStr = absoluteString.urlDecoded().replacingOccurrences(of: "\(JSBRIDGEHEADER)Navigator/reader#", with: "")
                    let a = convertStringToDictionary(dictStr)
                    if let bid = a?["book_id"] {
                        let book = MQIEachBook()
                        book.book_id = "\(bid)"
                        MQIUserOperateManager.shared.toReader(book.book_id)
                        decisionHandler(.cancel)
                    }else {
                        decisionHandler(.allow)
                    }
                }else if absoluteString.urlDecoded().range(of: "\(JSBRIDGEHEADER)MethodCall/addToBookshelf?addShelfSuccess#") != nil {
                    let dictStr = absoluteString.urlDecoded().replacingOccurrences(of: "\(JSBRIDGEHEADER)MethodCall/addToBookshelf?addShelfSuccess#", with: "")
                    let a = convertStringToDictionary(dictStr)
                    if let _ = a?["book_id"] {
                        decisionHandler(.cancel)
                    }else {
                        decisionHandler(.allow)
                    }
                }else if absoluteString.urlDecoded().range(of: "\(JSBRIDGEHEADER)MethodCall/queryBookshelf?addShelfSuccess#") != nil {
                    //查询书架的接口
                    let dictStr = absoluteString.urlDecoded().replacingOccurrences(of: "\(JSBRIDGEHEADER)MethodCall/queryBookshelf?addShelfSuccess#", with: "")
                    let a = convertStringToDictionary(dictStr)
                    if let _ = a?["book_id"] {
                        //                            if MQIShelfManager.shared.checkIsExist("\(bid)") == true {
                        //                                 webView.evaluateJavaScript("addShelfSuccess()", completionHandler: nil)
                        //                            }
                        decisionHandler(.cancel)
                    }else {
                        decisionHandler(.allow)
                    }
                    
                }else {
                    //nav jsbridge
                    gdschemeBridge_toWebVC(absoluteString)
                    decisionHandler(.cancel)
                }
                
            }else {
                if isAc == true{
                    decisionHandler(.allow)
                }else{
                    
                    guard let  url = navigationAction.request.url else {
                        decisionHandler(.cancel)
                        return
                    }
                    if  hostWhiteList.contains(url.host ?? "") {
                        toWebVC(absoluteString)
                        decisionHandler(.cancel)
                    }else{
                        
                        UIApplication.shared.openURL(url)
                        decisionHandler(.cancel)
                    }
                    
                }
            }
        }else {
            decisionHandler(.allow)
            return
        }
    }
    @objc func test(str:NSString){
        print(str)
    }
    //MARK: WKUIDelegate
    /**  确认框 */
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        //一定要调用
        let ac = UIAlertController(title: webView.title, message: message, preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: { (a) -> Void in
            completionHandler()
        }))
        
        self.present(ac, animated: true, completion: nil)
        //completionHandler()
    }
    
    /**  警告框 */  /**  输入框 */
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(false)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        if prompt == "getUserInfo" {
            completionHandler(WKHandlerManager.shared.returnUserInfo())
        }else{
            completionHandler("OK")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        toLoginCont = 0
    }
    var toLoginCont  = 0
    //MARK: WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        WKHandlerManager.shared.jumpFromData(message) {[weak self] (type, data) -> (Void) in
            
            if let weakSelf  = self {
                let params = data!
                if type == .showToastCallBack {
                    if let callBackId = data!["callBackId"]  {
                        let app = "{'name' : 'showMessageToastCalBack','params':{'callBackId' : '\(callBackId)'}}"
                        WKHandlerManager.shared.callbackToJs(webView: weakSelf.webView, funcName:app)
                    }
                }else if  type == .ToLogin {
                    if weakSelf.toLoginCont > 0 {return}
                    weakSelf.toLoginCont = 1
                    MQIUserOperateManager.shared.toLoginVC({
                        weakSelf.webView.reload()
                    })
                }else if type == .OpenPage {
                    if weakSelf.toLoginCont > 0 {return}
                    weakSelf.toLoginCont = 1
                    mqLog("\(params)")
                    var key = ""
                    var url = ""
                    var book_id = ""
                    var tab = ""
                    
                    if params["path"] !=  nil {
                        key = params["path"] as! String
                    }
                    if params["params"] !=  nil {
                        
                        let dic =  WKHandlerManager.shared.getDicFromJSONString(jsonString: params["params"] as! String)
                        if dic.keys.count > 0{
                            if dic["book_id"] != nil {
                                book_id = dic["book_id"] as! String
                            }
                            if dic["url"] != nil {
                                url = dic["url"] as! String
                            }
                            if dic["tab"] != nil {
                                tab = dic["tab"] as! String
                            }
                        }
                        
                    }
                    
                    MQIOpenlikeManger.todo(key: key, book_id: book_id, url: url, tab: tab,webvc: self)
                    
                }else if type == .ShowToast {
                    if params["message"] !=  nil  {
                        MQILoadManager.shared.makeToast(data!["message"] as! String)
                    }
                }
            }
        }
        //        if message.name == "NativeMethod" {
        //            let data = message.body as! Dictionary<String, Any>
        //            let name = data["name"] as! String
        //            //此处根据定义好的文字判断是否是带回调的调用
        //            if name == "showMessageToastCalBack"{
        //                let app = "{'name' : 'showMessageToastCalBack','params':{'callBackId' : '\(String(describing: data["callBackId"]))'}}"
        //                WKHandlerManager.shared.callbackToJs(webView: webView, funcName:app)
        //            }
        //        }
    }
    
    
    
    //MARK:js跳转
    func gdschemeBridge_toWebVC(_ absoluteString:String) {
        //阅读页上面以前有
        //签到页
        if absoluteString.urlDecoded().range(of: "\(JSBRIDGEHEADER)Navigator/lottery") != nil{
            //            let signVC = GDSignVC()
            //            pushVC(signVC)
        }
            //书籍详情
        else if absoluteString.urlDecoded().range(of: "\(JSBRIDGEHEADER)Navigator/book/") != nil {
            let array = absoluteString.components(separatedBy: "/book/")
            if array.count > 1 {
                let bookId = array[1]
                let bookInfoVC = GDBookInfoVC()
                bookInfoVC.bookId = bookId
                pushVC(bookInfoVC)
            }
        }
        else if absoluteString.urlDecoded().range(of: "\(JSBRIDGEHEADER)Navigator/link?") != nil {
            let dicStr = absoluteString.urlDecoded().replacingOccurrences(of: "\(JSBRIDGEHEADER)Navigator/link?", with: "")
            let a = convertUrlToDictionary(dicStr)
            if let auth = a?["auth"],let link = a?["link"] {
                let towebBlock = {[weak self] ()->Void in
                    if let weakSelf = self {
                        let vc = MQIWebVC()
                        vc.url = link as! String
                        weakSelf.pushVC(vc)
                    }
                }
                if auth as! String == "1" {
                    if MQIUserManager.shared.checkIsLogin() == false {
                        MQIloginManager.shared.toLogin(kLocalized("SorryYouHavenLoggedInYet"), finish: {()->Void in
                            towebBlock()
                        })
                    }else {
                        towebBlock()
                    }
                }else {
                    towebBlock()
                }
            }
        }
        else if absoluteString.urlDecoded().range(of: "\(JSBRIDGEHEADER)Navigator/reader/") != nil {
            let dictStr = absoluteString.urlDecoded().replacingOccurrences(of: "\(JSBRIDGEHEADER)Navigator/reader/", with: "")
            let book = MQIEachBook()
            book.book_id = "\(dictStr)"
            MQIUserOperateManager.shared.toReader(book.book_id)
        }
        else {
            return
        }
        
    }
    
    
    //MARK: --
    func toWebVC(_ url: String) {
        if url.range(of: "about:blank") != nil {
            return
        }
        
        var title = ""
        if url.range(of: "search") != nil {
            title = kLocalized("classification")
        }else if url.range(of: "top") != nil {
            title = kLocalized("list")
        }else if url.range(of: "free") != nil {
            title = kLocalized("free")
        }else if url.range(of: "pay") != nil {
            MQIUserOperateManager.shared.toPayVC(nil)
            return
        }else if url.range(of: "book") != nil {
            let array = url.components(separatedBy: "/book/")
            if array.count > 1 {
                let bookId = array[1].replacingOccurrences(of: ".html", with: "")
                if NSString(string: bookId).integerValue > 0 {
                    
                    //                    let bookInfoVC = GYBookOriginalInfoVC()
                    let bookInfoVC = GDBookInfoVC()
                    bookInfoVC.bookId = bookId
                    
                    /*
                     let bookInfoVC = GYBookInfoVC()
                     bookInfoVC.bookId = bookId
                     bookInfoVC.url = url
                     bookInfoVC.sTitle = "书籍详情"
                     */
                    pushVC(bookInfoVC)
                    return
                }else {
                    title = kLocalized("BookInfo")
                }
            }else {
                title = kLocalized("BookInfo")
            }
            
        }else {
            title = kLocalized("detailed")
        }
        let vc = MQIWebVC()
        vc.url = url
        vc.title = title
        pushVC(vc)
    }
    func New_payRequestServer(_ action:String,params:String ,success:String, failed:String , complete:((_ suc:Bool, _ jsonString:String)->())?) {
        //解析params
        
        GDH5ActionToServerRequest(action: action, params: params).gd_AllrequestCollection({ (request, response, result:[GYEachUserCoupon]) in
            if let data = response?.data {
                let jsonString = String(data: data, encoding: String.Encoding.utf8)
                //                MQLog(jsonString)
                complete?(true,jsonString!)
            }
        }) { (msg, code, http_code) in
            //            MQLog(" \(msg)   \(code)  \(http_code)")
            if http_code == "401" {
                MQIloginManager.shared.toLogin(kLocalized("SorryYouHavenLoggedInYet"), finish: {[weak self]()->Void in
                    if let strongSelf = self {
                        strongSelf.webView.reload()
                    }
                })
            }else {
                let param = ["code":"\(code)","message":"\(msg)"]
                let jsonString = dictionaryToJsonString(param)
                complete?(false,jsonString)
            }
        }
    }
    
}
