//
//  MQINewUserActivityManager.swift
//  XSDQReader
//
//  Created by _CHK_  on 2018/9/5.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

let ActivityPlist = "/ActivityPlist.plist"
let WelfareTaskPlist =  "/WelfareTaskModel.plist"
/// 展示福利弹框
let showWelfareTaskView = "showWelfareTaskView"
/// 固定时长c缓存key
let fixed_Duration_key = "requestDataForAFixedDuration_key"


class MQINewUserActivityManager: NSObject {
    
    var userActivity: MQIDailyModelList?
    var userItemActivity: MQIWelfareItemModel?
    
    var isNewUser:Bool = false
    /// 当前阅读本地阅读时长
    var currentTimeLength:Int = 0
    /// 任务展示视图
    var activityView:UIView?
    /// 新人福利和活动数据
    var welfareTaskModel =  MQINotificationModel()
    
    ///计时器
    var timer:DispatchSourceTimer?
    ///  一次有效计时器
    var oneTimer:DispatchSourceTimer!
    ///  是否在阅读
    var isReader:Bool = false
    ///  阅读器显示了菜单栏
    var isMenuShow:Bool = false
    /// 当前的
    var currentCount:Int = 0
    ///  当弹框下次上报时间为0时就不弹框了
    var bounced:Int = 0
    /// 上报间隔
    var timeCount:Int = 1
    /// 下次上报间隔
    var next_time:Int = 0 {
        didSet(oldValue) {
            if timeCount > 0 {
                /// 展示阅读器弹框
                startTimer { [weak self](con) in
                    if con <= 0 { //  上报
                        if let weakSelf = self {
                            weakSelf.cancelTimer()
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                                let currentCount =  weakSelf.currentCount
                                weakSelf.currentCount = 0
                                weakSelf.uploadReadTime(weakSelf.getCurrentReadTime(currentCount),isTiming:true)
                                
                            }
                        }
                    }
                }
            }else{
                timeCount = -1
                currentCount = 0
            }
        }
        
    }
    
    var promptText:String = ""
    
    /// 固定请求接口时长 单位秒
    var fixedDuration = 60*60*2
    
    fileprivate static var __once: () = {
        Inner.instance = MQINewUserActivityManager()
    }()
    
    struct Inner {
        static var token: Int = 0
        static var instance: MQINewUserActivityManager?
    }
    
    class var shared: MQINewUserActivityManager {
        _ = MQINewUserActivityManager.__once
        let path = MQIFileManager.getCachesPath()
        let sPath = NSString(string:path).appendingPathComponent(READTIME)
        MQIFileManager.creatPathIfNecessary(sPath)
        return Inner.instance!
    }
    override init() {
        super.init()
        currentTimeLength = 0
        UserNotifier.addObserver(self, selector: #selector(MQINewUserActivityManager.loginOut), notification: .login_out)
        UserNotifier.addObserver(self, selector: #selector(MQINewUserActivityManager.loginOut), notification: .login_in)
    }
    
    @objc func loginOut()  {
        isShowWelfareTask(true)
        saveLocalData(data: MQINotificationModel())
        welfareTaskModel = MQINotificationModel()
    }
    
    
    //第一次登录上传，获取是否展示新手任务
    func upLoadUserFirstLogin(){
        //        if !MQIUserManager.shared.checkIsLogin() { return }
        //        GDUserActivationRequest().request({ (request, response, result:MQINewUserModel) in
        //            self.isNewUser = result.is_new_user_task
        //            ShelfNotifier.postNotification(.refresh_tableView)
        //        }) {(errmsg, errcode) in
        //
        //        }
    }
    
    /// 是否是7天内新用户
    func is7DayNewUser() -> Bool {
        if let user = MQIUserManager.shared.user {
            //  user.user_reg_time
            if  let date = dateStrToDate(dateStr:user.user_reg_time){
                /// 转换为00：00：00分钟去对比
                if  checkPlusDays(timeStampA: getDayRelativeInterval(timeInterval: NSInteger(date.timeIntervalSince1970)) , timeStampB: getDayInterval(timeInterval: getNowTime()+86399)) <= 7 {
                    return true
                }
            }
        }
        
        return false
    }
    
    ///开始计时
    func startTimer(block:((_ length:Int) ->())? = nil){
        cancelTimer()
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        timer!.schedule(deadline: .now(), repeating: .seconds(1))
        timer!.setEventHandler(handler: {
            self.timeCount -= 1
            self.currentCount += 1
            block?(self.timeCount)
        })
        if timer!.isCancelled {
            timer = nil
            return
        }
        timer!.resume()
    }
    
    //结束计时
    func cancelTimer() {
        if self.timer != nil  {
            self.timer!.cancel()
            self.timer = nil
        }
    }
    

    /// 展示福利和活动弹框
    var linkBlock:(()->())?
    var activitiesCacView:UIView?
    
    /// 活动弹框
    func addWelfareActivities(superView:UIView,block:(()->())?) ->Void {
        
        guard let model = getShowModel() else { return }
        
        linkBlock = block
        
        if let oldBacView = superView.viewWithTag(1020) {
            oldBacView.removeFromSuperview()
        }
        
        mqLog("当前展示的活动弹窗 id \(model.id), title \(model.title), position \(model.pop_position)")
        
        let bacView = UIView(frame: superView.bounds)
        bacView.tag = 1020
        self.activitiesCacView = bacView
        bacView.backgroundColor = kUIStyle.colorWithHexString("000000", alpha: 0.25)
        superView.addSubview(bacView)
        superView.bringSubviewToFront(bacView)
        bacView.dsyAddTap(self, action: #selector(dismissWelfareActivitiesView(tap:)))
        
        
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth*0.75266, height: screenWidth*0.8266))
        contentView.backgroundColor = UIColor.clear
        bacView.addSubview(contentView)
        contentView.centerX = screenWidth*0.5
        contentView.centerY = screenHeight*0.5-20
        
        let image = FLAnimatedImageView(frame: contentView.bounds)
        image.backgroundColor = UIColor.clear
        contentView.addSubview(image)
        
        
        
        /// 赋值
        image.sd_setImage(with: URL(string: model.image))
        
        /// [left, top, right, bottom]
        let comfirm_rect = model.confirm_rect
        if comfirm_rect.count >= 4 {
            var  comfirm_frame = CGRect.zero
            comfirm_frame.origin.x = CGFloat(comfirm_rect[0].floatValue)*contentView.width
            comfirm_frame.origin.y =  CGFloat(comfirm_rect[1].floatValue)*contentView.height
            comfirm_frame.size.width = CGFloat(comfirm_rect[2].floatValue)*contentView.width-comfirm_frame.origin.x
            comfirm_frame.size.height = CGFloat(comfirm_rect[3].floatValue)*contentView.height-comfirm_frame.origin.y
            let  view = UIView(frame: comfirm_frame)
            view.dsyAddTap(self, action: #selector(jumpAction(tap:)))
            contentView.addSubview(view)
            
        }else{
            contentView.dsyAddTap(self, action: #selector(jumpAction(tap:)))
        }
        
        let cancel_rect  = model.cancel_rect
        if cancel_rect.count >= 4 {
            var  cancel_frame = CGRect.zero
            cancel_frame.origin.x = CGFloat(cancel_rect[0].floatValue)*contentView.width
            cancel_frame.origin.y =  CGFloat(cancel_rect[1].floatValue)*contentView.height
            cancel_frame.size.width = CGFloat(cancel_rect[2].floatValue)*contentView.width-cancel_frame.origin.x
            cancel_frame.size.height = CGFloat(cancel_rect[3].floatValue)*contentView.height-cancel_frame.origin.y
            let  view = UIView(frame: cancel_frame)
            view.dsyAddTap(self, action: #selector(dismissWelfareActivitiesView(tap:)))
            contentView.addSubview(view)
        }else{
            let jumpBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            jumpBtn.setImage(UIImage(named: "tk_gb_img"), for: .normal)
            jumpBtn.setTitleColor(UIColor.white, for: .normal)
            jumpBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            bacView.addSubview(jumpBtn)
            jumpBtn.addTarget(self, action:#selector(clcikJumpBtn(btn:)) , for: UIControl.Event.touchUpInside)
            jumpBtn.y = contentView.y+5
            jumpBtn.x = contentView.maxX
        }
        
        
    }
    
    //当前时间戳
    var nowTimestapmp: Int {
        return getDayRelativeInterval(timeInterval: getNowTime())
    }
    ///获取当前展示model
    func getShowModel() -> MQINotificationItemModel? {

        var pop_position = "2"
        if !MQIUserManager.shared.checkIsLogin() {
            pop_position = "1"
        } else {
            if is7DayNewUser() {
                pop_position = "1"
            }
        }
        for indexModel in self.welfareTaskModel.list {
            if indexModel.pop_position == pop_position && indexModel.id > 0{
                if getDayRelativeInterval(timeInterval: indexModel.start_time) <= nowTimestapmp && getDayRelativeInterval(timeInterval: indexModel.end_time) >= nowTimestapmp  {
                    if indexModel.had_show_time == 0 || (nowTimestapmp - getDayRelativeInterval(timeInterval: indexModel.had_show_time) >= fixedDuration) {
                        mqLog("当前弹框 title \(indexModel.title) pop_position \(indexModel.pop_position),nowTimestapmp \(nowTimestapmp),showTime \(indexModel.had_show_time)")
                        return indexModel
                    }
                }
            }
        }
        return nil
        
//        var model = self.welfareTaskModel.list.filter({$0.pop_position == "2" && $0.had_show == false}).first
//        if !MQIUserManager.shared.checkIsLogin() {
//            model = self.welfareTaskModel.list.filter({$0.pop_position == "1" && $0.had_show == false}).first
//        }else{
//            if is7DayNewUser() {
//                model = self.welfareTaskModel.list.filter({$0.pop_position == "1" && $0.had_show == false}).first
//            }
//        }
//        guard let indexModel = model else { return nil }
//        if indexModel.id == 0 { return nil }
//        return indexModel
    }
    
    
    func changeShowModelState(model: MQINotificationItemModel) {
        
       self.welfareTaskModel.list = self.welfareTaskModel.list.map { (indexModel) -> MQINotificationItemModel in
            if indexModel.id == model.id {
                indexModel.had_show_time = nowTimestapmp
            }
            return indexModel
        }
        
        //保存活动数据
        saveLocalData(data: self.welfareTaskModel)
    }
    
    
    @objc func jumpAction(tap:UITapGestureRecognizer) {
        if  tap.view !=  nil {
            activitiesCacView?.removeFromSuperview()
            linkBlock?()
            isShowWelfareTask(false)
            linkBlock = nil
            toLinkeUrl()
        }
    }
    func toLinkeUrl()  {
        if let model = getShowModel(){
            //将当前model置为已展示并记录展示时间存本地
            changeShowModelState(model: model)
            if model.url.count > 0 {
                MQIOpenlikeManger.openLike(model.url)
            }
        }
    }
    
    @objc func dismissWelfareActivitiesView(tap:UITapGestureRecognizer) {
        activitiesCacView?.removeFromSuperview()
        isShowWelfareTask(false)
        linkBlock = nil
        if let model = getShowModel(){
            //将当前model置为已展示并记录展示时间存本地
            changeShowModelState(model: model)
        }
    }
    
    @objc func clcikJumpBtn(btn:UIButton) -> Void {
        activitiesCacView?.removeFromSuperview()
        isShowWelfareTask(false)
        linkBlock = nil
        if let model = getShowModel(){
            //将当前model置为已展示并记录展示时间存本地
            changeShowModelState(model: model)
        }
    }
    
    
    /// 福利请求接口
    ///
    /// - Parameters:
    ///   - first_open: 是否是新手福利 false其福利
    ///   - block: 数据成功回调
    func getHomeNotification(_ first_open:Bool ,block:(()->())?) -> Void {
        
        //        MQIHomeNotificationRequest(first_open:first_open)
        mqLog("弹窗接口~");
        MQIPopup_listRequest()
            .request({[weak self]  (request, response, result:MQINotificationModel ) in

                if result.list.count == 0 { // 没有数据不展示 等待激活和重新登录
                    if MQIUserManager.shared.checkIsLogin() {
                        self?.isShowWelfareTask(false)
                    }
                    self?.welfareTaskModel = MQINotificationModel()
                    self?.saveLocalData(data: MQINotificationModel())
                    
                }else{
                    
                    //本地添加假数据测试，呵呵
//                    let fakeResult = result
//                    var fakeList = result.list
//                    let item = result.list.first
//
//                    if let item = item {
//                        var array = [MQINotificationItemModel]()
//                        for index in 0...3 {
//                            let indexItem = MQINotificationItemModel(jsonDict: item.dict)
//                            indexItem.id = 10+index
//                            if index < 2 {
//                                indexItem.title = "新人福利\(index+1)"
//                                indexItem.pop_position = "1"
//                            } else {
//                                indexItem.title = "活动弹窗\(index+1)"
//                                indexItem.pop_position = "2"
//                            }
//                            array.append(indexItem)
//                        }
//                        fakeList.append(contentsOf: array)
//                        fakeResult.list = fakeList
//                    }
//                    self?.saveLocalData(data: fakeResult)
//                    self?.welfareTaskModel = fakeResult
                    
                    self?.saveLocalData(data: result)
                    self?.welfareTaskModel = result
 
                    if self?.is7DayNewUser() != true {
                        self?.isShowWelfareTask(true)
                    }
                }
                self?.saveFixedDuration(Date())
                block?()
            }) { (errorMsg, errorCode) in
                mqLog("\(errorMsg)")
        }
    }
    
    
    
    ///初次安装记录 false 为初次安装  true 请求数据
    @discardableResult  func isShowWelfareTask(_ isSohw:Bool? = nil) -> Bool {
        if isSohw == nil {
            return  UserDefaults.standard.bool(forKey: showWelfareTaskView)
        }else{
            bounced = 0
            UserDefaults.standard.set(isSohw!, forKey: showWelfareTaskView)
            UserDefaults.standard.synchronize()
            return isSohw!
        }
        
    }
    
    /// 刷新固定时长
    func requestDataForAFixedDuration()  {
        /// 1.距上次时间超过2个小时 请求数据 更新本次时长  失败 不变 继续请求数据
        let  new_Date = Date()
        let old_date = saveFixedDuration()
        if Calendar.current.isDate(old_date , inSameDayAs: new_Date ) {
            /// 是否超过两个小时
            let  result = Int(new_Date.timeIntervalSince1970 - old_date.timeIntervalSince1970)
            if result >= fixedDuration {
                isShowWelfareTask(true)
                getHomeNotification(MQIUserManager.shared.checkIsLogin() ? is7DayNewUser():true, block: nil)
            }
        }else {
            /// 不是同一天 可以刷新数据
            isShowWelfareTask(true)
            getHomeNotification(MQIUserManager.shared.checkIsLogin() ? is7DayNewUser():true, block: nil)
        }
    }
    

    
    
    /// 缓存固定时长
    @discardableResult
    func saveFixedDuration(_ new_Date: Date? = nil) -> Date{
        if new_Date == nil {
            guard let date = UserDefaults.standard.object(forKey: fixed_Duration_key) as? Date else {
                /// 只会在第一次 赋值
                return  Date.init(timeInterval:TimeInterval(-fixedDuration-300) , since:  Date())
            }
            return  date
        }else{
            UserDefaults.standard.set(new_Date!, forKey: fixed_Duration_key)
            UserDefaults.standard.synchronize()
            return new_Date!
        }
    }
    
    //获取新用户活动数据
    func getLocalData() -> MQINotificationModel{
        let infoPath = getLocalDataPath(info: WelfareTaskPlist)
        if FileManager.default.fileExists(atPath: infoPath as String) {
            return NSKeyedUnarchiver.unarchiveObject(withFile: infoPath as String) as! MQINotificationModel
        }
        return MQINotificationModel()
    }
    //是否有活动数据
    func isWelfareTaskData() -> Bool {
        let infoPath = getLocalDataPath(info: WelfareTaskPlist)
        if FileManager.default.fileExists(atPath: infoPath as String) {
            return  true
        }
        return false
    }
    //储存新用户活动数据
    func saveLocalData(data:MQINotificationModel){
        let infoPath = getLocalDataPath(info: WelfareTaskPlist)
        NSKeyedArchiver.archiveRootObject(data,toFile:infoPath)
    }
    
    //记录数据目录
    func getLocalDataPath(info:String) -> String{
        let path = MQIFileManager.getCachesPath()
        let sPath = NSString(string:path).appendingPathComponent("Notification")
        MQIFileManager.creatPathIfNecessary(sPath)
        let infoPath = NSString(string:sPath).appendingPathComponent(info)
        return infoPath
    }
    
    var lock = NSLock()
}

//MARK: 计时
/// 临时计时
let READTIMEBEBIN = "READTIMEBEBIN"
/// 上传失败计时
let UPDATEREADTIMEERROR = "UPDATEREADTIMEERROR"
/// 当前阅读时间
let CURRENTREADTIME = "CURRENTREADTIME"

extension  MQINewUserActivityManager {
    
    //记录开始
    func beginReadTime(){
        UserDefaults.standard.set(getNowTime(), forKey: READTIMEBEBIN)
        isReader = true
        isMenuShow = false
        startOneTimer(interval: 60) {
            if self.currentCount >= 60{
                self.currentCount = 60
            }
            self.getCurrentReadTime(self.currentCount)
            self.currentCount = 0
        }
    }
    
    //记录结束 时间秒
    func endReadTime() {
        isReader = false
        isMenuShow = false
        cancelOneTimer()
        cancelTimer()
        if self.currentCount >= 60{
            self.currentCount = 60
        }
        getCurrentReadTime(self.currentCount)
        self.currentCount = 0
        UserDefaults.standard.set(0, forKey: READTIMEBEBIN)
    }
    /// 当前完成时间
    func getCompleteReadTime() -> Int {
        UserDefaults.standard.set(0, forKey: READTIMEBEBIN)
        let time = getCurrentReadTime(0)
        return time
    }
    /// 清空阅读记录
    func emptyReadTime() {
        UserDefaults.standard.set(0, forKey: READTIMEBEBIN)
        UserDefaults.standard.set(0, forKey: UPDATEREADTIMEERROR)
        UserDefaults.standard.set(0, forKey: CURRENTREADTIME)
    }
    /// 计算当前时长
    @discardableResult  func getCurrentReadTime(_ current:Int = 0) -> Int{
        lock.lock()
        //1.取出开始记录时间
        let beginTime = UserDefaults.standard.integer(forKey: READTIMEBEBIN)
        let historyTime = computingHistoryReadTime()
        var  jetLag =  historyTime
        if beginTime <= 0 {
            // 1.1 返回当前历史没有上传时间
            UserDefaults.standard.set(self.errorKey(jetLag) , forKey: CURRENTREADTIME)
            UserDefaults.standard.set(0, forKey: READTIMEBEBIN)
            lock.unlock()
            return historyTime
        }
        let now  = getNowTime()
        //2.重新开始记录时间
        UserDefaults.standard.set(now, forKey: READTIMEBEBIN)
        //3.对比开始时间与现在时间是否是同一天
        if checkIsSameDay(timeStampA: beginTime, timeStampB: now) {
            //记录当天时差
            let poor = current
            //3.1 同一天有时差 记录当前阅读时长 = 当前阅读时长+历史阅读时长（上传失败+历史时长）
            if poor > 0 {
                jetLag = poor+historyTime
                UserDefaults.standard.set(self.errorKey(jetLag) , forKey: CURRENTREADTIME)
                
            }else{ ///
                jetLag = historyTime
                //3.2 同一天有没有时差 记录当前阅读时长 = 当前阅读时长
                UserDefaults.standard.set(self.errorKey(jetLag) , forKey: CURRENTREADTIME)
            }
            
        }else{
            /// 4.不是 记录零点到现在的时长
            //            let zeroTime =  getDayInterval(timeInterval: now)
            let poor = current
            if poor > 0 {
                jetLag = poor
                //4.1记录当前零点到现在的时长
                UserDefaults.standard.set(self.errorKey(jetLag), forKey: CURRENTREADTIME)
            }else{ ///
                jetLag = 0
                // 4.2 恢复历史记录
                UserDefaults.standard.set(self.errorKey(0) , forKey: CURRENTREADTIME)
            }
            ///5. 删除错误记录恢复
            UserDefaults.standard.set(0, forKey: UPDATEREADTIMEERROR)
        }
        mqLog("当前阅读时长\(jetLag)")
        lock.unlock()
        return jetLag
    }
    
    /// 获取当前阅累计阅读时长（包括上传失败的阅读时长）
    func computingHistoryReadTime() -> Int {
        // 1.获取当前记录时间
        
        var  jetLag = 0
        let current = wantTheTime(CURRENTREADTIME)
        let errorTime = wantTheTime(UPDATEREADTIMEERROR)
        jetLag = current+errorTime
        /// 当记录时间大于了24小时的时间那证明数据错乱了
        if jetLag >= 86400 {
            //3.记录时间当前阅读时 =  错误归0
            UserDefaults.standard.set(0, forKey: READTIMEBEBIN)
            UserDefaults.standard.set(0, forKey: CURRENTREADTIME)
            UserDefaults.standard.set(0, forKey: UPDATEREADTIMEERROR)
            jetLag  = 0
        }else{
            //3.记录时间当前阅读时 =  当前+错误时间
            UserDefaults.standard.set(self.errorKey(jetLag), forKey: CURRENTREADTIME)
            ///4.错误归0
            UserDefaults.standard.set(0, forKey: UPDATEREADTIMEERROR)
        }
        
        mqLog("历史阅读时长\(jetLag)")
        return jetLag
    }
    
    ///时长上传回调
    ///
    /// - Parameters:
    ///   - during: 上传时长
    ///   - isEnd: 是否是结束上传 是结束上传不提示弹框
    func uploadReadTime(_ during:Int,isEnd:Bool = false,isTiming:Bool = false) -> Void {
        if during < 0  || !MQIUserManager.shared.checkIsLogin() {
            self.next_time = 0
            self.timeCount  = -1
            return
        }
        mqLog("当前上传的阅读时间\(during)")
        
        //1. 标记当前阅读时间为 0
        UserDefaults.standard.set(0, forKey: CURRENTREADTIME)
        //2.失败记录当前阅读时长
        UserDefaults.standard.set(self.errorKey(during) , forKey: UPDATEREADTIMEERROR)
        MQIUserReadingRequest.init(during: during)
            .request({ (request, response, result:MQINotificationItemModel)  in
                
                //3.成功 清空数据记录
                UserDefaults.standard.removeObject(forKey: UPDATEREADTIMEERROR)
                //                self.timeCount = 70
                //                self.next_time = 70
                //                 self.promptText  = "上传阅读时长成功"
                if !isEnd {
                    if  result.next_time  <= 0 {self.bounced += 1}
                    if result.code == "200"{
                        self.emptyReadTime()
                        self.cancelOneTimer()
                        self.cancelTimer()
                        
                    }else{
                        
                        if self.bounced < 3 {
                            if isTiming  {
                                self.bounced = -1
                            }
                            
                            /// 当没有提示文案时 不展示弹框
                            if result.message.count > 2 {
                                let image_name =  result.message.contains("未完成")  ?  "Reader_Welfare_image1":"Reader_Welfare_image2"
                                let userInfo:[String : String] = ["promptText":result.message,"image_name":image_name ]
                                self.promptText = result.message
                                self.timeCount = result.next_time
                                self.next_time = result.next_time
                                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DisplayThePopUpBoxInTheReader"), object: nil, userInfo: userInfo)
                            }
                            
                        }else{
                            self.promptText = result.message
                            self.timeCount = result.next_time
                            self.next_time = result.next_time
                            self.bounced = 5
                        }
                        
                        
                    }
                    
                }
                
                mqLog("上传阅读时长成功")
                
            }) { (errmsg, errcode) in
                self.next_time = 0
                self.timeCount  = -1
                mqLog("上传阅读时长失败\(errmsg)")
        }
    }
    
    
    
    ///固定计时阅读定时器 一分钟定时
    func startOneTimer(interval:Int,block:@escaping () ->()){
        cancelOneTimer()
        var count:Int = 0
        oneTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        oneTimer.schedule(deadline: .now(), repeating: .seconds(interval))
        oneTimer.setEventHandler(handler: {
            if count != 0 {
                block()
            }
            count += 1
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
    
    
    ///缓存失败key
    func errorKey(_ time:Int) -> String {
        return "\(getTormatToday(timeStamp: getNowTime()))_dsy_\(time)"
    }
    func  wantTheTime(_ key:String) -> Int {
        var jetLag:Int = 0
        if  let error = UserDefaults.standard.string(forKey: key) {
            let errorArr = error.components(separatedBy: "_dsy_")
            if errorArr.count  == 2 {
                ///是否是同一天记录
                if errorArr[0] == getTormatToday(timeStamp: getNowTime()) {
                    /// 删除记录恢复
                    UserDefaults.standard.removeObject(forKey: key)
                    jetLag = errorArr[1].integerValue()
                }else{
                    /// 删除记录恢复
                    UserDefaults.standard.removeObject(forKey: key)
                    jetLag =  0
                }
            }else{
                ///删除记录恢复
                UserDefaults.standard.removeObject(forKey: key)
                jetLag =  0
            }
        }else{
            jetLag = 0
        }
        return  jetLag
        
    }
    //返回一个日期格式 年月日
    @discardableResult func getTormatToday(timeStamp:NSInteger) -> String{
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date = Date(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日"
        return dformatter.string(from: date)
    }
    
    //返回一个日期格式
    @discardableResult func getTodayMatter(timeStamp:NSInteger) -> String{
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date = Date(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        return dformatter.string(from: date)
    }
    
    //获取当前时间戳
    @discardableResult func getNowTime() -> NSInteger{
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = NSInteger(timeInterval)
        return timeStamp
    }
    
    //传入秒计算相差分钟数
    @discardableResult func objToInterval(timeInterval:NSInteger) -> NSInteger{
        let more = Float(timeInterval % 60)
        var plusMin = 0
        if more / 60.0 > 0.5{
            plusMin = timeInterval / 60 + 1
        }else{
            plusMin = timeInterval / 60
        }
        return plusMin
    }
    
    //对比是否是同一天
    @discardableResult func checkIsSameDay(timeStampA:NSInteger,timeStampB:NSInteger) -> Bool{
        let dateA = NSDate(timeIntervalSince1970:TimeInterval(timeStampA))
        let dateB = NSDate(timeIntervalSince1970:TimeInterval(timeStampB))
        if Calendar.current.isDate(dateA as Date, inSameDayAs: dateB as Date) {
            return true
        }else {
            return false
        }
    }
    
    //获取当天0点时间戳
    @discardableResult func getDayInterval(timeInterval:NSInteger) -> NSInteger{
        let date = NSDate(timeIntervalSince1970:TimeInterval(timeInterval))
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year,.month,.day], from: date as Date)
        let timeInterval1:TimeInterval = (calendar.date(from: components)!.timeIntervalSince1970)
        let timeStamp = NSInteger(timeInterval1)
        return timeStamp
    }
    
    //获取当前对应的时间戳
    @discardableResult func getDayRelativeInterval(timeInterval:NSInteger) -> NSInteger{
        let date = NSDate(timeIntervalSince1970:TimeInterval(timeInterval))
        //        let calendar = NSCalendar.current
        let calendar = MQINewUserActivityManager.calendar
        let  components  =  calendar?.components([.year,.month,.day,.hour,.minute,.second], from: date as Date)
        let timeInterval1:TimeInterval = (calendar!.date(from: components!)!.timeIntervalSince1970)
        let timeStamp = NSInteger(timeInterval1)
        return timeStamp
    }
    
    static let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
    /// 给定时间转换date yyy-MM-dd HH:mm:ss
    func dateStrToDate(dateStr:String) -> Date? {
        if dateStr == "" { return nil}
        let dateFormatter = DateFormatter()
        //        dateFormatter.calendar = MQINewUserActivityManager.calendar as Calendar?
        dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        if let dateNew =  dateFormatter.date(from: dateStr) {
            return dateNew
        }
        let timeS = dateStr.integerValue()
        /// 1262275207 2010-01-01 年 公司成立2016年 不可能有10的用户
        if  timeS < 1262275207 {return nil}
        return  Date.init(timeIntervalSince1970: TimeInterval(dateStr.integerValue()))
        
        
    }
    
    //返回时间差天
    @discardableResult func checkPlusDays(timeStampA:NSInteger,timeStampB:NSInteger) -> NSInteger{
        let dateA = Date(timeIntervalSince1970:TimeInterval(timeStampA))
        let dateB = Date(timeIntervalSince1970:TimeInterval(timeStampB))
        
        let gregorian = MQINewUserActivityManager.calendar
        let result = gregorian!.components(NSCalendar.Unit.day, from: dateA, to: dateB, options: NSCalendar.Options(rawValue: 0))
        
        return result.day!
    }
    
    
    //    ///进入后台检测过期数据
    //    func addNotification() {
    //        NotificationCenter.default.addObserver(self, selector: #selector(backgroundRestoreOldFile), name:.UIApplicationDidEnterBackground, object: nil)
    //    }
    //
    //    @objc func backgroundRestoreOldFile()  {
    //        let application =   UIApplication.shared
    //        var newTaskId:UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid;
    //        newTaskId =  application.beginBackgroundTask(expirationHandler: {end()})
    //        restoreData {end()}
    //        func end(){
    //            application.endBackgroundTask(newTaskId)
    //            newTaskId = UIBackgroundTaskInvalid;
    //        }
    //    }
    //
    //    func restoreData(callback:(()->())? = nil){
    //        /// 记录当前时间
    //        endReadTime()
    //
    //    }
}



/// 魔情上报时长接口
extension  MQINewUserActivityManager {
    //获取日期记录目录
    func getActivityPlistPath() -> String{
        let path = MQIFileManager.getCachesPath()
        let sPath = NSString(string:path).appendingPathComponent(READTIME)
        let infoPath = NSString(string:sPath).appendingPathComponent(ActivityPlist)
        return infoPath
    }
    
    //获取每日任务进度
    func getUserActivityInfo(){
        GDGetUserTask().request({ (request, response, result:MQIDailyModelList) in
            self.userActivity = result
            ShelfNotifier.postNotification(.refresh_totalTime)
        }) {(errmsg, errcode) in
            self.userActivity = nil
            ShelfNotifier.postNotification(.refresh_totalTime)
        }
    }
    
    func saveActivity(){
        var userAccount = ""
        if let user =   MQIUserManager.shared.user{
            userAccount = user.user_id
            let path = MQIFileManager.getCachesPath()
            let sPath = NSString(string:path).appendingPathComponent(READTIME)
            let infoPath = NSString(string:sPath).appendingPathComponent("\(userAccount)+\(ActivityPlist)")
            //获取总任务进度
            let dic = ["userAccount":userAccount,"currentAct":"","totalAct":""]
            NSKeyedArchiver.archiveRootObject(dic,toFile:infoPath)
        }
        
    }
    
}


//MARK: - 阅读器弹框
extension MQINewUserActivityManager {
    
    /// 展示福利视图-阅读器使用
    func showActivityView(_ superView: UIView,y:CGFloat = root_status_height, title:String , image: String) -> Void {
        dismissActivityView()
        if title == "" {
            return
        }
        if activityView != nil {
            activityView!.x = kUIStyle.kScrWidth
        }else{
            activityView = addActivityView(superView: superView, title: title, image: image,y:y)
        }
        let x = kUIStyle.kScrWidth - activityView!.width
        //        superView.isUserInteractionEnabled = false
        //        UIView.animate(withDuration: 0.5) { [weak activityView] in
        //           activityView?.x = x
        //        }
        UIView.animate(withDuration: 0.5, animations: {
            self.activityView?.x = x
        }) { (su) in
            if su {
                self.perform(#selector(self.dismissActivityView), with: nil, afterDelay: 3, inModes: [.common])
            }
        }
    }
    
    @objc func dismissActivityView() {
        if activityView != nil {
            UIView.animate(withDuration: 0.5, animations: {
                self.activityView?.x = kUIStyle.kScrWidth+100
            }) { (suc) in
                if suc {
                    //                    activityView?.isUserInteractionEnabled = true
                    self.activityView?.removeFromSuperview()
                    self.activityView = nil
                }
            }
            
        }
        activityView = nil
    }
    
    private func addActivityView(superView:UIView,title:String = "" , image:String = "" ,y:CGFloat) -> UIView {
        //        var btnImage = (self.next_time > 0 ) ? "Reader_Welfare_image1":"Reader_Welfare_image2"
        var btnImage =  "Reader_Welfare_image1"
        var bacColor = UIColor.colorWithHexString("#FA9E02")
        if bounced < 0 || title.contains("奖励") {
            btnImage = "Reader_Welfare_image2";
            bounced = 0
        }
        if image != "" {btnImage = image}
        if btnImage == "Reader_Welfare_image2"{ bacColor = UIColor.colorWithHexString("#7FC354")}
        
        
        let btn = UIButton()
        btn.tag = 11020
        //        btn.backgroundColor = kUIStyle.colorWithHexString("000000", alpha: 0.5)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal)
        let noimage = UIImage(named: btnImage)
        //        btn.setImage(noimage, for: .normal)
        //        btn.setTitle(title, for: .normal)
        btn.isUserInteractionEnabled = false
        superView.addSubview(btn)
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = UIColor.white
        titleLabel.backgroundColor = bacColor
        titleLabel.text = "   "+title
        titleLabel.lineBreakMode = .byTruncatingTail
        btn.addSubview(titleLabel)
        
        let assImg = UIImageView()
        assImg.image = noimage
        btn.addSubview(assImg)
        
        let  w =   kUIStyle.getTextSizeWidth(text:titleLabel.text!, font: titleLabel.font, maxHeight: 30)+10
        var w2:CGFloat = w
        if w2 >= kUIStyle.kScrWidth {
            w2  = kUIStyle.kScrWidth - 10
        }
        if image == "" || noimage == nil {
            w2 -= 60
        }
        
        btn.frame = CGRect(x: kUIStyle.kScrWidth, y: y, width: w2, height: 60)
        titleLabel.frame = CGRect(x: btn.width-w+3, y:18, width: w,height: 30)
        titleLabel.dsySetCorner(byRoundingCorners: [.topRight,.bottomRight], radii: 15)
        assImg.frame = CGRect(x: 0, y: 0, width: 48, height: 56)
        assImg.maxX = titleLabel.x+10
        return btn
    }
    
}
