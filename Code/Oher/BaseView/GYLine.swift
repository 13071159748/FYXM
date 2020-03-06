//
//  GYLine.swift
//  Gem
//
//  Created by CQSC  on 15/7/15.
//  Copyright (c) 2015年  CQSC. All rights reserved.
//

import UIKit


let gyLine_height: CGFloat = 0.5

class GYLine: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = RGBColor(200, g: 200, b: 200)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
