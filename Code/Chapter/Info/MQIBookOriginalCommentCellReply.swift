//
//  MQIBookOriginalCommentCellReply.swift
//  Reader
//
//  Created by _CHK_  on 2017/6/17.
//  Copyright © 2017年 _xinmo_. All rights reserved.
//

import UIKit


class MQIBookOriginalCommentCellReply: UIView {

    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var nickLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!

    var titleFont = systemFont(12)
    
    var reply: GYEachCommentReply! {
        didSet {
//            nickLabel.text = "作者"
            nickLabel.attributedText = getauthorAttstr()
            contentLabel.text = reply.comment_content
        }
    }
    func getauthorAttstr() ->NSMutableAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left
        
        let attStr = NSMutableAttributedString(string: "| ", attributes:
            [NSAttributedString.Key.font : titleFont,
             NSAttributedString.Key.paragraphStyle : paragraph,
             NSAttributedString.Key.foregroundColor : UIColor.red])
        
        let booknameStr = NSMutableAttributedString(string: kLocalized("TheAuthor"), attributes: [NSAttributedString.Key.font : titleFont,NSAttributedString.Key.paragraphStyle : paragraph,                                                             NSAttributedString.Key.foregroundColor : UIColor.colorWithHexString("#23252C")])
        
        attStr.append(booknameStr)
        return attStr
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nickLabel.font = titleFont
        nickLabel.textColor = UIColor(hex: "333333")
        
        contentLabel.numberOfLines = 0
        contentLabel.font = titleFont
        contentLabel.textColor = UIColor(hex: "666666")  
    }
    
    class func getHeight(reply: GYEachCommentReply, width: CGFloat) -> CGFloat {
        let height = getAutoRect(reply.comment_content,
                                 font: systemFont(12),
                                 maxWidth: width, maxHeight: CGFloat(MAXFLOAT)).size.height
        return height+50
    }
}

extension MQIBookOriginalCommentCellReply {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: MQIBookOriginalCommentCellReply.getHeight(reply: reply, width: size.width))
    }
}
