//
//  GDReadEndFooterReusableView.swift
//  Reader
//
//  Created by CQSC  on 2018/1/24.
//  Copyright © 2018年  CQSC. All rights reserved.
//

import UIKit

let gdreadendFooterCollectionID = "gdreadendFooterCollectionID"

class GDReadEndFooterReusableView: UICollectionReusableView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addFooterView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addFooterView()
    }
    
    func addFooterView() {

        let view = UIView(frame: CGRect(x: 24.5*gd_scale, y: 0, width: screenWidth-49*gd_scale, height: 10*gd_scale))
        view.backgroundColor = UIColor.white
        view.clipRectCorner(direction: [.bottomLeft,.bottomRight], cornerRadius: 8)
        self.addSubview(view)
        
//        let cornerSize = CGSize(width: 8, height: 8)
//        let corner:UIRectCorner = [.bottomLeft,.bottomRight]
//        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners:corner, cornerRadii: cornerSize)
//        let maskLayer = CAShapeLayer()
//        maskLayer.frame = bounds
//        maskLayer.path = maskPath.cgPath
//        view.layer.addSublayer(maskLayer)
//        view.layer.mask = maskLayer
        
        
    }
    class func getFooterSize() -> CGSize {
        return CGSize(width: screenWidth, height: 15.5*gd_scale)
    }
}
