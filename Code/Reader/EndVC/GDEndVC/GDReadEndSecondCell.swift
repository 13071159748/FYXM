//
//  GDReadEndSecondCell.swift
//  Reader
//
//  Created by CQSC  on 2018/1/23.
//  Copyright © 2018年  CQSC. All rights reserved.
//

import UIKit


class GDReadEndSecondCell: MQICollectionViewCell {
    
    var book:MQIEachBook? {
        didSet{
            if let book = book {
                bookCover.sd_setImage(with: URL(string:book.book_cover), placeholderImage: UIImage(named: book_PlaceholderImg))
                bookNameText = book.book_name
            }
        }
    }
    
    fileprivate var bookCover:UIImageView!
    fileprivate var contentLabel:UILabel!
    fileprivate var bookNameText:String = "我是标题" {
        didSet{
            contentLabel.text = bookNameText
            layoutSubviews()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addsecondView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addsecondView()
    }
    func addsecondView() {
        bookCover = UIImageView(frame: CGRect.zero)
        bookCover.layer.cornerRadius = 8
        bookCover.clipsToBounds = true
//        bookCover.backgroundColor = UIColor.colorWithHexString("#939599")
        bookCover.image = UIImage(named: book_PlaceholderImg)
        contentView.addSubview(bookCover)
        
        contentLabel = UILabel(frame: CGRect.zero)
        contentLabel.textColor = UIColor.colorWithHexString("#23252C")
        contentLabel.numberOfLines = 2
        contentLabel.text = bookNameText
        contentLabel.font = systemFont(12)
//        contentLabel.backgroundColor = UIColor.yellow
        contentView.addSubview(contentLabel)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //86  115
        bookCover.translatesAutoresizingMaskIntoConstraints = false
        bookCover.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(0)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(115.35*gdscale)
        }
        let newHeight = getAutoRect(bookNameText, font: contentLabel.font, maxWidth: self.width, maxHeight: 100).size.height
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.snp.updateConstraints { (make) in
            make.top.equalTo(bookCover.snp.bottom).offset(7)
            make.left.equalTo(bookCover.snp.left)
            make.right.equalTo(bookCover.snp.right)
//            make.height.equalTo(newHeight > 27*gd_scale ? 27*gd_scale : newHeight)
            make.height.equalTo(newHeight + 5)
        }
        
    }
    class func getSize() -> CGSize{
        return CGSize(width: 86.2*gdscale, height: (115*gdscale)+(10+27.5)*gd_scale + 5)
    }
}
