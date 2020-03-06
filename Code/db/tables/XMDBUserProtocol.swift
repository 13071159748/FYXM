//
//  XMUserAttribute.swift
//  TSYQKReader
//
//  Created by moqing on 2019/4/18.
//  Copyright © 2019年 _CHK_. All rights reserved.
//
///用户信息
protocol XMDBUserProtocol {
    
    var uid: Int { get }
    
    var nick: String { get }
    
    var avatar: String { get }
    
    var mobile: String { get }
    
    var regTime: String { get }
    
    var vipLevel: Int { get }
    
    var vipTime: Int { get }
    
    var vipExpiredTime: Int { get }
    
    var coin: Int { get }
    
    var premium: Int { get }
    
    var vipState: Int { get }
    
    var token: String { get }
    
    var email:String {get}
}

enum XMUserAttribute: XMDBModelAttribute {
    
    case nick(String)
    case avatar(String)
    case mobile(String)
    case regTime(String)
    case vipLevel(Int)
    case vipTime(Int)
    case vipExpiredTime(Int)
    case coin(Int)
    case premium(Int)
    case vipState(Int)
    case token(String)
    case email(String)
    
    case checkedIn(Int)
    case lastLoginType(Int)
    case lastLoginTime(String)
    
    var attributeName: String {
        switch self {
        case .checkedIn(_):
            return "checkedIn"
        case .lastLoginType(_):
            return "lastLoginType"
        case .lastLoginTime(_):
            return "lastLoginTime"
        case .nick(_):
            return "nick"
        case .avatar(_):
            return "avatar"
        case .mobile(_):
            return "mobile"
        case .regTime(_):
            return "regTime"
        case .vipLevel(_):
            return "vipLevel"
        case .vipTime(_):
            return "vipTime"
        case .vipExpiredTime(_):
            return "vipExpiredTime"
        case .coin(_):
            return "coin"
        case .premium(_):
            return "premium"
        case .vipState(_):
            return "vipState"
        case .token(_):
            return "token"
        case .email(_):
            return "email"
        }
    }
    
    var value: Any {
        switch self {
        case .checkedIn(let value):
            return value
        case .lastLoginType(let value):
            return value
        case .lastLoginTime(let value):
            return value
        case .nick(let value):
            return value
        case .avatar(let value):
            return value
        case .mobile(let value):
            return value
        case .regTime(let value):
            return value
        case .vipLevel(let value):
            return value
        case .vipTime(let value):
            return value
        case .vipExpiredTime(let value):
            return value
        case .coin(let value):
            return value
        case .premium(let value):
            return value
        case .vipState(let value):
            return value
        case .token(let value):
            return value
        case .email(let value):
             return value
        }
    }
    
    var isString: Bool {
        switch self {
        case .checkedIn(_):
            return false
        case .lastLoginType(_):
            return false
        case .lastLoginTime(_):
            return true
        case .nick(_):
            return true
        case .avatar(_):
            return true
        case .mobile(_):
            return true
        case .regTime(_):
            return true
        case .vipLevel(_):
            return false
        case .vipTime(_):
            return false
        case .vipExpiredTime(_):
            return false
        case .coin(_):
            return false
        case .premium(_):
            return false
        case .vipState(_):
            return false
        case .token(_):
            return true
        case .email(_):
            return true
        }
    }
}
