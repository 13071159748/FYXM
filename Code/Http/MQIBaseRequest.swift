//
//  MQIBaseRequest.swift
//  Nymph
//
//  Created by CQSC  on 15/10/23.
//  Copyright © 2015年  CQSC. All rights reserved.
//

import UIKit
/*
 拉拉
 */
import Alamofire

//登录API



//充值页面
func payHttpURL() -> String {
    return "\(BASEHTTPURL)pay/index/v3"
}
//反馈
func feedBackHttpURL() -> String {
    return "\(BASEHTTPURL)feedback/list"
}

//反馈列表
func feedBackListHttpURL() -> String {
    return "\(BASEHTTPURL)feedback/my"
}

//帮助页面
func helpHttpURL() -> String {
    return "\(BASEHTTPURL)main/help"
}
//报错
func anErrorHttpURL() -> String {
    return "\(BASEHTTPURL)feedback/chapter-error-add"
}
/*****************************************/

let defaultTimeOutInterval: TimeInterval = 60

let baseURL: String = "https://cqscrest.legendnovel.com/v1/"
let base_URL_CDN: String  = "https://cqscrestcdn.legendnovel.com/v1/"
let BASEHTTPURL: String  = "https://cqsch5.legendnovel.com/v1/"
let BASEHTTPURL_CDN: String  = "https://cqsch5cdn.legendnovel.com/v1/"
let hostname:String =  "www.cqscrest.legendnovel.com"

let hostWhiteList = [
    "cqscrestcdn.legendnovel.com",
    "cqsch5.legendnovel.com",
    "cqsch5cdn.legendnovel.com",
    "cqscrest.legendnovel.com",
]


/// 分享
let BASESHAREDHTTPURL = BASEHTTPURL
/// 埋点上报
let BuriedPoint_URL  =  "https://report.dmw11.com:8088/log"

class MQIBaseRequest: NSObject {
    var isCDN:Bool = false
    var host: String {
        get {
//            return  isCDN ? base_URL_CDN:baseURL
            return baseURL
        }
        
    }
    var path: String = ""
    
    var encoding: ParameterEncoding = URLEncoding.default
    var method: Alamofire.HTTPMethod = HTTPMethod.post {
        didSet {
            encoding = method == HTTPMethod.post ? JSONEncoding.default : URLEncoding.default
        }
    }
    var headers = [String : String]()
    var param: Parameters?
    var bodyDatas: [String : (data: Data, fileName: String, mimeType: String)]?
    
    var timeoutInverval: TimeInterval = defaultTimeOutInterval
    
    var manager: SessionManager!
    
    var needToken: Bool = true
    
    var urlPath: String! {
        return "\(host)"
    }
    
    override init() {
        super.init()
        
    }
    
    func addHeaders() {
        if needToken == true {
            let token = MQIUserManager.shared.user == nil ? "" : MQIUserManager.shared.user!.access_token
            headers["Authorization"] = "Bearer \(token)"
        }
        headers["user-agent"] = "\(TARGET_NAME_EN)/ios \(UIDevice.current.modelName)"
        headers["Accept"] = "application/vnd.api.v1.0+json"
        headers["charset"] = "utf-8"
        headers["X-App-Version"] = getCurrentVersion()
        headers["X-App-Channel"] = "apple"
        headers["X-APP-FC"] = FC_Str ?? "1"
        headers["X-APP-FC2"] = "1"
        headers["Device-Uuid"] = DEVICEID
        headers["X-Device-Time"] = GetCurrent_millisecondIntervalSince1970String()
        headers["Accept-Language"] = DSYLanguageControl.currentLanStr
        
        //      headers["Host"] = "app.moqing.com"
    }
    
    
    func cleanCookies() {
        let array:NSArray = HTTPCookieStorage.shared.cookies! as NSArray
        
        for cookieie in array{
            if let cookie:HTTPCookie = cookieie as? HTTPCookie{
                HTTPCookieStorage.shared.deleteCookie(cookie)
                //            gLog(cookie)
            }
        }
    }
    
    /**
     请求 数据 返回 model
     
     - parameter completion:     成功 返回值
     - parameter response:       urlResponse
     - parameter result:         遵循 BaseModelSerializable 的 BaseModel 子类
     - parameter failureHandler: 失败 返回
     - parameter err_code:       错误码
     */
    func request<T: MQIBaseModel>(_ completion: @escaping ((_ request: URLRequest?, _ response: HTTPURLResponse?, _ result: T) -> ()),
                                  failureHandler: @escaping (_ err_msg: String, _ err_code: String) -> ()) {
        cleanCookies()
        addHeaders()
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInverval
        configuration.httpMaximumConnectionsPerHost = 10
        manager = Alamofire.SessionManager(configuration: configuration)
        manager.delegate.sessionDidReceiveChallenge = {
            session,challenge in
            return    (URLSession.AuthChallengeDisposition.useCredential,URLCredential(trust:challenge.protectionSpace.serverTrust!))
        }
        
        manager.request(host+path,
                        method: method,
                        parameters: param,
                        encoding: encoding,
                        headers: headers).responseObject { (response: DataResponse<T>) in
                            
                            self.logContentOrError(content: response.result.value, error: response.result.error)
                            if let model = response.result.value {
                                completion(response.request, response.response, model)
                            }else {
                                if let error = response.result.error {
                                    if let msg = (error as NSError).userInfo["msg"] {
                                        let code = (error as NSError).code
                                        self.checkAuth(code, completion: ({(reloadRequest: Bool) -> Void in
                                            if reloadRequest == true {
                                                self.request(completion, failureHandler: failureHandler)
                                            }else {
                                                
                                                failureHandler("\(msg)", "\(code)")
                                            }
                                            
                                        }))
                                    }else if error is BackendError {
                                        failureHandler(kLocalized("TheNetworkIsOffPleaseTryItLater"), "-1")
                                    }else {
                                        failureHandler(kLocalized("TheNetworkIsOffPleaseTryItLater"), "-1")
                                    }
                                }else {
                                    failureHandler(kLocalized("TheNetworkIsOffPleaseTryItLater"), "-1")
                                }
                            }
        }
    }
    
    func gd_WelfareRequest<T:MQIBaseModel>(_ completion: @escaping ((_ request: URLRequest?, _ response: DataResponse<T>?) -> ())) {
        cleanCookies()
        addHeaders()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInverval
        configuration.httpMaximumConnectionsPerHost = 10
        manager = Alamofire.SessionManager(configuration: configuration)
        manager.delegate.sessionDidReceiveChallenge = {
            session,challenge in
            return    (URLSession.AuthChallengeDisposition.useCredential,URLCredential(trust:challenge.protectionSpace.serverTrust!))
        }
        manager.request(host+path,
                        method: method,
                        parameters: param,
                        encoding: encoding,
                        headers: headers).responseObject { (response:DataResponse<T>) in
                            
                            completion(response.request,response)
        }
        
    }
    
    
    /**
     请求 数据 返回 固定格式 -  [T]数组 resultModel（next, previous, count）
     
     - parameter completion:     成功 返回值
     - parameter response:       urlResponse
     - parameter result:         遵循 BaseModelSerializable 的 BaseModel 子类
     - parameter failureHandler: 失败 返回
     - parameter err_code:       错误码
     */
    func requestCollection<T: ResponseCollectionSerializable>(_ completion: @escaping ((_ request: URLRequest?, _ response: DataResponse<[T]>?, _ result: [T]) -> ()), failureHandler: @escaping (_ err_msg: String, _ err_code: String) -> ()) {
        
        cleanCookies()
        addHeaders()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInverval
        configuration.httpMaximumConnectionsPerHost = 10
        manager = Alamofire.SessionManager(configuration: configuration)
        manager.delegate.sessionDidReceiveChallenge = {
            session,challenge in
            return    (URLSession.AuthChallengeDisposition.useCredential,URLCredential(trust:challenge.protectionSpace.serverTrust!))
        }
        manager.request(host+path,
                        method: method,
                        parameters: param,
                        encoding: encoding,
                        headers: headers).responseCollection { (response: DataResponse<[T]>) in
                            if let model = response.result.value {
                             
                                completion(response.request, response, model)
                            }else {
                                if let error = response.result.error {
                                    if let msg = (error as NSError).userInfo["msg"] {
                                        let code = (error as NSError).code
                                        self.checkAuth(code, completion: ({(reloadRequest: Bool) -> Void in
                                            if reloadRequest == true {
                                                self.requestCollection(completion, failureHandler: failureHandler)
                                            }else {
                                                
                                                failureHandler("\(msg)", "\(code)")
                                            }
                                            
                                        }))
                                    }else if error is BackendError {
                                        //                                 failureHandler((error as! BackendError).localizedDescription, "-1")
                                        failureHandler(kLocalized("TheNetworkIsOffPleaseTryItLater"), "-1")
                                        
                                    }else {
                                        failureHandler(kLocalized("TheNetworkIsOffPleaseTryItLater"), "-1")
                                    }
                                }else {
                                    failureHandler(kLocalized("TheNetworkIsOffPleaseTryItLater"), "-1")
                                }
                            }
        }
    }
    
    
    
    
    /**
     请求 数据 返回 固定格式 -  [T]数组 resultModel（next, previous, count）
     
     - parameter completion:     成功 返回值
     - parameter response:       urlResponse
     - parameter result:         遵循 BaseModelSerializable 的 BaseModel 子类
     - parameter failureHandler: 失败 返回
     - parameter err_code:       错误码
     */
    func gd_AllrequestCollection<T: ResponseCollectionSerializable>(_ completion: @escaping ((_ request: URLRequest?, _ response: DataResponse<[T]>?, _ result: [T]) -> ()), failureHandler: @escaping (_ err_msg: String, _ err_code: String,_ http_code:String) -> ()) {
        
        cleanCookies()
        addHeaders()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInverval
        configuration.httpMaximumConnectionsPerHost = 10
        manager = Alamofire.SessionManager(configuration: configuration)
        manager.delegate.sessionDidReceiveChallenge = {
            session,challenge in
            return    (URLSession.AuthChallengeDisposition.useCredential,URLCredential(trust:challenge.protectionSpace.serverTrust!))
        }
        manager.request(host+path,
                        method: method,
                        parameters: param,
                        encoding: encoding,
                        headers: headers).responseCollection { (response: DataResponse<[T]>) in
                            
                            if let model = response.result.value {
                                //                           let dic = try? JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                //                           MQLog(dic)
                                completion(response.request, response, model)
                            }else {
                                if let error = response.result.error {
                                    if let msg = (error as NSError).userInfo["msg"] {
                                        let code = (error as NSError).code
                                        self.checkAuth(code, completion: ({(reloadRequest: Bool) -> Void in
                                            if reloadRequest == true {
                                                self.gd_AllrequestCollection(completion, failureHandler: failureHandler)
                                            }else {
                                                
                                                failureHandler("\(msg)", "\(code)","\(String(describing: response.response?.statusCode))")
                                            }
                                            
                                        }))
                                    }else if error is BackendError {
                                        failureHandler(kLocalized("TheNetworkIsOffPleaseTryItLater"), "-1","1000000")
                                        
                                    }else {
                                        failureHandler(kLocalized("TheNetworkIsOffPleaseTryItLater"), "-1","1000000")
                                    }
                                }else {
                                    failureHandler(kLocalized("TheNetworkIsOffPleaseTryItLater"), "-1","1000000")
                                }
                            }
        }
    }
    
    /// 上传点击数据
    ///
    /// - Parameters:
    ///   - eventData: 点击数据
    ///   - completion: 成功 返回
    ///   - failureHandler: 失败 返回
    func uploadEventData(eventData:Data , completion: @escaping ((_ result: String) -> ()),failureHandler: @escaping (_ err_msg: String, _ err_code: String) -> ()) {
        Alamofire.upload(eventData, to: BuriedPoint_URL, method: .post, headers: headers)
            .validate()
            .responseJSON { response in
                if response.result.isSuccess {
                    mqLog("成功")
                    completion("")
                }
                if response.result.isFailure {
                    mqLog("失败\(String(describing: response.result.error?.localizedDescription))")
                    if let error = response.result.error {
                        if let msg = (error as NSError).userInfo["msg"] {
                            let code = (error as NSError).code
                            failureHandler("\(msg)", "\(code)")
                        }else if error is BackendError {
                            failureHandler(kLocalized("TheNetworkIsOffPleaseTryItLater"), "-1")
                        }else {
                            failureHandler(kLocalized("TheNetworkIsOffPleaseTryItLater"), "-1")
                        }
                    }else {
                        failureHandler(kLocalized("TheNetworkIsOffPleaseTryItLater"), "-1")
                    }
                    
                }
                
        }
        
        
    }
    
    /**
     请求 数据 返回 model    -----  上传头像
     
     - parameter completion:     成功 返回值
     - parameter response:       urlResponse
     - parameter result:         遵循 BaseModelSerializable 的 BaseModel 子类
     - parameter failureHandler: 失败 返回
     - parameter err_code:       错误码
     */
    func gd_UploadRequest(imgdata:Data , completion: @escaping ((_ result: String) -> ()),
                          failureHandler: @escaping (_ err_msg: String, _ err_code: String) -> ()) {
        
        
        cleanCookies()
        addHeaders()
        
//        var imgData:Data?
     
//        if let jpegData = UIImageJPEGRepresentation(img, 1.0) {
//            imgData = jpegData
//        }
//        if let pngData = UIImagePNGRepresentation(img){
//            imgData = pngData
//            mimetype = "image/png"
//        }
//        if imgData == nil {
//            failureHandler("上传失败","-1")
//            return}
        let mimetype = "image/jpeg"
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInverval
        configuration.httpMaximumConnectionsPerHost = 10
        manager = Alamofire.SessionManager(configuration: configuration)
        
        manager.delegate.sessionDidReceiveChallenge = {
            session,challenge in
            return    (URLSession.AuthChallengeDisposition.useCredential,URLCredential(trust:challenge.protectionSpace.serverTrust!))
        }
        
        manager.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imgdata, withName: "avatar", fileName: "headImg.jpg", mimeType: mimetype)
            
        }, to: host + path,headers:headers) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let _ = response.result.value as? [String: AnyObject]{
                        let dic = try? JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        
                        if let dic = dic {
                            let model = MQIUpLoadModel.init(jsonDict:dic as! [String : Any])
//                            if model.code == 401{
//                                self.checkAuth(401, completion: ({(reloadRequest: Bool) -> Void in
//                                    if reloadRequest == true {
//                                        self.gd_UploadRequest(imgData:imgData,completion:completion, failureHandler: failureHandler)
//                                    }else {
//
//                                    }
//                                }))
//                                return
//                            }
                            if model.code == 200 {
                                completion(model.data.avatar_url)
                            }else {
                                if model.desc.count > 0  {
                                    failureHandler(model.desc,"-1")
                                }else if (dic.object(forKey: "error_code") != nil){
                                    failureHandler(dic.object(forKey: "error_code") as! String,"-1")
                                }
                            }
                            return
                        }
                        completion("")
                    }else {
                        if let error = response.result.error {
                            if let msg = (error as NSError).userInfo["msg"] {
                                let code = (error as NSError).code
                                self.checkAuth(code, completion: ({(reloadRequest: Bool) -> Void in
                                    if reloadRequest == true {
                                        self.gd_UploadRequest(imgdata:imgdata,completion:completion, failureHandler: failureHandler)
                                    }else {
                                        
                                        failureHandler("\(msg)", "\(code)")
                                    }
                                    
                                }))
                            }else if error is BackendError {
                                failureHandler(kLocalized("TheNetworkIsOffPleaseTryItLater"), "-1")
                            }else {
                                failureHandler(kLocalized("TheNetworkIsOffPleaseTryItLater"), "-1")
                            }
                        }else {
                            failureHandler(kLocalized("TheNetworkIsOffPleaseTryItLater"), "-1")
                        }
                        
                        
                    }
                }
            case .failure( _):
                failureHandler(kLocalized("TheNetworkIsOffPleaseTryItLater"), "-1")
                break
            }
        }
    }
    
    /**
     请求 数据 返回 model
     
     - parameter completion:     成功 返回值
     - parameter response:       urlResponse
     - parameter result:         遵循 BaseModelSerializable 的 BaseModel 子类
     - parameter failureHandler: 失败 返回
     - parameter err_code:       错误码
     */
    func requestAuth<T: MQIBaseModel>(_ completion: @escaping ((_ request: URLRequest?, _ response: HTTPURLResponse?, _ result: T) -> ()),
                                      failureHandler: @escaping (_ err_msg: String, _ err_code: String) -> ()) {
        cleanCookies()
        addHeaders()
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInverval
        configuration.httpMaximumConnectionsPerHost = 10
        manager = Alamofire.SessionManager(configuration: configuration)
        manager.delegate.sessionDidReceiveChallenge = {
            session,challenge in
            return    (URLSession.AuthChallengeDisposition.useCredential,URLCredential(trust:challenge.protectionSpace.serverTrust!))
        }
        manager.request(host+path,
                        method: method,
                        parameters: param,
                        encoding: encoding,
                        headers: headers).responseObject { (response: DataResponse<T>) in
                            print("RequestURL = \(String(describing: response.request?.url))")
                            print("param = \(String(describing: self.param))")
                            print(self.manager)
                            if let model = response.result.value {
                                completion(response.request, response.response, model)
                            }else {
                                if let error = response.result.error {
                                    if let msg = (error as NSError).userInfo["msg"] {
                                        let code = (error as NSError).code
                                        failureHandler("\(msg)", "\(code)")
                                        
                                    }else {
                                        failureHandler(kLocalized("TheNetworkIsOffPleaseTryItLater"), "-1")
                                    }
                                }
                            }
        }
    }
    var alreadyCheck: Bool = false
    var needLogin: Bool = false
    func checkAuth(_ code: Int, completion: ((_ reloadRequest: Bool) -> ())?) {
        if code == 401 {
            if alreadyCheck == true {
                MQILoadManager.shared.makeToast(kLocalized("AccounVerificationHasExpired"))
                MQIUserManager.shared.loginOut(kLocalized("AccounVerificationHasExpired"), finish: { (suc) in
                    completion?(false)
                })
                return
            }
            if needLogin == true {
                alreadyCheck = true
                if let user = MQIUserManager.shared.user {
                    let mobile = "\(user.user_mobile!)"
                    let psw = "\(user.user_password)"
                    
                    if mobile.count <= 0 || psw.count <= 0 {
                        MQIUserManager.shared.user = nil
                        MQIFileManager.removePath(MQIUserManager.shared.userPath)
                        completion?(false)
                        return
                    }
                    manager.request(host+path,
                                    method: HTTPMethod.post,
                                    parameters: param,
                                    encoding: encoding,
                                    headers: headers).responseObject { (response: DataResponse<GYResponseModel>) in
                                        
                                        //                                 gLog("RequestURL = \(String(describing: response.request?.url))")
                                        //                                 gLog("param = \(String(describing: self.param))")
                                        //                                 gLog(self.manager)
                                        
                                        if let result = response.result.value {
                                            paseUserObject(result)
                                            
                                            if let user = MQIUserManager.shared.user {
                                                user.user_mobile = mobile
                                                user.user_password = psw
                                                MQIUserManager.shared.saveUser()
                                            }
                                            
                                            completion?(true)
                                        }else {
                                            MQIUserManager.shared.user = nil
                                            MQIFileManager.removePath(MQIUserManager.shared.userPath)
                                            completion?(false)
                                        }
                                        
                                        
                    }
                }else {
                    completion?(false)
                }
            }
            //TODO:  新接口不刷新token
            completion?(false)
            
            //         if let user = MQIUserManager.shared.user {
            //            GYUserRefreshTokenRequest()
            //               .requestAuth({ (request, response, result: MQIAuthorizationModel) in
            //                  user.refresh_token = result.refresh_token
            //                  user.access_token = result.access_token
            //                  MQIUserManager.shared.user?.refresh_token = result.refresh_token
            //                  MQIUserManager.shared.user?.access_token = result.access_token
            //                  MQIUserManager.shared.saveUser()
            //                  completion?(true)
            //               }, failureHandler: { (err_msg, err_code) in
            //                  self.needLogin = true
            //                  self.checkAuth(code, completion: completion)
            //               })
            //         }else {
            //            completion?(false)
            //         }
        }else {
            if  code == 5005  {
                if let id = MQIUserManager.shared.user?.user_id.integerValue() {
                    ///删除当前用户token
                    try? XMDBTool.shared.update(user: id, values: [XMUserAttribute.token("")])
                    MQIUserManager.shared.getHistoryLogDataFunc()
                }
                MQIUserManager.shared.loginOut(" ", finish: { (suc) in
                    completion?(false)
                })
                MQIShelfBackBouncedView.showBouncedView(true) { (c) in
                    //               DownNotifier.postNotification(.clickTabbar, object: nil, userInfo: ["index" : 1])
                    }.titleLable.text = "帐号已在其他设备登录，请检查账号安全性！"
                
                
            }else if  code == 5006 {
                MQIUserManager.shared.loginOut(" ", finish: { (suc) in
                    completion?(false)
                })
                MQIShelfBackBouncedView.showBouncedView(true) { (c) in
                    
                    }.titleLable.text = "帐号验证已过期，请重新登录！"
                
            }else{
                completion?(false)
            }
            
        }
        
    }
    
    
    func logContentOrError(content: MQIBaseModel?, error: Error?) {
        if let con = content {
            if con.obj == nil {
                mqLog("---- hostURL: \(self.host)\(self.path) param: \(self.param ?? [:])  dict: \(con.dict.debugDescription)")
            }else{
                mqLog("---- hostURL: \(self.host)\(self.path) param: \(self.param ?? [:])  obj: \(con.obj.debugDescription)")
            }
          
            return
        }
        if let error = error {
            mqLog("---- hostURL: \(self.host)\(self.path) param: \(self.param ?? [:])  error_msg: \(error.localizedDescription)  error_code \((error as NSError).code)")
            return
        }
        
    }
        
}






