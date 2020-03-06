//
//  MQIReadView.swift
//  Reader
//
//  Created by CQSC  on 2017/6/23.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit

class MQIReadView: UIView {
    
//    var title: String?
//    /// 内容
//    var content: String? {
//        
//        didSet{
//            if let content = content {
//                var nFrame = GetReadViewFrame()
//                nFrame.size.height = height
//                
//                frameRef = GYReadParser.GetReadFrameRef(title: title,
//                                                        titleAttrs: GYReadStyle.shared.readTitleAttribute(),
//                                                        content: content,
//                                                        attrs: GYReadStyle.shared.readAttribute())
//            }
//        }
//    }
    
    /// CTFrame
    public var frameRef:CTFrame? {
        didSet{
            if frameRef != nil {
                setNeedsDisplay()
            }
        }
    }
    
    public var frameRefHeight: CGFloat = 0
    
    /// 绘制
    override func draw(_ rect: CGRect) {
        backgroundColor = UIColor.clear
        
        guard let frameRef = frameRef else {
            return
        }

        
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.textMatrix = CGAffineTransform.identity
        ctx?.translateBy(x: 0, y: frameRefHeight == 0 ? bounds.size.height : frameRefHeight)
//        ctx?.translateBy(x: 0, y: bounds.size.height)
        ctx?.scaleBy(x: 1.0, y: -1.0)
        CTFrameDraw(frameRef, ctx!)
        
    }
    
    deinit {
        
    }
}

