//
//  MQIWrongView.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/6/27.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

import SnapKit
class MQIWrongView: UIView {

    var icon: UIImageView!
    var titleLabel: UILabel!
    var button: UIButton!
    
    var sTitle: String!
    var sBlock: (() -> ())!
    
    var loadText: String = ""
    var loadingText: String = ""
    
    let titleColor = UIColor.colorWithHexString("999999")
    let titleFont = UIFont.systemFont(ofSize: ipad == true ? 16 : 14)
    
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
        
        defaultText()
        
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.font = titleFont
        titleLabel.textAlignment = .center
        titleLabel.textColor = titleColor
        titleLabel.numberOfLines = 0
        titleLabel.text = sTitle
        self.addSubview(titleLabel)
        
        let noNetworkImage = UIImage(named: "jiaz_error_img")!
        
        icon = UIImageView(frame: CGRect.zero)
        icon.image = noNetworkImage
        self.addSubview(icon)
        
        button = UIButton(type: .custom)
        button.setTitle(loadText, for: .normal)
        button.setTitleColor(UIColor.colorWithHexString("#666666"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.borderColor = UIColor.colorWithHexString("#666666").cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(MQIWrongView.buttonAction), for: .touchUpInside)
        self.addSubview(button)
        
        let iconWidth: CGFloat = 160
        let iconHeight = noNetworkImage.size.height*iconWidth/noNetworkImage.size.width
        let labelHeight: CGFloat = 20
        let btnWidth: CGFloat = 140
        let btnHeight: CGFloat = 40
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.snp.centerY).offset(-40)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(labelHeight)
        }
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(titleLabel.snp.top).offset(-10)
            make.width.equalTo(iconWidth)
            make.height.equalTo(iconHeight)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(titleLabel.snp.bottom).offset(19)
            make.width.equalTo(btnWidth)
            make.height.equalTo(btnHeight)
        }
    }
    
    func defaultText() {
        loadText = kLocalized("Click_the_refresh")
        sTitle = kLocalized("Make_a_mistake_Sorry_try_refresh")
        loadingText = kLocalized("Loadingin")
    }
    
    @objc func buttonAction() {
        self.setLoading()
        sBlock()
    }
    
    func setRefresh(_ block: @escaping () -> ()) {
        sBlock = block
    }
    
    func configText(_ text: String) {
        titleLabel.text = text
    }
    
    func setLoading() {
        button.setTitle(loadingText, for: .normal)
        button.isUserInteractionEnabled  = false
    }
    
    func setLoad() {
        button.setTitle(loadText, for: .normal)
        button.isUserInteractionEnabled = true
    }
    
    func btnClick(_ button: UIButton) {
        self.setLoading()
        sBlock()
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
