//
//  MQIForgetPsdView.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIForgetPsdView: UIView,UITextFieldDelegate {
    var phoneText:UITextField!
    var codeText:UITextField!
    var passwordText:UITextField!
    var leftImg1: UIImageView!
    var leftImg2: UIImageView!
    var leftImg3: UIImageView!
    var line1: UILabel!
    var redLine: UILabel!
    var line2: UILabel!
    var line3:UILabel!
    var finishBtn: UIButton!
    var registerFinish:(() -> ())?
    var codeBtn: UIButton!
    var isChange:Bool = false {
        didSet{
            if isChange == true {
                phoneText.text = MQIUserManager.shared.user?.user_mobile
                phoneText.isUserInteractionEnabled = false
            }
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
        phoneText = UITextField.init(frame: CGRect (x: 54 * gdscale, y: 61 * hdscale, width: 250 * gdscale, height: 30 * hdscale))
        phoneText.placeholder = kLocalized("PleaseEnterYourCellPhoneNumber")
        phoneText.keyboardType = UIKeyboardType.numberPad
        phoneText.layer.borderColor = UIColor.clear.cgColor
        phoneText.delegate = self
        phoneText.tintColor = colorWithHexString("#EB5567")
        self.addSubview(phoneText)
        leftImg1 = UIImageView.init(image: UIImage.init(named: "login_mobile")?.withRenderingMode(.alwaysOriginal))
        leftImg1.frame = CGRect (x: 32 * gdscale, y: 61 * hdscale, width: 14 * gdscale, height: 18 * hdscale)
        self.addSubview(leftImg1)
        leftImg1.centerY = phoneText.centerY
        line1 = UILabel.init(frame: CGRect (x: 30 * gdscale, y: 91 * hdscale, width: 315 * gdscale, height: 1 * hdscale))
        line1.backgroundColor = colorWithHexString("#EBEBEB")
        self.addSubview(line1)
        
        codeText = UITextField.init(frame: CGRect (x: 54 * gdscale, y: 133 * hdscale, width: 250 * gdscale, height: 30 * hdscale))
        codeText.placeholder = kLocalized("PleaseEnterTheVerificationCode")
        codeText.layer.borderColor = UIColor.clear.cgColor
        codeText.delegate = self
        codeText.tintColor = colorWithHexString("#EB5567")
        self.addSubview(codeText)
        leftImg2 = UIImageView.init(image: UIImage.init(named: "login_code")?.withRenderingMode(.alwaysOriginal))
        leftImg2.frame = CGRect (x: 32 * gdscale, y: 133 * hdscale, width: 16 * gdscale, height: 18 * hdscale)
        self.addSubview(leftImg2)
        leftImg2.centerY = codeText.centerY
        line2 = UILabel.init(frame: CGRect (x: 30 * gdscale, y: 163 * hdscale, width: 315 * gdscale, height: 1 * hdscale))
        line2.backgroundColor = colorWithHexString("#EBEBEB")
        self.addSubview(line2)
        codeBtn = UIButton(type: .custom)
        codeBtn = UIButton(frame: CGRect(x: 268 * gdscale, y: 133 * hdscale, width: 90 * gdscale, height: 20 * hdscale))
        codeBtn.centerY = codeText.centerY
        codeBtn.setTitle(kLocalized("GetTheVerificationCode"), for: .normal)
        codeBtn.setTitleColor(colorWithHexString("#EB5567"), for: .normal)
        codeBtn.titleLabel?.font = systemFont(14 * gdscale)
        codeBtn.addTarget(self, action: #selector(MQIForgetPsdView.codeBtnClick(_:)), for: .touchUpInside)
        self.addSubview(codeBtn)
        
        
        passwordText = UITextField.init(frame: CGRect (x: 54 * gdscale, y: 205 * hdscale, width: 250 * gdscale, height: 30 * hdscale))
        passwordText.placeholder = kLocalized("PleaseEnterYourPassword")
        passwordText.layer.borderColor = UIColor.clear.cgColor
        passwordText.delegate = self
        passwordText.tintColor = colorWithHexString("#EB5567")
        passwordText.isSecureTextEntry = true
        self.addSubview(passwordText)
        leftImg3 = UIImageView.init(image: UIImage.init(named: "login_psw")?.withRenderingMode(.alwaysOriginal))
        leftImg3.frame = CGRect (x: 32 * gdscale, y: 205 * hdscale, width: 16 * gdscale, height: 18 * hdscale)
        self.addSubview(leftImg3)
        leftImg3.centerY = passwordText.centerY
        line3 = UILabel.init(frame: CGRect (x: 30 * gdscale, y: 235 * hdscale, width: 315 * gdscale, height: 1 * hdscale))
        line3.backgroundColor = colorWithHexString("#EBEBEB")
        self.addSubview(line3)
        
        
        finishBtn = UIButton(type: .custom)
        finishBtn = UIButton(frame: CGRect(x: 28 * gdscale, y: 290 * hdscale, width: 320 * gdscale, height: 44 * hdscale))
        finishBtn.setTitle("修改密码", for: .normal)
        finishBtn.layer.cornerRadius = 3 * gdscale
        finishBtn.layer.masksToBounds = true
        finishBtn.backgroundColor = mainColor
        finishBtn.setTitleColor(UIColor.white, for: .normal)
        finishBtn.titleLabel?.font = systemFont(16 * gdscale)
        finishBtn.addTarget(self, action: #selector(MQIForgetPsdView.finishBtnClick(_:)), for: .touchUpInside)
        self.addSubview(finishBtn)
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
        if let text = phoneText.text {
            if text.count > 0 {
                if text.count != 11 || !isMobileNumber(yourNum: text){
                    MQILoadManager.shared.makeToast(kLocalized("PleaseEnterTheCorrectMobilePhoneNumber"))
                    return
                }
                toCode(text)
            }else {
                MQILoadManager.shared.makeToast(kLocalized("PleaseFillInYourCellPhoneNumber"))
            }
        }else {
            MQILoadManager.shared.makeToast(kLocalized("PleaseFillInYourCellPhoneNumber"))
        }
    }
    func toCode(_ mobile: String) {
        MQILoadManager.shared.addProgressHUD(kLocalized("GetIn"))
        checkPhoneExists(mobile, completion: { [weak self](result) in
            if result == "exist" {
                if let weakSelf = self {
                    weakSelf.codeBtn.isEnabled = false
                    weakSelf.forgetVCGetYZM(mobile)
                }
            }else {
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast("您的手机号还没注册过")
            }
        })
        
    }
    func checkPhoneExists(_ phoneNumber:String,completion: ((_ result:String)->())?) {
        
        GDUserPhoneNumCheckExists(phoneNumber: phoneNumber).request({ (request, response, result:MQIBaseModel) in
            
            if result.dict["exists"] != nil{
                let exists =  result.dict["exists"]!
                if exists is Bool {
                    let s = exists as! Bool
                    if s != true {
                        completion?("none")
                    }else {
                        completion?("exist")
                    }
                }else if exists is NSNumber {
                    let num = exists as! NSNumber
                    if num != 1 {
                        completion?("none")
                    }else {
                        completion?("exist")
                    }
                }else {
                    completion?("none")
                }
                
            }else {
                completion?("exist")
            }
            
            
            
        }) {(errorMsg, errorCode) in
            
            completion?("none")
        }
    }
    func forgetVCGetYZM(_ mobile:String){
        GYUserPhoneVertifyCodeRequest(phone: mobile)
            .request({ (request, response, result: MQIBaseModel) -> () in
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(kLocalized("SuccessfulPpleaseCheckTheMessage"))
                MQIRegisterManager.shared.begin()
            }) { [weak self](errorMsg, errorCode) -> () in
                if let weakSelf = self {
                    weakSelf.codeBtn.isEnabled = true
                }
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(errorMsg)
        }
        
    }
    @objc func finishBtnClick(_ button: UIButton) {
        if let mobile = phoneText.text, let codeStr = codeText.text, let psw = passwordText.text{
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
            if codeStr.count <= 0 {
                msg = kLocalized("PleaseEnterTheVerificationCode")
                MQILoadManager.shared.makeToast(msg)
                return
            }
            if psw.count <= 5 {
                msg = kLocalized("PleaseEnterYourPasswordWithNoLessThanBits")
                MQILoadManager.shared.makeToast(msg)
                return
            }
            if psw.count >= 17 {
                msg = kLocalized("PleaseEnterYourPasswordWithNoMoreThanBits")
                MQILoadManager.shared.makeToast(msg)
                return
            }
            let donotWant = CharacterSet.init(charactersIn:" ")
            let keyword = psw.trimmingCharacters(in: donotWant)
            if keyword.count < psw.count {
                msg = kLocalized("APasswordShouldBeACombinationOfAlphanumericAndUnderscoreCharacters")
                MQILoadManager.shared.makeToast(msg)
                return
            }
            if msg.count <= 0 {
                toChangePsw(mobile, code: codeStr, psw: psw)
            }else {
                MQILoadManager.shared.makeToast(msg)
            }
        }
    }
    func toChangePsw(_ mobile: String, code: String, psw: String) {
        GYUserChangePswRequest(phone: mobile, code: code, password: psw)
            .request({ (request, response, result: GYResultModel) in
                MQILoadManager.shared.dismissProgressHUD()
               MQIUserManager.shared.loginOut(nil, finish: { (suc) in
                    
                })
                MQILoadManager.shared.addAlert_oneBtn(kLocalized("Warn"), msg: kLocalized("PasswordChangedSuccessfullyPleaseLogin"), block: {
                    self.registerFinish?()
                })
                
            }) { (err_msg, err_code) in
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(err_msg)
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
            phoneText.frame = CGRect (x: 32 * gdscale, y: 61 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            phoneText.placeholder = ""
            leftImg2.isHidden = false
            codeText.frame = CGRect (x: 54 * gdscale, y: 133 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            codeText.placeholder = kLocalized("PleaseEnterTheVerificationCode")
            leftImg3.isHidden = false
            passwordText.frame = CGRect (x: 54 * gdscale, y: 205 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            passwordText.placeholder = kLocalized("PleaseEnterYourPassword")
            removeRedLine()
            addRedLine(view: line1)
        }else if textField == codeText{
            leftImg1.isHidden = false
            phoneText.frame = CGRect (x: 54 * gdscale, y: 61 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            phoneText.placeholder = kLocalized("PleaseEnterYourCellPhoneNumber")
            leftImg2.isHidden = true
            codeText.frame = CGRect (x: 32 * gdscale, y: 133 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            codeText.placeholder = ""
            leftImg3.isHidden = false
            passwordText.frame = CGRect (x: 54 * gdscale, y: 205 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            passwordText.placeholder = kLocalized("PleaseEnterYourPassword")
            removeRedLine()
            addRedLine(view: line2)
        }else{
            leftImg1.isHidden = false
            phoneText.frame = CGRect (x: 54 * gdscale, y: 61 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            phoneText.placeholder = kLocalized("PleaseEnterYourCellPhoneNumber")
            leftImg2.isHidden = false
            codeText.frame = CGRect (x: 54 * gdscale, y: 133 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            codeText.placeholder = kLocalized("PleaseEnterTheVerificationCode")
            leftImg3.isHidden = true
            passwordText.frame = CGRect (x: 32 * gdscale, y: 205 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            passwordText.placeholder = ""
            removeRedLine()
            addRedLine(view: line3)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
}

