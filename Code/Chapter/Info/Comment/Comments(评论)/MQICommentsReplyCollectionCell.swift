//
//  MQICommentsReplyCollectionCell.swift
//  Reader
//
//  Created by _CHK_  on 2017/11/4.
//  Copyright © 2017年 _xinmo_. All rights reserved.
//

import UIKit

class MQICommentsReplyCollectionCell: MQICollectionViewCell {
    
    var replyView: MQIBookOriginalCommentCellReply!

    var reply: GYEachCommentReply! {
        didSet {
            replyView.reply = reply
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func configUI() {
        replyView = UIView.loadNib(MQIBookOriginalCommentCellReply.self)
        backgroundColor = .white//kUIStyle.randomColor()
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
class GDCommentsHeaderCollectionCell: UICollectionReusableView {

    var header: GDCommetsHeaderView!


    var comment:GYEachComment! {
        didSet{
            header.comment = comment
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    func createUI() {
        header = GDCommetsHeaderView(frame: CGRect.zero)
        header.frame = bounds
        self.addSubview(header)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        header.frame = bounds
    }
}
class GDCommetsHeaderView:UIView {
    let headerImage = UIImage(named: "mine_header")

    var icon:UIImageView!
    var nickLabel:UILabel!
    var timeLabel:UILabel!
    var contentView:UILabel!
    var topLabel:UILabel!
    var goodLabel:UILabel!
    var chapterTitleLabel:UILabel!
    var voteBtn:UIButton!
    
    
    var toVote: ((_ comment: GYEachComment) -> ())?
    
    var comment: GYEachComment = GYEachComment() {
        didSet{
            if comment.comment_id != "" {

                if comment.user_avatar.count > 0{
                    icon.sd_setImage(with: URL(string: comment.user_avatar), placeholderImage: headerImage)
                }else {
                    icon.image = headerImage
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
//                MQLog(comment.comment_content)
                contentView.attributedText = comment.content_attstr

                layoutSubviews()
                
                //置顶，精华
                
                if comment.comment_top == "1" {
                    addGoodIcon()
                }else {
                    removeGoodIcon()
                }
                if comment.comment_good == "1" {
                    addTopIcon()
                }else {
                    removeTopIcon()
                }
                let chapter = comment.chapter
                if chapter.chapter_title.count > 0 {
//                    addChapterTitle()
//                    chapterTitleLabel.text = "(\(chapter.chapter_title))"
                    chapterTitleLabel.isHidden = false
                    chapterTitleLabel.text = "(\(chapter.chapter_title))"
                }else {
//                    removeChapterTitle()
                    chapterTitleLabel.isHidden = true
                }
                
                
            }
        }
    }
    func addChapterTitle() {
        if chapterTitleLabel == nil {
            chapterTitleLabel = createLabel(CGRect.zero, font: UIFont.systemFont(ofSize: 10), bacColor: UIColor.white, textColor: UIColor.colorWithHexString("#999999"), adjustsFontSizeToFitWidth: false, textAlignment: .left, numberOfLines: 1)
            self.addSubview(chapterTitleLabel)
        }
        chapterTitleLabel.frame = CGRect (x: nickLabel.x, y: contentView.maxY + 10, width: screenWidth-100, height: 10)
        chapterTitleLabel.backgroundColor = UIColor.red
        //        chaptertitle.textColor = UIColor.black
        self.bringSubviewToFront(chapterTitleLabel)
    }
    func removeChapterTitle() {
        if let _ = chapterTitleLabel {
            chapterTitleLabel!.removeFromSuperview()
            chapterTitleLabel = nil
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    func createUI(){

        icon = UIImageView(frame: CGRect.zero)
        icon.image = headerImage
        icon.backgroundColor = UIColor(hex: "999999")
        self.addSubview(icon)
        
        nickLabel = UILabel(frame: CGRect.zero)
        nickLabel.textColor = UIColor.colorWithHexString("#313131")
        nickLabel.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(nickLabel)
        
        timeLabel = UILabel(frame: CGRect.zero)
        timeLabel.textColor = UIColor.colorWithHexString("#999999")
        timeLabel.font = UIFont.systemFont(ofSize: 10)
        self.addSubview(timeLabel)
        
        contentView = UILabel(frame: CGRect.zero)
//        contentView.backgroundColor = UIColor.yellow
        contentView.numberOfLines = 0
        contentView.font = UIFont.systemFont(ofSize: 13)
        contentView.textColor = UIColor.colorWithHexString("#666666")
        self.addSubview(contentView)
        
        voteBtn = UIButton(type: .custom)
        voteBtn.setTitle(" 999", for: .normal)
        voteBtn.setTitleColor(UIColor(hex: "666666"), for: .normal)
        voteBtn.titleLabel?.font = systemFont(14)
        voteBtn.contentHorizontalAlignment = .center
        let image = UIImage(named: "info_likes")?.withRenderingMode(.alwaysTemplate)
        voteBtn.setImage(image, for: .normal)
        voteBtn.tintColor = UIColor(hex: "666666")
        self.addSubview(voteBtn)
        voteBtn.addTarget(self, action: #selector(GDCommetsHeaderView.voteAction(_:)), for: .touchUpInside)
        
        
        chapterTitleLabel = createLabel(CGRect.zero, font: UIFont.systemFont(ofSize: 10), bacColor: UIColor.white, textColor: UIColor.colorWithHexString("#999999"), adjustsFontSizeToFitWidth: false, textAlignment: .left, numberOfLines: 1)
        self.addSubview(chapterTitleLabel)
//        chapterTitleLabel.backgroundColor = UIColor.red
        self.bringSubviewToFront(chapterTitleLabel)

        
    }
    @objc func voteAction(_ sender: Any) {
        if comment.comment_id != "" {
            if MQICommentManager.shared.checkIsVote(comment: comment) == false {
                toVote?(comment)
            }
        }
    }
    class func getHeight(comment: GYEachComment) -> CGFloat {
        let regex = try! NSRegularExpression(pattern: "<([^>]*)>", options: NSRegularExpression.Options(rawValue: 0))
        let str = regex.stringByReplacingMatches(in: comment.comment_content, options: .reportProgress, range: NSMakeRange(0, comment.comment_content.length), withTemplate: "")
        
        let height = getAutoRect(str, font: UIFont.systemFont(ofSize: 13), maxWidth: screenWidth-65, maxHeight: CGFloat(MAXFLOAT)).size.height
        
        var titleHeight = 0
        if comment.chapter.chapter_title.count > 0{
            titleHeight = 20
        }
        return 57 + height+CGFloat(titleHeight)
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        icon.frame = CGRect (x: 15, y: 10, width: 32, height: 32)
        icon.layer.cornerRadius = icon.width/2
        icon.clipsToBounds = true

        nickLabel.frame = CGRect (x: icon.maxX + 7, y: icon.y + 5, width: self.width - icon.maxX - 65, height: 12)
        
        timeLabel.frame = CGRect (x: nickLabel.x, y: nickLabel.maxY + 5, width: 100, height: 10)
        
        var chapterTitleHeight = 0
        if comment.chapter.chapter_title.count > 0 {
            chapterTitleHeight = 10 + 10
        }
        
        contentView.frame = CGRect (x: nickLabel.x, y: timeLabel.maxY + 10, width: self.width - icon.maxX - 7 - 44, height: self.height - 57 - CGFloat(chapterTitleHeight))
        voteBtn.frame = CGRect (x: self.width - 60, y: nickLabel.y, width: 40, height: 20.5)
    
        chapterTitleLabel.frame = CGRect (x: nickLabel.x, y: self.height - 20, width: contentView.width, height: 10)
    }
    
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
//        54+
        goodLabel!.text = "置顶"
        goodLabel!.frame = CGRect(x: nickWidth+54+10,
                                  y: nickLabel.y+(nickLabel.height-15)/2,
                                  width: 35, height: 15)
        goodLabel!.layer.cornerRadius = goodLabel!.height/2
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
            originX = nickWidth+54+10
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
        return UIFont.systemFont(ofSize: 10)
    }
    
}

