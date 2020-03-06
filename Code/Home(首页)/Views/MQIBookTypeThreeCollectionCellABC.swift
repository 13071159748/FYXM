//
//  MQIBookTypeThreeCollectionCellABC.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/2.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIBookTypeThreeCollectionCellABC: MQICollectionViewCell {
    var book_nameLabel :UILabel!
    
    var book_introLabel:UILabel!
    
    var class_nameLabel:UILabel!
    
    var classText:String? = kLocalized("through") {
        didSet {
            if let text = classText {
                class_nameLabel.isHidden = false
                //                if text.length == 4 {
                //                    class_nameLabel.text = text.substring(NSMakeRange(2, 2))
                //                }else{
                class_nameLabel.text = text
                //            }
            }else {class_nameLabel.isHidden = true}
            layoutSubviews()
        }
    }
    //连载状态
    var book_StatusLabel:UILabel?
    
    var statusText:String? = kLocalized("serial") {
        didSet {
            if statusText == "1" {
                self.book_StatusLabel?.text = kLocalized("serial")
                //                    self.book_StatusLabel?.textColor = UIColor.colorWithHexString("#7BC8A4")
                //                    self.book_StatusLabel?.layer.borderColor = UIColor.colorWithHexString("#7BC8A4").cgColor
                
            }else if statusText == "2"{
                self.book_StatusLabel?.text = kLocalized("TheEnd")
                //                    self.book_StatusLabel?.textColor = UIColor.colorWithHexString("#F16745")
                //                    self.book_StatusLabel?.layer.borderColor = UIColor.colorWithHexString("#F16745").cgColor
            }
            layoutSubviews()
        }
        
    }
    var lineView:UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        self.backgroundColor = UIColor.white
        addTypeThreeView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func addTypeThreeView() {
        
        book_nameLabel = createLabel(CGRect.zero, font: systemFont(18), bacColor: UIColor.white, textColor: UIColor.colorWithHexString("#333333"), adjustsFontSizeToFitWidth: false, textAlignment: .left, numberOfLines: 1)
        book_nameLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        book_nameLabel.text = ""
        contentView.addSubview(book_nameLabel)
        
        book_introLabel = createLabel(CGRect.zero, font: systemFont(12), bacColor: UIColor.white, textColor: UIColor.colorWithHexString("#999999"), adjustsFontSizeToFitWidth: false, textAlignment: .left, numberOfLines: 2)
        book_introLabel.text = ""
        contentView.addSubview(book_introLabel)
        
        class_nameLabel = UILabel(frame: CGRect.zero)
        class_nameLabel?.layer.cornerRadius = 2
        class_nameLabel?.clipsToBounds = true
        class_nameLabel?.font = systemFont(11*mqscale > 14 ? 14 : 11*mqscale)
        class_nameLabel?.textColor = UIColor.colorWithHexString("#999999")
        class_nameLabel.textAlignment = .center
        contentView.addSubview(class_nameLabel!)
        class_nameLabel?.layer.borderWidth = 1
        class_nameLabel?.layer.borderColor = UIColor.colorWithHexString("#CECECE").cgColor
        
        book_StatusLabel = UILabel (frame: CGRect.zero)
        book_StatusLabel?.font = systemFont(11*mqscale > 14 ? 14 : 11*mqscale)
        book_StatusLabel?.textAlignment = .center
        book_StatusLabel?.textColor = UIColor.colorWithHexString("#999999")
        
        contentView.addSubview(book_StatusLabel!)
        
        lineView = UIView(frame: CGRect(x: 0, y: 0, width: self.width, height: 1))
        lineView?.backgroundColor = UIColor.colorWithHexString("#eeeeee")
        contentView.addSubview(lineView!)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = getAutoRect(book_nameLabel.text, font: book_nameLabel.font, maxWidth: CGFloat(MAXFLOAT), maxHeight:14).size.width + 10.0
        
        
        //        book_nameLabel.frame = CGRect (x: 0, y: 19, width: self.width-147.5*gdscale, height: 14)
        book_nameLabel.frame = CGRect (x: 0, y: 10, width: width, height: 14)
        
        
        book_introLabel.frame = CGRect (x: 0, y: book_nameLabel!.maxY + 10, width: self.width, height: self.height-book_nameLabel!.maxY-15)
        
        let class_width = getAutoRect(classText, font: class_nameLabel.font, maxWidth: 100, maxHeight: 11*mqscale).size.width
        
        class_nameLabel.frame = CGRect (x: book_nameLabel!.maxX , y: 17, width: class_width + 10, height: 15*mqscale > 18 ? 18 : 15*mqscale)
        var status_width:CGFloat = 0.0
        if statusText == "2" {
            status_width = getAutoRect(kLocalized("TheEnd"), font: class_nameLabel.font, maxWidth: 100, maxHeight: 11*mqscale).size.width
        }else {
            status_width = 0
        }
        
        
        book_StatusLabel?.frame = CGRect (x: class_nameLabel!.maxX + 6, y: 17, width: status_width, height: 15*mqscale > 18 ? 18 : 15*mqscale)
        
    }
    //    func randomColor() -> UIColor {
    //        let color1 = UIColor.colorWithHexString("#FFC65D")
    //        let color2 = UIColor.colorWithHexString("#F17E45")
    //        let color3 = UIColor.colorWithHexString("#7BC8A4")
    //        let color4 = UIColor.colorWithHexString("#4CC3D9")
    //
    //        let array = [color1,color2,color3,color4]
    //
    //        let temp = Int(arc4random()%4)
    //
    //        return array[temp]
    //
    //    }
    
    class func getSize() -> CGSize {
        //两条横线到横线的距离   （设计图）
        return CGSize(width: screenWidth-42*gdscale, height: 76.5)
        
    }
    

}
