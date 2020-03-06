//
//  MQIPreloadView.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/6/27.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

class MQIPreloadView: UIView {

    var gifView: GYGifView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func configUI() {
        self.backgroundColor = UIColor.white
        
        let gifSide: CGFloat = screenWidth/5
        gifView = GYGifView(frame: CGRect(x: ((self.bounds).width-gifSide)/2, y: ((self.bounds).height-gifSide)/2-60, width: gifSide, height: gifSide))
        gifView.imageName = "preload.gif"
        self.addSubview(gifView)
        gifView.backgroundColor = UIColor.red
        let title = UILabel(frame: CGRect(x: 10, y: gifView.maxY+10, width: (self.bounds).width-20, height: 20))
        title.font = UIFont.systemFont(ofSize: 12)
        title.textColor = UIColor.colorWithHexString("#999999")
        title.text = kLongLocalized("Th_content_is_trying_to_load", replace: "加载中")
        title.textAlignment = .center
        self.addSubview(title)
        
    }
    
    func show() {
        
    }
    
    func dismiss(_ completion: (() -> ())?) {
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.alpha = 0
        }, completion: { (suc) -> Void in
            self.removeFromSuperview()
            completion?()
        })
    }
}
