 //
//  AppDelegate.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/6/27.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

        
import iVersion
        
import Firebase
import UserNotifications

import FirebaseMessaging
 import FacebookCore
 import FirebaseDynamicLinks

//import Bolts
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarController: MQITabBarController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        kCreateLanguage()
//
        tabBarController =  MQITabBarController()
        window = UIWindow()
        window!.makeKeyAndVisible()
        
        window!.frame = UIScreen.main.bounds
        window!.rootViewController = tabBarController
        configUM()
      
        MQIloginManager.shared.configSDK(application, launchOptions: launchOptions)
        
//        iVersion.sharedInstance().applicationBundleID = BUNDLE_ID
//        iVersion.sharedInstance().checkForNewVersion()
        
        ///配置 Firebase 监听
          configFB()
        /// bug 监听
        Fabric.sharedSDK().debug = true
        
        ///开启 Firebase 长连接
        Messaging.messaging().shouldEstablishDirectChannel  = true
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        if !MQIEventManager.shared.isFirstOpen() {
             MQIEventManager.shared.appendEventData(eventType: .first_open)
            ///初次安装显示弹框
             MQINewUserActivityManager.shared.isShowWelfareTask(true)
        }
        MQIDataUtil.conversionTokenAndFileData(MQIUserManager.shared.userPath, block: nil)
        MQIPayTypeManager.shared.config() // 类型
        MQIEventManager.shared.appendEventData(eventType: .active)
        MQIAdvertisingManager.shared.judgeIsExistad(window!)
//        let VIP = MQIUserManager.shared.user?.isVIP
//        mqLog("\(String(describing: VIP))")
        return true
    }
    
    fileprivate func configFB() {
        Messaging.messaging().delegate = self
        Messaging.messaging().subscribe(toTopic: "all")

        #if DEBUG
            Messaging.messaging().subscribe(toTopic: "debug")
        #endif
        FirebaseApp.configure()

        AppLinkUtility.fetchDeferredAppLink { (url, error) in
            if let error = error {
                print("Received error while fetching deferred app link %@", error)
            }
            if let url = url {
                // 带有深度链接
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
   
    func configUM(){
//        UMConfigure.initWithAppkey(MOBCLICK_ID, channel: nil)
        //打开调试日志
//        UMSocialManager.default().openLog(true)
////        设置微信的appKey和appSecret
//        UMSocialManager.default().setPlaform(.wechatSession, appKey: KWXAppID, appSecret: KWXAPPKEY, redirectURL: "http://mobile.umeng.com/social")
//        UMSocialManager.default().removePlatformProvider(with:.wechatFavorite)
//        UMSocialManager.default().setPlaform(.facebook, appKey: "fb277492592825321", appSecret: "277492592825321", redirectURL: "http://mobile.umeng.com/social")

    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
       
        AppEvents.activateApp()
        MQIIAPManager.shared.addPayObserve()


    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        MQIIAPManager.shared.removePayObserve()
        
    }
  
    //MARK: ---
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return MQIloginManager.shared.loginApplication(application,open:url,sourceApplication:sourceApplication ,annotation: annotation)
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        
        return  MQIloginManager.shared.loginApplication(app, open: url, options: options)
    }

   let gcmMessageIDKey =  "gcm.message_id"
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
         Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            mqLog("Message ID: \(messageID)")
        }
        
        // Print full message.
        mqLog(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        let token = Messaging.messaging().fcmToken
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
         Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            mqLog("Message ID: \(messageID)")
        }
//        MQIOpenlikeManger.openNotice(userInfo: userInfo)
        // Print full message.
        mqLog(userInfo.debugDescription)
        /// 云消息传递
        if MQIUserManager.shared.checkIsLogin() {
            if !MQINewUserActivityManager.shared.is7DayNewUser() {
                if  userInfo["data_action"]  != nil {
                    let data_action  = userInfo["data_action"] as! String
                    if data_action == "act" {
                        ///请求活动
                        MQINewUserActivityManager.shared.isShowWelfareTask(true)
                    }
                }
            }
        }else{ /// 未登录 如果有福利提示就请求数据
            if  userInfo["data_action"]  != nil {
                let data_action  = userInfo["data_action"] as! String
                if data_action == "act" {
                    ///请求活动
                    MQINewUserActivityManager.shared.isShowWelfareTask(true)
                }
            }
        }
        
        
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo
        
        completionHandler([])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        MQIOpenlikeManger.openNotice(userInfo: response.notification.request.content.userInfo)
        completionHandler()
    }
   
}
extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        messaging.subscribe(toTopic: "all")
        #if DEBUG
        messaging.subscribe(toTopic: "debug")
        #endif
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated
        if let token = Messaging.messaging().fcmToken{
            mqLog("FCM token: \(token)")
            UserDefaults.standard.set(token, forKey: "push_token")
           
        }
      
      
      
    }
    // [END refresh_token]
    
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        mqLog("Received data message: \(remoteMessage.appData)")
        mqLog("message:notification == \(remoteMessage.appData["notification"]) ")
    }
    // [END ios_10_data_message]
}
        
        
