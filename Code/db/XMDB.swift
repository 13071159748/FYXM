//
//   XMDB.swift
//  XMFMDBTestDemo
//
//  Created by moqing on 2019/4/16.
//  Copyright © 2019年 jutu12138. All rights reserved.
//

import UIKit
import FMDB
class XMDBTable {
    var name: String
    var createSql: String
    init(name: String, createSql: XMSQL) {
        self.name = name
        self.createSql = createSql.sql
    }
}

extension XMDBTable {
    ///书原子表
    static var book: XMDBTable = XMDBTable(name: "book", createSql: .create_book_sql)
    ///用户原子表
    static var user: XMDBTable = XMDBTable(name: "user", createSql: .create_user_sql)
    ///阅读记录，书架
    static var library: XMDBTable = XMDBTable(name: "library", createSql: .create_library_sql)
    ///白名单
    static var book_white_list: XMDBTable = XMDBTable(name: "book_white_list", createSql: .create_book_white_list_sql)
    ///评论，点赞
    static var comment_like: XMDBTable = XMDBTable(name: "comment_like", createSql: .create_comment_like_sql)
    ///阅读时长
    static var reading_statistic: XMDBTable = XMDBTable(name: "reading_statistic", createSql: .create_reading_statistic_sql)
    ///搜索记录
    static var search_history: XMDBTable = XMDBTable(name: "search_history", createSql: .create_search_history_sql)
    ///书架操作记录(用户删除等)
    static var shelf_op: XMDBTable = XMDBTable(name: "shelf_op", createSql: .create_shelf_op_sql)
    ///用户订阅章节
    static var subscribe: XMDBTable = XMDBTable(name: "subscribe", createSql: .create_subscribe_sql)
    
    static var bookshelf: XMDBTable = XMDBTable(name: "bookshelf", createSql: .create_bookshelf_sql)
    
    static var auto_subscribe_book: XMDBTable = XMDBTable(name: "auto_subscribe_book", createSql: .create_auto_subscribe_sql)
    
    static var latest_read_log: XMDBTable = XMDBTable(name: "latest_read_log", createSql: .create_latest_read_log_sql)
    
    
}

class XMDB: NSObject {
    
    ///表
    lazy var tables: [XMDBTable] = {
        return [.book,
                .user,
                .library,
                .book_white_list,
                .comment_like,
                .reading_statistic,
                .search_history,
                .shelf_op,
                .subscribe,
                .bookshelf,
                .auto_subscribe_book,
                .latest_read_log]
    }()
    
    
    private let db_path = "\(NSHomeDirectory())/Library/Application Support/com.xm.db"
    lazy var db: FMDatabase? = {
        let path = db_path
        return FMDatabase(path: path)
    }()
    
    //    lazy var queue: FMDatabaseQueue? = {
    //        let path = db_path
    //        return FMDatabaseQueue(path: path)
    //    }()
    
    private override init() {
        super.init()
        createTable()
    }
    
    static var shared =  XMDB()
    
    
    //    func inTransaction(block: (( XMDB, FMDatabase, UnsafeMutablePointer<ObjCBool>) -> ())?) {
    //        queue?.inTransaction { db, rollback in
    //            block?(self, db, rollback)
    //        }
    //    }
    
    ///创建表
    func createTable() {
        guard let db = db else { return }
        db.open()
        defer { db.close() }
        //        defer { db.commit() }
        //        db.beginTransaction()
        for table in tables {
            guard !db.tableExists(table.name) else { continue }
            do { try db.executeUpdate(table.createSql, values: nil) }
            catch { continue }
        }
        addColumn(t_name: "user", t_column: "email",t_column_type: "TEXT")
    }
    
        //添加列
    func addColumn(t_name: String?, t_column: String?,t_column_type:String) {
            guard let t_name = t_name, let t_column = t_column else { return }
            guard !(db?.columnExists(t_column, inTableWithName: t_name) ?? false) else { return }
            let sql = "ALTER TABLE \(t_name) ADD \(t_column) \(t_column_type) "
            do { try db?.executeUpdate(sql, values: nil) }
            catch {}
    
        }
    
    //    ///添加
    //    func insert(db: FMDatabase, sql: XMSQL?) throws {
    //        guard let sql = sql?.sql else { return }
    //        db.open()
    //        defer { db.close() }
    //        try db.executeUpdate(sql, values: nil)
    //    }
    //    ///查询
    //    func query(db: FMDatabase, sql: XMSQL?) throws -> [[AnyHashable: Any]]? {
    //        guard let sql = sql?.sql else { return nil }
    //        let rs = try db.executeQuery(sql, values: nil)
    //        var jsons: [[AnyHashable: Any]] = []
    //        while rs.next() {
    //            if let json = rs.resultDictionary {
    //                jsons.append(json)
    //            }
    //        }
    //        return jsons
    //    }
    //    ///修改
    //    func update(db: FMDatabase, sql: XMSQL?) throws {
    //        try insert(db: db, sql: sql)
    //    }
    //    ///删除
    //    func delete(db: FMDatabase, sql: XMSQL?) throws {
    //        try insert(db: db, sql: sql)
    //    }
    
    ///添加
    func insert(sql: XMSQL?) throws {
        guard let db = db else { return }
        guard let sql = sql?.sql else { return }
        db.open()
        defer { db.close() }
        //        defer { db.commit() }
        //        db.beginTransaction()
        try db.executeUpdate(sql, values: nil)
    }
    
    ///添加
    func insert_noTransaction(t_db: FMDatabase?,sql:  XMSQL?) throws {
        guard let t_db = t_db else { return }
        guard let sql = sql?.sql else { return }
        try t_db.executeUpdate(sql, values: nil)
    }
    ///添加
    func query_noTransaction(sql: XMSQL?) throws -> [[AnyHashable: Any]]? {
        guard let db = db else { return nil }
        guard let sql = sql?.sql else { return nil }
        let rs = try db.executeQuery(sql, values: nil)
        var jsons: [[AnyHashable: Any]] = []
        while rs.next() {
            if let json = rs.resultDictionary {
                jsons.append(json)
            }
        }
        return jsons
    }
    
    
    ///查询
    func query(sql: XMSQL?) throws -> [[AnyHashable: Any]]? {
        guard let db = db else { return nil }
        guard let sql = sql?.sql else { return nil }
        db.open()
        defer { db.close() }
        //        defer { db.commit() }
        //        db.beginTransaction()
        let rs = try db.executeQuery(sql, values: nil)
        var jsons: [[AnyHashable: Any]] = []
        while rs.next() {
            if let json = rs.resultDictionary {
                jsons.append(json)
            }
        }
        return jsons
    }
    ///修改
    func update(sql: XMSQL?) throws {
        try insert(sql: sql)
    }
    ///删除
    func delete(sql: XMSQL?) throws {
        try insert(sql: sql)
        
    }
}
