//
//  GYBookOriginalCommentCell.swift
//  Reader
//
//  Created by CQSC  on 2017/3/28.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYBookOriginalCommentCell: MQITableViewCell {
 
    var header: GYBookOriginalCommentCellHeader!
    var replys = [GYBookOriginalCommentCellReply]()
    
    var comment: GYEachComment! {
        didSet {
            header.comment = comment
            header.frame = CGRect(x: 0, y: 0,
                                  width: self.width,
                                  height: GYBookOriginalCommentCellHeader.getHeight(comment: comment))
            
            for reply in replys {
                reply.removeFromSuperview()
            }
            replys.removeAll()
            var originY: CGFloat = header.maxY
            for i in 0..<(comment.reply.count > 2 ? 2 : comment.reply.count) {
                let reply = UIView.loadNib(GYBookOriginalCommentCellReply.self)
                reply.reply = comment.reply[i]
                reply.frame = CGRect(x: header.contentLabel.x,
                                         y: originY,
                                         width: header.contentLabel.width,
                                         height: GYBookOriginalCommentCellReply.getHeight(reply: comment.reply[i], width: header.contentLabel.width))
                contentView.addSubview(reply)
                replys.append(reply)
                
                originY = reply.maxY
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configUI()
    }
    
    func configUI() {
        header = UIView.loadNib(GYBookOriginalCommentCellHeader.self)
        contentView.addSubview(header)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override class func getHeight<T: MQIBaseModel>(_ obj: T?) -> CGFloat {
        let comment = obj as! GYEachComment
        var height: CGFloat = 0
        for i in 0..<(comment.reply.count > 2 ? 2 : comment.reply.count) {
            let replyHeight = GYBookOriginalCommentCellReply.getHeight(reply: comment.reply[i], width: (screenWidth-63))
            height += replyHeight
        }
        return GYBookOriginalCommentCellHeader.getHeight(comment: comment)+height
    }
}


class GYBookOriginalCommentHeaderCell: MQITableViewCell {
    
    var header: GYBookOriginalCommentCellHeader!
    
    var comment: GYEachComment! {
        didSet {
            header.comment = comment
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func configUI() {
        header = UIView.loadNib(GYBookOriginalCommentCellHeader.self)
        header.frame = bounds
        contentView.addSubview(header)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        header.frame = bounds
    }
}

class MQIBookOriginalCommentReplyCell: MQITableViewCell {
    
    var replyView: GYBookOriginalCommentCellReply!
    
    var reply: GYEachCommentReply! {
        didSet {
            replyView.reply = reply
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        configUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func configUI() {
        replyView = UIView.loadNib(GYBookOriginalCommentCellReply.self)

        replyView.frame = CGRect(x: 50,
                             y: 0,
                             width: self.width-50-13,
                             height: self.height)
        contentView.addSubview(replyView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        replyView.frame = CGRect(x: 50,
                                 y: 0,
                                 width: self.width-50-13,
                                 height: self.height)
    }
}

extension GYBookOriginalCommentHeaderCell {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        return CGSize(width: size.width,
//                      height: GYBookOriginalCommentCellHeader.getHeight(comment: comment))
        return CGSize(width: size.width, height: header.sizeThatFits(size).height)
    }
}

extension MQIBookOriginalCommentReplyCell {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        return CGSize(width: size.width, height: GYBookOriginalCommentCellReply.getHeight(reply: reply, width: size.width))
        return CGSize(width: size.width, height: replyView.sizeThatFits(size).height)
    }
}
