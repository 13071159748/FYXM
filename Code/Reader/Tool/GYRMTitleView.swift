//
//  GYRMTitleView.swift
//  Reader
//
//  Created by CQSC  on 2017/6/24.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYRMTitleView: UIView {

    var bookLabel: UILabel!
    var chapterLabel: UILabel!
    
    fileprivate let labelFont = UIFont.systemFont(ofSize: 12)
    
    var textColor: UIColor! {
        didSet {
            bookLabel.textColor = textColor
            chapterLabel.textColor = textColor
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
        bookLabel = UILabel(frame: CGRect.zero)
        bookLabel.textAlignment = .left
        bookLabel.backgroundColor = UIColor.clear
        bookLabel.lineBreakMode = .byTruncatingMiddle
        bookLabel.font = labelFont
        self.addSubview(bookLabel)
        self.bringSubviewToFront(bookLabel)
        
        chapterLabel = UILabel(frame: CGRect.zero)
        chapterLabel.textAlignment = .right
        chapterLabel.backgroundColor = UIColor.clear
        chapterLabel.lineBreakMode = .byTruncatingMiddle
        chapterLabel.font = labelFont
        self.addSubview(chapterLabel)
        self.bringSubviewToFront(chapterLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        chapterLabel.frame = CGRect(x: self.width/2, y: 0, width: self.width/2, height: self.height)
        bookLabel.frame = CGRect(x: 0, y: 0, width: self.width/2, height: self.height)
        
    }
}
