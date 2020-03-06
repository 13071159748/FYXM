//
//  GYNoDataViewNew.swift
//  Reader
//
//  Created by CQSC  on 2018/4/28.
//  Copyright © 2018年  CQSC. All rights reserved.
//

import UIKit


class MQINoDataBookView: UIView {
    
    var icon: UIImageView!
    var titleLabel: UILabel!
    var clickBlock:(()->())?
    
    let titleFont = UIFont.systemFont(ofSize: ipad == true ? 16 : 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        setNoDataLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
        setNoDataLayout()
    }
    /// 书籍暂无数据
    func noBook(_ title:String,imgName:String = "searchNoBook",click:(()->())? = nil) -> Void {
        setBookLayout()
        titleLabel.text = title
        icon.image = UIImage(named: imgName)
        clickBlock = click
    }
    /// 默认暂无数据
    func noData(_ title:String,imgName:String = "searchNoBook",click:(()->())? = nil) -> Void {
        titleLabel.text = title
        icon.image = UIImage(named: imgName)
        clickBlock = click
    }
    func dismiss(_ completion: (() -> ())?) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.alpha = 0
        }, completion: { (suc) -> Void in
            self.removeFromSuperview()
            completion?()
        })
    }
    
    private func configUI() {
        self.backgroundColor = UIColor.white
        
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.font = titleFont
        titleLabel.textAlignment = .center
        titleLabel.text = kLocalized("NoAboutData")
        titleLabel.textColor = blackColor
        titleLabel.numberOfLines = 0
        self.addSubview(titleLabel)
        icon = UIImageView(frame: CGRect.zero)
        icon.image = UIImage(named: "searchNoBook")
        self.addSubview(icon)
        let tgr = UITapGestureRecognizer(target: self, action: #selector(clickView(tap:)))
        self.addGestureRecognizer(tgr)
        
    }
    
    @objc private func clickView(tap:UITapGestureRecognizer) -> Void {
        clickBlock?()
    }
    
    
    private func setNoDataLayout() -> Void {
        let w = screenWidth*0.3
        icon.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(self).offset(-30)
            make.centerX.equalTo(self)
            make.width.equalTo(w)
            make.height.equalTo(w*0.87)
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(icon)
            make.top.equalTo(icon.snp.bottom).offset(20)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            
        }
    }
    
    
    private  func setBookLayout() -> Void {
        icon.snp.removeConstraints()
        titleLabel.snp.removeConstraints()
        icon.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(100)
            make.centerX.equalTo(self)
//            make.width.equalTo(screenWidth*0.3)
//            make.height.equalTo(screenWidth*0.4)
            
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(icon)
            make.top.equalTo(icon.snp.bottom).offset(20)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            
        }
    }
    
    
    
    
    
}
