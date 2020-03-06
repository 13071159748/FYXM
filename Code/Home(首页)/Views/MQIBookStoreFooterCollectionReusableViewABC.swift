//
//  MQIBookStoreFooterCollectionReusableViewABC.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/2.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

//首页商城collection的footer线
class MQIBookStoreFooterCollectionReusableViewABC: UICollectionReusableView {
    var footer_line:UIView?
    
    var footer_lineColor:String = "#F0F0F0"
    
    var space:CGFloat = 17
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addFooterLine() {
        
        //        if footer_line == nil {
        //            footer_line = UIView(frame: CGRect(x: 17, y: 0, width: self.width-34, height: 1))
        //            self.addSubview(footer_line!)
        //        }
        //        footer_line?.backgroundColor =  UIColor.colorWithHexString(footer_lineColor)
        self.backgroundColor =  UIColor.colorWithHexString(footer_lineColor)
        
    }
}
