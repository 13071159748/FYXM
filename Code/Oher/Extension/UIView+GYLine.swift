//
//  UIView+GYLine.swift
//  Nymph
//
//  Created by CQSC  on 15/9/16.
//  Copyright (c) 2015年  CQSC. All rights reserved.
//

import UIKit

import SnapKit
extension UIView {
    
    /**
     添加边框线条
     
     - parameter offset:     边框线条距离两边的 距离
     - parameter lineColor:  边框线条颜色
     - parameter directions: 哪个边  .top .bottom .left .right
     */
    func addLine(_ offset: CGFloat, lineColor: UIColor?, directions: lineDirection...,lineHeight:CGFloat = gyLine_height) {
        var leftLine: GYLine?
        var rightLine: GYLine?
        var bottomLine: GYLine?
        var topLine: GYLine?
        
        if directions.count > 0 {
            for direction in directions {
                if direction == .left {
                    if leftLine == nil {
                        leftLine = GYLine(frame: CGRect.zero)
                        if let lineColor = lineColor {
                            leftLine!.backgroundColor = lineColor
                        }
                        self.addSubview(leftLine!)
                    }
                }else if direction == .right {
                    if rightLine == nil {
                        rightLine = GYLine(frame: CGRect.zero)
                        if let lineColor = lineColor {
                            rightLine!.backgroundColor = lineColor
                        }
                        self.addSubview(rightLine!)
                    }
                }else if direction == .top {
                    if topLine == nil {
                        topLine = GYLine(frame: CGRect.zero)
                        if let lineColor = lineColor {
                            topLine!.backgroundColor = lineColor
                        }
                        self.addSubview(topLine!)
                    }
                }else {
                    if bottomLine == nil {
                        bottomLine = GYLine(frame: CGRect.zero)
                        if let lineColor = lineColor {
                            bottomLine!.backgroundColor = lineColor
                        }
                        self.addSubview(bottomLine!)
                    }
                }
            }
            if let leftLine = leftLine {
                leftLine.translatesAutoresizingMaskIntoConstraints = false
                leftLine.snp.makeConstraints({ (make) -> Void in
                    make.left.equalTo(self.snp.left)
                    make.width.equalTo(lineHeight)
                    make.top.equalTo(self.snp.top).offset(offset)
                    make.bottom.equalTo(self.snp.bottom).offset(-offset)
                })
            }
            
            if let rightLine = rightLine {
                rightLine.translatesAutoresizingMaskIntoConstraints = false
                rightLine.snp.makeConstraints({ (make) -> Void in
                    make.right.equalTo(self.snp.right)
                    make.width.equalTo(lineHeight)
                    make.top.equalTo(self.snp.top).offset(offset)
                    make.bottom.equalTo(self.snp.bottom).offset(-offset)
                })
            }
            
            if let topLine = topLine {
                topLine.translatesAutoresizingMaskIntoConstraints = false
                topLine.snp.makeConstraints({ (make) -> Void in
                    make.left.equalTo(self.snp.left).offset(offset)
                    make.right.equalTo(self.snp.right).offset(-offset)
                    make.top.equalTo(self.snp.top)
                    make.height.equalTo(lineHeight)
                })
            }
            
            
            if let bottomLine = bottomLine {
                bottomLine.translatesAutoresizingMaskIntoConstraints = false
                bottomLine.snp.makeConstraints({ (make) -> Void in
                    make.left.equalTo(self.snp.left).offset(offset)
                    make.right.equalTo(self.snp.right).offset(-offset)
                    make.bottom.equalTo(self.snp.bottom)
                    make.height.equalTo(lineHeight)
                })
            }
        }
    }
    
    
    
    
}
