//
//  GYPlanManager.swift
//  Reader
//
//  Created by _CHK_  on 2017/9/28.
//  Copyright © 2017年 _xinmo_. All rights reserved.
//

import UIKit


enum MQIPlanTaskType: String {
    case refreshChpaterList = "chapterRefreshList.db"
    case refreshBookInfo = "refreshBookInfo.db"
}

class MQIPlanManager: NSObject {
    
    fileprivate var tasks = [String : MQIEachTask]()
    
    
    struct Inner {
        static var token: Int = 0
        static var instance: MQIPlanManager?
    }
    
    static var __once: () = {
        Inner.instance = MQIPlanManager()
    }()
    
    class var shared: MQIPlanManager {
        _ = MQIPlanManager.__once
        return Inner.instance!
    }
    
    override init() {
        super.init()
        addPlan(type: .refreshChpaterList, limitTime: bookRefreshInterval)
        addPlan(type: .refreshBookInfo, limitTime: bookRefreshInterval)
    }
    
    fileprivate func addPlan(type: MQIPlanTaskType, limitTime: Int) {
        guard let _ = tasks[type.rawValue] else {
            let task = MQIEachTask(type.rawValue, limitTime: limitTime)
            tasks[type.rawValue] = task
            return
        }
    }
    
    func checkNeedRefresh(_ type: MQIPlanTaskType, id: String) -> Bool {
        let task = tasks[type.rawValue]
        return task!.checkNeedForceRefresh(id)
    }
    
}

class MQIEachTask: NSObject {
    
    fileprivate var limitTime: Int = 0
    fileprivate var name: String = ""
    
    fileprivate var refreshListPath: String = ""
    fileprivate var refreshList: [String : Date]!
    
    init(_ name: String, limitTime: Int) {
        super.init()
        self.name = name
        self.limitTime = limitTime
        
        refreshListPath = MQIFileManager.getCurrentStoreagePath(name)
        
        if MQIFileManager.checkFileIsExist(refreshListPath) == true {
            if let list = NSKeyedUnarchiver.unarchiveObject(withFile: refreshListPath) as? [String : Date] {
                refreshList = list
            }else {
                refreshList = [String : Date]()
            }
        }else {
            refreshList = [String : Date]()
        }
    }
    
    fileprivate func todayDate() -> Date {
        let interval = TimeZone(secondsFromGMT: +28800)?.secondsFromGMT(for: Date())
        let today = Date().addingTimeInterval(TimeInterval(interval!))
        return today
    }
    
    //MARK: 判断 是否 需要强制刷新
    func checkNeedForceRefresh(_ id: String) -> Bool {
        if let time = refreshList[id] {
            
            let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
            var result = gregorian?.components(.hour, from: time, to: todayDate(), options: NSCalendar.Options.init(rawValue: 0))
            
            guard let hour = result?.hour else {
                return false
            }
            
            if hour >= limitTime {
                recordRefreshTime(id)
                return true
            }else {
                return false
            }
        }else {
            recordRefreshTime(id)
            return true
        }
        
    }
    
    //MARK: 更新 刷新时间
    fileprivate func recordRefreshTime(_ id: String) {
        refreshList[id] = todayDate()
        saveRefreshList()
    }
    
    //MARK: 保存刷新列表
    @discardableResult func saveRefreshList() -> Bool {
        if refreshList.count >= 0 {
            dispatchArchive(refreshList, path: refreshListPath)
            return true
        }
        return false
    }
    
}
