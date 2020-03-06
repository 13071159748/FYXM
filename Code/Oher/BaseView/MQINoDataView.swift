//
//  MQINoDataView.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/6/27.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQINoDataView: UIView {

    var icon: UIImageView!
    var titleLabel: UILabel!
    
    let titleFont = UIFont.systemFont(ofSize: ipad == true ? 15 : 13)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func configUI() {
        self.backgroundColor = colorWithHexString("#F8F8F8")
        
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.font = systemFont(14)
        titleLabel.textAlignment = .center
        titleLabel.text = kLocalized("No_list_yet")
        titleLabel.textColor = colorWithHexString("#999999")
        titleLabel.numberOfLines = 2
        self.addSubview(titleLabel)
       
        icon = UIImageView(frame: CGRect.zero)
        icon.image = UIImage(named: "liebiao_no_data_img")
        icon.contentMode = .scaleAspectFit
        self.addSubview(icon)
    
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.snp.centerY).offset( 10)
            make.width.equalTo(100 * gdscale)
            make.height.equalTo(100 * hdscale)
            make.centerX.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(icon.snp.bottom).offset(10)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
        }
        
        
    }
    
    func dismiss(_ completion: (() -> ())?) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.alpha = 0
        }, completion: { (suc) -> Void in
            self.removeFromSuperview()
            completion?()
        })
    }

}
