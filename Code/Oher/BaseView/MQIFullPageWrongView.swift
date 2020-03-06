//
//  MQIFullPageWrongView.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/6/27.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIFullPageWrongView: UIView {

    var icon: UIImageView!
    var titleLabel: UILabel!
    var button: UIButton!
    
    var sTitle: String!
    var sBlock: (() -> ())!
    
    var loadText: String = ""
    var loadingText: String = ""
    
    let titleColor = RGBColor(151, g: 151, b: 151)
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
        
        let noNetworkImage = UIImage(named: "noNetwork")!
        
        icon = UIImageView(frame: CGRect.zero)
        icon.image = noNetworkImage
        self.addSubview(icon)
        
        button = UIButton(type: .custom)
        button.setTitle(loadText, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = titleFont
        button.layer.borderColor = titleColor.cgColor
        button.layer.borderWidth = 0.8
        button.addTarget(self, action: #selector(MQIWrongView.buttonAction), for: .touchUpInside)
        self.addSubview(button)
        
        let iconWidth: CGFloat = 160
        let iconHeight = noNetworkImage.size.height*iconWidth/noNetworkImage.size.width
        let labelHeight: CGFloat = 20
        let space: CGFloat = 10
        let btnWidth: CGFloat = 215
        let btnHeight: CGFloat = 30
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(labelHeight)
        }
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(titleLabel.snp.top)
            make.width.equalTo(iconWidth)
            make.height.equalTo(iconHeight)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(titleLabel.snp.bottom).offset(space)
            make.width.equalTo(btnWidth)
            make.height.equalTo(btnHeight)
        }
    }
    
    func defaultText() {
        loadText = kLocalized("retry")
        sTitle = kLocalized("LoadingAataFailedPleaseTryAgain")
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
