//
//  MQINotification.swift
//  Reader
//
//  Created by CQSC  on 2017/7/1.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import Foundation

// MARK: - Protocol

public protocol Notifier {
    associatedtype Notification: RawRepresentable
}

public extension Notifier where Notification.RawValue == String {
    
    // MARK: - Static Computed Variables
    
    private static func nameFor(_ notification: Notification) -> String {
        return "\(self).\(notification.rawValue)"
    }
    
    
    // MARK: - Instance Methods
    
    // Pot
    
    func postNotification(_ notification: Notification, object: Any? = nil) {
        postNotification(notification, object: object)
    }
    
    func postNotification(_ notification: Notification, object: Any? = nil, userInfo: [String : Any]? = nil) {
        postNotification(notification, object: object, userInfo: userInfo)
    }
    
    
    // MARK: - Static Function
    
    // Post
    
    static func postNotification(_ notification: Notification, object: Any? = nil, userInfo: [String : Any]? = nil) {
        let name = NSNotification.Name(rawValue: nameFor(notification))
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }
    
    // Add
    
    static func addObserver(_ observer: Any, selector: Selector, notification: Notification) {
        let name = NSNotification.Name(rawValue: nameFor(notification))
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: nil)
    }
    
    // Remove
    
    static func removeObserver(_ observer: Any, notification: Notification, object: Any? = nil) {
        let name = NSNotification.Name(rawValue: nameFor(notification))
        NotificationCenter.default.removeObserver(observer, name: name, object: object)
    }
}


class UserNotifier: Notifier {
    enum Notification: String {
        case login_in
        case login_out
        case refresh_coin
        case sign_finish
        case refresh_bage
        case reLoadAgain
        case bookStoreScroll
        case changeSectionID
        case gotop

    }
}

class ShelfNotifier: Notifier {
    enum Notification: String {
        case refresh_shelf
        case refresh_recent
        case refresh_recommends //刷新推荐书籍
        case refresh_totalTime
        case refresh_listenList
        case refresh_updataSave
        case refresh_tableView
    }
}

class ReadNotifier: Notifier {
    enum Notification: String {
        case refresh_lastRead
    }
}

class APPNotifier: Notifier {
    enum Notification: String {
        case enter_background
    }
}

class DownNotifier: Notifier {
    enum Notification: String {
        case download_finish
        case clickTabbar
    }
}




