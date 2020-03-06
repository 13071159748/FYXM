//
//  MQISocialManager.swift
//  SShopping
//
//  Created by CQSC  on 16/3/22.
//  Copyright © 2016年  CQSC. All rights reserved.
//

import UIKit

import SDWebImage
enum SocialPlatform: String {
    case qq = "qq"
    case weibo = "weibo"
    case friends = "friends"
    case wechat = "timeline"
}

class MQISocialManager: NSObject {
    
    fileprivate static var __once: () = {
        Inner.instance = MQISocialManager()
    }()
    
    var sharedSucBlock: ((_ suc: Bool) -> ())?
    
    var rootVC: MQINavigationViewController!{
        return gd_currentNavigationController()
    }
    
    struct Inner {
        static var token: Int = 0
        static var instance: MQISocialManager?
    }
    
    class var shared: MQISocialManager {
        _ = MQISocialManager.__once
        return Inner.instance!
    }
    
    override init() {
        super.init()
        //        rootVC = (UIApplication.shared.delegate as! AppDelegate).navigationController
    }
    
 
    func sharedApp() {
        let shareText = kLocalized("theMostPopularAndBestSellingNovelsAllHave")
        let image = targetIcon
        let text = shareText
        let url = NSURL.init(string: "https://cqsc.dmw11.com/web/mapp_cqsc/index.html")
        let items:[Any] = [image!, text, url!]
        shared(items: items)
    }
    
    func sharedBook(_ book: MQIEachBook) {
        
//        let manager = SDWebImageManager.shared()
//        let key = manager.cacheKey(for: URL(string: book.book_cover))
//        let image = SDImageCache.shared().imageFromCache(forKey: key)
//        let text = book.book_intro.book_intro
//        let url = NSURL.init(string: BASESHAREDHTTPURL+"book/"+book.book_id+".html")
        
        let image = targetIcon
        let text = kLongLocalized("TheNovelReadingAddiction", replace: book.book_name)
        let url = NSURL.init(string: "https://cqsc.dmw11.com/web/mapp_cqsc/index.html")
        var items = [Any]()
        if image != nil {
            items =  [image!, text, url!]
        }else{
            items = [text, url!]
        }
        shared(items: items)
    }
    
    //分享文本
    //分享文本
    func shared(items:[Any]) {
        let activityVC = UIActivityViewController.init(activityItems: items, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.mail, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.assignToContact];
        
        
        /// 适配ipd
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = gd_currentViewController().view
            popoverController.sourceRect = CGRect.init(x:screenWidth*0.25, y: screenHeight-100, width: screenWidth*0.5 , height: screenWidth*0.3)
        }
        
        gd_currentViewController().present(activityVC, animated: true, completion: nil)
        activityVC.completionWithItemsHandler = {(T:UIActivity.ActivityType?, complant:Bool, item:[Any]?, err:Error?)in
            
            if complant {
                MQILoadManager.shared.makeToast(kLocalized("ShareSuccess"))
            }else{
                MQILoadManager.shared.makeToast(kLocalized("ShareFaild"))
            }
            activityVC.completionWithItemsHandler = nil
        }
          MQIEventManager.shared.appendEventData(eventType: .share)
          MQIEventManager.shared.eShare()
    }
}

class GYSocialModel: NSObject {
    
    var title: String = ""
    var content: String = ""
    var image: UIImage?
    var url: String?
    //    var location: CLLocation?
    
    init(title_: String,
         content_: String,
         image_: UIImage?,
         url_: String?) {
        //         location_: CLLocation?) {
        super.init()
        
        title = title_
        content = content_
        image = image_
        url = url_
        //        location = location_
    }
}
