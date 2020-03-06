//
//  AAReadLogManager.swift
//  Reader
//
//  Created by CQSC  on 2018/1/30.
//  Copyright © 2018年  CQSC. All rights reserved.
//

import UIKit


class AAReadLogManager: NSObject {

    static var shared:AAReadLogManager {
        struct gdStatic {
            static let instance = AAReadLogManager()
        }
        return gdStatic.instance
    }
    
    func save_read_logWhenDisappear(_ book_id:String,chapter_id:String, position:String) {
        
        let readTime = GetCurrent_millisecondIntervalSince1970String()
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .short
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let readTime = formatter.string(from: date)
//        MQLog(readTime)
        
        GDSave_read_logRequest(book_id: book_id, chapter_id: chapter_id, position: position, readtime: readTime).request({ (request, response, result) in
        }) { (msg, code) in
        }
        
    }
    
    
}
