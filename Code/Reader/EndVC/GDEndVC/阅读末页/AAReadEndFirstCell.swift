//
//  AAReadEndFirstCell.swift
//  Reader
//
//  Created by CQSC  on 2018/1/23.
//  Copyright © 2018年  CQSC. All rights reserved.
//

import UIKit


class AAReadEndFirstCell: MQICollectionViewCell {
    
    var headerBtnClick:((_ type:BookHeaderCellBtnType) -> ())?
    var book:MQIEachBook? {
        didSet{
            if let book = book {
                bookCover.sd_setImage(with: URL(string:book.book_cover), placeholderImage: UIImage(named: book_PlaceholderImg))
                bookTitle.text = book.book_name
                if book.book_status == "1"{
                    contentLabel.text = kLocalized("AuthHard")
                }else if book.book_status == "2" {
//                    contentLabel.text = "作者努力更新中感谢您的支持！"
                    contentLabel.text = kLocalized("AuthFinsh")
                }
            }
        }
    }
    fileprivate var bookCover:UIImageView!
    fileprivate var bgView:UIView!
    fileprivate var bookTitle:UILabel!
    fileprivate var contentLabel:UILabel!
    fileprivate var sharedBtn:UIButton!
    fileprivate var wordsView:EndHeaderDetailView!
    fileprivate var likesView:EndHeaderDetailView!
    fileprivate var commentsView:EndHeaderDetailView!
    
    fileprivate var line1:UIView!
    fileprivate var line2:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addFirstView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addFirstView()
    }
    func addFirstView() {
    
        bgView = UIView(frame: CGRect.zero)
        bgView.backgroundColor = UIColor.white
        bgView.layer.cornerRadius = 8
        bgView.clipsToBounds = true
        bgView.isUserInteractionEnabled = true
        contentView.addSubview(bgView)
        
        sharedBtn = bgView.addCustomButton(CGRect.zero, title: nil, action: {[weak self] (sender) in
            if let weakSelf = self {
                weakSelf.sharedClick(sender)
            }
        })
    //TODO:  分享 ====
        let nimaImg = UIImage(named:"info_shared")?.withRenderingMode(.alwaysTemplate)
        sharedBtn.setImage(nimaImg, for: .normal)
        sharedBtn.tintColor = UIColor.colorWithHexString("#999999")
        
        bookCover = UIImageView(frame: CGRect.zero)
        bookCover.layer.cornerRadius = 8
        bookCover.clipsToBounds = true
//        bookCover.backgroundColor = UIColor.colorWithHexString("#939599")
        bookCover.image = UIImage(named: book_PlaceholderImg)
        contentView.addSubview(bookCover)
        contentView.bringSubviewToFront(bookCover)
        
        bookTitle = UILabel(frame: CGRect.zero)
        bookTitle.textColor = UIColor.colorWithHexString("#313133")
        bookTitle.textAlignment = .center
        bookTitle.text = kLocalized("TitleName")
        bookTitle.font = systemFont(17)
        bgView.addSubview(bookTitle)
        
        contentLabel = UILabel(frame: CGRect.zero)
        contentLabel.textColor = UIColor.colorWithHexString("#939599")
        contentLabel.font = systemFont(13)
        contentLabel.textAlignment = .center
        contentLabel.text = kLocalized("HardUpdate")
        bgView.addSubview(contentLabel)
        
        for i in 0..<3 {
            if i==0 {
                wordsView = EndHeaderDetailView(frame: CGRect.zero, title: kLocalized("GiveLike"),imageNamed:"readend_likes")
                addTGR(self, action: #selector(AAReadEndFirstCell.likesTabAction), view: wordsView)
                bgView.addSubview(wordsView)
            }else if i==1 {
                likesView = EndHeaderDetailView(frame: CGRect.zero, title:kLocalized("Exception"),imageNamed:"readend_reward")
                addTGR(self, action: #selector(AAReadEndFirstCell.rewardTapAction), view: likesView)
                bgView.addSubview(likesView)
            }else {
                commentsView = EndHeaderDetailView(frame: CGRect.zero, title: kLocalized("Comments"),imageNamed:"readend_comment")
                addTGR(self, action: #selector(AAReadEndFirstCell.commentsTapAction), view: commentsView)
                bgView.addSubview(commentsView)
            }
        }
        for i in 0..<2 {
            if i==0 {
                line1 = UIView(frame: CGRect.zero)
                line1.backgroundColor = UIColor.colorWithHexString("#EBEBF5")
                contentView.addSubview(line1)
            }else {
                line2 = UIView(frame: CGRect.zero)
                line2.backgroundColor = UIColor.colorWithHexString("#EBEBF5")
                contentView.addSubview(line2)
            }
        }
        
        if MQIPayTypeManager.shared.type == .inPurchase {
            likesView.isHidden = true
            line1.isHidden = true
            line2.isHidden = true
        }
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(58.5*gd_scale+18)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        sharedBtn.translatesAutoresizingMaskIntoConstraints = false
        sharedBtn.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.right.equalTo(bgView.snp.right).offset(-5)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        bookCover.translatesAutoresizingMaskIntoConstraints = false
        bookCover.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(18)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(86.5*gd_scale)
            make.height.equalTo(115.5*gd_scale)
        }
        
        bookTitle.translatesAutoresizingMaskIntoConstraints = false
        bookTitle.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.top).offset(57*gd_scale+16)
            make.left.equalTo(bgView.snp.left)
            make.right.equalTo(bgView.snp.right)
            make.height.equalTo(17)
        }
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bookTitle.snp.bottom).offset(18)
            make.left.equalTo(bgView.snp.left)
            make.right.equalTo(bgView.snp.right)
            make.height.equalTo(13)
        }
  
        if MQIPayTypeManager.shared.type == .inPurchase {
            wordsView.translatesAutoresizingMaskIntoConstraints = false
            wordsView.snp.makeConstraints({ (make) in
                make.top.equalTo(contentLabel.snp.bottom).offset(42)
                make.bottom.equalTo(bgView.snp.bottom)
                make.left.equalTo(bgView.snp.left)
                make.width.equalTo(self.width/2)
            })
            commentsView.translatesAutoresizingMaskIntoConstraints = false
            commentsView.snp.makeConstraints { (make) in
                make.top.equalTo(wordsView.snp.top)
                make.bottom.equalTo(wordsView.snp.bottom)
                make.right.equalTo(bgView.snp.right)
                make.width.equalTo(self.width/2)
            }

            return
        }
        wordsView.translatesAutoresizingMaskIntoConstraints = false
        wordsView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(42)
            make.bottom.equalTo(bgView.snp.bottom)
            make.left.equalTo(bgView.snp.left)
            make.width.equalTo(self.width/3)
        }
        likesView.translatesAutoresizingMaskIntoConstraints = false
        likesView.snp.makeConstraints { (make) in
            make.top.equalTo(wordsView.snp.top)
            make.bottom.equalTo(wordsView.snp.bottom)
            make.left.equalTo(wordsView.snp.right)
            make.width.equalTo(self.width/3)
        }
        commentsView.translatesAutoresizingMaskIntoConstraints = false
        commentsView.snp.makeConstraints { (make) in
            make.top.equalTo(wordsView.snp.top)
            make.bottom.equalTo(wordsView.snp.bottom)
            make.left.equalTo(likesView.snp.right)
            make.width.equalTo(self.width/3)
        }
        
        line1.translatesAutoresizingMaskIntoConstraints = false
        line1.snp.makeConstraints { (make) in
            make.left.equalTo(wordsView.snp.right).offset(-0.25)
            make.width.equalTo(0.5)
            make.height.equalTo(33)
            make.centerY.equalTo(wordsView.snp.centerY).offset(-5)
        }
        line2.translatesAutoresizingMaskIntoConstraints = false
        line2.snp.makeConstraints { (make) in
            make.left.equalTo(likesView.snp.right).offset(-0.25)
            make.width.equalTo(0.5)
            make.height.equalTo(33)
            make.centerY.equalTo(wordsView.snp.centerY).offset(-5)
        }
    }
    class func getFirstCellSize() -> CGSize {
        return CGSize(width: screenWidth-49*gd_scale, height: 18+295-115.5 + 115.5*gd_scale)
    }
    func sharedClick(_ sender:UIButton) {
        headerBtnClick?(.sharedBtn)
    }
    @objc func likesTabAction() {
        headerBtnClick?(.likeBtn)
    }
    @objc func rewardTapAction() {
        headerBtnClick?(.rewardBtn)
    }
    @objc func commentsTapAction() {
        headerBtnClick?(.commentBtn)
    }
    
    
}
class EndHeaderDetailView :UIView{
        var bottomLabel:UILabel!
    var topImageView:UIImageView!
    
    fileprivate let bottomFont = 11*gd_scale < 11 ? 11 : 11*gd_scale
    fileprivate let topFont = 25*gdscale > 25 ? 25 : 25*gdscale
    
    init(frame: CGRect,title:String,imageNamed:String) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        createUI(title,imageNamed: imageNamed)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func createUI(_ title :String,imageNamed:String) {
        
        topImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20*gd_scale, height: 20*gd_scale))
        topImageView.image = UIImage(named: imageNamed)
        topImageView.centerX = self.width/2
        self.addSubview(topImageView)
        
        bottomLabel = UILabel(frame: CGRect(x: 0, y: topImageView.maxY + 15.5, width: self.width, height: bottomFont))
        bottomLabel.text = title
        bottomLabel.textAlignment = .center
        bottomLabel.font = systemFont(bottomFont)
        bottomLabel.textColor = UIColor.colorWithHexString("#939599")
        addSubview(bottomLabel)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        topImageView.frame = CGRect(x: 0, y: 0, width: 20*gd_scale, height: 20*gd_scale)
        topImageView.centerX = self.width/2
        bottomLabel.frame = CGRect(x: 0, y: topImageView.maxY + 17, width: self.width, height: bottomFont)
    }
    
}

