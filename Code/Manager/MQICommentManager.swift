//
//  MQICommentManager.swift
//  Reader
//
//  Created by CQSC  on 2017/6/17.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class MQICommentManager: NSObject {
    
    var tmpPath = MQIFileManager.getCurrentStoreagePath("commentVoteIds.db")
    var commentVoteIds = [String]()
    
    fileprivate static var __once: () = {
        Inner.instance = MQICommentManager()
    }()
    
    struct Inner {
        static var token: Int = 0
        static var instance: MQICommentManager?
    }
    
    class var shared: MQICommentManager {
        _ = MQICommentManager.__once
        return Inner.instance!
    }
    
    override init() {
        super.init()
        //        if MQIFileManager.checkFileIsExist(tmpPath) == true {
        //            if let array = NSKeyedUnarchiver.unarchiveObject(withFile: tmpPath) as? [String] {
        //                commentVoteIds = array
        //            }
        //        }
        commentVoteIds = getdbLikes()
        if commentVoteIds.count == 0 {
            commentVoteIds =  conversionFileData()
        }
        
    }
    
    @discardableResult func saveIds() -> Bool {
        if commentVoteIds.count >= 0 {
            dispatchArchive(commentVoteIds, path: tmpPath)
            return true
        }
        return true
    }
    
    func checkIsVote(comment: GYEachComment) -> Bool {
        
        return commentVoteIds.contains(comment.comment_id) == true
    }
    
    func addCommentVoteId(comment: GYEachComment) {
        if commentVoteIds.contains(comment.comment_id) == false {
            commentVoteIds.append(comment.comment_id)
        }
        //        saveIds()
        
        saveDBLikes(commentVote(id:comment.comment_id.integerValue(), like: 1))
    }
}

struct commentVote:XMDBCommentLikeProtocol {
    var id: Int
    var like: Int
    
}


extension MQICommentManager {
    
    func getdbLikes() -> [String] {
        var likes = [String]()
        do {
            likes =  try XMDBTool.shared.selectAllCommentLike()
            return likes
        } catch  {
            mqLog(error.localizedDescription)
            return likes
        }
    }
    
    
    func saveDBLikes(_ vote:commentVote) {
        do{
            try XMDBTool.shared.insert(cl: vote)
            mqLog("保存成功")
        }
        catch  {
            mqLog("保存失败")
        }
    }
    /// 本地数据转化
    func conversionFileData() -> [String]  {
        if  let array = NSKeyedUnarchiver.unarchiveObject(withFile: tmpPath) as? [String] {
            for likes in array {
                let likesNEW = commentVote(id: likes.integerValue(), like: 1)
                saveDBLikes(likesNEW)
            }
            MQIFileManager.removePath(tmpPath)
            return array
        }else{
            return [String]()
        }
        
    }
    
    
    
}
