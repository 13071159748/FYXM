//
//  MQIUserBindPhoneView.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIUserBindPhoneView: UIView {
    let MQIRegisterView_tag: Int = 10000
    var bacColor: UIColor = RGBColor(234, g: 234, b: 234)
    var originY: CGFloat = 20
    
    let font = UIFont.systemFont(ofSize: ipad == true ? 18 : 15)
    var tags = [Int]()
    let pSpace: CGFloat = 25
    let pHeight: CGFloat = 50
    let iconSide: CGFloat = 20
    
    var finishBtn: UIButton!
    var codeBtn: UIButton!
    var tfBacView: UIView!
    var completion: (() -> ())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    func configUI() {
      
        
        let codeBtnWidth: CGFloat = 93
        
        let placeHolders = [kLocalized("MobilePhone"), kLocalized("VerificationCode")]
        let imgs = ["login_mobile", "login_code"]
        let iconSide: CGFloat = 20
        
        tfBacView = UIView(frame: CGRect(x: 0, y: pSpace, width: self.bounds.size.width, height: pHeight*CGFloat(placeHolders.count)))
        tfBacView.backgroundColor = UIColor.white
        self.addSubview(tfBacView)
        
        for i in 0..<placeHolders.count {
            
            let icon = UIImageView(image: UIImage(named: imgs[i]))
            icon.frame = CGRect(x: 18.5, y: pHeight*CGFloat(i)+(pHeight-iconSide)/2, width: iconSide, height: iconSide)
            tfBacView.addSubview(icon)
            var tf:UITextField
            
            if i == 0 {
                tf = GDTextField(frame: CGRect(x: icon.frame.maxX+12,
                                               y: pHeight*CGFloat(i),
                                               width: tfBacView.bounds.width-icon.frame.maxX-2*pSpace,
                                               height: pHeight))
                
            }else {
                tf = GDYZMField(frame: CGRect(x: icon.frame.maxX+12,
                                              y: pHeight*CGFloat(i),
                                              width: tfBacView.bounds.width-icon.frame.maxX-3*pSpace-codeBtnWidth,
                                              height: pHeight))
            }
            
            tf.keyboardType = .numberPad
            tf.clearButtonMode = .whileEditing
            tf.backgroundColor = UIColor.clear
            tf.placeholder = placeHolders[i]
            tf.tag = MQIRegisterView_tag+i
            tf.font = font
            
            
            if i == 0{
                let line = UIView(frame: CGRect (x: 0, y: tf.maxY - 0.5, width: screenWidth, height: 0.5))
                line.backgroundColor = UIColor.colorWithHexString("#EFEFF4")
                tfBacView.addSubview(line)
            }
            
            tfBacView.addSubview(tf)
            
        }
        let reigsetrBtnHeight: CGFloat = 30
        originY = tfBacView.frame.minY+pHeight+(pHeight-reigsetrBtnHeight)/2
        codeBtn = UIButton(frame: CGRect(x: self.bounds.width-codeBtnWidth-pSpace, y: originY, width: codeBtnWidth, height: reigsetrBtnHeight))
        codeBtn.backgroundColor = mainColor
        codeBtn.setTitle(kLocalized("SendVerificationCode"), for: .normal)
        codeBtn.setTitleColor(UIColor.white, for: .normal)
        codeBtn.titleLabel?.font = systemFont(12)
        codeBtn.layer.cornerRadius = reigsetrBtnHeight/2
        codeBtn.layer.masksToBounds = true
        codeBtn.addTarget(self, action: #selector(MQIUserBindPhoneView.codeBtnClick(_:)), for: .touchUpInside)
        self.addSubview(codeBtn)
        //判断发送验证码
        MQIRegisterManager.shared.change = {[weak self] (count) -> Void in
            if let weakSelf = self {
                //倒计时
                weakSelf.secondsCountDown(count: count)
            }
        }
        
        MQIRegisterManager.shared.changeEnd = {[weak self] ()-> Void in
            if let weakSelf = self {
                //停止
                DispatchQueue.main.async {()->Void in
                    weakSelf.codeBtn.setTitle(kLocalized("SendVerificationCode"), for: .normal)
                    weakSelf.codeBtn.isEnabled = true
                }
            }
        }
        
        //        finishBtn = UIButton(frame: CGRect(x: pSpace/2, y: tfBacView.frame.minY+pHeight*CGFloat(placeHolders.count)+pSpace, width: self.bounds.width-pSpace, height: pHeight))
        //        finishBtn = UIButton(frame: CGRect(x: (screenWidth - 235)/2, y: tfBacView.maxY + 83, width: 235, height: 40))
        finishBtn = UIButton(frame: CGRect(x: 70, y: tfBacView.maxY + 83, width: screenWidth - 140, height: 40))
        
        finishBtn.setTitle(kLocalized("TheBinding"), for: .normal)
        finishBtn.layer.cornerRadius = 20
        finishBtn.layer.masksToBounds = true
        finishBtn.layer.borderColor = mainColor.cgColor
        finishBtn.layer.borderWidth = 1
        finishBtn.setTitleColor(mainColor, for: .normal)
        finishBtn.titleLabel?.font = font
        finishBtn.addTarget(self, action: #selector(MQIUserBindPhoneView.finishBtnClick(_:)), for: .touchUpInside)
        self.addSubview(finishBtn)
        
        
    }
    func secondsCountDown(count:Int) {
        
        DispatchQueue.main.async {[weak self]()->Void in
            if let weakSelf = self {
                weakSelf.codeBtn.setTitle("\(count)\(kLocalized("SecondsLaterToTry"))", for: .normal)
                weakSelf.codeBtn.isEnabled = false
            }
        }
    }
    @objc func codeBtnClick(_ button: UIButton) {
        if MQIRegisterManager.shared.allow == false {
          
            MQILoadManager.shared.makeToast(kLongLocalized("PleaseTryAfterSecond", replace: "\(60-MQIRegisterManager.shared.count)"))
            return
        }
        if let tf = tfBacView.viewWithTag(MQIRegisterView_tag) as? UITextField {
            if let text = tf.text {
                if text.count > 0 {
                    if text.count != 11 || !isMobileNumber(yourNum: text){
                        MQILoadManager.shared.makeToast(kLocalized("PleaseEnterTheCorrectMobilePhoneNumber"))
                        return
                    }
                    codeBtn.isEnabled = false
                    toCode(text)
                    
                }else {
                    MQILoadManager.shared.makeToast(kLocalized("PleaseFillInYourCellPhoneNumber"))
                }
            }else {
                MQILoadManager.shared.makeToast(kLocalized("PleaseFillInYourCellPhoneNumber"))
            }
        }
    }
    
    @objc func finishBtnClick(_ button: UIButton) {
        if let mobileTF = tfBacView.viewWithTag(MQIRegisterView_tag) as? UITextField,
            let codeTF = tfBacView.viewWithTag(MQIRegisterView_tag+1) as? UITextField{
            if let mobile = mobileTF.text,
                let code = codeTF.text{
                var msg = ""
                if mobile.count <= 0 {
                    msg = kLocalized("PleaseEnterYourCellPhoneNumber")
                    MQILoadManager.shared.makeToast(msg)
                    return
                }
                if mobile.count != 11  || !isMobileNumber(yourNum: mobile){
                    msg = kLocalized("PleaseEnterTheCorrectMobilePhoneNumber")
                    MQILoadManager.shared.makeToast(msg)
                    return
                }
                if code.count <= 0 {
                    msg = kLocalized("PleaseEnterTheVerificationCode")
                    MQILoadManager.shared.makeToast(msg)
                    return
                }
                if msg.count <= 0 {
                    toBindPhone(mobile, code: code)
                }else {
                    MQILoadManager.shared.makeToast(msg)
                }
            }
        }
    }
    func toCode(_ mobile: String) {
        MQILoadManager.shared.addProgressHUD(kLocalized("GetIn"))
        
        GYUserPhoneVertifyCodeRequest(phone: mobile)
            .request({ (request, response, result: MQIBaseModel) -> () in
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(kLocalized("SuccessfulPpleaseCheckTheMessage"))
                MQIRegisterManager.shared.begin()
            }) { (errorMsg, errorCode) -> () in
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(errorMsg)
        }
    }
    
    func toBindPhone(_ mobile: String, code: String) {
        
        MQILoadManager.shared.addProgressHUD(kLocalized("TheBindingOf"))
        
        GYUserBindMobileRequest(phone: mobile, code: code).request({[weak self] (request, response, result:GYResultModel) in
            
            MQILoadManager.shared.dismissProgressHUD()
            MQILoadManager.shared.makeToast(kLocalized("BindingSuccess"))
            if let user = MQIUserManager.shared.user {
                user.user_mobile = mobile
                MQIUserManager.shared.saveUser()
            }
            UserNotifier.postNotification(.login_in)
            if let weakSelf = self {
                weakSelf.completion?()
            }
        }) { (err_msg, err_code) in
            MQILoadManager.shared.dismissProgressHUD()
            MQILoadManager.shared.makeToast(err_msg)
        }
    }


}
