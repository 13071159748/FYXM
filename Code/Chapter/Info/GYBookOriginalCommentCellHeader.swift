//
//  GYBookOriginalCommentCellHeader.swift
//  Reader
//
//  Created by CQSC  on 2017/6/17.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYBookOriginalCommentCellHeader: UIView {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var nickTextView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var voteBtn: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
    var toVote: ((_ comment: GYEachComment) -> ())?
    
    var comment: GYEachComment = GYEachComment() {
        didSet {
            if comment.comment_id != "" {
                let image = UIImage(named: "mine_header")
                if comment.user_avatar.count > 0{
                    icon.sd_setImage(with: URL(string: comment.user_avatar), placeholderImage: image)
                }else {
                    icon.image = image
                }
                
                
                
                nickLabel.text = comment.user_nick
                timeLabel.text = comment.comment_month2
                
                var vote_num = NSString(string: comment.vote_num).integerValue
                if MQICommentManager.shared.checkIsVote(comment: comment) == true {
                    vote_num += 1
                    voteBtn.tintColor = RGBColor(253, g: 107, b: 64)
                }else {
                    voteBtn.tintColor = UIColor(hex: "666666")
                }
                voteBtn.setTitle(" \(vote_num)", for: .normal)
                
                contentLabel.attributedText = comment.content_attstr
                if comment.comment_good == "1" {
                    addGoodIcon()
                }else {
                    removeGoodIcon()
                }
                
                if comment.comment_top == "1" {
                    addTopIcon()
                }else {
                    removeTopIcon()
                }
                //章节评论
                let chapter = comment.chapter
                if chapter.chapter_title.count > 0 {
                    addChapterTitle()
                    chaptertitle.text = "(\(chapter.chapter_title))"

                }else {
                    removeChapterTitle()

                }
                
                /*
                if let chapter = comment.chapter {
                    addChapterTitle()
//                    MQLog("🍎\(chapter.chapter_title)")

//                    if let _ = chapter.chapter_title {
                    if chapter.chapter_title.count > 0 {
                        MQLog("🍎--\(chapter.chapter_title)")

                        chaptertitle.text = "(\(chapter.chapter_title))"
                    }
                }else {
                    removeChapterTitle()
                }
                */
            }
        }
    }
    var chaptertitle:UILabel!
    func addChapterTitle() {
        if chaptertitle == nil {
            chaptertitle = createLabel(CGRect.zero, font: UIFont.systemFont(ofSize: 10), bacColor: UIColor.white, textColor: UIColor.colorWithHexString("#999999"), adjustsFontSizeToFitWidth: false, textAlignment: .left, numberOfLines: 1)
            self.addSubview(chaptertitle)
        }
        chaptertitle.frame = CGRect (x: nickLabel.x, y: self.height - 10, width: screenWidth-65, height: 10)
//        chaptertitle.backgroundColor = UIColor.yellow
//        chaptertitle.textColor = UIColor.black
        self.bringSubviewToFront(chaptertitle)
    }
    func removeChapterTitle() {
        if let _ = chaptertitle {
            chaptertitle!.removeFromSuperview()
            chaptertitle = nil
        }
    }
    var goodLabel: UILabel?
    var topLabel: UILabel?
    func addGoodIcon() {
        if goodLabel == nil {
            goodLabel = createLabel(CGRect.zero,
                                font: italicfont(),
                                bacColor: UIColor.colorWithHexString("#E53D3D"),
                                textColor: UIColor.white,
                                adjustsFontSizeToFitWidth: false,
                                textAlignment: .center,
                                numberOfLines: 1)
        }
        let nickWidth = getAutoRect(comment.user_nick, font: nickLabel.font, maxWidth: nickLabel.width, maxHeight: nickLabel.height).size.width
        
        goodLabel!.text = "置顶"
        goodLabel!.frame = CGRect(x: nickWidth+nickLabel.x+10,
                                  y: nickLabel.y+(nickLabel.height-15)/2,
                                  width: 35, height: 15)
        goodLabel!.layer.cornerRadius = goodLabel!.height/2
//        goodLabel!.layer.borderColor = goodLabel!.textColor.cgColor
//        goodLabel!.layer.borderWidth = 1.0
        goodLabel!.layer.masksToBounds = true
        self.addSubview(goodLabel!)
        self.bringSubviewToFront(goodLabel!)
    }
    
    func removeGoodIcon() {
        if let _ = goodLabel {
            goodLabel!.removeFromSuperview()
            goodLabel = nil
        }
    }
    
    func addTopIcon() {
        if topLabel == nil {
            topLabel = createLabel(CGRect.zero,
                                    font: italicfont(),
                                    bacColor: UIColor.colorWithHexString("#0097A7"),
                                    textColor: UIColor.white,
                                    adjustsFontSizeToFitWidth: false,
                                    textAlignment: .center,
                                    numberOfLines: 1)
        }
        var originX: CGFloat = 0
        if let goodLabel = goodLabel {
            originX = goodLabel.maxX+10
        }else {
            let nickWidth = getAutoRect(comment.user_nick, font: nickLabel.font, maxWidth: nickLabel.width, maxHeight: nickLabel.height).size.width
            originX = nickWidth+nickLabel.x+10
        }
        
        topLabel!.text = kLocalized("Essence")
        topLabel!.frame = CGRect(x: originX,
                                  y: nickLabel.y+(nickLabel.height-15)/2,
                                  width: 35, height: 15)
        topLabel!.layer.cornerRadius = topLabel!.height/2
        topLabel!.layer.borderColor = topLabel!.textColor.cgColor
        topLabel!.layer.borderWidth = 1.0
        topLabel!.layer.masksToBounds = true
        self.addSubview(topLabel!)
        self.bringSubviewToFront(topLabel!)
    }
    
    func removeTopIcon() {
        if let _ = topLabel {
            topLabel!.removeFromSuperview()
            topLabel = nil
        }
    }
    
    func italicfont() -> UIFont {
//        let transform = __CGAffineTransformMake(1, 0, 0.2, 1, 0, 0)
//        let desc = UIFontDescriptor(name: systemFont(10).fontName, matrix: transform)
//        return UIFont(descriptor: desc, size: 10)
        return UIFont.systemFont(ofSize: 10)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nickLabel.font = systemFont(14)
        nickLabel.textColor = UIColor(hex: "313131")
        
        timeLabel.font = systemFont(12)
        timeLabel.textColor = UIColor(hex: "999999")

        icon.layer.cornerRadius = icon.width/2
        icon.clipsToBounds = true
        icon.backgroundColor = UIColor(hex: "999999")
        contentLabel.numberOfLines = 0
        contentLabel.font = systemFont(13)
        contentLabel.textColor = UIColor(hex: "666666")
        
//        contentLabel.frame = CGRect (x: contentLabel.x, y: timeLabel.maxY + 10, width: contentLabel.width, height: self.height - 20)
        
//        contentLabel.backgroundColor = UIColor.red
        
        voteBtn.setTitle(" 999", for: .normal)
        voteBtn.setTitleColor(UIColor(hex: "666666"), for: .normal)
        voteBtn.titleLabel?.font = systemFont(14)
        voteBtn.contentHorizontalAlignment = .center
        
        let image = UIImage(named: "info_likes")?.withRenderingMode(.alwaysTemplate)
        voteBtn.setImage(image, for: .normal)
        voteBtn.tintColor = UIColor(hex: "666666")
        
    }
    
    @IBAction func voteAction(_ sender: Any) {
        if comment.comment_id != "" {
            if MQICommentManager.shared.checkIsVote(comment: comment) == false {
                toVote?(comment)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    class func getHeight(comment: GYEachComment) -> CGFloat {
        
        let regex = try! NSRegularExpression(pattern: "<([^>]*)>", options: NSRegularExpression.Options(rawValue: 0))
        let str = regex.stringByReplacingMatches(in: comment.comment_content, options: .reportProgress, range: NSMakeRange(0, comment.comment_content.length), withTemplate: "")
        
        let height = getAutoRect(str, font: UIFont.systemFont(ofSize: 13), maxWidth: screenWidth-65, maxHeight: CGFloat(MAXFLOAT)).size.height
        
        var titleHeight = 0
//        if let chapter = comment.chapter {
            if comment.chapter.chapter_title.count > 0{
                titleHeight = 10
            }
//        }
        return 76+height+CGFloat(titleHeight)
    }
    
}

extension GYBookOriginalCommentCellHeader {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width,
                      height: GYBookOriginalCommentCellHeader.getHeight(comment: comment))
//        return CGSize(width: size.width, height: contentLabel.sizeThatFits(size).height+76)
    }
}
