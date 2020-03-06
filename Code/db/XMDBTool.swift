//
//  XMUserTool.swift
//  TSYQKReader
//
//  Created by moqing on 2019/4/16.
//  Copyright © 2019年 _CHK_. All rights reserved.
//

import UIKit


class XMDBTool {
    
    private init() {}
    
    static var shared: XMDBTool = XMDBTool()
    
    ///默认user
    var defaultUser: NSDictionary? {
        do {
            return try XMDB.shared.query(sql: .select_user_all)?.filter { return ($0["checkedIn"] as? Int) == 1 }.first as NSDictionary?
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    ///添加用户信息
    func insert(user: XMDBUserProtocol?) throws {
        guard let user = user else { return }
        try XMDB.shared.insert(sql: .insert(user: user))
    }
    ///更新用户信息
    func update(user uid: Int?, values: [XMUserAttribute]?) throws {
        guard let uid = uid, let values = values else { return }
        try XMDB.shared.insert(sql: .update(t_name: "user", key: "uid", value: uid, values: values))
    }
    ///获取全部用户
    func allUser() -> [NSDictionary] {
        guard let us = try? XMDB.shared.query(sql: .select_user_all) else { return [] }
        return us as [NSDictionary]? ?? []
    }
}





protocol XMDBModelAttribute {
    var value: Any { get }
    var isString: Bool { get }
    var attributeName: String { get }
}



