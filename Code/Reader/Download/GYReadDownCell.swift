//
//  GYReadDownCell.swift
//  Reader
//
//  Created by CQSC  on 2017/6/28.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYReadDownCell: MQITableViewCell {
    
    public var baseView: GYReadDownBaseView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func configUI() {
        self.selectionStyle = .none
        
        contentView.backgroundColor = RGBColor(242, g: 242, b: 242)
        baseView = GYReadDownBaseView(frame: contentView.bounds)
        baseView.forceToHiddenSelBtn = true
        contentView.addSubview(baseView)
        
        baseView.isUserInteractionEnabled = true
        addTGR(self, action: #selector(GYReadDownCell.selAction), view: baseView)
        baseView.selBtn.isHidden = true
    }
    
    @objc func selAction() {
        baseView.selBtn.isSelected = !baseView.selBtn.isSelected
        baseView.selBlock?(baseView.selBtn.isSelected)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        baseView.frame = contentView.bounds
    }
    
    override class func getHeight<T: MQIBaseModel>(_ obj: T?) -> CGFloat {
        return 45
    }
    
}

class GYReadDownAllFinishCell: GYReadDownCell {
    override func configUI() {
        super.configUI()
        baseView.configDown()
//        baseView
    }
}
