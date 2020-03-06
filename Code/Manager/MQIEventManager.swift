//
//  MQIEventManager.swift
//  XSDQReader
//
//  Created by _CHK_  on 2018/9/12.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

/// 点击类型
enum MQIEventType:String {
    /// 分享
    case share = "share"
    /// 首次打开应用
    case first_open = "first_open"
    /// 用户活跃
    case active = "active"
    /// 首页推荐位点击 /* book_id position*/
    case home_recommend_book = "home_recommend_book"
    /// 点击了首页推荐位url /* position:推荐位id url:链接地址 */
    case home_recommend_url = "home_recommend_url"
    /// 点击了首页banner书籍/* book_id: 书籍id */
    case banner_book = "banner_book"
    /// 点击了最近阅读的书籍/* book_id: 书籍id*/
    case recents_book = "recents_book"
    /// 点击了书架书籍的书籍/* book_id: 书籍id*/
    case favorite_book = "favorite_book"
    /// 点击了分类的书籍/* book_id: 书籍id class_id:二级分类id*/
    case genre_book = "genre_book"
    /// 点击了排行的书籍/* book_id: 书籍id ranking_type:排行type*/
    case ranking_book = "ranking_book"
    /// 点击了书籍末页推荐书籍/* book_id: 书籍id*/
    case end_page_book = "end_page_book"
    /// 点击了签到页推荐书籍/* position:推荐位idbook_id: 书籍id*/
    case lottery_book = "lottery_book"
    /// 点击了精选页推荐的书籍/* book_id: 书籍id*/
    case boutique_book = "boutique_book"
    /// 点击了搜索页推荐的书籍/* position:推荐位id book_id: 书籍id*/
    case search_recommend_book = "search_recommend_book"
    /// 点击了搜索的书籍/*book_id: 书籍id*/
    case search_book = "search_book"
    /// 点击了充值项目开始支付/*method: 支付方式 product_id:产品id*/
    case pay_start = "pay_start"
    /// 阅读了一章/*book_id: 书籍id chapter_id:章节id*/
    case event_reader_chapter = "event_reader_chapter"
    /// 详情页点击阅读/*book_id: 书籍id */
    case detail_read = "detail_read"
    /// 点击详情页推荐的书籍/*position:推荐位id book_id: 书籍id */
    case detail_book = "detail_book"
    /// 用户选择男女/*id: section id */
    case section_select = "section_select"
    /// 点击了新书推荐位书籍*position:推荐位id book_id: 书籍id */
    case new_book_recommend = "new_book_recommend"
    /// 支付相关
    
    /// 点击了充值项目开始支付/*method:支付方式 sku_id:产品id */
    case purchase_start = "purchase_start"
    /// 支付已完成/*method: 支付方式 sku_id:充值的产品id  transaction_id:事务id  receipt:苹果付款收据 */
    case purchased = "purchased"
    /// 支付出错/*method: 支付方式  sku_id:充值的产品id  error_code:错误码，记录是何种原因出错 */
    case purchase_fail = "purchase_fail"
    /// 支付已取消/*method: 支付方式 sku_id:充值的产品id */
    case purchase_cancel = "purchase_cancel"
    /// 充值书币已到账/*method: 支付方式 sku_id:充值的产品id */
    case purchase_complete = "purchase_complete"
}



extension MQIEventManager {
    
    /// 数据记录
    func appendEventData(eventType type:MQIEventType,additional:[String:Any]? = nil)  {
        lock.lock();defer{self.lock.unlock()}
        var dic = [String:Any]()
        var eventsList = getEventsList()
        switch type {
        case .share:
            dic = ["timestamp":getTimeStamp(),"event":type.rawValue,"uid":uid]
            oneRequest(events: [dic])
            break
        case .active:
            //            dic = ["timestamp":getTimeStamp(),"event":type.rawValue,"data":["uid":uid]]
            //            eventsList.append(dic)
            //            saveEvents(events: [])
            
            startOneTimer(interval: uploadTimeInterval) {
                self.uploadThEvent()
            }
            //            lastReportinTime = getTimeStamp()
            //            uploadThEvent()
            return
        case .first_open:
            if isFirstOpen() { return }
            dic = ["timestamp":getTimeStamp(),"event":type.rawValue,"uid":uid]
            break
        default :
            if additional == nil {
                dic = ["timestamp":getTimeStamp(),"event":type.rawValue,"uid":uid]
            }else{
                dic = ["timestamp":getTimeStamp(),"event":type.rawValue,"uid":uid,"data":additional!]
            }
            
            break
        }
        eventsList.append(dic)
        while eventsList.count > maxCount{
            eventsList.removeFirst()
        }
        saveEvents(events: eventsList)
    }
    
    
    
}


///存储地址
let ReadEventPlist = "/ReadEventPlist.plist"
///存储临时上传地址
let TempReadEventPlist = "/ReadEventTempPlist.plist"/*缓存上传时的数据 上传失败缓存 成功清空 */
/// 初次安装
let firstStart = "firstStart"

class MQIEventManager: NSObject {
    static let  shared = MQIEventManager()
    
    /// 重试次数
    var retryCount:Int = 0
    /// 最大缓存数据 临时上传数据为3倍的缓存数据
    var maxCount:Int = 300
    ///上报时间间隔
    var uploadTimeInterval = 900
    /// Uid
    var uid:String {
        get{
            return MQIUserManager.shared.user?.user_id ?? "-1"
        }
    }
    ///  一次有效计时器
    var oneTimer:DispatchSourceTimer!
    
    /// 上一次上报时间 每两次上报间隔不低于120秒
    var  lastReportinTime = 0
    
    var lock = NSLock()
    override init() {
        super.init()
        retryCount = 0
        
    }
    
    /// 上传点击数据
    func uploadThEvent() {
        retryCount = 0
        /// 1.先获取临时数据
        let tmpEventsList = getEventsList(info: TempReadEventPlist)
        var eventsList = getEventsList()
        /// 2.是否有未上传成功的数据
        if tmpEventsList.count > 0 {
            /// 3.拼接临时数据
            eventsList.append(contentsOf: tmpEventsList)
            /// 4.清空本地临时数据
            saveEvents(events: [[String:Any]](),info: TempReadEventPlist)
            //            saveEvents(events: [[String:Any]]())
        }
        if eventsList.count > 0 {
            /// 5.缓存临时数据
            let aMaxCount = 3*self.maxCount
            while eventsList.count-aMaxCount > 0{
                eventsList.removeFirst()
            }
            saveEvents(events: eventsList, info: TempReadEventPlist)
            /// 6.清空本地数据
            saveEvents(events: [[String:Any]]())
            /// 7.上传 上传成功清空临时数据
            request(events: eventsList)
        }
        
        
    }
    
    ///固定计时阅读定时器
    func startOneTimer(interval:Int,block:@escaping () ->()){
        cancelOneTimer()
        //        var count:Int = 0
        oneTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        oneTimer.schedule(deadline: .now(), repeating: .seconds(interval))
        oneTimer.setEventHandler(handler: {
            //            if count != 0 {
            //                block()
            //            }
            //            count += 1
            block()
        })
        if oneTimer.isCancelled {
            return
        }
        oneTimer.resume()
    }
    
    //结束计时
    func cancelOneTimer() {
        if self.oneTimer != nil  {
            self.oneTimer!.cancel()
            self.oneTimer = nil
        }
    }
    /// 字典转json
    func dicToJsonStr(_ dic:[String:Any]) -> String {
        
        if (!JSONSerialization.isValidJSONObject(dic)){
            return ""
        }
        let data = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        let jsonString = String(data: data!, encoding: String.Encoding.utf8)
        
        return jsonString!
    }
    
    /// json 转字典
    func jsonStrToDic(_ jsonString:String) ->[String:Any]{
        if jsonString == "" { return [:] }
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! [String:Any]
        }
        return [:]
        
    }
    
    func getNowDateFromatAnDate(andate:Date) -> Date? {
        
        let  format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        /// 东8区时间“Asia/Shanghai”
        let  sourceTimeZone = TimeZone(secondsFromGMT: 28800)
        format.timeZone = sourceTimeZone
        let strDate = format.string(from: andate)
        //        let nowDate = format.date(from: "2018-09-14 18:48:37")
        let nowDate = format.date(from: strDate)
        mqLog("current\(TimeZone.current) == \(String(describing: sourceTimeZone)) == \(andate)== \(String(describing: nowDate))")
        
        return nowDate
    }
    
    /// 获取时间戳
    func  getTimeStamp() -> Int {
        return Int(Date().timeIntervalSince1970)
    }
    
    ///获取列表
    func getEventsList(info:String = ReadEventPlist) -> [[String:Any]] {
        let infoPath = getEventListPath(info:info)
        if FileManager.default.fileExists(atPath: infoPath as String) {
            return  NSArray(contentsOfFile: infoPath) as! [[String:Any]]
        }
        return [[String:Any]]()
    }
    
    /// 缓存
    func saveEvents(events:[[String:Any]],info:String = ReadEventPlist)  {
        let infoPath = getEventListPath(info:info)
        let arr = events as NSArray
        let results  = arr.write(toFile: infoPath, atomically: true)
        if  !results  {
            arr.write(toFile: infoPath, atomically: true)
        }
    }
    
    //生成点击记录目录
    func getEventListPath(info:String = ReadEventPlist) -> String{
        let path = MQIFileManager.getCachesPath()
        let sPath = NSString(string:path).appendingPathComponent("EVENTLIST/")
        MQIFileManager.creatPathIfNecessary(sPath)
        let infoPath = NSString(string:sPath).appendingPathComponent(info)
        return infoPath
    }
    
    ///初次安装记录 false 为初次安装
    func isFirstOpen() -> Bool {
        if UserDefaults.standard.bool(forKey: firstStart) { return true }else{ UserDefaults.standard.set(true, forKey: firstStart) }
        if  UserDefaults.standard.object(forKey: kPayType) == nil { return false } // 类型数据
        return true
    }
    
    //// 拼接
    func assemblyProBufData(_ events:[[String:Any]]) -> Data? {
        mqLog("\(events)")
        if events.count <= 0 {return nil}
        let buf = LogInfo()
        buf.baseInfo.appName = bufName
        buf.baseInfo.platform = .ios
        buf.baseInfo.uuid =  DEVICEID
        buf.baseInfo.fc = "AppStore"
        for i in events {
            let businessItem =   BusinessInfo()
            businessItem.event = i["event"] as? String
            if i["timestamp"] != nil {
                businessItem.timestamp = Int32(i["timestamp"] as! Int)
            }
            if i["uid"] != nil {
                businessItem.userId = (i["uid"] as! String).int32Value()
            }
            
            if i["data"] != nil {
                let itemS =  i["data"] as! [String:Any]
                for  (key,value) in itemS {
                    let  item = Params()
                    item.key = key
                    item.value = value as? String
                    businessItem.paramsArray.add(item)
                }
            }
            buf.businessInfoArray.add(businessItem)
        }
        return buf.data()
    }
    
    ///上传
    func request(events:[[String:Any]]) {
        // 序列化为Data
        guard let bufData =  assemblyProBufData(events) else {
            return
        }
        uploadEvent(eventData: bufData) { (msg, code) in
            if code == nil {
                mqLog("上传成功")
                /// 清空临时数据
                self.saveEvents(events: [[String:Any]](), info: TempReadEventPlist)
                self.retryCount = 0
                
            }else{
                mqLog("上传失败\(msg)==\(String(describing: code))")
            }
            
        }
        
        //        MQIEventRequest(events: events).request({ (request, response, result:MQIBaseModel)  in
        //            mqLog("上传成功")
        //            /// 清空临时数据
        //            self.saveEvents(events: [[String:Any]](), info: TempReadEventPlist)
        //            self.retryCount = 0
        //
        //        }) { (errmsg, errcode) in
        //            mqLog("上传失败")
        //            self.retryCount += 1
        //            if self.retryCount <= 3 {
        //                self.request(events: events)
        //            }
        //        }
        
    }
    
    
    func uploadEvent(eventData:Data,block:@escaping ((String,String?)->()))  {
        if eventData.count == 0 {   block("上传失败","-1") ; return }
        MQIUploadEventDataRequest()
            .uploadEventData(eventData: eventData , completion: { (msg) in
                mqLog("上传成功")
                block("上传成功",nil)
            }) { (errmsg, errcode) in
                mqLog("上传失败\(errmsg)==\(errcode)")
                block(errmsg,errcode)
        }
    }
    
    
    ///分享完成
    func oneRequest(events:[[String:Any]]) {
        if !MQIUserManager.shared.checkIsLogin(){ return }
        
        MQIDaily_shareRequest(id: "17")
            .request({ (request, response, result:MQIBaseModel)  in
                mqLog("上传成功")
                
            }) { (errmsg, errcode) in
                mqLog("上传失败")
        }
        //        MQIEventRequest(events: events).request({ (request, response, result:MQIBaseModel)  in
        //            mqLog("上传成功")
        //
        //        }) { (errmsg, errcode) in
        //            mqLog("上传失败")
        //        }
    }
    
}


//MARK:  Facebook和firebase 埋点
extension MQIEventManager {
    
    ///签到
    func eCheckIn() {
        
        AppEvents.logEvent(AppEvents.Name.achievedLevel)
        Answers.logCustomEvent(withName: "check_in", customAttributes: nil)
        //        Crashlytics.logEvent("check_in")
        
    }
    ///搜索
    func eSearch() {
        AppEvents.logEvent(AppEvents.Name.searched)
        Answers.logSearch(withQuery: nil, customAttributes: nil)
    }
    ///领取福利
    func  eReceiveBenefit() {
        AppEvents.logEvent(AppEvents.Name.unlockedAchievement)
        Answers.logCustomEvent(withName: "receive_benefit", customAttributes: nil)
    }
    ///分享
    func  eShare() {
        AppEvents.logEvent(AppEvents.Name.rated)
        Answers.logCustomEvent(withName: "share", customAttributes: nil)
    }
    ///退出阅读时点击加入书架
    func  eAddBookshelfonExit() {
        AppEvents.logEvent(AppEvents.Name.addedToWishlist)
        Answers.logCustomEvent(withName: "add_to_library_exit", customAttributes: nil)
    }
    ///在阅读器菜单中加入书架
    func  eAddBookshelfMenu() {
        AppEvents.logEvent(AppEvents.Name.addedToWishlist)
        Answers.logCustomEvent(withName: "add_to_library_menu", customAttributes: nil)
    }
    ///订阅了章节
    func  eSubscribeChapter() {
        AppEvents.logEvent(AppEvents.Name.spentCredits)
        Answers.logCustomEvent(withName: "subscribe_chapter", customAttributes: nil)
    }
    
    
    /// 自定义上传事件
    func eSetFirebaseData(_ str:String)  {
        if str.count > 0 {
            Answers.logCustomEvent(withName: str, customAttributes: nil)
        }
        
    }
    ///开通vip
    func  eOpenVIP() {
        AppEvents.logEvent(AppEvents.Name.subscribe)
    }
    /// 支付上传
    func ePurchased(_ purchase:Double )  {
//        AppEvents.logPurchase(purchase/2.0, currency:"USD")
//        AppEvents.logPurchase(purchase, currency:"USD")
    }
    
}

