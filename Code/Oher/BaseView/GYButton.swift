//
//  GYButton.swift
//  Gem
//
//  Created by CQSC  on 15/7/19.
//  Copyright (c) 2015年  CQSC. All rights reserved.
//

import UIKit


enum textDirection {
    case left
    case right
    case down
    case up
}

enum buttonAlignment {
    case left
    case right
    case center
}

class GDButton: UIButton {
    var btnAction:((_ button:UIButton)->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(GDButton.gdBtnClick(_:)), for: .touchUpInside)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc fileprivate func gdBtnClick(_ sender:UIButton) {
        btnAction?(self)
    }
}


extension UIView {
    
    @discardableResult func addCustomButton(_ frame:CGRect,title:String?,action:((_ button:UIButton)->())?) -> UIButton{
        let button = GDButton(type: .custom)
        button.frame = frame
        if title != nil {
            button.setTitle(title, for: .normal)
        }
        button.btnAction = action
        self.addSubview(button)
        return button
    }
    @discardableResult func addLoginViewButton(_ frame:CGRect,title:String?,img:String?,backColor:UIColor?,color:UIColor?,imgFrame:CGRect,tags:Int) -> UIButton{
        
        let wxButton = UIButton(type: .custom)
        wxButton.frame = frame
        wxButton.layer.cornerRadius = 3 * gdscale
        wxButton.clipsToBounds = true
        if backColor != nil {
            wxButton.backgroundColor = backColor
        }
        
        let wxImage = UIImageView.init(frame:imgFrame)
        if img != "" {
            wxImage.image = UIImage.init(named: img!)?.withRenderingMode(.alwaysOriginal)
        }
        wxImage.tag = tags + 3000
        wxButton.addSubview(wxImage)
        
        let wxLabel = UILabel.init(frame: CGRect (x: 90 * gdscale, y: 11 * hdscale, width: 150 * gdscale, height: 22 * hdscale))
        if title != "" {
            wxLabel.text = title
        }
        if color != nil {
            wxLabel.textColor = color
        }
        wxLabel.tag = tags + 4000
        wxLabel.font = systemFont(16)
        wxButton.addSubview(wxLabel)
        return wxButton
    }
}
//详情页点赞，打赏按钮
extension UIButton {
    func layoutUpImage_BottomTitleButton(_ space:CGFloat) {
        let imageWidth = self.imageView?.frame.size.width
        
        let labelWidth = self.titleLabel?.intrinsicContentSize.width
        let labelHeight = self.titleLabel?.intrinsicContentSize.height
        
        self.imageEdgeInsets = UIEdgeInsets(top: -labelHeight! - space/2.0, left: 0, bottom: 0, right: -labelWidth!)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth! - 20, bottom: -25, right: 0)
    }
    
}

class GYButton: UIButton {
    
    var leftLine: GYLine?
    var rightLine: GYLine?
    var bottomLine: GYLine?
    var topLine: GYLine?
    
    var direction: textDirection = .right {
        didSet {
            self.layoutIfNeeded()
            self.layoutSubviews()
        }
    }
    
    var alignment: buttonAlignment = .center {
        didSet {
            self.layoutIfNeeded()
            self.layoutSubviews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if imageView == nil {
            return
        }
        if titleLabel == nil {
            return
        }
        
        switch direction {
        case .down:
            // Center image
            var center = self.imageView!.center
            center.x = self.frame.width/2
            center.y = self.imageView!.frame.height/2
            self.imageView!.center = center
            
            //Center text
            var newFrame = self.titleLabel!.frame
            newFrame.origin.x = 0
            newFrame.origin.y = self.imageView!.frame.height+3
            newFrame.size.height = self.bounds.height/2-3
            newFrame.size.width = frame.width
            
            self.titleLabel!.frame = newFrame
            self.titleLabel!.textAlignment = NSTextAlignment.center
        case .left:
            let width = self.bounds.width/2
            let height = self.bounds.height
            self.imageView!.contentMode = UIView.ContentMode.scaleAspectFit
            self.imageView!.frame = CGRect(x: width, y: 0, width: width, height: height)
            
            self.titleLabel!.textAlignment = NSTextAlignment.center
            self.titleLabel!.frame = CGRect(x: 0, y: 0, width: width, height: height)
        case .up:
            let width = self.bounds.width
            let height = self.bounds.height/2
            self.imageView!.contentMode = UIView.ContentMode.scaleAspectFit
            self.imageView!.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
            self.titleLabel!.textAlignment = NSTextAlignment.center
            self.titleLabel!.frame = CGRect(x: 0, y: height, width: width, height: height)
        default:
            print("1")
        }
        
        switch alignment {
        case .left:
            let space: CGFloat = 2
            var iFrame = self.imageView!.frame
            iFrame.origin.x = space
            self.imageView!.frame = iFrame
            
            var tFrame = self.titleLabel!.frame
            tFrame.origin.x = iFrame.origin.x+iFrame.size.width+space
            tFrame.size.width = self.bounds.width-tFrame.origin.x
            self.titleLabel!.frame = tFrame
        case .center:
            self.imageView!.frame.size.height -= 10
            self.imageView!.frame.size.width = self.imageView!.frame.size.height
            self.imageView!.frame.origin.y = (self.bounds.height-self.imageView!.bounds.height)/2
            
            let width = self.imageView!.frame.size.height+self.titleLabel!.frame.size.width
            self.imageView!.frame.origin.x = (self.bounds.width-width)/2
            self.titleLabel!.frame.origin.x = imageView!.frame.maxX+2
        default:
            print("1")
        }
    }
    
}
