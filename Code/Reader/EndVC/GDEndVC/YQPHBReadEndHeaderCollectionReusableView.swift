//
//  YQPHBReadEndHeaderCollectionReusableView.swift
//  Reader
//
//  Created by CQSC  on 2018/1/23.
//  Copyright © 2018年  CQSC. All rights reserved.
//

import UIKit

let gdreadendHeaderCollectionID = "gdreadendHeaderCollectionID"
class YQPHBReadEndHeaderCollectionReusableView: UICollectionReusableView {
    
    var headerLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addHeaderView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addHeaderView()
    }
    
    func addHeaderView() {
        
        let view = UIView(frame: CGRect(x: 24.5*gd_scale, y: 18, width: screenWidth-49*gd_scale, height: self.height - 18))
        view.backgroundColor = UIColor.white
        view.clipRectCorner(direction: [.topRight,.topLeft], cornerRadius: 8)
        self.addSubview(view)
        
        headerLabel = UILabel(frame: CGRect(x: 16*gdscale, y: 0, width: view.width, height: view.height))
        headerLabel.font = systemFont(14*gdscale)
        view.addSubview(headerLabel)
        
    }
    class func getHeaderSize() -> CGSize {
        return CGSize(width: screenWidth, height: 46.5*gdscale+18)
    }
}
