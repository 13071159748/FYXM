//
//  XMDBSearchHistorProtocol.swift
//  TSYQKReader
//
//  Created by moqing on 2019/4/18.
//  Copyright © 2019年 _CHK_. All rights reserved.
//

enum XMSeq: String {
    case asc = "ASC"
    case desc = "DESC"
}

extension XMDBTool {
    
    ///获取全部搜索结果  asc = "正序"， desc = "倒序"
    func selectAllSearchHistory(seq: XMSeq = .desc) throws -> [String] {
        let rs = try XMDB.shared.query(sql: .select_searchHistory_all(seq: seq.rawValue))
        return rs?.map { return $0["keyword"] } as? [String] ?? []
    }
    
    ///删除搜索结果
    func remove(sh: XMDBSearchHistoryProtocol?) throws {
        guard let sh = sh else { return }
        try XMDB.shared.delete(sql: .remove(sh: sh))
    }
    
    ///删除全部搜索结果
    func removeAllSearchHistory() throws {
        try XMDB.shared.delete(sql: .remove_searchHistory_all)
    }
    
    ///添加搜索结果
    func insert(sh: XMDBSearchHistoryProtocol?) throws {
        guard let sh = sh else { return }
        try XMDB.shared.insert(sql: .insert(sh: sh))
    }
}



///搜索历史
protocol XMDBSearchHistoryProtocol {
    var keyword: String { get }
}
enum XMSearchHistoryAttribute: XMDBModelAttribute {
    case keyword(String)
    case count(Int)
    
    var attributeName: String {
        switch self {
        case .keyword(_):
            return "keyword"
        case .count(_):
            return "count"
        }
    }
    var value: Any {
        switch self {
        case .keyword(let value):
            return value
        case .count(let value):
            return value
        }
    }
    var isString: Bool {
        switch self {
        case .keyword(_):
            return true
        case .count(_):
            return false
        }
    }
}
