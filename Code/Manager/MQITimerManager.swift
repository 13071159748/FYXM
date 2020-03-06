//
//  MQITimerManager.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/9/5.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

let READTIME = "READTIME"

let BEGINTIME = "BEGINTIME"
let ReadTimePlist = "/ReadTimePlist.plist"
let LogInState = ""
let tempIndex = 10000000
class MQITimerManager: NSObject {
    fileprivate static var __once: () = {
        Inner.instance = MQITimerManager()
    }()
    
    struct Inner {
        static var token: Int = 0
        static var instance: MQITimerManager?
    }
    
    class var shared: MQITimerManager {
        _ = MQITimerManager.__once
        let path = MQIFileManager.getCachesPath()
        let sPath = NSString(string:path).appendingPathComponent(READTIME)
        MQIFileManager.creatPathIfNecessary(sPath)
        mqLog(sPath)
      
        return Inner.instance!
    }
    
    override init() {
        super.init()
        addNotification()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //获取日期记录目录
    func getReadListPath() -> String{
        let path = MQIFileManager.getCachesPath()
        let sPath = NSString(string:path).appendingPathComponent(READTIME)
        let infoPath = NSString(string:sPath).appendingPathComponent(ReadTimePlist)
        return infoPath
    }
    //记录开始
    func saveBeginReadTime(){
        UserDefaults.standard.set(getNowTime(), forKey: BEGINTIME)
    }
    
    
    
    //将没有记录账号的阅读记录记录到第一个登录的账号中
    func saveFirstLoginAccountReadTime(readList:[MQIReadTimeModel]){
        var totalTime = 0
        let tempList = readList
        if tempList.count > 0 {
            for i in 0..<tempList.count {
                if tempList[i].userAccount == LogInState{
                    readList[i].userAccount = (MQIUserManager.shared.user?.user_id)!
                    totalTime = totalTime + readList[i].allDayReadTime
                }
            }
            let dic = getNowData()
            if dic.keys.first! != tempIndex && (dic.values.first?.allDayReadTime)! > 0{
                readList[dic.keys.first!].allDayReadTime = totalTime
            }
            saveLocalList(readList: readList)
        }
    }
    
    //获取本地缓存列表
    func getLocalList() -> [MQIReadTimeModel]{
        let infoPath = getReadListPath()
        var readList = [MQIReadTimeModel]()
        if FileManager.default.fileExists(atPath: infoPath as String) {
            readList = NSKeyedUnarchiver.unarchiveObject(withFile: infoPath as String) as! [MQIReadTimeModel]
        }
        return readList
    }
    //储存本地列表
    func saveLocalList(readList:[MQIReadTimeModel]){
        let infoPath = getReadListPath()
        NSKeyedArchiver.archiveRootObject(readList,toFile:infoPath)
    }
    
    //删除3天多余记录
    func deleteLocalDateInfo(callback:(()->())? = nil){
        var readList = getLocalList()
        let nowDate = getNowTime()
        readList =  readList.filter { (m) -> Bool in
            if m.beginTime > 0 {
                if checkPlusDays(timeStampA: m.beginTime, timeStampB: nowDate) > 3
                { ///大于3天的不保留
                    return  false
                }else{
                    ///小于3天的保留
                    return true
                }
            }
            ///没有计时的不保留
            return false
        }
        
        saveLocalList(readList: readList)
        callback?()
    }
  
    //返回今日总阅读时间
    @discardableResult func todayTotalRead() -> NSInteger{
        let readList = getLocalList()
        var serviceTotalTime = 0
        //1.本地没有数据，没有登录，返回0
        if readList.count <= 0 && !MQIUserManager.shared.checkIsLogin(){
            return 0
        }else if readList.count <= 0 && MQIUserManager.shared.checkIsLogin() {
            //2.本地没数据，但是登录了
            if MQINewUserActivityManager.shared.userActivity != nil{
                //如果网络有数据，返回服务器时间否则就是没有阅读时间，返回0
                let i = (MQINewUserActivityManager.shared.userActivity?.daily_accumulated_duration)!
                serviceTotalTime = i / 60
                return serviceTotalTime
            }else{
                return 0
            }
        }else if readList.count > 0 && !MQIUserManager.shared.checkIsLogin(){
            //3.如果本地有数据，但是没登录
            let dic = getNowData()
            if dic.keys.first! != tempIndex && (dic.values.first?.allDayReadTime)! > 0{
                return (dic.values.first?.allDayReadTime)!
            }else{
                return 0
            }
        }else if readList.count > 0 && MQIUserManager.shared.checkIsLogin(){
            //4.如果已登录，并且本地也有数据，此时如果没有网络上报失败，获取不到服务器，就已本地为准,如果有网络，那么此时的未上报信息也已经上报了，所以以服务器为准，并且set本地当天阅读时长
            if MQINewUserActivityManager.shared.userActivity != nil{
                let i = (MQINewUserActivityManager.shared.userActivity?.daily_accumulated_duration)!
                serviceTotalTime = i / 60
                //重新set本地某账号的最大阅读时长
                let dic = getNowData()
                if dic.keys.first! != tempIndex && (dic.values.first?.allDayReadTime)! > 0{
                    if (dic.values.first?.isAlreadySend)! == true{
                        readList[dic.keys.first!].allDayReadTime = serviceTotalTime
                    }else{
                        readList[dic.keys.first!].allDayReadTime = serviceTotalTime + readList[dic.keys.first!].allDayReadTime
                        serviceTotalTime = serviceTotalTime + readList[dic.keys.first!].allDayReadTime
                    }
                    saveLocalList(readList: readList)
                }
                return serviceTotalTime
            }else{
                let dic = getNowData()
                if dic.keys.first! != tempIndex && (dic.values.first?.allDayReadTime)! > 0{
                    return (dic.values.first?.allDayReadTime)!
                }
            }
        }
        return 0
    }
  
    
    //记录结束
    func saveEndReadTime(){
        let beginTime = UserDefaults.standard.integer(forKey: BEGINTIME)
        if beginTime <= 0 {
            return
        }

        let nowDate = getNowTime()
        var userAccount = LogInState
        if let user =  MQIUserManager.shared.user{
            userAccount = user.user_id
        }
        
        //先获取之前储存的plist文件
        var readList = getLocalList()
        //获取开始时间，转化为今日格式
        let isSameDay = checkIsSameDay(timeStampA: beginTime, timeStampB: getNowTime())
        // 当天
        if isSameDay == true{
            //当如果是同一天的话这里逻辑处理完毕
            let today = getTodayMatter(timeStamp: getNowTime())
            let plusSec = checkPlusMinute(timeStampA: beginTime, timeStampB: nowDate)
            //这里为了方便测试暂时先每次阅读原基础上+1
            let plusMin = objToInterval(timeInterval: plusSec)
            if plusMin > 0{
                let dic = MQIReadTimeModel.init(jsonDict: ["beginTime":beginTime,"endTime":nowDate,"today":today,"totalReadTime":plusMin,"userAccount":userAccount,"isAlreadySend":false])
                //存入数组
                //totalReadTime
                let data = updateAllDayTime(dic: dic, plusTime: plusMin)
                readList.append(data)
            }
        }else{//1014  12:00
            //先计算此次退出距离上次打开是多少天
            let totalDays = checkToTimeSpenDay(timeIntervalA: beginTime, timeIntervalB: nowDate)
            let otherDay = totalDays - 2
            //如果不是同一天，需要分2段计算
            let zeroTime = getDayInterval(timeInterval: beginTime) + 86440
            //先记录第一天
            let firstDate = checkPlusMinute(timeStampA: beginTime, timeStampB: zeroTime)
            let plusMin = objToInterval(timeInterval: firstDate)
            if plusMin > 0{
                let today = getTodayMatter(timeStamp: beginTime)
                let dic = MQIReadTimeModel.init(jsonDict: ["beginTime":beginTime,"endTime":zeroTime,"today":today,"totalReadTime":plusMin,"userAccount":userAccount,"isAlreadySend":false])
                let data = updateAllDayTime(dic: dic, plusTime: plusMin)
                readList.append(data)
            }
            //如果中间间隔不止一天
            if otherDay > 0{
                for i in 0..<otherDay {
                    //获取第二天凌晨的时间
                    let zeroTime1 = getDayInterval(timeInterval: beginTime) + 86400 * (i + 1)
                    //第二天59分的时间
                    let endTim = zeroTime1 + 86399
                    let toda = getTodayMatter(timeStamp: endTim)
                    let plusMin = 1440
                    let dic = MQIReadTimeModel.init(jsonDict: ["beginTime":zeroTime1,"endTime":endTim,"today":toda,"totalReadTime":plusMin,"userAccount":userAccount,"isAlreadySend":false])
                    let data = updateAllDayTime(dic: dic, plusTime: plusMin)
                    readList.append(data)
                }
            }
            //再记录第二天
            let lastDay = getDayInterval(timeInterval: nowDate)
            let secondDate = checkPlusMinute(timeStampA: lastDay, timeStampB: nowDate)
            let plusMinSec = objToInterval(timeInterval: secondDate)
            let tos = getDayInterval(timeInterval: lastDay)
            if plusMinSec > 0{
                let today = getTodayMatter(timeStamp: nowDate)
                let dic = MQIReadTimeModel.init(jsonDict: ["beginTime":tos,"endTime":nowDate,"today":today,"totalReadTime":plusMinSec,"userAccount":userAccount,"isAlreadySend":false])
                let data = updateAllDayTime(dic: dic, plusTime: plusMinSec)
                readList.append(data)
            }
        }
//        reportLocalDateInfo(readList: readList)
        UserDefaults.standard.set(0, forKey: BEGINTIME)
    }
    
    //获取最后一个记录的时间
    @discardableResult func getNowData() -> Dictionary<Int, MQIReadTimeModel>{
        let readList = getLocalList()
        if let user =  MQIUserManager.shared.user{
            if readList.count > 0{
                let  count = (0..<readList.count).reversed()
                for i in count{
                    //如果登录中，账号相等
                    if user.user_id  == readList[i].userAccount{
                        //并且是同一天
                        if checkIsSameDay(timeStampA: readList[i].beginTime, timeStampB: getNowTime()){
                            return [i:readList[i]]
                        }else{
                            return [tempIndex:MQIReadTimeModel.init(jsonDict: ["none":"none"])]
                        }
                        
                    }
                }
            }else{
                return [tempIndex:MQIReadTimeModel.init(jsonDict: ["none":"none"])]
            }
        }else{
            if readList.count > 0{
                let  count = (0..<readList.count).reversed()
                for i in count {
                    if LogInState == readList[i].userAccount{
                        if checkIsSameDay(timeStampA: readList[i].beginTime, timeStampB: getNowTime()){
                            return [i:readList[i]]
                        }else{
                            return [tempIndex:MQIReadTimeModel.init(jsonDict: ["none":"none"])]
                        }
                    }
                }
            }else{
                return [tempIndex:MQIReadTimeModel.init(jsonDict: ["none":"none"])]
            }
        }
        return [tempIndex:MQIReadTimeModel.init(jsonDict: ["none":"none"])]
    }
    //上报服务器本地未上报的数据
    func reportLocalDateInfo(readList:[MQIReadTimeModel]){
        var updateArr = [NSDictionary]()
        var infoArr = [Dictionary<String,MQIReadTimeModel>]()
        let tem = readList
        if tem.count > 0 {
            for i in 0..<tem.count {
                if tem[i].isAlreadySend == false && tem[i].userAccount != ""{
                    let time = "\(tem[i].beginTime)"
                    let total = "\(tem[i].totalReadTime * 60)"
                    let dic = ["date_day":time,"read_long":total] as NSDictionary
                    updateArr.append(dic)
                    infoArr.append(["\(i)":readList[i]])
                }
            }
            //success中标记为已上报
            if updateArr.count > 0{
//                //上报
//                GDUserReadingRequest(during: updateArr).request({ (request, response, result:MQIDailyModelList) in
//                    if infoArr.count > 0{
//                        for i in 0..<infoArr.count{
//                            let index = NSInteger(infoArr[i].keys.first!)
//                            readList[index!].isAlreadySend = true
//                        }
//                    }
//                    self.saveLocalList(readList: readList)
//                    MQINewUserActivityManager.shared.userActivity = nil
//                    MQINewUserActivityManager.shared.getUserActivityInfo()
//                }) {(errmsg, errcode) in
//                    MQINewUserActivityManager.shared.userActivity = nil
//                    ShelfNotifier.postNotification(.refresh_totalTime)
//                }
            }
            saveLocalList(readList: readList)
        }
        if updateArr.count <= 0 {
            MQINewUserActivityManager.shared.getUserActivityInfo()
        }
    }
    //更新时长
    func updateAllDayTime(dic:MQIReadTimeModel,plusTime:NSInteger) -> MQIReadTimeModel{
        let model = dic
        var readList = getLocalList()
        if readList.count > 0 {
            let  count = (0..<readList.count).reversed()
            for i in count {
                if readList[i].userAccount == dic.userAccount && checkIsSameDay(timeStampA: readList[i].beginTime, timeStampB: getNowTime()){
                    if readList[i].allDayReadTime + plusTime >= 1440{
                        model.allDayReadTime = 1440
                    }else{
                        model.allDayReadTime = readList[i].allDayReadTime + plusTime
                    }
                    return model
                }
            }
        }
        model.allDayReadTime = plusTime
        return model
    }
    
    /*------------------------------------------时间工具-----------------------------------------------*/
    
    //获取当前时间戳
    @discardableResult func getNowTime() -> NSInteger{
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = NSInteger(timeInterval)
        return timeStamp
    }
    //B是大数A小数
    @discardableResult func checkToTimeSpenDay(timeIntervalA:NSInteger,timeIntervalB:NSInteger) -> Int{
        let beginDay = MQITimerManager.shared.getTodayMatter(timeStamp: timeIntervalA)
        let endDay = MQITimerManager.shared.getTodayMatter(timeStamp: timeIntervalB)
        let s1 = beginDay.substring(NSRange.init(location: beginDay.length - 3, length: 2)).integerValue()
        let s2 = endDay.substring(NSRange.init(location: endDay.length - 3, length: 2)).integerValue()
        let totalDay = s2 - s1 + 1
        return NSInteger(totalDay)
    }
    //获取当天0点时间戳
    @discardableResult func getDayInterval(timeInterval:NSInteger) -> NSInteger{
        let date = NSDate(timeIntervalSince1970:TimeInterval(timeInterval))
        let calendar = NSCalendar.init(identifier: .chinese)
        let components = calendar?.components([.year,.month,.day], from: date as Date)
        let timeInterval1:TimeInterval = (calendar?.date(from: components!)!.timeIntervalSince1970)!
        let timeStamp = NSInteger(timeInterval1)
        return timeStamp
    }
    //获取某天到当天0点的差
    @discardableResult func getCheckDayInterval(timeInterval:NSInteger) -> NSInteger{
        let zeroTime = getDayInterval(timeInterval: timeInterval)
        let plusSec = checkPlusMinute(timeStampA: timeInterval, timeStampB: zeroTime)
        let plusMin = objToInterval(timeInterval: plusSec)
        return plusMin
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
    //返回一个日期格式
    @discardableResult func getTodayMatter(timeStamp:NSInteger) -> String{
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date = Date(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日"
        return dformatter.string(from: date)
    }
    //返回时间差
    @discardableResult func checkPlusMinute(timeStampA:NSInteger,timeStampB:NSInteger) -> NSInteger{
        let dateA = NSDate(timeIntervalSince1970:TimeInterval(timeStampA)) as Date
        let dateB = NSDate(timeIntervalSince1970:TimeInterval(timeStampB)) as Date
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.chinese)
        let result = gregorian!.components(NSCalendar.Unit.second, from: dateA, to: dateB, options: NSCalendar.Options(rawValue: 0))
        return result.second!
    }
    //返回时间差天
    @discardableResult func checkPlusDays(timeStampA:NSInteger,timeStampB:NSInteger) -> NSInteger{
        let dateA = NSDate(timeIntervalSince1970:TimeInterval(timeStampA)) as Date
        let dateB = NSDate(timeIntervalSince1970:TimeInterval(timeStampB)) as Date
        
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let result = gregorian!.components(NSCalendar.Unit.day, from: dateA, to: dateB, options: NSCalendar.Options(rawValue: 0))
        
        return result.day!
    }
   
    ///进入后台检测过期数据
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(backgroundDeleteOldFiles), name:UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc func backgroundDeleteOldFiles()  {
        let application =   UIApplication.shared
        var newTaskId:UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid;
        newTaskId =  application.beginBackgroundTask(expirationHandler: {end()})
        deleteLocalDateInfo {end()}
        
        func end(){
            application.endBackgroundTask(newTaskId)
            newTaskId = UIBackgroundTaskIdentifier.invalid;
        }
    }
}

