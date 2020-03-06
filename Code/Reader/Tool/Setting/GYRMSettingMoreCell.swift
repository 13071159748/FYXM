//
//  GYRMSettingMoreCell.swift
//  Reader
//
//  Created by CQSC  on 2017/6/24.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit

//设置中 行间距、段间距等...
class GYRMSettingMoreCell: GYRMSettingCell {
    
    var deTitleLabel: UILabel!
    
    var actionBlock: ((_ plus: Bool) -> ())?
    
    override func configUI() {
        super.configUI()
        deTitleLabel = createLabel(CGRect.zero, font: titleFont, bacColor: bacColor, textColor: titleColor, adjustsFontSizeToFitWidth: nil, textAlignment: .center, numberOfLines: nil)
        actionView.addSubview(deTitleLabel)
        
        
        let titles = ["-", "+"]
        for i in 0..<titles.count {
            let button = createButton(CGRect.zero, normalTitle: titles[i], normalImage: nil, selectedTitle: nil, selectedImage: nil, normalTilteColor: titleColor, selectedTitleColor: nil, bacColor: nil, font: titleFont, target: self, action:  #selector(GYRMSettingMoreCell.buttonAction(_:)))
            
            button.setTitleColor(titleColorSel, for: .highlighted)
            button.layer.borderColor = borderColor.cgColor
            button.layer.borderWidth = 1.0
            button.layer.masksToBounds = true
            button.titleLabel?.font = titleFont
            button.tag = btnTag+i
            actionView.addSubview(button)
            fontBtns.append(button)
            
        }
    }
    
    @objc func buttonAction(_ button: UIButton) {
        if button.tag-btnTag == 0 {
            actionBlock?(false)
        }else {
            actionBlock?(true)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let space: CGFloat = 15
        deTitleLabel.frame = CGRect(x: space, y: 0, width: 40, height: self.bounds.height)
        
        let btnWidth: CGFloat = (actionView.bounds.width-deTitleLabel.frame.maxX-3*space)/2
        let btnHeight: CGFloat = 30
        let originX: CGFloat = deTitleLabel.frame.maxX+space
        for i in 0..<fontBtns.count {
            fontBtns[i].frame = CGRect(x: originX+(btnWidth+space)*CGFloat(i), y: (self.bounds.height-btnHeight)/2, width: btnWidth, height: btnHeight)
        }
    }
    
}
