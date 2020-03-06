//
//  MQITimeLabel.swift
//  XSDQReader
//
//  Created by _CHK_  on 2018/7/2.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQITimeLabel: UIView {
    var textLabel:UILabel!
    
    var dayText:String = "00"
    var hourText:String = "00"
    var minuteText:String = "00"
    var secondText:String = "00"
    
    let tian:String = kLocalized("Day")
    /// UIColor.colorWithHexString("#DD5048").cgColor
    var textColor:UIColor = UIColor.white
    var dayColor:UIColor = mainColor
    var strokeColor:UIColor = mainColor
    var fillColor:UIColor = mainColor
    var showBorder:Bool = true
    /// 设置所有的统一颜色 此时填充色为 clear
    var allColor:UIColor? {
        didSet(oldValue) {
            if allColor != nil {
                fillColor = UIColor.clear
                textColor = allColor!
                dayColor  =  textColor
                strokeColor = textColor
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addTimeText(_ days:String, hours:String,minutes:String,seconds:String) {
        
        dayText = days
        hourText = hours
        minuteText = minutes
        secondText = seconds
        //        MQLog()
        setNeedsDisplay()
        
    }
    //画 时间
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(0.8);
        //        context!.setFillColor(UIColor.clear.cgColor);//填充颜色
        //        context!.setStrokeColor(UIColor.colorWithHexString("#DD5048").cgColor);
        context!.setStrokeColor(strokeColor.cgColor);
        context!.setFillColor(fillColor.cgColor);//填充颜色
        //        DD5048
        var ori_X:CGFloat  = 0
        let height:CGFloat = 16
        let ori_Y:CGFloat  = rect.height*0.5-height*0.5
        //        let xianshi:String = kLocalized("TimeFree")
        //        let nickWidth1 = getAutoRect(xianshi as String, font: UIFont.systemFont(ofSize: 13), maxWidth: 1000, maxHeight: 15)
        //        xianshi.draw(in: CGRect (x: 0, y: 0, width: nickWidth1.width, height: 15), withAttributes:
        //            get_Attstr())
        
        let nickWidth1 = CGSize(width: 0, height: 0)
        
        //几天
        if showBorder {
            context?.drawTimeBorder(CGRect (x: nickWidth1.width+1, y: ori_Y, width: 22, height: height))
        }
        
        let text1 = dayText
        (text1 as NSString).draw(in: CGRect (x: nickWidth1.width+2, y: ori_Y, width: 20, height: height), withAttributes: get_Attstr(textColor))
        
        ori_X = nickWidth1.width+23
        
        //        let tian:String = kLocalized("Day")
        let nickWidth2 = getAutoRect(tian as String, font: UIFont.systemFont(ofSize: 13), maxWidth: 1000, maxHeight: height)
        tian.draw(in: CGRect (x: ori_X+1, y: ori_Y, width: nickWidth2.width, height: height), withAttributes:
            get_Attstr(dayColor))
        ori_X += (nickWidth2.width + 2);
        //小时
        let text2 = hourText
        if showBorder {
            context?.drawTimeBorder(CGRect (x: ori_X, y: ori_Y, width: 22, height: height))
        }
        (text2 as NSString).draw(in: CGRect (x: ori_X+1, y: ori_Y, width: 20, height: height), withAttributes:  get_Attstr(textColor))
        
        
        if showBorder {
            ori_X += 24
        }else{
            ori_X += 20
        }
        
        
        //  :
        let maohao1:NSString = ":"
        let nickWidth3 = getAutoRect(maohao1 as String, font: UIFont.systemFont(ofSize: 13), maxWidth: 1000, maxHeight: 15)
        maohao1.draw(in: CGRect (x: ori_X+1, y: ori_Y, width: nickWidth3.width, height: height), withAttributes:
            get_Attstr(strokeColor))
        if showBorder {
            ori_X += (nickWidth3.width + 3);
        }else{
            ori_X += (nickWidth3.width );
        }
        
        
        //  分钟
        if showBorder {
            context?.drawTimeBorder(CGRect (x: ori_X, y: ori_Y, width: 22, height: height))
        }
        let text3 = minuteText
        (text3 as NSString).draw(in: CGRect (x: ori_X+1, y: ori_Y, width: 20, height: height), withAttributes: get_Attstr(textColor))
        
        if showBorder {
            ori_X += 24
        }else{
            ori_X += 20
        }
        
        //  :
        let maohao2:NSString = ":"
        let nickWidth4 = getAutoRect(maohao2 as String, font: UIFont.systemFont(ofSize: 13), maxWidth: 1000, maxHeight: 15)
        maohao2.draw(in: CGRect (x: ori_X+1, y: ori_Y, width: nickWidth4.width, height: height), withAttributes:
            get_Attstr(strokeColor))
        
        
        
        if showBorder {
            ori_X += (nickWidth4.width + 3);
        }else{
            ori_X += (nickWidth4.width )
        }
        
        // 秒
        if showBorder {
            context?.drawTimeBorder(CGRect (x: ori_X, y: ori_Y, width: 22, height: height))
        }
        let text4 = secondText
        (text4 as NSString).draw(in: CGRect (x: ori_X+1, y: ori_Y, width: 20, height: height), withAttributes: get_Attstr(textColor))
        
        
    }
    
    @objc  func get_Attstr(_ textColor:UIColor) -> [NSAttributedString.Key : Any] {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        return [.font : UIFont.systemFont(ofSize: 13),
                .paragraphStyle : paragraph,
                .foregroundColor: textColor,
                .backgroundColor : UIColor.clear]
        
    }
    
}
extension CGContext {
    //画方块
    func drawTimeBorder(_ rect:CGRect) {
        self.addRect(rect)
        self.drawPath(using: .fillStroke)
    }
}


