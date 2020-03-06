//
//  GDRankRightCell.swift
//  Reader
//
//  Created by _CHK_  on 2018/1/19.
//  Copyright © 2018年 _xinmo_. All rights reserved.
//

import UIKit
 /*
  拉拉
  */

class MQIRankRightCell: MQITableViewCell {
    
    var model : MQIMainEachRecommendModel? {
        didSet{
            if let model = model {
                iconImageView.sd_setImage(with: URL(string:model.book_cover), placeholderImage: UIImage(named: book_PlaceholderImg))
                titleLabel.text = model.book_name
                
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = .justified
                paragraph.lineSpacing = 3
                
                let bookIntro = replacingDefaultOccurrences(model.book_intro)
                let attStr = NSMutableAttributedString(string: bookIntro, attributes:
                    [NSAttributedStringKey.paragraphStyle : paragraph,
                     NSAttributedStringKey.font:systemFont(10*gd_scale),
                     ])
                contentLabel.attributedText = attStr
                contentLabel.lineBreakMode = .byTruncatingTail
                
            
//                let newN = qiuZhengshu(model.read_num) + "人追读"
                let newN =  kLongLocalized("PeoplePursuing", replace: qiuZhengshu(model.read_num), isFirst: true)
                classLabel.text = model.subclass_name + "  " + newN
                
            }
        }
    }
    
    fileprivate var iconImageView:UIImageView!
    fileprivate var titleLabel:UILabel!
    fileprivate var classLabel:UILabel!
    //    fileprivate var lookCountLabel:UILabel!
    fileprivate var contentLabel:UILabel!
    
    
    fileprivate var rankLabel:UILabel!
    fileprivate var rankImgView:UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addRightCellView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func addRightCellView() {
        iconImageView = UIImageView(frame: CGRect.zero)
        iconImageView.layer.cornerRadius = 5
        iconImageView.clipsToBounds = true
        iconImageView.image = UIImage(named:book_PlaceholderImg)
        contentView.addSubview(iconImageView)
        
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.font = systemFont(14)
        titleLabel.text = kLocalized("Title")
        contentView.addSubview(titleLabel)
        
        classLabel = UILabel(frame: CGRect.zero)
        classLabel.font = systemFont(10*gd_scale)
        classLabel.text = kLocalized("Tag")
        classLabel.textColor = UIColor.colorWithHexString("#808080")
        contentView.addSubview(classLabel)
        
        contentLabel = UILabel(frame: CGRect.zero)
        contentLabel.numberOfLines = 2
        contentLabel.textColor = UIColor.colorWithHexString("#808080")
        contentView.addSubview(contentLabel)
        
        rankImgView = UIImageView(frame: CGRect.zero)
        //        rankImgView.image = randomImg()
        iconImageView.addSubview(rankImgView)
        
        rankLabel = UILabel(frame: CGRect.zero)
        rankLabel.font = UIFont.boldSystemFont(ofSize: 8)
        rankLabel.textColor = UIColor.white
        rankLabel.textAlignment = .center
        rankImgView.addSubview(rankLabel)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(13)
            make.left.equalTo(self.snp.left).offset(14.5)
            make.bottom.equalTo(self.snp.bottom).offset(-13)
            make.width.equalTo((self.height-26)*52.5/69)
        }
        
        rankImgView.translatesAutoresizingMaskIntoConstraints = false
        rankImgView.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.top)
            make.left.equalTo(iconImageView.snp.left)
            make.width.equalTo(13)
            make.height.equalTo(17)
        }
        
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        rankLabel.snp.makeConstraints { (make) in
            make.top.equalTo(rankImgView.snp.top)
            make.left.equalTo(rankImgView.snp.left)
            make.width.equalTo(rankImgView.snp.width)
            make.height.equalTo(rankImgView.snp.height)
        }
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.top).offset(1)
            make.left.equalTo(iconImageView.snp.right).offset(8.5)
            make.right.equalTo(self.snp.right).offset(-23)
            make.height.equalTo(14)
        }
        
        classLabel.translatesAutoresizingMaskIntoConstraints = false
        classLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(8.5*gd_scale)
            make.left.equalTo(iconImageView.snp.right).offset(8.5)
            make.right.equalTo(self.snp.right).offset(-23)
            make.height.equalTo(10*gd_scale)
        }
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(classLabel.snp.bottom).offset(8.5)
            make.left.equalTo(iconImageView.snp.right).offset(8.5)
            make.right.equalTo(self.snp.right).offset(-23)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
        }
        
        
        
        
        
    }
    
    class func getSizeHeight() -> CGFloat {
        return 95*gd_scale
    }
    func replacingDefaultOccurrences(_ content:String) -> String {
        let bookIntro1 = content.replacingOccurrences(of: "\n", with: "")
        let bookIntro2 = bookIntro1.replacingOccurrences(of: "\t", with: "")
        let bookIntro3 = bookIntro2.replacingOccurrences(of: " ", with: "")
        return bookIntro3
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
