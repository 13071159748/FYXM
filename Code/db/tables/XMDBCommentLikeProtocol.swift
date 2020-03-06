//
//  XMDBCommentLikeProtocol.swift
//  TSYQKReader
//
//  Created by moqing on 2019/4/18.
//  Copyright © 2019年 _CHK_. All rights reserved.
//

extension XMDBTool {
    ///获取全部点赞
    func selectAllCommentLike() throws -> [String] {
        let rs = try XMDB.shared.query(sql: .select_commentLike_all)
        let rsi = rs?.map { return $0["id"] } as? [Int] ?? []
        return rsi.map { return "\($0)" }
    }
    
    ///删除点赞
    func remove(cl: XMDBCommentLikeProtocol?) throws {
        guard let cl = cl else { return }
        try XMDB.shared.delete(sql: .remove(cl: cl))
    }
    
    ///删除全部点赞
    func removeAllCommentLike() throws {
        try XMDB.shared.delete(sql: .remove_commentLike_all)
    }
    
    ///添加点赞
    func insert(cl: XMDBCommentLikeProtocol?) throws {
        guard let cl = cl else { return }
        try XMDB.shared.insert(sql: .insert(cl: cl))
    }
}



///点赞
protocol XMDBCommentLikeProtocol {
    var id: Int { get }
    var like: Int { get }
}
enum XMCommentLikeAttribute: XMDBModelAttribute {
    case like(Int)
    
    var attributeName: String {
        switch self {
        case .like(_):
            return "like"
        }
    }
    var value: Any {
        switch self {
        case .like(let value):
            return value
        }
    }
    var isString: Bool {
        switch self {
        case .like(_):
            return false
        }
    }
}
