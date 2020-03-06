//
//  MQIApplePayFootCollectionReusableView.swift
//  CQSC
//
//  Created by moqing on 2019/2/25.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQIApplePayFootCollectionReusableView: UICollectionReusableView {
    
    
    var countText:NSAttributedString = NSAttributedString() {
        didSet(oldValue) {
            countLable.attributedText = countText
        }
    }
    
    var titleText:String = "" {
        didSet(oldValue) {
            titleLable.text = titleText
        }
    }
    
    
    var clickBlock:(()->())?
    var titleLable:UILabel!
    var countLable:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() -> Void {
        
        titleLable = UILabel()
        titleLable.textColor = kUIStyle.colorWithHexString("333333")
        titleLable.font = UIFont.boldSystemFont(ofSize: 14)
        addSubview(titleLable)
        
        
        countLable = UILabel()
        countLable.textColor = kUIStyle.colorWithHexString("333333")
        countLable.font = UIFont.systemFont(ofSize: 12)
        countLable.numberOfLines = 0
        addSubview(countLable)
        
        
        titleLable.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(self).offset(-kUIStyle.scale1PXW(15))
            make.top.equalTo(self).offset(kUIStyle.scale1PXH(40))
        }
        countLable.snp.makeConstraints { (make) in
            make.left.equalTo(titleLable)
            make.top.equalTo(titleLable.snp.bottom).offset(5)
            make.right.equalTo(-20)
        }
        
        let clickView = UIView()
        clickView.backgroundColor = UIColor.clear
        clickView.dsyAddTap(self, action: #selector(clickTap(tap:)))
        addSubview(clickView)
        clickView.snp.makeConstraints { (make) in
            make.left.equalTo(countLable).offset(50)
            make.bottom.equalTo(countLable)
            make.right.equalTo(countLable).offset(-60)
            make.height.equalTo(20)
        }
    }
    
    @objc func clickTap(tap:UITapGestureRecognizer)  {
        clickBlock?()
    }
    
    func getAtStr(str:String) -> NSMutableAttributedString {
        let att1 = NSMutableAttributedString(string: str)
        let sye = NSMutableParagraphStyle()
        sye.lineSpacing = 5
        att1.addAttributes([NSAttributedString.Key.paragraphStyle:sye], range: NSRange.init(location: 0, length: str.count))
        return att1
    }
 
    
    class func getIdentifier() -> String {
        
        return  "MQIApplePayFootCollectionReusableView_Identifier"
    }
}

class MQIApplePayHeadCollectionReusableView: UICollectionReusableView {
    
    
    
    let payTintColor = mainColor
    
    var titleBtn:UIButton!
    var vrestoreBlock:(()->())?
    var clickBtn: (()->())?
    var clickBanner: (()->())?
    
    var bannerImageView: UIImageView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI()  {
        
        let label = UILabel()
        label.text = kLocalized("FailedToRechargeSuccessfully")
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.numberOfLines = 0
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(19)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(-20)        }
        
        titleBtn = UIButton()
        titleBtn.layer.borderWidth = 1
        titleBtn.layer.borderColor = #colorLiteral(red: 0.9254901961, green: 0.368627451, blue: 0.4352941176, alpha: 1).cgColor
        titleBtn.setTitleColor(#colorLiteral(red: 0.9254901961, green: 0.368627451, blue: 0.4352941176, alpha: 1), for: .normal)
        titleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        titleBtn.addTarget(self, action: #selector(vrestoreBtnClick(btn:)), for: .touchUpInside)
//        addSubview(titleBtn)
//        titleBtn.setTitle("点击获取书币", for: .normal)
//        titleBtn.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().offset(19)
//            make.left.equalTo(label.snp.right)
//            make.width.equalTo(86)
//            make.height.equalTo(17)
//        }
//
        
        let discard_bg = UIImageView()
        addSubview(discard_bg)
        let height = (screenWidth - 40) * 109 / 335
        discard_bg.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(height)
        }
        discard_bg.dsyAddTap(self, action: #selector(onBnnerTapped))
        bannerImageView = discard_bg
//        let btn = UIButton()
//        addSubview(btn)
//        btn.tag = 2
//        btn.addTarget(self, action: #selector(clickBtn(btn:)), for: .touchUpInside)
//        btn.snp.makeConstraints { (make) in
//            make.top.equalTo(titleBtn.snp.bottom).offset(10)
//            make.left.equalTo(20)
//            make.right.equalTo(-20)
//            make.height.equalTo(height)
//        }
    }
    
    @objc func clickBtn(btn: UIButton) {
        let clickEvent = btn.tag == 2 ? clickBanner : clickBtn
        clickEvent?()
        
    }
    
    @objc func onBnnerTapped(){
        clickBanner?()
    }
    
    
//    /// 创建一个atts
//    func getAttStr(_ str:String , _ str2:String ) -> NSAttributedString {
//        
//        let attributedString = NSMutableAttributedString(string: str)
//        
//        let attributedString2 = NSMutableAttributedString(string: str2)
//        attributedString2.addAttributes([NSAttributedString.Key.underlineStyle:NSUnderlineStyle.NSUnderlineStyle.single.rawValue ,NSAttributedString.Key.foregroundColor:payTintColor], range: NSRange.init(location: 0, length: str2.count))
//        attributedString.append(attributedString2)
//        
//        return attributedString as NSAttributedString
//    }
//    
    @objc func vrestoreBtnClick(btn:UIButton) -> Void {
        vrestoreBlock?()
        
    }
    class func getIdentifier() -> String {
        return  "MQIApplePayHeadCollectionReusableView_Identifier"
    }
    
}
