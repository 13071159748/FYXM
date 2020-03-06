//
//  MQIReadCoverView.swift
//  Reader
//
//  Created by _CHK_  on 2017/8/8.
//  Copyright © 2017年 _xinmo_. All rights reserved.
//

import UIKit
 /*
  拉拉
  */

class MQIReadCoverView: UIView {
    
    fileprivate var bacImageView: UIImageView!
    fileprivate var bookCover: UIImageView!
    fileprivate var bookName: UILabel!
    
    fileprivate var copyright1: UILabel!
    fileprivate var copyright2: UILabel!
    
    fileprivate let titleFont = UIFont.boldSystemFont(ofSize: 22)
    fileprivate let titleColor = blackColor
    
    fileprivate let copyright1Font = UIFont.systemFont(ofSize: 15)
    fileprivate let copyright1Color = RGBColor(83, g: 83, b: 83)
    
    fileprivate let copyright2Font = UIFont.systemFont(ofSize: 13)
    fileprivate let copyright2Color = RGBColor(135, g: 135, b: 135)
    
    public var book: MQIEachBook! {
        didSet {
            bookName.text = book.book_name
            bookCover.sd_setImage(with: URL(string: book.book_cover), placeholderImage: bookPlaceHolderImage)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func configUI() {
        bacImageView = UIImageView(frame: CGRect.zero)
        self.addSubview(bacImageView)
        self.sendSubview(toBack: bacImageView)
        
//        var imageName = ""
//        if iPhone_4_4s == true {
//            imageName = "4"
//        }else if ipad == true {
//            imageName = "ipad"
//        }else {
//            imageName = "6p"
//        }
//
//        bacImageView.image = UIImage(named: "readerHomePage_\(imageName)")
        
//TODO: 添加新背景
        bacImageView.image = UIImage(named: "readerHomePage_bg")
//        bacImageView.contentMode = .scaleAspectFit
        
        bookCover = UIImageView(frame: CGRect.zero)
        self.addSubview(bookCover)
//        self.sendSubview(toBack: bookCover)
        
        bookName = createLabel(CGRect.zero,
                               font: titleFont,
                               bacColor: UIColor.clear,
                               textColor: titleColor,
                               adjustsFontSizeToFitWidth: nil,
                               textAlignment: .center,
                               numberOfLines: 0)
        self.addSubview(bookName)
        self.bringSubview(toFront: bookName)
        
        copyright2 = createLabel(CGRect.zero,
                                 font: copyright2Font,
                                 bacColor: UIColor.clear,
                                 textColor: copyright2Color,
                                 adjustsFontSizeToFitWidth: false,
                                 textAlignment: .center,
                                 numberOfLines: 1)
        copyright2.text = kLocalized("GetNee")
        self.addSubview(copyright2)
        self.bringSubview(toFront: copyright2)
        
        copyright1 = createLabel(CGRect.zero,
                                 font: copyright1Font,
                                 bacColor: UIColor.clear,
                                 textColor: copyright1Color,
                                 adjustsFontSizeToFitWidth: false,
                                 textAlignment: .center,
                                 numberOfLines: 1)
        copyright1.text = "\(kLocalized("BookFrom"))\(COPYRIGHTNAME)\(kLocalized("ACEFirst"))"
        self.addSubview(copyright1)
        self.bringSubview(toFront: copyright1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        bacImageView.frame = self.bounds
       
        let width = self.bounds.width
        let height = self.bounds.height
        
        var top: CGFloat = 0
        var bookCoverWidth: CGFloat = 0
        var bookCoverHeight: CGFloat = 0
        
        if iPhone_4_4s == true {
            top = 142*height/960
            bookCoverWidth = 253*width/640
            bookCoverHeight = bookCoverWidth*335/253
        }else if ipad == true {
            top = 300*height/2048
            bookCoverWidth = 538*width/1536
            bookCoverHeight = bookCoverWidth*713/538
        }else {
            top = 328*height/2208
            bookCoverWidth = 580*width/1242
            bookCoverHeight = bookCoverWidth*775/580
        }
        
        bookCover.translatesAutoresizingMaskIntoConstraints = false
        bookCover.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(top)
            make.width.equalTo(bookCoverWidth)
            make.height.equalTo(bookCoverHeight)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        copyright2.translatesAutoresizingMaskIntoConstraints = false
        copyright2.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(10)
            make.right.equalTo(self.snp.right).offset(-10)
            make.bottom.equalTo(self.snp.bottom).offset(-100)
            make.height.equalTo(18)
        }
        
        copyright1.translatesAutoresizingMaskIntoConstraints = false
        copyright1.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(10)
            make.right.equalTo(self.snp.right).offset(-10)
            make.bottom.equalTo(copyright2.snp.top).offset(-2)
            make.height.equalTo(18)
        }
        
        bookName.translatesAutoresizingMaskIntoConstraints = false
        bookName.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(-10)
            make.right.equalTo(self.snp.right).offset(10)
            make.top.equalTo(bookCover.snp.bottom).offset(10)
            make.bottom.equalTo(copyright1.snp.top).offset(-10)
        }
        
    //TODO: 添加新背景
         bacImageView.snp.makeConstraints { (make) in
            make.top.equalTo(bookCover).offset(-40*gdscale)
            make.left.equalTo(20*gdscale)
            make.right.equalTo(-20*gdscale)
            make.bottom.equalTo(copyright2).offset(30*gdscale)
        }

    }
    
}
