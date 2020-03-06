//
//  MQISearchResultsManager.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

let search_path = "search.db"
class MQISearchResultsManager: NSObject {

    fileprivate static var __once: () = {
        Inner.instance = MQISearchResultsManager()
    }()
    
    var results = [String]()
    var searchPath = MQIFileManager.getCurrentStoreagePath(search_path)
    
    struct Inner {
        static var token: Int = 0
        static var instance: MQISearchResultsManager?
    }
    
    class var shared: MQISearchResultsManager {
        _ = MQISearchResultsManager.__once
        return Inner.instance!
    }
    
    override init() {
        super.init()
        if MQIFileManager.checkFileIsExist(searchPath) == true {
            if let array = NSKeyedUnarchiver.unarchiveObject(withFile: searchPath) as? [String] {
                results = array
            }
        }
    }
    
    func saveResults() {
        dispatchArchive(results, path: searchPath)
    }
    
    func saveKey(_ key: String) {
        for i in 0..<results.count {
            if results[i] == key {
                results.remove(at: i)
                break
            }
        }
        results.insert(key, at: 0)
        saveResults()
    }
    
    func configResults(_ keys: [String]) {
        for i in 0..<keys.count {
            var isHave: Bool = false
            for j in 0..<results.count {
                if keys[i] == results[j] {
                    isHave = true
                }
            }
            if isHave == false {
                results.append(keys[i])
            }
        }
        saveResults()
    }
    
    func removeAll() {
        results.removeAll()
        saveResults()
    }
    
    func removeKey(_ key: String) {
        for i in 0..<results.count {
            if results[i] == key {
                results.remove(at: i)
                break
            }
        }
    }
}
