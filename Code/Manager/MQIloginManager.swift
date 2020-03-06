//
//  MQIloginManager.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/6/28.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit
import FirebaseDynamicLinks
import GoogleSignIn

enum LoginType:Int {
    /// 微信
    case Wechat = 1
    /// Facebook
    case Facebook = 16
    /// Twitter
    case Twitter = 17
    /// Line
    case Linkedin = 22
    /// Google
    case Google = 30
    /// 邮箱
    case Email = 50
    /// 手机号
    case Mobile = 1000
    /// 其他方式
    case other = 1001
    
    func conversion()->String {
        switch self {
        case .Wechat:  return "1"
        case .Facebook: return "16"
        case .Twitter: return "17"
        case .Linkedin:  return "22"
        case .Google:  return  "30"
        case .Email:  return  "50"
        case .Mobile:  return  "1000"
        default:
            return "1001"
        }
    }
    
    
    static  func createType(_ typeStr:String) -> LoginType {
        switch typeStr {
        case "1"  : return .Wechat
        case "16" : return .Facebook
        case "17" : return .Twitter
        case "22": return .Linkedin
        case "30": return .Google
        case "50": return .Email
        case "1000": return .Mobile
        default:
            return .other
        }
    }
    
    
}
/// 登录控制类
class MQIloginManager: NSObject {
    static let  shared = MQIloginManager()
    
    var loginBegin: (() -> ())?
    /// 登录回调
    var loginSuccess: ((_ success:Bool) -> ())?
    weak var fromVC:UIViewController?
    
    
    var type:LoginType = .Mobile {
        didSet(oldValue) {
            getLoginTypeoperation(type)
        }
        
    }
    
    
    func getLoginTypeoperation(_ type:LoginType) -> Void {
        switch type {
        case .Wechat:
            wechatLogin()
            return
        case .Facebook:
            if let vc  = fromVC {
                facebookLogin(vc: vc)
            }else{
                MQILoadManager.shared.makeToast(kLocalized("LoginFailed"))
                loginSuccess?(false)
            }
            
            return
        case .Twitter:
            twitterLogin()
            return
        case .Linkedin:
            lineLogin()
            return
        case .Google:
            googleLogin(false)/// 先退登
            googleLogin()
            return
        case .Mobile:
            
            return
        default:
            mqLog("其他")
            return
        }
    }
    
    
    
    var need: Bool = true
    var lock = NSLock()
    func toLogin(_ text: String?, finish: @escaping () -> ()) {
        
        //        if MQIPayTypeManager.shared.type == .inPurchase {
        //             MQILoadManager.shared.makeToast(kLocalized("SorryYouHavenLoggedInYet"))
        //
        //        }
        lock.lock()
        if need == true {
            self.need = false
            MQILoadManager.shared.addPayLoginAlert("", successBlock: {[weak self] (type) in
                if let strongSelf = self {
                    strongSelf.loginBegin?()
                    if type == .other {
                        MQIUserOperateManager.shared.toLoginVC({
                            strongSelf.loginBegin = nil
                            finish()
                        })
                        
                    } else {
                        MQIloginManager.shared.fromVC = gd_currentViewController()
                        MQIloginManager.shared.loginSuccess = {(success:Bool) -> Void in
                            if success {
                               finish()
                            }
                            strongSelf.loginBegin = nil
                        }
                        MQIloginManager.shared.type = type
                    }
                    strongSelf.need = true
                }
                
            }) { [weak self]()->Void in
                if let strongSelf = self {
                    strongSelf.need = true
                }

            }
            lock.unlock()
        }
        
    }
    
    /// 设置Google代理
    func setGoogleDelegate() -> Void {
        GIDSignIn.sharedInstance().delegate = self
        //MARK:   vc 必须遵循 GIDSignInUIDelegate
//        GIDSignIn.sharedInstance().uiDelegate = vc as! GIDSignInUIDelegate
    }
    //    "获取微信 ACCESS_TOKEN 出错：{\"errcode\":40029,\"errmsg\":\"invalid code, hints: [ req_id: 30R2TA08918801 ]\"}"
    /// 登录方法
    private func loginRequest(_ R:MQIBaseRequest) {
        MQILoadManager.shared.addProgressHUD(kLocalized("InTheLogin"))
        R.request({[weak self] (request, response, result:  MQIBaseModel) in
            
            if let strongSelf = self {
                paseUserObject(result)
                MQIUserManager.shared.saveUser()
                MQIUserManager.shared.updateUserState(checkedIn: 1, lastLoginType: strongSelf.type.rawValue)
                UserNotifier.postNotification(.login_in)
                strongSelf.loginSuccess?(true)
            }
            
            MQILoadManager.shared.dismissProgressHUD()
            MQILoadManager.shared.makeToast(kLocalized("LoginSuccessful"))
            
            }, failureHandler: { [weak self]  (err_msg, err_code) in
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(err_msg)
                if let strongSelf = self {
                    strongSelf.loginSuccess?(false)
                }
        })
    }
    
}

//MARK: 配置第三方
extension MQIloginManager {
    
    
    /// 程序启动配置
    func configSDK(_ application:UIApplication,launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Void {
        
        /// 配置Twitter
        TWTRTwitter.sharedInstance().start(withConsumerKey:TWITTER_APIkey, consumerSecret:TWITTER_Secretkey)
        /// 配置Google
        GIDSignIn.sharedInstance().clientID = KGOOGLEKey
        // https://developers.google.cn/identity/sign-in/ios/offline-access
        GIDSignIn.sharedInstance()?.serverClientID = KGOOGLEServerKey
        
        configPersistentSDK(application, launchOptions: launchOptions)
        
        FC_Str = getFCStr()
    }
    /// 配置登录sdk
    func configLoginSDK(_ application:UIApplication) -> Void {
        
        setGoogleDelegate()
    }
    
    
    /// 配置持久运行的sdk
    func configPersistentSDK(_ application:UIApplication,launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Void {
        /// 配置微信
        WXApi.registerApp(KWXAppID)
        /// 配置Facebook  launchOptions:[UIApplicationLaunchOptionsKey.annotation: "Any"]
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions:launchOptions)
        //   FBSDKSettings.setAutoLogAppEventsEnabled(true)
        //        FBSDKSettings.setAutoLogAppEventsEnabled(true)
    }
    
    
    
    /// OPENURL
    func loginApplication(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if WXApi.handleOpen(url, delegate: self) {
            
            return true
        }
        
        if ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) {
            
            return true
        }
        if GIDSignIn.sharedInstance()?.handle(url as URL?) ?? false {
            
            return true
        }
        
        if LineSDKLogin.sharedInstance().handleOpen(url) {
            
            return true
        }
        
        if TWTRTwitter.sharedInstance().application(application, open: url, options: [UIApplication.OpenURLOptionsKey.annotation : annotation]) {
            
            return true
        }
        
        if  deepLinksClick(url) {
            return true
        }
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            if  let url = dynamicLink.url {
                return  dynamicLinks(url)
            }
            
            return false
        }
        
        return false
    }
    /// OPENURL
    func loginApplication(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool{
        
        if WXApi.handleOpen(url, delegate: self) {
            
            return true
        }
        
        if ApplicationDelegate.shared.application(app, open: url, options: options) {
            
            return true
        }
        if GIDSignIn.sharedInstance()?.handle(url as URL?) ?? false {
            
            return true
        }
        if LineSDKLogin.sharedInstance().handleOpen(url) {
            
            return true
        }
        
        
        if TWTRTwitter.sharedInstance().application(app, open: url, options: options) {
            
            return true
        }
        if  deepLinksClick(url) {
            return true
        }
        
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            if  let url = dynamicLink.url {
                return  dynamicLinks(url)
            }
            return false
        }
        
        
        return false
    }
    
    ///深度链接点击
    @discardableResult  func deepLinksClick( _ url:URL)  -> Bool {
        let prefix = deepLinkStr
        var   results  = false
        if url.absoluteString.contains(prefix) {
                results = true
                let srt = url.absoluteString
                let arr = srt.components(separatedBy: "?")
                if arr.count >= 2 {
                    if let url_new = URL(string: arr[0]) {
                        MQIOpenlikeManger.toPath(url_new)
                    }
                }

            }
        return results
    }
    ///动态链接
    @discardableResult  func dynamicLinks( _ url:URL)  -> Bool {
        if   let  components = URLComponents(url: url, resolvingAgainstBaseURL: true){
            if let url_new = components.url {
                var testArr = url_new.path.components(separatedBy: "/")
                                testArr = testArr.filter({ $0 != "" && $0 != " " })
                                if testArr.first == "applinks" {
                                    testArr.removeFirst()
                                    MQIOpenlikeManger.toPath(url)
                                }
                            }
            /// 获取fc
            for item  in components.queryItems ?? [URLQueryItem]()  {
                if item.name == "fc" {
                    if let value = item.value {
                        FC_Str = value
                    }
                }
            }
            if FC_Str == nil {
                UserDefaults.standard.set("\(getCurrentStamp()+60*60*24*7+1)_fc_\(FC_Str!)", forKey: "FC_Str_FC_Str_7_date")
                UserDefaults.standard.synchronize()
            }
        }
        
        return false
    }
    
    fileprivate  func getFCStr() -> String? {
        if  var  fcArr =  UserDefaults.standard.string(forKey: "FC_Str_FC_Str_7_date")?.components(separatedBy: "_fc_") {
            fcArr = fcArr.filter({$0 != "" && $0 != " "})
            if fcArr.first?.integerValue() ?? 0 > getCurrentStamp() {
                return fcArr.last
            }
        }
        
        return nil
    }
    
}


////MARK:  weicahat
extension MQIloginManager:WXApiDelegate{
    
    func wechatLogin() -> Void {
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = KWXSTATE
        WXApi.send(req)
    }
    
    //MARK: WXDelegate
    func onResp(_ resp: BaseResp) {
        
        if resp.isKind(of: SendAuthResp.classForCoder()) {
            let response = resp as! SendAuthResp
            if response.errCode == 0 {
                if response.state != KWXSTATE {
                    MQILoadManager.shared.makeToast(kLocalized("LoginFailed"))
                    return
                }
                
                //            self.loginRequest(MQIUserWXLoginRequest(auth_code: response.code, device_id: DEVICEID, bind: false)) /// 0712sZze0oRnWt1M9mBe0q2Xze02sZzh
                if let auth_code = response.code {
                    mqLog("\(auth_code)")
                    self.loginRequest(GYUserSnsPathtRequest("weixin", param: ["code":auth_code]))
                }
                
                
            }else {
                loginSuccess?(false)
                MQILoadManager.shared.makeToast(response.errStr)
                if resp.errCode == -2 {
                    //                         MQILoadManager.shared.makeToast("已取消登录")
                    MQILoadManager.shared.makeToast(kLocalized("LoginFailed"))
                }
                
            }
        }
    }
    
}

//MARK:  Facebook
extension MQIloginManager {
    
    func facebookLogin(vc:UIViewController) -> Void {
        
        //        // 打开 FBSDKProfile 自动追踪 FBSDKAccessToken
        //           FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        //        // 清空FBSDKAccessToken
        //        FBSDKAccessToken.setCurrent(nil)
        
        clearCookiesForDomain("facebook")
        let loing = LoginManager()
        loing.logOut()
        loing.authType = LoginAuthType(rawValue: "reauthenticate")
        //      let cookieStore = HTTPCookieStorage.sortedCookies(HTTPCookieStorage.init())
        loing.loginBehavior = .browser
        //        let permissions = ["public_profile","user_actions.news","user_birthday","user_education_history","email","user_friends","user_likes","user_relationships"]
        //        let permissions = ["public_profile","user_birthday","email","user_friends","user_likes"]
        //
        //        MQLog("\(FBSDKAccessToken.current())")
        loing.logIn(permissions: ["email"], from: vc) {[weak self] (result, error) in
            if error != nil {
                mqLog("\(String(describing: error))")
                MQILoadManager.shared.makeToast(kLocalized("LoginFailed"))
                if let strongSelf = self {
                    strongSelf.loginSuccess?(false)
                }
            }else if result!.isCancelled {
                MQILoadManager.shared.makeToast(kLocalized("LoginFailed"))
                if let strongSelf = self {
                    strongSelf.loginSuccess?(false)
                }
            }else{
                guard let token = AccessToken.current?.tokenString else {
                    MQILoadManager.shared.makeToast(kLocalized("InformationAcquisitionFailure"))
                    if let strongSelf = self {
                        strongSelf.loginSuccess?(false)
                    }
                    return
                }
                mqLog("\(token)")
                if let strongSelf = self {
                    //                    strongSelf.loginRequest(MQIUserFacebookLoginRequest.init(access_token: token))
                    strongSelf.loginRequest(GYUserSnsPathtRequest("facebook", param: ["access_token":token]))
                }else{
                    MQILoadManager.shared.dismissProgressHUD()
                }
                
                
                //                    let request = FBSDKGraphRequest.init(graphPath: result?.token?.userID, parameters: ["fields":"id,name,email,age_range,first_name,last_name,link,gender,locale,picture,timezone,updated_time,verified"], httpMethod: "GET")
                //                    request!.start(completionHandler: { (connection, resultabc, error) in
                //                        let resultDic = resultabc as! NSDictionary
                //                        guard  let userid:String = resultDic["id"] as? String,let account:String = resultDic["name"] as? String  else{
                //                            return
                //                        }
                //                        let heardUrl:String = "https://graph.facebook.com/\(userid))/picture?type=large"
                //                         MQLog("\(userid),\(account),\(heardUrl)")
                
                //                    })
                
            }
            
        }
        
        
    }
    
    
}


//MARK:  Google
extension MQIloginManager: GIDSignInDelegate{
    
    func googleLogin(_ isSign:Bool = true) -> Void {
        configLoginSDK(UIApplication.shared)
        GIDSignIn.sharedInstance()?.presentingViewController = gd_currentViewController()
        if isSign {
            GIDSignIn.sharedInstance().signIn()
        }else{
            GIDSignIn.sharedInstance().signOut()
        }
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            mqLog("登录失败 \(error)")
            MQILoadManager.shared.makeToast(kLocalized("LoginFailed"))
            loginSuccess?(false)
        }else{
            mqLog("登录成功\(user.userID)")
            //            let token = user.authentication.idToken
            //            let name = user.profile.name
            //            guard let authentication = user.authentication else { return }
            //
            //            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
            //            return
            //        }
            //            guard let token =  user.authentication.idToken else {
            //                MQILoadManager.shared.makeToast(kLocalized("InformationAcquisitionFailure"))
            //                loginSuccess?(false)
            //                return
            //            }
            guard let token =  user.serverAuthCode else {
                MQILoadManager.shared.makeToast(kLocalized("InformationAcquisitionFailure"))
                loginSuccess?(false)
                return
            }
            //        / "4/xgC7Gx8SvDmXpdusmPuFER7_3IqeVf4_odOVhKhZv6JBk8GXFx4hH0QAAUeFeH1gPkDkTb4Ek91XA5vH94ol3NM
            //            /4%2FxgAYeuo9zhRSGYXcHMJl6-u7A8n_z9DdFARCBxUjGuUWRzWgjDZFPyikrQw4MHk5ILBupFsIBwDAuYs7P_R7GF4
            //            /  "4%2FxgANPNDxqBimRmXGANcc5zIlTOzobLc_9MtpWnsq3M9VIYVyoD60g5VWPF8egZBbOAtNtJ6F2z-hcWYZVJyg_0w"
            //            self.loginRequest(MQIUserGoogleLoginRequest.init(id_token: token))
            
            
            self.loginRequest(GYUserSnsPathtRequest("google", param:["code": token]))
            
        }
    }
    
    /// 退登
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            mqLog("授权失败 \(error)")
            return
        }else{
            
            
        }
        
    }
    
}

//MARK:  Line
extension MQIloginManager:LineSDKLoginDelegate{
    ///登录
    func lineLogin() -> Void {
        
        LineSDKLogin.sharedInstance().delegate = self
        LineSDKLogin.sharedInstance().start()
    }
    
    
    /// 代理
    func didLogin(_ login: LineSDKLogin, credential: LineSDKCredential?, profile: LineSDKProfile?, error: Error?) {
        
        if error != nil {
            mqLog("登录失败 \(error.debugDescription)")
            MQILoadManager.shared.makeToast(kLocalized("LoginFailed"))
            loginSuccess?(false)
        }else{
            
            //            guard let accessToken :String = credential?.accessToken?.accessToken ,let userID = profile?.userID,let statusMessage = profile?.statusMessage,let ictureURL = profile?.pictureURL
            //                else {
            //
            //                return
            //            }
            //                mqLog("\(accessToken),\(userID)\(statusMessage)\(ictureURL)")
            guard let accessToken :String = credential?.accessToken?.accessToken else {
                MQILoadManager.shared.makeToast(kLocalized("InformationAcquisitionFailure"))
                loginSuccess?(false)
                return
            }
            //            self.loginRequest( MQIUserLineLoginRequest.init(access_token: accessToken))
            self.loginRequest(GYUserSnsPathtRequest("line", param:["access_token":accessToken]))
        }
        
    }
    
    
}

//MARK:  Twitter
extension MQIloginManager{
    
    func twitterLogin() -> Void {
        if let userID =  TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
            //                TWTRTwitter.sharedInstance().sessionStore.existingUserSessions()
            TWTRTwitter.sharedInstance().sessionStore.logOutUserID(userID)
        }
        //     TWTRAPIClient.withCurrentUser()
        ///Twitter 3.0 不重定向 https://github.com/twitter/twitter-kit-ios/issues/74
        TWTRTwitter.sharedInstance().logIn{[weak self] (session, error) in
            if (session == nil) {
                MQILoadManager.shared.makeToast(kLocalized("LoginFailed"))
                if let strongSelf = self {
                    strongSelf.loginSuccess?(false)
                }
                
                mqLog("error: \(String(describing: error?.localizedDescription))");
            } else {
                //                mqLog("signed in as \(String(describing: session?.userName))");
                //                mqLog("signed in as \(String(describing: session?.userID))");
                //                mqLog("signed in as \(String(describing: session?.authTokenSecret))");
                mqLog("signed in as \(String(describing: session?.authToken))");
                
                guard let userName :String =  session?.userName,let userID :String =  session?.userID,let authTokenSecret :String =  session?.authTokenSecret,let authToken :String =  session?.authToken else {
                    MQILoadManager.shared.makeToast(kLocalized("InformationAcquisitionFailure"))
                    if let strongSelf = self {
                        strongSelf.loginSuccess?(false)
                    }
                    return
                }
                if let strongSelf = self {
                    //                    strongSelf.loginRequest(MQIUserTwitterLoginRequest.init(oauth_token: authToken, user_id: userID, screen_name: userName, oauth_token_secret: authTokenSecret))
                    strongSelf.loginRequest(GYUserSnsPathtRequest("twitter", param: ["oauth_token":authToken,"oauth_token_secret":authTokenSecret,"user_id":userID,"screen_name":userName]))
                }else{
                    MQILoadManager.shared.dismissProgressHUD()
                }
            }
        }
    }
    
    //    let userID =  TWTRTwitter.sharedInstance().sessionStore.session()?.userID
    //
    //    if userID != nil {
    //            Twitter.sharedInstance().sessionStore.existingUserSessions()
    //            Twitter.sharedInstance().sessionStore.logOutUserID(userID!)
    //    }
    
    //
    
    //        URLSession.shared.reset {
    //
    //        }
    //
    //        let cookieStore = HTTPCookieStorage.sortedCookies(<#T##HTTPCookieStorage#>)
    //
    ///did encounter error with message "Error obtaining user auth token.": Error Domain=TWTRLogInErrorDomain Code=-1 "" UserInfo={NSLocalizedDescription=}
    /*
     ///https://github.com/twitter/twitter-kit-ios/wiki/Log-In-With-Twitter
     
     //https://stackoverflow.com/questions/40863953/getting-errors-from-twitter-sharedinstance-swift-3-ios-10
     */
}



//MARK: 清理特定cookie
extension MQIloginManager{
    
    func clearCookiesForDomain(_ domain:String){
        let storage:HTTPCookieStorage  = HTTPCookieStorage.shared
        guard  let cookies = storage.cookies else {
            return
        }
        for cookie in cookies {
            let domainName = cookie.domain
            let domainRange =  domainName.range(of: domain)
            
            if domainRange?.isEmpty == false {
                storage .deleteCookie(cookie)
            }
        }
        
    }
    
    
}
