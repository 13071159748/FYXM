//
//  GYBookOriginalInfoCellHeaderView.swift
//  Reader
//
//  Created by CQSC  on 2017/4/3.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYBookOriginalInfoCellHeaderView: UIView {

    var label: UILabel!
    var btn: UIButton!
    var title: String = "" {
        didSet {
            label.text = title
        }
    }
    
    var btnBlock: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func configUI() {
        self.backgroundColor = UIColor.white
        label = createLabel(self.bounds,
                                font: GYBookOriginalInfoVC_headerFont,
                                bacColor: UIColor.white,
                                textColor: GYBookOriginalInfoVC_headerColor,
                                adjustsFontSizeToFitWidth: nil,
                                textAlignment: .left,
                                numberOfLines: 0)
        label.text = ""
        self.addSubview(label)
        
        let btnHeight: CGFloat = 30
        let btnWidth: CGFloat = 80
        
        btn = createButton(CGRect(x: self.width-btnWidth-10, y: (self.height-btnHeight)/2, width: btnWidth, height: btnHeight),
                           normalTitle: "",
                           normalImage: nil,
                           selectedTitle: nil,
                           selectedImage: nil,
                           normalTilteColor: UIColor.colorWithHexString("#999999"),
                           selectedTitleColor: nil,
                           bacColor: UIColor.clear,
                           font: systemFont(15),
                           target: self,
                           action: #selector(GYBookOriginalInfoCellHeaderView.btnAction))
        label.width = self.width-btn.origin.x-10
        self.addSubview(btn)
        
        self.addLine(10, lineColor: GYBookOriginalInfoVC_lineColor, directions: .bottom)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(16)
            make.right.equalTo(self.snp.right).offset(0)
            make.top.equalTo(self.snp.top).offset(0)
            make.bottom.equalTo(self.snp.bottom).offset(0)
        }
    }
    
    @objc func btnAction() {
        btnBlock?()
    }

}
