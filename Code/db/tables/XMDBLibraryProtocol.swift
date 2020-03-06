//
//  XMDBLibraryProtocol.swift
//  TSYQKReader
//
//  Created by moqing on 2019/4/18.
//  Copyright © 2019年 _CHK_. All rights reserved.
//
///书架
extension XMDBTool {
    ///获取阅读记录
    func queryReadLog() throws -> [NSDictionary] {
        return try XMDB.shared.query(sql: .select_readLog_all) as [NSDictionary]? ?? []
    }
    ///获取阅读记录
    func query(readLog bid: Int) throws -> NSDictionary? {
        return try XMDB.shared.query(sql: .select(t_name: "latest_read_log", key: "bookId", value: bid))?.first as NSDictionary?
    }
    
    ///获取书架列表
    func queryShelfList() throws -> [NSDictionary] {
        return try XMDB.shared.query(sql: .select_shelf_all) as [NSDictionary]? ?? []
    }
    
    ///添加阅读记录/书架
    func insert(lib: XMDBLibraryProtocol?, attrs: [XMLibraryAttribute] = []) throws {
        guard let lib = lib else { return }
        guard let db = XMDB.shared.db else { return }
        try XMDB.shared.insert(sql: .insert(t_db: db, lib: lib, attrs: attrs))
    }
    
    ///添加阅读记录/书架
    func update(bid: Int?, attrs: [XMLibraryAttribute]) throws {
        guard let bid = bid else { return }
        try XMDB.shared.update(sql: XMSQL.update(t_name: "library", key: "bookId", value: bid, values: attrs))
    }
    
    func insert(libs: [(XMDBLibraryProtocol, [XMLibraryAttribute])]) throws {
        guard let db = XMDB.shared.db else { return }
        db.open()
        defer { db.close() }
        defer { db.commit() }
        db.beginTransaction()
        for lib in libs {
            try XMDB.shared.insert_noTransaction(t_db: db, sql: .insert(t_db: db, lib: lib.0, attrs: lib.1))
        }
        
    }
}




protocol XMDBLibraryProtocol {
    var bookId: Int { get }
}
enum XMLibraryAttribute: XMDBModelAttribute {
    case chapterId(Int)
    case chapterPosition(Int)
    case readTime(Int)
    case favorite(Int)
    case autoSubscribe(Int)
    case chapterTitle(String)
    case updateBook(Int)
    
    var attributeName: String {
        switch self {
        case .chapterId(_):
            return "chapterId"
        case .chapterPosition(_):
            return "chapterPosition"
        case .readTime(_):
            return "readTime"
        case .favorite(_):
            return "favorite"
        case .autoSubscribe(_):
            return "autoSubscribe"
        case .chapterTitle(_):
            return "chapterTitle"
        case .updateBook(_):
            return "updateBook"
        }
    }
    var value: Any {
        switch self {
        case .chapterId(let value):
            return value
        case .chapterPosition(let value):
            return value
        case .readTime(let value):
            return value
        case .favorite(let value):
            return value
        case .autoSubscribe(let value):
            return value
        case .chapterTitle(let value):
            return value
        case .updateBook(let value):
            return value
        }
    }
    var isString: Bool {
        switch self {
        case .chapterId(_),
             .chapterPosition(_),
             .readTime(_),
             .favorite(_),
             .updateBook(_),
             .autoSubscribe(_):
            return false
        case .chapterTitle(_):
            
            return true
            
        }
    }
}





