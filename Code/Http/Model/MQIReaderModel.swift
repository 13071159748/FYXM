//
//  MQIReaderModel.swift
//  Reader
//
//  Created by CQSC  on 16/7/17.
//  Copyright © 2016年  CQSC. All rights reserved.
//

import UIKit


class MQIReaderModel: MQIBaseModel {
    
    var bid: String = ""
    var bookChapterIndex: Int = 0
    var bookChapterPage: Int = 0
    var bookChapterTitle: String = ""
    var bookPageMode: Bool = false
    var bookTitle: String = ""
    var bookCover: String = ""
    
    override init() {
        super.init()
        
    }
    
    required init(jsonDict: [String : Any]) {
        super.init(jsonDict: jsonDict)
    }
    
    required init?(response: HTTPURLResponse, representation: Any) {
        super.init(response: response, representation: representation)
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
        bid = decodeStringForKey(aDecoder, key: "bookId")
        bookChapterIndex = decodeIntForKey(aDecoder, key: "chapterIndex") < 0 ? 0 : decodeIntForKey(aDecoder, key: "chapterIndex")
        bookChapterPage = decodeIntForKey(aDecoder, key: "chapterPage") < 0 ? 0 : decodeIntForKey(aDecoder, key: "chapterPage")
        bookPageMode = decodeBoolForKey(aDecoder, key: "bookPageMode_new")
        bookChapterTitle = decodeStringForKey(aDecoder, key: "bookChapterTitle")
        bookTitle = decodeStringForKey(aDecoder, key: "bookTitle")
        bookCover = decodeStringForKey(aDecoder, key: "bookCover")
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(bid, forKey: "bookId")
        aCoder.encode(bookChapterIndex, forKey: "chapterIndex")
        aCoder.encode(bookChapterPage, forKey: "chapterPage")
        aCoder.encode(bookPageMode, forKey: "bookPageMode_new")
        aCoder.encode(bookChapterTitle, forKey: "bookChapterTitle")
        aCoder.encode(bookTitle, forKey: "bookTitle")
        aCoder.encode(bookCover, forKey: "bookCover")
    }
    
}
