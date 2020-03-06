//
//  MQILoginFirstView.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQILoginFirstView: UIView {


    var promptActionBlock:(( _ tag:Int) -> ())?
    var otherActionBlock:((_ type:LoginType) -> ())?
    var phoneActionBlock:(() -> ())?
    var clickloginHistoryActionBlock:(() -> ())?
    /// 是否有微信登录
    var isWechat:Bool = false
    var isMobile:Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        isMobile = (!MQIPayTypeManager.shared.isAvailable()) ? true:false
        isWechat =  (WXApi.isWXAppInstalled() || !isMobile)
        configUI()
    
    }
    
    
    func configUI() -> Void {
        
        let iconImage = UIImageView(frame: CGRect(x: self.width*0.5-35.5, y: kUIStyle.kScaleH*79, width: 77, height: 77))
        iconImage.image = UIImage(named: About_IconName)
        self.addSubview(iconImage)
        
        let title = UILabel(frame: CGRect(x: 0, y: iconImage.maxY+5, width: self.width, height: 21))
        title.font = UIFont.systemFont(ofSize: 15)
        title.textColor = UIColor.colorWithHexString("#6F7377")
        title.textAlignment = .center
        addSubview(title)
        title.text = "海量热门小说限时免费"
        
       
        let facebookBtn = configLongBtn(frame: CGRect(x: 0, y: iconImage.maxY+92*kUIStyle.kScaleH , width: 312*kUIStyle.kScaleW, height: 46), bacColor: kUIStyle.colorWithHexString("365AB2"), image: UIImage(named: "login_facebook_w"), title:  kLongLocalized("ToLogin", replace: "Facebook", isFirst: true), font: kUIStyle.sysFontDesignSize(size: 32))
        self.addSubview(facebookBtn)
      
       facebookBtn.centerX = iconImage.centerX
       facebookBtn.loingType = .Facebook
      
        if isMobile {
            let mobileBtn = configLongBtn(frame: CGRect(x: 0, y: facebookBtn.y-50, width: 312*kUIStyle.kScaleW, height: 38), bacColor: mainColor, image: nil, title: kLongLocalized("ToLogin", replace: kLocalized("MobilePhone"), isFirst: true), font: kUIStyle.sysFontDesignSize(size: 32))
            self.addSubview(mobileBtn)
            mobileBtn.centerX = iconImage.centerX
            mobileBtn.loingType = .Mobile
        }
        
        
        let googleBtn = configLongBtn(frame: CGRect(x: 0, y: facebookBtn.maxY+30*kUIStyle.kScaleH , width: facebookBtn.width, height:facebookBtn.height), bacColor: kUIStyle.colorWithHexString("E64131"), image: UIImage(named: "login_google_image"), title: kLongLocalized("ToLogin", replace: "Google", isFirst: true), font: kUIStyle.sysFontDesignSize(size: 32))
        self.addSubview(googleBtn)
        googleBtn.centerX = iconImage.centerX
        googleBtn.loingType = .Google
        
        
        let loginHistoryLable = UILabel(frame: CGRect(x: 0, y:googleBtn.maxY+14 , width: googleBtn.width, height: 20))
        loginHistoryLable.textColor = kUIStyle.colorWithHexString("FF4A9E")
        loginHistoryLable.font = kUIStyle.sysFontDesignSize(size: 26)
        loginHistoryLable.textAlignment = .right
        loginHistoryLable.backgroundColor = UIColor.white
        self.addSubview(loginHistoryLable)
        loginHistoryLable.attributedText =  getAttStr( kLocalized("View_login_history"), nil)
        loginHistoryLable.dsyAddTap(self, action: #selector(clickloginHistoryAction(tap:)))
        
        
        let otherlineView = UIView(frame: CGRect(x: 0, y: 0, width: googleBtn.width, height: 1))
        otherlineView.backgroundColor = UIColor.colorWithHexString("#CFCFCF")
        self.addSubview(otherlineView)

        let otherLable = UILabel(frame: CGRect(x: 0, y:googleBtn.maxY+80*kUIStyle.kScaleH , width: 10, height: 20))
        otherLable.textColor = kUIStyle.colorWithHexString("9B9B9B")
        otherLable.font = kUIStyle.sysFontDesignSize(size: 24)
        otherLable.textAlignment = .center
        otherLable.backgroundColor = UIColor.white
        self.addSubview(otherLable)
        otherLable.text = kLocalized("OtherWaysToLogin")
        otherLable.width = otherLable.font.pointSize*CGFloat((otherLable.text!.count+1))
        otherLable.centerX = iconImage.centerX
        
        
        otherlineView.centerX = otherLable.centerX
        otherlineView.centerY  = otherLable.centerY
       

        addOtherLogin(maxY: otherLable.maxY)
        
        let font = kUIStyle.sysFontDesignSize(size: 22)
        let textW = kUIStyle.getTextSizeWidth(text: kLocalized("LoginIndicatingThatYouAgreeWithOurTermsOfServicePrivacyPolicy"), font: font, maxHeight: 20)
        let promptView = UIView(frame: CGRect(x: 0, y: self.height-11*kUIStyle.kScaleH-20*kUIStyle.kScaleH , width: textW, height: 20*kUIStyle.kScaleH ))
        self.addSubview(promptView)
        promptView.centerX = iconImage.centerX
        
        configPromptSubView(promptView: promptView,font: font)
        

    }
    
    
    func addOtherLogin(maxY:CGFloat) -> Void {
        
        let btnW:CGFloat = 36*kUIStyle.kScaleH
        let btnY = maxY+25*kUIStyle.kScaleH
        var manger:CGFloat = 0
        if !isWechat{
             manger = (screenWidth - btnW*5)/CGFloat(3)
            let  twitterBtn = configRoundBtn(frame: CGRect(x: manger, y: btnY, width: btnW, height: btnW), image: UIImage(named: "login_line"))
            self.addSubview(twitterBtn)
            twitterBtn.loingType = . Linkedin
            
            let  lineBtn = configRoundBtn(frame: CGRect(x: twitterBtn.maxX+manger, y: btnY, width: btnW, height: btnW), image: UIImage(named: "login_twitter_image"))
            self.addSubview(lineBtn)
            lineBtn.loingType = .Twitter
            
            
            let  mailBtn = configRoundBtn(frame: CGRect(x: lineBtn.maxX+manger, y: btnY, width: btnW, height: btnW), image: UIImage(named: "login_mail_img"))
            self.addSubview(mailBtn)
            mailBtn.loingType = .Email
            
            
        }else{
            
            
            manger = (screenWidth - btnW*5)/CGFloat(4)
            
            let  wechatBtn = configRoundBtn(frame:  CGRect(x: manger, y: btnY, width: btnW, height: btnW), image: UIImage(named: "login_line"))
            self.addSubview(wechatBtn)
            wechatBtn.loingType = . Linkedin
            
            let  twitterBtn = configRoundBtn(frame: CGRect(x: wechatBtn.maxX+manger, y: btnY, width: btnW, height: btnW), image: UIImage(named: "login_twitter_image"))
            self.addSubview(twitterBtn)
            twitterBtn.loingType = .Twitter
       
            let  lineBtn = configRoundBtn(frame: CGRect(x: twitterBtn.maxX+manger, y: btnY, width: btnW, height: btnW), image: UIImage(named: "login_wechat"))
            self.addSubview(lineBtn)
            lineBtn.loingType = .Wechat
            
        
            let  mailBtn = configRoundBtn(frame: CGRect(x: lineBtn.maxX+manger, y: btnY, width: btnW, height: btnW), image: UIImage(named: "login_mail_img"))
            self.addSubview(mailBtn)
            mailBtn.loingType = .Email
            
         
        }
       
    }
    
    
    fileprivate func configPromptSubView(promptView:UIView ,font :UIFont) -> Void {
        
        let text1 = kLocalized("SignInToShowThatYouAgreeWithUs")
        let textW1 = kUIStyle.getTextSizeWidth(text: text1, font:  font, maxHeight: 20)
        let promptLable = UILabel(frame: CGRect(x: 0, y: 0, width: textW1, height: promptView.height))
        promptLable.textColor = kUIStyle.colorWithHexString("B2B2B2")
        promptLable.font = font
        promptLable.textAlignment = .left
        promptView.addSubview(promptLable)
        promptLable.text = text1
        
        let text2 = "\(kLocalized("TheTermsOfService"))，"
        let textW2 = kUIStyle.getTextSizeWidth(text: text2, font:  font, maxHeight: 20)
        let promptLable2 = UILabel(frame: CGRect(x: promptLable.maxX, y: 0, width: textW2, height: promptView.height))
        promptLable2.textColor = promptLable.textColor
        promptLable2.font = promptLable.font
        promptLable2.textAlignment = promptLable.textAlignment
        promptView.addSubview(promptLable2)
        
        promptLable2.attributedText = getAttStr(kLocalized("TheTermsOfService"),"，")
        promptLable2.tag = 100
        promptLable2.dsyAddTap(self, action: #selector(clickPromptAction(tap:)))

        let text3 = kLocalized("PrivacyPolicy")
        let textW3 = kUIStyle.getTextSizeWidth(text: text3, font:  font, maxHeight: 20)
        let promptLable3 = UILabel(frame: CGRect(x:promptLable2.maxX, y: 0, width: textW3, height: promptView.height))
        promptLable3.textColor = promptLable.textColor
        promptLable3.font = promptLable.font
        promptLable3.textAlignment = promptLable.textAlignment
        promptView.addSubview(promptLable3)
        promptLable3.attributedText = getAttStr(text3)
        promptLable3.dsyAddTap(self, action: #selector(clickPromptAction(tap:)))
        
      
    }
    
    @objc fileprivate func loginAction(_ sender:MQILoginBtn){
        otherActionBlock?(sender.loingType)
        
    }
    
    @objc fileprivate func clickloginHistoryAction(tap:UITapGestureRecognizer){
       clickloginHistoryActionBlock?()
    }
    
    
    @objc  fileprivate func clickPromptAction(tap:UITapGestureRecognizer) -> Void {
        if let tag = tap.view?.tag {
            promptActionBlock?(tag)
        }
        
    }
    /// 创建一个atts
    fileprivate func getAttStr(_ str:String? = " ", _ str2:String? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: str!)
        attributedString.addAttributes([.underlineStyle:NSUnderlineStyle.single.rawValue ], range: NSRange.init(location: 0, length: str!.count))
        if str2 != nil {
             let attributedString2 = NSMutableAttributedString(string: str2!)
            attributedString.append(attributedString2)
        }
        
        return attributedString as NSAttributedString
    }
    
    fileprivate func configLongBtn(frame:CGRect,bacColor:UIColor ,image:UIImage?,title:String,font:UIFont) -> MQILoginBtn {
        
        let btn = MQILoginBtn(frame: frame)
        btn.backgroundColor = bacColor
        btn.setImage(image, for: .normal)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = font
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 19
        btn.imageEdgeInsets = UIEdgeInsets(top:0 , left: -10, bottom: 0, right: 10)
        btn.contentHorizontalAlignment = .center
        btn.addTarget(self, action: #selector(loginAction(_:)), for: .touchUpInside)
        return btn
        
    }
    
  fileprivate  func configRoundBtn(frame:CGRect,image:UIImage?) -> MQILoginBtn {
        let btn = MQILoginBtn(frame: frame)
        btn.backgroundColor =  UIColor.clear
        btn.setImage(image, for: .normal)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = frame.height*0.5
        btn.addTarget(self, action: #selector(loginAction(_:)), for: .touchUpInside)
        return btn
        
    }
    

    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isMobile = (!MQIPayTypeManager.shared.isAvailable()) ? true:false
        isWechat =  (WXApi.isWXAppInstalled() || !isMobile)
        configUI()
    }
}

private class MQILoginBtn: UIButton {
    /// 登录类型
    var loingType:LoginType = .other
    
}
