//
//  MQIBookImageView.swift
//  Reader
//
//  Created by CQSC  on 16/9/28.
//  Copyright © 2016年  CQSC. All rights reserved.
//

import UIKit


class MQIBookImageView: UIImageView {
    
    var bookView: UIImageView!
    var side: CGFloat = 1.5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.creatImage()
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        self.creatImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.creatImage()
    }
    
    func creatImage() {
        self.layer.borderColor = lineColor.cgColor
        self.layer.borderWidth = 0.5
        bookView = UIImageView(frame: CGRect(x: side, y: side, width: frame.width-2*side, height: frame.height-2*side))
        self.addSubview(bookView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bookView.frame = CGRect(x: side, y: side, width: frame.width-2*side, height: frame.height-2*side)
        
    }
}
