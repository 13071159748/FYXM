//
//  GYReadParser.swift
//  Reader
//
//  Created by CQSC  on 2017/6/23.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit

import CoreText

class GYReadParser: NSObject {
    
    
    // MARK: -- 对内容进行整理排版 比如去掉多余的空格或者段头留2格等等
    
    /// 内容排版整理
    class func ContentTypesetting(content: String) ->String {
        var newContent = content
        if content.hasPrefix("<div><span>") == true {
            newContent = content.replacingOccurrences(of: "</span></div><div><span>", with: "\n　　")
            newContent = newContent.replacingOccurrences(of: "<div><span>", with: "　　")
            newContent = newContent.replacingOccurrences(of: "</span></div>", with: "")
        }
        
        // 替换单换行
        newContent = newContent.replacingOccurrences(of: "\r", with: "")
        // 替换换行 以及 多个换行 为 换行加空格
        newContent = newContent.replacingCharacters(pattern: "\\s*\\n+\\s*", template: "\n　　")
        // 返回
        return newContent
    }
    
    /*
     guard muStr.length > 0 else {
     return ""
     }
     guard muStr.hasSuffix("</p>") == false else {
     return muStr as String
     }
     //        muStr = "<br id =\"chapter\">\(muStr)</br>"
     muStr = "<p>\(muStr)</p>"
     return muStr as String
     */
    
    class func TitleTypesetting(title: String) ->String {
        var newTitle = title
        if newTitle.hasPrefix("</p>") == true {
            newTitle = title.replacingOccurrences(of: "<p>", with: "")
            newTitle = title.replacingOccurrences(of: "</p>", with: "")
            newTitle = newTitle.replacingOccurrences(of: "</br>", with: "")
        }
        return newTitle+"\n"
    }
    
    // MARK: -- 获得 FrameRef CTFrame
    
    // MARK: -- 内容分页
    
    /**
     内容分页
     
     - parameter string: 内容
     
     - parameter rect: 范围
     
     - parameter attrs: 文字属性
     
     - returns: 每一页的起始位置数组
     */
    class func ParserPageRange(title: String, string: String, rect: CGRect, titleAttrs: [NSAttributedString.Key : Any], attrs: [NSAttributedString.Key : Any]) ->([CTFrame], [NSRange]) {
        
        // 记录
        var rangeArray:[NSRange] = []
        // 拼接字符串
        let titleString = NSMutableAttributedString(string: title, attributes: titleAttrs)
        let contentString = NSMutableAttributedString(string: string, attributes: attrs)
        
        let attrString = NSMutableAttributedString(attributedString: titleString)
        attrString.append(contentString)
        
        let frameSetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        
        let path = CGPath(rect: rect, transform: nil)
        
        var range = CFRangeMake(0, 0)
        
        var rangeOffset:NSInteger = 0
        
        var frames = [CTFrame]()
        var index: Int = 0
        repeat{
            
            let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(rangeOffset, 0), path, nil)
            
            range = CTFrameGetVisibleStringRange(frame)
            
            rangeArray.append(NSMakeRange(rangeOffset, range.length))
            rangeOffset += range.length
            
            frames.append(frame)
            
            index += 1
            
        }while(range.location + range.length < attrString.length)
        
        return (frames, rangeArray)
    }
    
    /// 获得 CTFrame
    class func GetReadFrameRef(title: String?, titleAttrs: [NSAttributedString.Key : Any]?, content: String, attrs:[NSAttributedString.Key : Any]?) -> (CTFrame?, CGFloat) {
        
        var attributedString: NSMutableAttributedString!
        if let title = title {
            attributedString = NSMutableAttributedString(string: title, attributes: titleAttrs)
            let contentString = NSMutableAttributedString(string: content, attributes: attrs)
            attributedString.append(contentString)
        }else {
            attributedString = NSMutableAttributedString(string: content,attributes: attrs)
        }
        //layout master - gd
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        //layout colum frame
        let maxHeight: CGFloat = screenHeight*100
        var rect = CGRect(x: 0, y: 0, width: GetReadViewFrame().width, height: maxHeight)
        var path = CGPath(rect: rect, transform: nil)
        var frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        
        //获取行数
        let lineArray = CTFrameGetLines(frameRef) as! Array<Any>
        
        var origins = [CGPoint](repeating: CGPoint.zero, count:lineArray.count)
        //获取每行的坐标
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), &origins)
        
        let line_y = origins[lineArray.count-1].y
        
        var ascent: CGFloat = 0
        var descent: CGFloat = 0
        var leading: CGFloat = 0
        
        var height: CGFloat = 0
        if let line = lineArray.last  {//获取每行的字形
            CTLineGetTypographicBounds(line as! CTLine, &ascent, &descent, &leading)
            height = maxHeight-line_y+descent+ascent+leading+10
        }else {
            let lineHeight = CGFloat(GYReadStyle.shared.styleModel.bookLineHeight)*GYReadStyle.shared.readFont(isTitle: false).lineHeight+10
            height = maxHeight-line_y+lineHeight
        }
        
        rect.size.height = height
        path = CGPath(rect: rect, transform: nil)
        frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        return (frameRef, height)
    }
    
}

