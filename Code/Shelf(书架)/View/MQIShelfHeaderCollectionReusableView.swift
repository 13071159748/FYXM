//
//  MQIShelfHeaderCollectionReusableView.swift
//  Reader
//
//  Created by CQSC  on 2017/8/23.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class MQIShelfHeaderCollectionReusableView: UICollectionReusableView {
    
    
    //    var head_line:UIView?
    
    //    var head_lineColor:String = "#ffffff"
    
    //    var space:CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        self.layer.addDefineLayer(self.bounds)
        self.backgroundColor = UIColor.white
        addheaderLine()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addheaderLine() {
        
        //        if head_line == nil {
        //            head_line = UIView(frame: CGRect(x: 0, y: 0, width: self.width, height: space))
        //            self.addSubview(head_line!)
        //        }
        //        head_line?.backgroundColor = UIColor.colorWithHexString(head_lineColor)
        
        
    }
    
    
    
    
    
}
