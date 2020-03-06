//
//  DSYBaseBtn.swift
//  Translatemanager
//
//  Created by DSY on 2018/2/5.
//  Copyright © 2018年 DSY. All rights reserved.
//

import UIKit

class DSYBaseBtn: UIButton {
///图片与文字的间距
    var spacing:CGFloat = 0.0
    /// TouchUpInside Action
 
    func dsyAddTarget(target:Any?,action: Selector) -> Void {
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    
  
    
}

/// 左边图片 右边文字 btn
class DSYLeftImgBtn: DSYBaseBtn {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let oldRect: CGRect  = self.bounds;
        let oldRect2:CGRect  = (self.imageView?.frame)!;
        let oldRect3:CGRect = (self.titleLabel?.frame)!;
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.numberOfLines = 0;
        let X:CGFloat  = oldRect2.maxX;
    
        if (X>0) {
            if oldRect2 != CGRect.zero{
             self.titleLabel?.frame = CGRect(x: X+self.spacing, y: 0, width: oldRect3.size.width, height: oldRect.size.height )
            }
        }
    }
    
}
/// 右边图片 左边文字 btn
class DSYRightImgBtn: DSYBaseBtn {
    var  titleX :CGFloat = 0
    override func layoutSubviews() {
        super.layoutSubviews()
        let oldRect: CGRect  = self.bounds;
        let oldRect2:CGRect  = (self.imageView?.frame)!;
        let oldRect3:CGRect  = (self.titleLabel?.frame)!;
        self.imageView?.frame = CGRect.zero;
        self.titleLabel?.frame = CGRect.zero;
        self.titleLabel?.numberOfLines = 1;
        self.titleLabel?.textAlignment = .center
        
        self.titleLabel?.frame = CGRect(x: titleX, y: 0, width: oldRect3.size.width, height: oldRect.size.height )
        
        self.imageView?.frame = CGRect(x: (self.titleLabel?.frame.maxX)! + self.spacing+2, y: oldRect2.origin.y, width: oldRect2.size.width, height: oldRect2.size.height)
    
    }
}

/// 上部图片 下部文字 btn
class DSYTopImgBtn: DSYBaseBtn {
    var imgScale:CGFloat = 0.5
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
           commonInit()
    }
    //设置按钮的基本属性
    func commonInit() {
        self.titleLabel?.textAlignment = .center
        self.imageView?.contentMode = .scaleAspectFit
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.lineBreakMode = .byTruncatingTail
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        
        let imageW = contentRect.width
        let imageH = contentRect.size.height * imgScale
        return CGRect(x: 0, y: 0, width: imageW, height: imageH )
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleX:CGFloat = 0.0
        let titleY = contentRect.size.height * (imgScale - 0.1)
        let titleH = contentRect.size.height - titleY
        return CGRect(x: titleX, y:titleY, width: contentRect.width, height: titleH )
    }
}

/// 下部图片 上部文字 btn
class DSYBottomImgBtn: DSYBaseBtn {
    
    var imgScale:CGFloat = 0.5
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //设置按钮的基本属性
    func commonInit() {
        self.titleLabel?.textAlignment = .center
        self.imageView?.contentMode = .scaleAspectFit
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.lineBreakMode = .byTruncatingTail
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {

        let imageW = contentRect.width
        let imageH = contentRect.size.height * imgScale
        return CGRect(x: 0, y:imageH, width: imageW, height: imageH )
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleY = contentRect.size.height * (imgScale - 0.1)
        let titleH = contentRect.size.height - titleY
        return CGRect(x: 0, y:0, width: contentRect.width, height: titleH )
    }
    
}


