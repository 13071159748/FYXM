//
//  XMSQL+query.swift
//  TSYQKReader
//
//  Created by moqing on 2019/4/16.
//  Copyright © 2019年 _CHK_. All rights reserved.
//

import Foundation
import FMDB
//MARK: - create (查找)
extension XMSQL {
    static var select_book_all: XMSQL = XMSQL(sql: "SELECT * FROM book")
    static var select_user_all: XMSQL = XMSQL(sql: "SELECT * FROM user")
    static var select_commentLike_all: XMSQL = XMSQL(sql: "SELECT * FROM comment_like")
    static var select_readLog_all: XMSQL = XMSQL(sql: "SELECT * FROM [latest_read_log]")
    static var select_shelf_all: XMSQL = XMSQL(sql: "SELECT * FROM [bookshelf]")
    static var remove_searchHistory_all: XMSQL = XMSQL(sql: "DELETE FROM search_history")
    static var remove_commentLike_all: XMSQL = XMSQL(sql: "DELETE FROM comment_like")
}

extension XMSQL {
    static func insert(user: XMDBUserProtocol) -> XMSQL {
        let select_sql = select(t_name: "user", key: "uid", value: user.uid)
        do {
            if !(try XMDB.shared.query(sql: select_sql)?.isEmpty ?? true) {
                let values: [XMUserAttribute] = [.nick(user.nick),
                                                 .avatar(user.avatar),
                                                 .mobile(user.mobile),
                                                 .regTime(user.regTime),
                                                 .vipLevel(user.vipLevel),
                                                 .vipTime(user.vipTime),
                                                 .vipExpiredTime(user.vipExpiredTime),
                                                 .coin(user.coin),
                                                 .premium(user.premium),
                                                 .vipState(user.vipState),
                                                 .token(user.token),
                                                 .email(user.email)]
                return update(t_name: "user", key: "uid", value: user.uid, values: values)
            }
        }
        catch { print(error.localizedDescription) }
        let sql = "INSERT INTO user (uid, nick, avatar, mobile, regTime, vipLevel, vipTime, vipExpiredTime, coin, premium, vipState, token , email) VALUES (\(user.uid), '\(user.nick)','\(user.avatar)','\(user.mobile)','\(user.regTime)',\(user.vipLevel),\(user.vipTime),\(user.vipExpiredTime),\(user.coin),\(user.premium),\(user.vipState),'\(user.token)','\(user.email)')"
        return XMSQL(sql: sql)
    }
    static func select_searchHistory_all(seq: String) -> XMSQL {
        return XMSQL(sql: "SELECT * FROM search_history ORDER BY count DESC")
        
    }
    
    static func insert(t_db: FMDatabase, book: XMDBBookProtocol) -> XMSQL {
        let select_sql = select(t_name: "book", key: "bookId", value: book.bookId)
        do {
            
            let array = t_db.isOpen ? try XMDB.shared.query_noTransaction(sql: select_sql)
                : try XMDB.shared.query(sql: select_sql)
            if !(array?.isEmpty ?? true) {
                let values: [XMBookAttribute] = [.name(book.name),
                                                 .chapterCount(book.chapterCount),
                                                 .wordCount(book.wordCount),
                                                 .sectionId(book.sectionId),
                                                 .bookUpdateTime(book.bookUpdateTime),
                                                 .label(book.label),
                                                 .tags(book.tags),
                                                 .status(book.status),
                                                 .readNumber(book.readNumber),
                                                 .voteNumber(book.voteNumber),
                                                 .lastChapterTitle(book.lastChapterTitle),
                                                 .lastChapterId(book.lastChapterId),
                                                 .caption(book.caption),
                                                 .shortCaption(book.shortCaption),
                                                 .category(book.category),
                                                 .subcategory(book.subcategory),
                                                 .authorId(book.authorId),
                                                 .authorName(book.authorName),
                                                 .cover(book.cover)]
                return update(t_name: "book", key: "bookId", value: book.bookId, values: values)
            }
        }
        catch { print(error.localizedDescription) }
        let sql = "INSERT INTO book (bookId, name, chapterCount, authorName, authorId, caption, shortCaption, category, subcategory, lastChapterId, lastChapterTitle, voteNumber, readNumber, status, label, tags, wordCount, sectionId, entireSubscribe, bookUpdateTime, cover) VALUES (\(book.bookId), '\(book.name)',\(book.chapterCount),'\(book.authorName)',\(book.authorId),'\(book.caption)','\(book.shortCaption)','\(book.category)','\(book.subcategory)',\(book.lastChapterId),'\(book.lastChapterTitle)',\(book.voteNumber), \(book.readNumber), \(book.status), '\(book.label)', '\(book.tags)', \(book.wordCount), \(book.sectionId), \(0), \(book.bookUpdateTime), '\(book.cover)')"
        return XMSQL(sql: sql)
    }
    
    static func insert(t_db: FMDatabase, lib: XMDBLibraryProtocol, attrs: [XMLibraryAttribute] = []) -> XMSQL {
        let select_sql = select(t_name: "library", key: "bookId", value: lib.bookId)
        do {
            let array = t_db.isOpen ? try XMDB.shared.query_noTransaction(sql: select_sql)
                : try XMDB.shared.query(sql: select_sql)
            if array?.isEmpty ?? true {
                let sql = "INSERT INTO library (bookId) VALUES (\(lib.bookId))"
                if t_db.isOpen {
                    try XMDB.shared.insert_noTransaction(t_db: t_db, sql: XMSQL(sql: sql))
                } else {
                    try XMDB.shared.insert(sql: XMSQL(sql: sql))
                }
                
            }
        }
        catch { print(error.localizedDescription) }
        return update(t_name: "library", key: "bookId", value: lib.bookId, values: attrs)
    }
    static func insert(cl: XMDBCommentLikeProtocol) -> XMSQL {
        let sql = "INSERT INTO comment_like (id, like) VALUES (\(cl.id), \(cl.like))"
        return XMSQL(sql: sql)
    }
    static func insert(sb: XMDBSubscribeProtocol, attrs: [XMSubscribeAttribute] = []) -> XMSQL {
        let select_sql = "SELECT * FROM subscribe WHERE bookId = \(sb.bookId) AND userId = \(sb.userId)"
        do {
            if try XMDB.shared.query(sql: XMSQL(sql: select_sql))?.isEmpty ?? true {
                let sql = "INSERT INTO subscribe (bookId, userId) VALUES (\(sb.bookId), \(sb.userId))"
                try XMDB.shared.insert(sql: XMSQL(sql: sql))
            }
        }
        catch { print(error.localizedDescription) }
        return update(subscribe: sb.userId, bid: sb.bookId, values: attrs)
    }
    
    
    
    static func insert(sh: XMDBSearchHistoryProtocol) -> XMSQL {
        let select_sql = select(t_name: "search_history", key: "keyword", value: sh.keyword)
        do {
            if var count = try XMDB.shared.query(sql: select_sql)?.first?["count"] as? Int  {
                //                let values: [XMSearchHistoryAttribute] = [.count(count+1)]
                count = getCurrentStamp()
                let values: [XMSearchHistoryAttribute] = [.count(count)]
                return update(t_name: "search_history", key: "keyword", value: sh.keyword, values: values)
            }
        }
        catch { print(error.localizedDescription) }
        let sql = "INSERT INTO search_history (keyword, count) VALUES ('\(sh.keyword)', \(getCurrentStamp()))"
        return XMSQL(sql: sql)
        
    }
    
    static func remove(sh: XMDBSearchHistoryProtocol) -> XMSQL {
        let sql = "DELETE FROM search_history WHERE keyword = '\(sh.keyword)'"
        return XMSQL(sql: sql)
    }
    static func remove(sb: XMDBSubscribeProtocol) -> XMSQL {
        let sql = "DELETE FROM subscribe WHERE bookId = \(sb.bookId) AND userId = \(sb.userId)"
        return XMSQL(sql: sql)
    }
    static func remove(cl: XMDBCommentLikeProtocol) -> XMSQL {
        let sql = "DELETE FROM comment_like WHERE id = '\(cl.id)'"
        return XMSQL(sql: sql)
    }
    
    
    static func select(t_name: String, key: String, value: Int) -> XMSQL {
        let sql = "SELECT * FROM \(t_name) WHERE \(key) = \(value)"
        return XMSQL(sql: sql)
    }
    static func select(t_name: String, key: String, value: String) -> XMSQL {
        let sql = "SELECT * FROM \(t_name) WHERE \(key) = '\(value)'"
        return XMSQL(sql: sql)
    }
    static func select(subscribe uid: Int, conditions: XMDBSubscribeScreenConditions) -> XMSQL {
        var sql = "SELECT * FROM subscribe LEFT JOIN book ON subscribe.bookID=book.bookID WHERE subscribe.userId = \(uid)"
        //        var sql = "SELECT * FROM subscribe WHERE userId = \(uid)"
        switch conditions {
        case .all:
            sql.append(" AND entire = 1")
            break
        case .chapter:
            sql.append(" AND chapterId > 0")
            break
        case .none:
            break
        }
        return XMSQL(sql: sql)
    }
    
    
    static func update(t_name: String, key: String, value: Int, values: [XMDBModelAttribute]) -> XMSQL {
        var sql = "UPDATE \(t_name) SET"
        values.filter { return $0.isString }.forEach { sql.append(" \($0.attributeName) = '\($0.value)',") }
        values.filter { return !$0.isString }.forEach { sql.append(" \($0.attributeName) = \($0.value),") }
        sql.removeLast()
        sql.append(contentsOf: " ")
        sql.append(contentsOf: "WHERE \(key) = \(value)")
        return  XMSQL(sql: sql)
    }
    static func update(t_name: String, key: String, value: String, values: [XMDBModelAttribute]) -> XMSQL {
        var sql = "UPDATE \(t_name) SET"
        values.filter { return $0.isString }.forEach { sql.append(" \($0.attributeName) = '\($0.value)',") }
        values.filter { return !$0.isString }.forEach { sql.append(" \($0.attributeName) = \($0.value),") }
        sql.removeLast()
        sql.append(contentsOf: " ")
        sql.append(contentsOf: "WHERE \(key) = '\(value)'")
        return XMSQL(sql: sql)
    }
    
    static func update(subscribe uid: Int, bid: Int, values: [XMSubscribeAttribute]) -> XMSQL {
        var sql = "UPDATE subscribe SET"
        values.filter { return $0.isString }.forEach { sql.append(" \($0.attributeName) = '\($0.value)',") }
        values.filter { return !$0.isString }.forEach { sql.append(" \($0.attributeName) = \($0.value),") }
        sql.removeLast()
        sql.append(contentsOf: " ")
        sql.append(contentsOf: "WHERE bookId = \(bid) AND userId = \(uid)")
        return XMSQL(sql: sql)
    }
}

