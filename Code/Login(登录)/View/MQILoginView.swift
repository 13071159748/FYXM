//
//  MQILoginView.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQILoginView: UIView,UITextFieldDelegate {

    var phoneText:UITextField!
    var passwordText:UITextField!
    var registerBtn: UIButton!
    var forgetBtn: UIButton!
    var leftImg1: UIImageView!
    var leftImg2: UIImageView!
    var line1: UILabel!
    var redLine: UILabel!
    var line2: UILabel!
    var finishBtn: UIButton!
    var loginFinish: (() -> ())?
    var toRegister: (() -> ())?
    var toForget: (() -> ())?
    var isAudit:Bool = false{
        didSet(oldValue) {
            registerBtn.isHidden = isAudit
            forgetBtn.isHidden = isAudit
        }
    }
    var mobile: String! {
        get {
            if phoneText != nil{
                return phoneText.text
            }
            return ""
        }
        set(newV) {
            if phoneText != nil{
                phoneText.text = newV
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        UI()
    }
    
    func UI() {
        phoneText = UITextField.init(frame: CGRect (x: 54 * gdscale, y: 68 * hdscale, width: 250 * gdscale, height: 30 * hdscale))
        phoneText.placeholder = kLocalized("PleaseEnterYourCellPhoneNumber")
        phoneText.keyboardType = UIKeyboardType.numberPad
        phoneText.layer.borderColor = UIColor.clear.cgColor
        phoneText.delegate = self
        phoneText.tintColor = colorWithHexString("#EB5567")
        self.addSubview(phoneText)
        leftImg1 = UIImageView.init(image: UIImage.init(named: "login_mobile")?.withRenderingMode(.alwaysOriginal))
        leftImg1.frame = CGRect (x: 32 * gdscale, y: 68 * hdscale, width: 14 * gdscale, height: 18 * hdscale)
        self.addSubview(leftImg1)
        leftImg1.centerY = phoneText.centerY
        line1 = UILabel.init(frame: CGRect (x: 30 * gdscale, y: 98 * hdscale, width: 315 * gdscale, height: 1 * hdscale))
        line1.backgroundColor = colorWithHexString("#EBEBEB")
        self.addSubview(line1)
        
        passwordText = UITextField.init(frame: CGRect (x: 54 * gdscale, y: 140 * hdscale, width: 250 * gdscale, height: 30 * hdscale))
        passwordText.placeholder = kLocalized("PleaseEnterYourPassword")
        passwordText.layer.borderColor = UIColor.clear.cgColor
        passwordText.delegate = self
        passwordText.tintColor = colorWithHexString("#EB5567")
        passwordText.isSecureTextEntry = true
        self.addSubview(passwordText)
        leftImg2 = UIImageView.init(image: UIImage.init(named: "login_psw")?.withRenderingMode(.alwaysOriginal))
        leftImg2.frame = CGRect (x: 32 * gdscale, y: 140 * hdscale, width: 16 * gdscale, height: 18 * hdscale)
        self.addSubview(leftImg2)
        leftImg2.centerY = passwordText.centerY
        line2 = UILabel.init(frame: CGRect (x: 30 * gdscale, y: 170 * hdscale, width: 315 * gdscale, height: 1 * hdscale))
        line2.backgroundColor = colorWithHexString("#EBEBEB")
        self.addSubview(line2)
        
        
        
        registerBtn = UIButton(frame: CGRect(x: 30 * gdscale, y: 191 * hdscale, width: 50 * gdscale, height: 17 * hdscale))
        registerBtn.setTitle(kLocalized("QuickRegistration"), for: .normal)
        registerBtn.setTitleColor(colorWithHexString("#8C8C8C"), for: .normal)
        registerBtn.titleLabel?.font = boldFont(Float(12 * gdscale))
        registerBtn.addTarget(self, action: #selector(MQILoginView.registerBtnClick(_:)), for: .touchUpInside)
        self.addSubview(registerBtn)
        
        
        forgetBtn = UIButton(frame: CGRect(x: 286 * gdscale, y: 191 * hdscale, width: 80 * gdscale, height: 17 * hdscale))
        forgetBtn.backgroundColor = UIColor.clear
        forgetBtn.setTitle(kLocalized("ForgetYourPassword"), for: .normal)
        forgetBtn.setTitleColor(colorWithHexString("#8C8C8C"), for: .normal)
        forgetBtn.titleLabel?.font = boldFont(Float(12 * gdscale))
        forgetBtn.addTarget(self, action: #selector(MQILoginView.forgetBtnAction(_:)), for: .touchUpInside)
        self.addSubview(forgetBtn)
        
        
        finishBtn = UIButton(type: .custom)
        finishBtn = UIButton(frame: CGRect(x: 28 * gdscale, y: 290 * hdscale, width: 320 * gdscale, height: 44 * hdscale))
        finishBtn.setTitle(kLocalized("TheLogin"), for: .normal)
        finishBtn.layer.cornerRadius = 3 * gdscale
        finishBtn.layer.masksToBounds = true
        finishBtn.backgroundColor = mainColor
        finishBtn.setTitleColor(UIColor.black, for: .normal)
        finishBtn.titleLabel?.font = systemFont(16 * gdscale)
        finishBtn.addTarget(self, action: #selector(MQILoginView.finishBtnClick(_:)), for: .touchUpInside)
        self.addSubview(finishBtn)
    }
    
    @objc func registerBtnClick(_ button: UIButton) {
        MQIRegisterManager.shared.mobile_Number = mobile
        self.endEditing(true)
        toRegister?()
    }
    @objc func forgetBtnAction(_ button: UIButton) {
        toForget?()
    }
    @objc func finishBtnClick(_ button: UIButton) {
        if let mobile = phoneText.text, let psw = passwordText.text {
            if NSString(string: mobile).length <= 0 {
                MQILoadManager.shared.makeToast(kLocalized("PleaseEnterYourCellPhoneNumber"))
                return
            }
            if mobile.count != 11   || !isMobileNumber(yourNum: mobile){
                MQILoadManager.shared.makeToast(kLocalized("PleaseEnterTheCorrectMobilePhoneNumber"))
                return
            }
            if NSString(string: psw).length <= 0 {
                MQILoadManager.shared.makeToast(kLocalized("PleaseEnterYourPassword"))
                return
            }
            let donotWant = CharacterSet.init(charactersIn:" ")
            let keyword = psw.trimmingCharacters(in: donotWant)
            if keyword.count < psw.count {
                MQILoadManager.shared.makeToast(kLocalized("APasswordShouldBeACombinationOfAlphanumericAndUnderscoreCharacters"))
                return
            }
            checkMobile(mobile, psw: psw)
        }
    }
    func checkMobile(_ mobile: String, psw: String) {
        self.endEditing(true)
        MQILoadManager.shared.addProgressHUD(kLocalized("InTheLogin"))
        GYUserMobileCheckRequest(mobile: mobile).request({[weak self] (request, response, result: MQIBaseModel) in
            MQILoadManager.shared.dismissProgressHUD()
            if let strongSelf = self {
                if  result.obj == nil {
                    if result.dict["exists"] != nil{
                        let exists =  result.dict["exists"]!
                        if exists is Bool {
                            let s = exists as! Bool
                            if s == true {
                                strongSelf.loginRequest(mobile, psw: psw)
                            }else {
                                strongSelf.toRegister?()
                            }
                        }else if exists is NSNumber {
                            let num = exists as! NSNumber
                            if num == 1 {
                                strongSelf.loginRequest(mobile, psw: psw)
                            }else {
                                strongSelf.toRegister?()
                            }
                        }else {
                            strongSelf.toRegister?()
                        }
                        
                    }else {
                        strongSelf.toRegister?()
                    }
                    
                }else {
                    if result.obj is Bool {
                        let s = result.obj as! Bool
                        if s == true {
                            strongSelf.loginRequest(mobile, psw: psw)
                        }else {
                            strongSelf.toRegister?()
                        }
                    }else if result.obj is NSNumber {
                        let num = result.obj as! NSNumber
                        if num == 1 {
                            strongSelf.loginRequest(mobile, psw: psw)
                        }else {
                            strongSelf.toRegister?()
                        }
                    }else {
                        strongSelf.toRegister?()
                    }
                    
                }
                
            }
        }) {[weak self] (err_msg, err_code) in
            MQILoadManager.shared.dismissProgressHUD()
            
            if err_code == "10800" {
                MQILoadManager.shared.makeToast(kLocalized("YourMobilePhoneHasNotBeenRegisteredPleaseRegister"))
                if let strongSelf = self {
                    after(1.0, block: {
                        strongSelf.toRegister?()
                    })
                }
            }else {
                MQILoadManager.shared.makeToast(err_msg)
            }
        }
    }
    func loginRequest(_ mobile: String, psw: String) {
        
        GYUserLoginRequest(mobile: mobile, password: psw, device_id: DEVICEID)
            .request({ [weak self](request, response, result: MQIBaseModel) -> () in
                
                paseUserObject(result)
                
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(kLocalized("LoginSuccessful"))
                
                if let user = MQIUserManager.shared.user {
                    user.user_mobile = mobile
                    user.user_password = psw
                    MQIUserManager.shared.saveUser()
                }
                UserNotifier.postNotification(.login_in)
                if let weakSelf = self {
                    after(0.5, block: {
                        weakSelf.loginFinish?()
                    })
                }
                
            }) { (errorMsg, errorCode) -> () in
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(errorMsg)
        }
    }
    func addRedLine(view:UILabel){
        if redLine != nil {
            redLine.removeFromSuperview()
        }
        redLine = UILabel.init(frame: CGRect (x: 0, y: view.frame.origin.y, width: 0, height: 2 * hdscale))
        redLine.centerX = view.centerX
        redLine.backgroundColor = colorWithHexString("#EB5567")
        self.addSubview(redLine)
        
        UIView.animateKeyframes(withDuration: 1, delay: 0.1, options: UIView.KeyframeAnimationOptions.beginFromCurrentState, animations: { () -> Void in
            //第一段
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                self.redLine.frame = CGRect (x: (screenWidth - view.width / 4) / 2, y: view.frame.origin.y, width: view.width / 4, height: 2 * hdscale)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
                self.redLine.frame = CGRect (x: (screenWidth - view.width / 2) / 2, y: view.frame.origin.y, width: view.width / 2, height: 2 * hdscale)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25, animations: {
                self.redLine.frame = CGRect (x: (screenWidth - (view.width / 4 * 3)) / 2, y: view.frame.origin.y, width: view.width / 4 * 3, height: 2 * hdscale)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: {
                self.redLine.frame = CGRect (x: view.frame.origin.x, y: view.frame.origin.y, width: view.width, height: 2 * hdscale)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 1, relativeDuration: 0.25, animations: {
                self.redLine.frame = view.frame
            })
            
        }) { _ in
            
        }
    }
    func removeRedLine(){
        if redLine != nil {
            redLine.removeFromSuperview()
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == phoneText {
            leftImg1.isHidden = true
            phoneText.frame = CGRect (x: 32 * gdscale, y: 68 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            phoneText.placeholder = ""
            leftImg2.isHidden = false
            passwordText.frame = CGRect (x: 54 * gdscale, y: 140 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            passwordText.placeholder = kLocalized("PleaseEnterYourPassword")
            removeRedLine()
            addRedLine(view: line1)
        }else{
            leftImg1.isHidden = false
            phoneText.frame = CGRect (x: 54 * gdscale, y: 68 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            phoneText.placeholder = kLocalized("PleaseEnterYourCellPhoneNumber")
            leftImg2.isHidden = true
            passwordText.frame = CGRect (x: 32 * gdscale, y: 140 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            passwordText.placeholder = ""
            removeRedLine()
            addRedLine(view: line2)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        UI()
    }


}
