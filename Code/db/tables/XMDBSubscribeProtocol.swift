//
//  XMDBSubscribeProtocol.swift
//  TSYQKReader
//
//  Created by moqing on 2019/4/18.
//  Copyright © 2019年 _CHK_. All rights reserved.
//
enum XMDBSubscribeScreenConditions {
    ///无筛选条件
    case none
    ///正本
    case all
    ///章节
    case chapter
}

extension XMDBTool {
    ///获取订阅,
    func querySubscribe(uid: Int?, conditions: XMDBSubscribeScreenConditions = .none) throws -> [NSDictionary] {
        guard let uid = uid else { return [] }
        return try XMDB.shared.query(sql: .select(subscribe: uid, conditions: conditions)) as [NSDictionary]? ?? []
    }
    
    ///添加阅读记录/书架
    func insert(sb: XMDBSubscribeProtocol?, attrs: [XMSubscribeAttribute] = []) throws {
        guard let sb = sb else { return }
        try XMDB.shared.insert(sql: .insert(sb: sb, attrs: attrs))
    }
    
    ///添加阅读记录/书架
    func remove(sb: XMDBSubscribeProtocol?) throws {
        guard let sb = sb else { return }
        try XMDB.shared.delete(sql: .remove(sb: sb))
    }
    
}
///订阅
protocol XMDBSubscribeProtocol {
    var bookId: Int { get }
    var userId: Int { get }
}
enum XMSubscribeAttribute: XMDBModelAttribute {
    case bookId(Int)
    case chapterId(Int)
    case entire(Int)
    case userId(Int)
    
    var attributeName: String {
        switch self {
        case .bookId(_):
            return "bookId"
        case .chapterId(_):
            return "chapterId"
        case .entire(_):
            return "entire"
        case .userId(_):
            return "userId"
        }
    }
    var value: Any {
        switch self {
        case .bookId(let value):
            return value
        case .chapterId(let value):
            return value
        case .entire(let value):
            return value
        case .userId(let value):
            return value
        }
    }
    var isString: Bool {
        switch self {
        case .bookId(_),
             .chapterId(_),
             .entire(_),
             .userId(_):
            return false
        }
    }
}
