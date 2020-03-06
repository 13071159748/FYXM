//
//  MQIRegView.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIRegView: UIView,UITextFieldDelegate {

    var nickText:UITextField!
    var phoneText:UITextField!
    var codeText:UITextField!
    var passwordText:UITextField!
    var leftImg1: UIImageView!
    var leftImg2: UIImageView!
    var leftImg3: UIImageView!
    var leftImg4: UIImageView!
    var line1: UILabel!
    var redLine: UILabel!
    var line2: UILabel!
    var line3:UILabel!
    var line4:UILabel!
    var finishBtn: UIButton!
    var registerFinish: (() -> ())?
    var backToLoginBlock: (() -> ())?
    var toVC: ((_ vc: UIViewController) -> ())?
    var codeBtn: UIButton!
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
        nickText = UITextField.init(frame: CGRect (x: 54 * gdscale, y: 61 * hdscale, width: 250 * gdscale, height: 30 * hdscale))
        nickText.placeholder = kLocalized("PleaseEnterNicknam")
        nickText.layer.borderColor = UIColor.clear.cgColor
        nickText.delegate = self
        nickText.tintColor = colorWithHexString("#EB5567")
        self.addSubview(nickText)
        leftImg4 = UIImageView.init(image: UIImage.init(named: "login_username")?.withRenderingMode(.alwaysOriginal))
        leftImg4.frame = CGRect (x: 32 * gdscale, y: 61 * hdscale, width: 18 * gdscale, height: 18 * hdscale)
        self.addSubview(leftImg4)
        leftImg4.centerY = nickText.centerY
        line4 = UILabel.init(frame: CGRect (x: 30 * gdscale, y: 91 * hdscale, width: 315 * gdscale, height: 1 * hdscale))
        line4.backgroundColor = colorWithHexString("#EBEBEB")
        self.addSubview(line4)
        
        
        phoneText = UITextField.init(frame: CGRect (x: 54 * gdscale, y: 132 * hdscale, width: 250 * gdscale, height: 30 * hdscale))
        phoneText.placeholder = kLocalized("PleaseEnterYourCellPhoneNumber")
        phoneText.keyboardType = UIKeyboardType.numberPad
        phoneText.layer.borderColor = UIColor.clear.cgColor
        phoneText.delegate = self
        phoneText.tintColor = colorWithHexString("#EB5567")
        self.addSubview(phoneText)
        leftImg1 = UIImageView.init(image: UIImage.init(named: "login_mobile")?.withRenderingMode(.alwaysOriginal))
        leftImg1.frame = CGRect (x: 32 * gdscale, y: 132 * hdscale, width: 14 * gdscale, height: 18 * hdscale)
        self.addSubview(leftImg1)
        leftImg1.centerY = phoneText.centerY
        line1 = UILabel.init(frame: CGRect (x: 30 * gdscale, y: 162 * hdscale, width: 315 * gdscale, height: 1 * hdscale))
        line1.backgroundColor = colorWithHexString("#EBEBEB")
        self.addSubview(line1)
        
        codeText = UITextField.init(frame: CGRect (x: 54 * gdscale, y: 203 * hdscale, width: 250 * gdscale, height: 30 * hdscale))
        codeText.placeholder = kLocalized("PleaseEnterTheVerificationCode")
        codeText.layer.borderColor = UIColor.clear.cgColor
        codeText.delegate = self
        codeText.tintColor = colorWithHexString("#EB5567")
        self.addSubview(codeText)
        leftImg2 = UIImageView.init(image: UIImage.init(named: "login_code")?.withRenderingMode(.alwaysOriginal))
        leftImg2.frame = CGRect (x: 32 * gdscale, y: 203 * hdscale, width: 16 * gdscale, height: 18 * hdscale)
        self.addSubview(leftImg2)
        leftImg2.centerY = codeText.centerY
        line2 = UILabel.init(frame: CGRect (x: 30 * gdscale, y: 233 * hdscale, width: 315 * gdscale, height: 1 * hdscale))
        line2.backgroundColor = colorWithHexString("#EBEBEB")
        self.addSubview(line2)
        
        codeBtn = UIButton(type: .custom)
        codeBtn = UIButton(frame: CGRect(x: 268 * gdscale, y: 203 * hdscale, width: 90 * gdscale, height: 20 * hdscale))
        codeBtn.centerY = codeText.centerY
        codeBtn.setTitle(kLocalized("GetTheVerificationCode"), for: .normal)
        codeBtn.setTitleColor(colorWithHexString("#EB5567"), for: .normal)
        codeBtn.titleLabel?.font = systemFont(14 * gdscale)
        codeBtn.addTarget(self, action: #selector(MQIRegView.codeBtnClick(_:)), for: .touchUpInside)
        self.addSubview(codeBtn)
        
        
        passwordText = UITextField.init(frame: CGRect (x: 54 * gdscale, y: 274 * hdscale, width: 250 * gdscale, height: 30 * hdscale))
        passwordText.placeholder = kLocalized("PleaseEnterYourPassword")
        passwordText.layer.borderColor = UIColor.clear.cgColor
        passwordText.delegate = self
        passwordText.tintColor = colorWithHexString("#EB5567")
        passwordText.isSecureTextEntry = true
        self.addSubview(passwordText)
        leftImg3 = UIImageView.init(image: UIImage.init(named: "login_psw")?.withRenderingMode(.alwaysOriginal))
        leftImg3.frame = CGRect (x: 32 * gdscale, y: 274 * hdscale, width: 16 * gdscale, height: 18 * hdscale)
        self.addSubview(leftImg3)
        leftImg3.centerY = passwordText.centerY
        line3 = UILabel.init(frame: CGRect (x: 30 * gdscale, y: 304 * hdscale, width: 315 * gdscale, height: 1 * hdscale))
        line3.backgroundColor = colorWithHexString("#EBEBEB")
        self.addSubview(line3)
        
        
        finishBtn = UIButton(type: .custom)
        finishBtn = UIButton(frame: CGRect(x: 28 * gdscale, y: 405 * hdscale, width: 320 * gdscale, height: 44 * hdscale))
        finishBtn.setTitle(kLocalized("registered"), for: .normal)
        finishBtn.layer.cornerRadius = 3 * gdscale
        finishBtn.layer.masksToBounds = true
        finishBtn.backgroundColor = mainColor
        finishBtn.setTitleColor(UIColor.white, for: .normal)
        finishBtn.titleLabel?.font = systemFont(16 * gdscale)
        finishBtn.addTarget(self, action: #selector(MQIRegView.finishBtnClick(_:)), for: .touchUpInside)
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
            if result == "none" {
                if let weakSelf = self {
                    weakSelf.codeBtn.isEnabled = false
                    weakSelf.getYZM(mobile)
                }
            }else {
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(kLocalized("YouHaveRegisteredThisMobilePhoneNumberPleaseReturnToLogin"))
            }
        })
    }
    func getYZM(_ mobile:String) {
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
    func secondsCountDown(count:Int) {
        
        DispatchQueue.main.async {[weak self]()->Void in
            if let weakSelf = self {
                weakSelf.codeBtn.setTitle("\(count)\(kLocalized("SecondsLaterToTry"))", for: .normal)
                weakSelf.codeBtn.isEnabled = false
            }
        }
    }
    
    @objc func finishBtnClick(_ button: UIButton) {
        if let mobile = phoneText.text,
            let code = codeText.text,
            let nick = nickText.text,
            let psw = passwordText.text {
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
            let nonickspace = (nick as NSString).replacingOccurrences(of: " ", with: "")
            
            guard nonickspace != "" else {
                MQILoadManager.shared.makeToast(kLocalized("PleaseEnterNicknam"))
                return
            }
            
            if msg.count <= 0 {
                
                checkPhoneExists(mobile, completion: { [weak self](result) in
                    if result == "none" {
                        if let weakSelf = self {
                            weakSelf.toRegister(mobile, nick: nick, code: code, psw: psw)
                        }
                    }else {
                        MQILoadManager.shared.makeToast(kLocalized("YouHaveRegisteredThisMobilePhoneNumberPleaseReturnToLogin"))
                    }
                })
            }else {
                MQILoadManager.shared.makeToast(msg)
            }
        }
    }
    func toRegister(_ mobile: String, nick: String, code: String, psw: String) {
        MQILoadManager.shared.addProgressHUD(kLocalized("InTheRegister"))
        GYUserRegisterRequest(phone_number: mobile, password: psw, code: code, nick: nick, device_id: DEVICEID)
            .request({[weak self] (request, response, result: MQIBaseModel) -> () in
                paseUserObject(result)
                
//                YPMobileManager.shared.saveMobile(mobile)
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(kLocalized("LoginSuccessful"))
                
                if let user = MQIUserManager.shared.user {
                    user.user_mobile = mobile
                    user.user_password = psw
                    MQIUserManager.shared.saveUser()
                }
                
                UserNotifier.postNotification(.login_in)
                if let strongSelf = self {
                    after(0.5, block: {
                        strongSelf.registerFinish?()
                    })
                }
                }, failureHandler: { (err_msg, err_code) -> () in
                    MQILoadManager.shared.dismissProgressHUD()
                    MQILoadManager.shared.makeToast(err_msg)
            })
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
        if textField == nickText{
            leftImg4.isHidden = true
            nickText.frame = CGRect (x: 32 * gdscale, y: 61 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            nickText.placeholder = ""
            leftImg1.isHidden = false
            phoneText.frame = CGRect (x: 54 * gdscale, y: 132 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            phoneText.placeholder = kLocalized("PleaseEnterYourCellPhoneNumber")
            leftImg2.isHidden = false
            codeText.frame = CGRect (x: 54 * gdscale, y: 203 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            codeText.placeholder = kLocalized("PleaseEnterTheVerificationCode")
            leftImg3.isHidden = false
            passwordText.frame = CGRect (x: 54 * gdscale, y: 274 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            passwordText.placeholder = kLocalized("PleaseEnterYourPassword")
            removeRedLine()
            addRedLine(view: line4)
        }else if textField == phoneText {
            leftImg4.isHidden = false
            nickText.frame = CGRect (x: 54 * gdscale, y: 61 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            nickText.placeholder = kLocalized("PleaseEnterNicknam")
            leftImg1.isHidden = true
            phoneText.frame = CGRect (x: 32 * gdscale, y: 132 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            phoneText.placeholder = ""
            leftImg2.isHidden = false
            codeText.frame = CGRect (x: 54 * gdscale, y: 203 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            codeText.placeholder = kLocalized("PleaseEnterTheVerificationCode")
            leftImg3.isHidden = false
            passwordText.frame = CGRect (x: 54 * gdscale, y: 274 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            passwordText.placeholder = kLocalized("PleaseEnterYourPassword")
            removeRedLine()
            addRedLine(view: line1)
        }else if textField == codeText{
            leftImg4.isHidden = false
            nickText.frame = CGRect (x: 54 * gdscale, y: 61 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            nickText.placeholder = kLocalized("PleaseEnterNicknam")
            leftImg1.isHidden = false
            phoneText.frame = CGRect (x: 54 * gdscale, y: 132 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            phoneText.placeholder = kLocalized("PleaseEnterYourCellPhoneNumber")
            leftImg2.isHidden = true
            codeText.frame = CGRect (x: 32 * gdscale, y: 203 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            codeText.placeholder = ""
            leftImg3.isHidden = false
            passwordText.frame = CGRect (x: 54 * gdscale, y: 274 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            passwordText.placeholder = kLocalized("PleaseEnterYourPassword")
            removeRedLine()
            addRedLine(view: line2)
        }else{
            leftImg4.isHidden = false
            nickText.frame = CGRect (x: 54 * gdscale, y: 61 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            nickText.placeholder = kLocalized("PleaseEnterNicknam")
            leftImg1.isHidden = false
            phoneText.frame = CGRect (x: 54 * gdscale, y: 132 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            phoneText.placeholder = kLocalized("PleaseEnterYourCellPhoneNumber")
            leftImg2.isHidden = false
            codeText.frame = CGRect (x: 54 * gdscale, y: 203 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            codeText.placeholder = kLocalized("PleaseEnterTheVerificationCode")
            leftImg3.isHidden = true
            passwordText.frame = CGRect (x: 32 * gdscale, y: 274 * hdscale, width: 250 * gdscale, height: 30 * hdscale)
            passwordText.placeholder = ""
            removeRedLine()
            addRedLine(view: line3)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
