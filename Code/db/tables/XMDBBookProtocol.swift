//
// XMDBBookProtocol.swift
//  TSYQKReader
//
//  Created by moqing on 2019/4/18.
//  Copyright © 2019年 _CHK_. All rights reserved.
//

///书

///书架
extension XMDBTool {
    ///获取书
    func fetch(book bid: Int?) throws -> NSDictionary? {
        guard let bid = bid else { return nil }
        return try XMDB.shared.query(sql: .select(t_name: "book", key: "bookId", value: bid))?.first as NSDictionary?
    }
    ///添加书
    func insert(book: XMDBBookProtocol?) throws {
        guard let book = book else { return }
        guard let db = XMDB.shared.db else { return }
        try XMDB.shared.insert(sql: .insert(t_db: db, book: book))
    }
    
    ///添加书
    func insert(books: [XMDBBookProtocol]) throws {
        guard let db = XMDB.shared.db else { return }
        db.open()
        defer { db.close() }
        defer { db.commit() }
        db.beginTransaction()
        for book in books {
            try XMDB.shared.insert_noTransaction(t_db: db, sql: .insert(t_db: db, book: book))
        }
    }
    
    
    ///更新
    func update(book bid: Int?, values: [XMBookAttribute]?) throws {
        guard let bid = bid, let values = values else { return }
        try XMDB.shared.insert(sql: .update(t_name: "book", key: "bookId", value: bid, values: values))
    }
}
protocol XMDBBookProtocol {
    
    var bookId: Int { get }
    
    var name: String { get }
    
    var chapterCount: Int { get }
    
    var authorName: String { get }
    
    var authorId: Int { get }
    
    var caption: String { get }
    
    var shortCaption: String  { get }
    
    var category: String { get }
    
    var subcategory: String { get }
    
    var lastChapterId: Int { get }
    
    var lastChapterTitle: String { get }
    
    var voteNumber: Int { get }
    
    var readNumber: Int { get }
    
    var status: Int { get }
    
    var label: String { get }
    
    var tags: String { get }
    
    var wordCount: Int { get }
    
    var sectionId: Int { get }
    
    var bookUpdateTime: Int { get }
    
    var cover: String { get }
    
}


enum XMBookAttribute: XMDBModelAttribute {
    case name(String)
    case chapterCount(Int)
    case wordCount(Int)
    case sectionId(Int)
    case entireSubscribe(Int)
    case bookUpdateTime(Int)
    case label(String)
    case tags(String)
    case status(Int)
    case readNumber(Int)
    case voteNumber(Int)
    case lastChapterTitle(String)
    case lastChapterId(Int)
    case caption(String)
    case shortCaption(String)
    case category(String)
    case subcategory(String)
    case authorId(Int)
    case authorName(String)
    case cover(String)
    
    var attributeName: String {
        switch self {
        case .authorId(_):
            return "authorId"
        case .authorName(_):
            return "authorName"
        case .cover(_):
            return "cover"
        case .name(_):
            return "name"
        case .chapterCount(_):
            return "chapterCount"
        case .wordCount(_):
            return "wordCount"
        case .sectionId(_):
            return "sectionId"
        case .entireSubscribe(_):
            return "entireSubscribe"
        case .bookUpdateTime(_):
            return "bookUpdateTime"
        case .label(_):
            return "label"
        case .tags(_):
            return "tags"
        case .status(_):
            return "status"
        case .readNumber(_):
            return "readNumber"
        case .voteNumber(_):
            return "voteNumber"
        case .lastChapterTitle(_):
            return "lastChapterTitle"
        case .lastChapterId(_):
            return "lastChapterId"
        case .caption(_):
            return "caption"
        case .shortCaption(_):
            return "shortCaption"
        case .category(_):
            return "category"
        case .subcategory(_):
            return "subcategory"
        }
    }
    
    var value: Any {
        switch self {
        case .name(let value):
            return value
        case .chapterCount(let value):
            return value
        case .wordCount(let value):
            return value
        case .sectionId(let value):
            return value
        case .entireSubscribe(let value):
            return value
        case .bookUpdateTime(let value):
            return value
        case .label(let value):
            return value
        case .tags(let value):
            return value
        case .status(let value):
            return value
        case .readNumber(let value):
            return value
        case .voteNumber(let value):
            return value
        case .lastChapterTitle(let value):
            return value
        case .lastChapterId(let value):
            return value
        case .caption(let value):
            return value
        case .shortCaption(let value):
            return value
        case .category(let value):
            return value
        case .subcategory(let value):
            return value
        case .authorId(let value):
            return value
        case .authorName(let value):
            return value
        case .cover(let value):
            return value
        }
    }
    
    var isString: Bool {
        switch self {
        case .name(_),
             .label(_),
             .tags(_),
             .lastChapterTitle(_),
             .caption(_),
             .shortCaption(_),
             .category(_),
             .subcategory(_),
             .cover(_),
             .authorName(_):
            return true
        case .chapterCount(_),
             .wordCount(_),
             .sectionId(_),
             .entireSubscribe(_),
             .status(_),
             .readNumber(_),
             .voteNumber(_),
             .lastChapterId(_),
             .authorId(_),
             .bookUpdateTime(_):
            return false
        }
    }
}
