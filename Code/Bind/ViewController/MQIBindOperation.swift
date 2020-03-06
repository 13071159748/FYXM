//
//  MQIBindOperation.swift
//  CQSC
//
//  Created by moqing on 2019/8/26.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit


enum BindPageType:String {
    case check_pwd = "check_pwd" /// 输入密码页面
    case check_email = "check_email" /// 输入邮箱页面
    case verificatio_code = "verificatio_code" /// 验证码页面
    case change_pwd = "change_pwd" /// 修改密码页面
    case input_nickname = "input_nickname" /// 密码+昵称页面
    case resetVerificatio_code = "resetVerificatio_code" /// 验证码样式2
}

enum BindCreatedPageType:String{
    case login = "login" /// 登录
    case reset_Pwd = "reset_Pwd"/// 修改密码
    case bind_email = "bind_email" /// 绑定邮箱
    case change_email = "change_email" /// 更换邮箱
}

class MQIBindOperation:NSObject {
    
    /// 登录成功回调
    var loginSuccess:(()->())?
    var changeTitle:((_ title:String)->())?
    /// 状态视图
    weak var itemView:MQIBindItemView!{
        didSet(oldValue) {
            itemView.nextBtn.addTarget(self, action: #selector(clickNextBtn(_:)), for: .touchUpInside)
            itemView.otherBtn.addTarget(self, action: #selector(clickOtherBtn(_:)), for: .touchUpInside)
            itemView.inputTextField.delegate = self
            itemView.inputTextField2.delegate = self
            itemView.inputTextField.textField.addTarget(self, action: #selector(inputTextFunc(sender:)), for: UIControl.Event.editingChanged)
            itemView.inputTextField2.textField.addTarget(self, action: #selector(inputTextFunc(sender:)), for: UIControl.Event.editingChanged)
        }
    }
    
    var type : BindCreatedPageType!{
        didSet(oldValue) {
            switch type {
            case .login?:
                tempModel.default()
                tempModel.nav_title = kLocalized("Email_login", describeStr: "邮箱登录")
                tempModel.send_type = "register"
                tempModel.icon_name = "Bind_Email_img"
                tempModel.inputText_1_placeholder = kLocalized("Please_ente_email", describeStr: "请输入邮箱")
                tempModel.nextBtn_title = kLocalized("Next_step", describeStr: "下一步")
                currentPageType = .check_email
                break
            case .bind_email?:
                tempModel.default()
                tempModel.nav_title = kLocalized("Binding_email", describeStr: "绑定邮箱")
                tempModel.send_type = "bind"
                tempModel.icon_name = "Bind_Email_img"
                tempModel.inputText_1_placeholder = kLocalized("Please_ente_email", describeStr: "请输入邮箱")
                tempModel.nextBtn_title =  kLocalized("Send_verification_code", describeStr: "发送验证码")
                currentPageType = .check_email
                break
            case .reset_Pwd?:
                tempModel.default()
                tempModel.nav_title = kLocalized("Reset_password", describeStr: "重置密码")
                tempModel.send_type = "reset_pass"
                tempModel.email = user_email
                tempModel.icon_name = "Bind_Email_img"
                tempModel.title_text  = kLongLocalized("The_verification_code_has_bee_sent_to_your_email", replace: tempModel.email,describeStr:"验证码已发送至您的邮箱")
         
                tempModel.otherBtn_title = NSAttributedString(string:   kLocalized("Resend_code", describeStr: "重新发送"), attributes: [NSAttributedString.Key.foregroundColor : UIColor.colorWithHexString("#7187FF"),.underlineStyle:NSUnderlineStyle.single.rawValue])
                tempModel.nextBtn_title = kLocalized("Next_step", describeStr: "下一步")
                currentPageType = .resetVerificatio_code
                isRefresh(true)
                send_email_login(tempModel.email, send_type:   tempModel.send_type, code: "") { [weak self] (suc, msg) in
                    guard let weakSelf = self else { return }
                    weakSelf.isRefresh(false)
                    if !suc {
                        weakSelf.isResend()
                        MQILoadManager.shared.makeToast(msg)
                    }else {
                         weakSelf.itemView.nextBtn.setImage(nil, for: .normal)
                    }
                    
                }
                break
            case .change_email?:
                tempModel.default()
                tempModel.email = user_email
                tempModel.send_type = "reset_email"
                tempModel.nav_title =   kLocalized("Change_your_email", describeStr: "变更邮箱" )
                tempModel.icon_name = "Bind_Pwd_img"
                tempModel.inputText_1_placeholder = kLocalized("Please_enter_password", describeStr: "请输入密码")
                tempModel.nextBtn_title = kLocalized("Next_step", describeStr: "下一步")
                tempModel.otherBtn_title = NSAttributedString(string:  kLocalized("Forget_password", describeStr: "忘记密码"), attributes: [NSAttributedString.Key.foregroundColor : UIColor.colorWithHexString("#7187FF")])
                currentPageType = .change_pwd
                break
            default:
                
                
                break
            }
        }
        
    }
    
    ///当前页面样式
    fileprivate  var currentPageType:BindPageType = .check_email {
        didSet(oldValue) {
            DispatchQueue.main.async {
            
                    switch self.currentPageType {
                    case .check_pwd:
                        self.check_pwd()
                        self.itemView.inputTextField.textField.becomeFirstResponder()
                        self.itemView.inputTextField.textField.isSecureTextEntry = true
                        self.itemView.inputTextField2.textField.isSecureTextEntry = true
                        break
                    case .check_email:
                        self.check_email()
                        self.itemView.inputTextField.textField.isSecureTextEntry = false
                        self.itemView.inputTextField2.textField.isSecureTextEntry = false
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                            if !self.itemView.inputTextField.textField.isFirstResponder {
                                self.itemView.inputTextField.textField.becomeFirstResponder()
                            }
                        }
                        break
                    case .verificatio_code:
                        self.verificatio_code()
                        self.itemView.codeBlock = { [weak self] (code) in
                            guard let weakSelf = self else { return }
                            if code.count > 5 {
                                weakSelf.itemView.nextBtn.isEnabled = true
                                weakSelf.tempModel.code_text = code
                            }else{
                                weakSelf.itemView.nextBtn.isEnabled =  false
                            }
                        }
                        self.itemView.codeView.becomeFirstResponder()
                        break
                    case .change_pwd:
                        self.change_pwd()
                        self.itemView.inputTextField.textField.isSecureTextEntry = true
                        self.itemView.inputTextField2.textField.isSecureTextEntry = true
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
//                            self.itemView?.inputTextField?.textField?.becomeFirstResponder()
                            if !self.itemView.inputTextField.textField.isFirstResponder {
                                self.itemView.inputTextField.textField.becomeFirstResponder()
                            }
                        }
                        
                    case .input_nickname:
                        self.input_nickname()
                        self.itemView.inputTextField.textField.becomeFirstResponder()
                        self.itemView.inputTextField.textField.isSecureTextEntry = false
                        self.itemView.inputTextField2.textField.isSecureTextEntry = false
                        break
                    case .resetVerificatio_code:
                        self.resetVerificatio_code()
                        self.itemView.codeBlock = { [weak self] (code) in
                            guard let weakSelf = self else { return }
                            if code.count > 5 {
                                weakSelf.itemView.nextBtn.isEnabled = true
                                weakSelf.tempModel.code_text = code
                            }else{
                                weakSelf.itemView.nextBtn.isEnabled =  false
                            }
                        }
                        self.itemView.codeView.becomeFirstResponder()
                        break
                        
                    }
//                 UIView.animate(withDuration: TimeInterval()+0.25, animations: {
//                    self.itemView?.layoutIfNeeded()
//                })
                
            }
        }
    }
 
      ///测试
    fileprivate  var isTest:Bool = false
     /// 用于保存临时数据
    fileprivate  var tempModel = BindTempModel()
    /// 获取用户邮箱
    fileprivate var user_email:String {
        return MQIUserManager.shared.user?.isNewEmail ?? ""
    }
   
    
    func isRefresh(_ refresh:Bool) {
        if refresh {
            itemView.nextBtn.isSelected = true
            tempModel.refresh_img_name = "Bind_refresh_img"
//            MQILoadManager.shared.makeToast(kLocalized("Is_sending", describeStr: "正在发送"))
            itemView.nextBtn.setImage(UIImage(named: tempModel.refresh_img_name), for: .normal)
            itemView.nextBtn.setTitle("  "+kLocalized("Next_step", describeStr: "正在发送"), for: .normal)
             itemView.isShowRefreshAnimation = true
        }else{
            itemView.nextBtn.isSelected = false
            itemView.isShowRefreshAnimation = false
            itemView.nextBtn.setTitle(tempModel.nextBtn_title, for: .normal)
            itemView.nextBtn.setImage(nil, for: .normal)
        }
    }
    
    func isResend() {
       itemView.nextBtn.setTitle("   "+kLocalized("Resend_code", describeStr: "重新发送") , for: .normal)
    }
    
}



//MARK:   操作方法
extension MQIBindOperation {
    
    /// 邮箱验证
    func validateEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with:email)
    }
    
    /// 下一步
    @objc  func clickNextBtn(_ btn:UIButton) {
        if btn.isSelected {return}
        editorFunc()
    }
    /// 其他按钮 例：忘记密码
    @objc  func clickOtherBtn(_ btn:UIButton) {
        self.itemView.codeView.resignFirstResponder()
        self.itemView.inputTextField.textField.resignFirstResponder()
        self.itemView.inputTextField2.textField.resignFirstResponder()
        if currentPageType  == .verificatio_code ||  currentPageType  ==  .resetVerificatio_code{
            /// 重新发送邮件验证码
            isRefresh(true)
            send_email(tempModel.email, send_type: tempModel.send_type) {[weak self] (suc, msg) in
                guard let weakSelf = self else { return }
                weakSelf.isRefresh(false)
                if suc {
                    
                }else{
                    weakSelf.isResend()
                }
//                MQILoadManager.shared.makeToast(msg)
                MQILoadManager.shared.dismissProgressHUD()
            }
            
        }
        else  if currentPageType == .change_pwd { /// 忘记密码
          
            isRefresh(true)
            tempModel.send_type = "retrieve_pass"
            
            
            
            /// 忘记密码
            tempModel.default()
            tempModel.nav_title = kLocalized("Reset_password", describeStr: "重置密码")
            tempModel.icon_name = "Bind_Email_img"
            tempModel.title_text  =  kLongLocalized("The_verification_code_has_bee_sent_to_your_email", replace: tempModel.email,describeStr:"验证码已发送至您的邮箱")
            tempModel.otherBtn_title = NSAttributedString(string:        kLocalized("Resend_code", describeStr: "重新发送"), attributes: [NSAttributedString.Key.foregroundColor : UIColor.colorWithHexString("#7187FF"),.underlineStyle:NSUnderlineStyle.single.rawValue])
            tempModel.nextBtn_title = kLocalized("Next_step", describeStr: "下一步")
            currentPageType = .resetVerificatio_code
            send_email(tempModel.email, send_type: tempModel.send_type) {[weak self] (suc, msg) in
                if !suc {
                    MQILoadManager.shared.makeToast(msg)
                }
            }
            
            
//            send_email(tempModel.email, send_type: tempModel.send_type) {[weak self] (suc, msg) in
//                guard let weakSelf = self else { return }
//                weakSelf.isRefresh(false)
//                if suc {
//                    /// 忘记密码
//                    weakSelf.tempModel.default()
//                    weakSelf.tempModel.nav_title = kLocalized("Reset_password", describeStr: "重置密码")
//                    weakSelf.tempModel.icon_name = "Bind_Email_img"
//                    weakSelf.tempModel.title_text  =  kLongLocalized("The_verification_code_has_bee_sent_to_your_email", replace: weakSelf.tempModel.email,describeStr:"验证码已发送至您的邮箱")
//                     weakSelf.tempModel.otherBtn_title = NSAttributedString(string:        kLocalized("Resend_code", describeStr: "重新发送"), attributes: [NSAttributedString.Key.foregroundColor : UIColor.colorWithHexString("#7187FF"),.underlineStyle:NSUnderlineStyle.NSUnderlineStyle.single.rawValue])
//                     weakSelf.tempModel.nextBtn_title = kLocalized("Next_step", describeStr: "下一步")
//                     weakSelf.currentPageType = .resetVerificatio_code
//                }else{
//                    weakSelf.isResend()
//                }
            
//                MQILoadManager.shared.makeToast(msg)
//                MQILoadManager.shared.dismissProgressHUD()
//            }
        }

    }
    
    
    func editorFunc() {
     self.itemView.codeView.resignFirstResponder()
     self.itemView.inputTextField.textField.resignFirstResponder()
     self.itemView.inputTextField2.textField.resignFirstResponder()
        
        switch type {
        case .login? ,.reset_Pwd?:
            switch currentPageType {
            case .check_email:
                if let  text = itemView.inputTextField.text {
                    if !validateEmail(email: text) {
                        MQILoadManager.shared.makeToast("输入邮箱不正确")
                    }else{
                        tempModel.email = text
                        loginToEmail()
                    }
                }else{
                    MQILoadManager.shared.makeToast("请输入邮箱账号")
                }
                break
            case .verificatio_code:
                guard  tempModel.code_text.count > 5 else {MQILoadManager.shared.makeToast("验证码不正确")  ;return}
                isRefresh(true)
                check_email_code(tempModel.email, email_code: tempModel.code_text, send_type: tempModel.send_type ) {[weak self]  (suc, msg) in
                    guard let weakSelf = self else { return }
                      weakSelf.isRefresh(false)
                    if suc {
                        weakSelf.tempModel.default()
                        weakSelf.tempModel.inputText_1_placeholder = kLocalized("Please_set_your_nickname", describeStr: "请设置您的昵称")
                        weakSelf.tempModel.inputText_2_placeholder =  kLocalized("Please_set_your_password", describeStr: "请设置您的密码")
                        weakSelf.tempModel.inputText_2_rightBtn_img = "Bind_yj_img_sel"
                        weakSelf.tempModel.inputText_2_rightBtn_img_sel = "Bind_yj_img_no"
                        weakSelf.tempModel.nextBtn_title = kLocalized("Complete_registration", describeStr: "完成注册")
                        weakSelf.currentPageType = .input_nickname
                    }else{
                        MQILoadManager.shared.makeToast(msg)
                    }
                }

                break
                
            case .change_pwd:
                isRefresh(true)
                /// 登录
                email_login(tempModel.email, password: tempModel.pwd) { [weak self] (suc, msg) in
                    guard let weakSelf = self else { return }
                     weakSelf.isRefresh(false)
                    MQILoadManager.shared.dismissProgressHUD()
                    if !suc {
                        MQILoadManager.shared.makeToast(msg)
                    }else{
                        weakSelf.loginSuccess?()
                    }
                    
                }

                break
                
            case .input_nickname:
                  isRefresh(true)
                register_email(tempModel.email, password: tempModel.pwd, nickname: tempModel.nickname) {[weak self] (suc, msg) in
                    MQILoadManager.shared.dismissProgressHUD()
                      self?.isRefresh(false)
                    if !suc {
                        MQILoadManager.shared.makeToast(msg)
                    }else{
                        self?.loginSuccess?()
                    }
                    
                }
                
                break
            case .resetVerificatio_code:
                isRefresh(true)
                let completion: ((_ success:Bool  ,_ str:String)->()) = { [weak self] (suc, msg) in
                    self?.isRefresh(false)
                    if suc {
                        self?.tempModel.default()
                        self?.tempModel.nav_title = kLocalized("Change_password", describeStr: "修改密码")
                        self?.tempModel.title_text =     kLocalized("Please_set_your_password_so_that_you_can_log_in_using_emai", describeStr: "请设置您的密码，以便使用邮箱登录")
                        self?.tempModel.inputText_1_placeholder =
                            kLocalized("Please_enter_a_new_password", describeStr: "请输入新密码")
                        self?.tempModel.inputText_2_placeholder =
                            kLocalized("Please_enter_a_new_password_again", describeStr: "请再输入一次新密码")
//                        self?.tempModel.inputText_1_rightBtn_img = "Bind_yj_img_no"
//                        self?.tempModel.inputText_2_rightBtn_img = "Bind_yj_img_no"
//                        self?.tempModel.inputText_1_rightBtn_img_sel = "Bind_yj_img_sel"
//                        self?.tempModel.inputText_2_rightBtn_img_sel = "Bind_yj_img_sel"
                        
                        self?.tempModel.nextBtn_title = kLocalized("determine", describeStr: "确定")
                        self?.currentPageType = .check_pwd
                    } else {
                        MQILoadManager.shared.makeToast(msg)
                    }
                }
                if MQIUserManager.shared.checkIsLogin() {
                    check_email_code_login(tempModel.email, email_code: tempModel.code_text, send_type: tempModel.send_type, completion: completion)
                } else {
                    check_email_code(tempModel.email, email_code: tempModel.code_text, send_type: tempModel.send_type, completion: completion)
                }
                break
                
                
            case .check_pwd:
                if itemView.inputTextField.textField.text != itemView.inputTextField2.textField.text {
                    MQILoadManager.shared.makeToast("温馨提示，您两次输入的密码不一致")
                    return
                } else {
                    tempModel.pwd = itemView.inputTextField.textField.text ?? ""
                }
                isRefresh(true)
                email_set_pass(tempModel.email, password: tempModel.pwd, email_code: tempModel.code_text, send_type:tempModel.send_type) {[weak self](suc, msg) in
                    guard let weakSelf = self else { return }
                    MQILoadManager.shared.dismissProgressHUD()
                     weakSelf.isRefresh(false)
                    if !suc {
                        MQILoadManager.shared.makeToast(msg)
                    }else{
                        //// 输入密码成后继续输入密码
                        if weakSelf.type == .login {
                            weakSelf.tempModel.default()
                            //                        weakSelf.tempModel.icon_name = ""
                            weakSelf.tempModel.title_text  =
                                kLongLocalized("You_log_in_using_mailbox", replace: weakSelf.tempModel.email,describeStr:"您使用邮箱")
                            weakSelf.tempModel.inputText_1_placeholder = kLocalized("Please_enter_password", describeStr: "请输入密码")
                            //                        weakSelf.tempModel.inputText_1_rightBtn_img = "Bind_yj_img_no"
                            //                        weakSelf.tempModel.inputText_1_rightBtn_img_sel = "Bind_yj_img_sel"
                            weakSelf.tempModel.nextBtn_title =  kLocalized("TheLogin", describeStr: "登录")
                            weakSelf.tempModel.otherBtn_title = NSAttributedString(string:  kLocalized("Forget_password", describeStr: "忘记密码"), attributes: [NSAttributedString.Key.foregroundColor : UIColor.colorWithHexString("#7187FF")])
                            weakSelf.currentPageType = .change_pwd
                        } else {
                            weakSelf.loginSuccess?()
                        }

                    }
                    
                }
                
                break
            }
            
            break
        case .change_email?,.bind_email?:
            
            switch currentPageType {
            case .change_pwd:
                isRefresh(true)
                 /// 验证密码
                password_check(tempModel.pwd) { [weak self]  (suc, msg) in
                    guard let weakSelf = self else { return }
                   weakSelf.isRefresh(false)
                    if !suc {
                        MQILoadManager.shared.makeToast(msg)
                    }else{
                        weakSelf.tempModel.default()
                        weakSelf.tempModel.icon_name = "Bind_Email_img"
                        weakSelf.tempModel.inputText_1_placeholder = kLocalized("Please_enter_new_email_address", describeStr: "请输入新邮箱")
                        weakSelf.tempModel.inputText_1_is_Clean = true
                        weakSelf.tempModel.inputText_1_rightBtn_img = "Bind_sc_img"
                        weakSelf.tempModel.nextBtn_title = kLocalized("Send_verification_code", describeStr: "发送验证码")
                        weakSelf.itemView.nextBtn.isEnabled = false
                        weakSelf.currentPageType = .check_email
                        
                    }
                    
                }
                 break
            case .check_email:
                 isRefresh(true)
                send_email_login(tempModel.email, send_type: tempModel.send_type,code: tempModel.reset_codel) { [weak self] (suc, msg) in
                    guard let weakSelf = self else { return }
                    MQILoadManager.shared.dismissProgressHUD()
                    weakSelf.itemView.nextBtn.isSelected = false
                      weakSelf.isRefresh(false)
                    if suc {
                        weakSelf.tempModel.default()
                        weakSelf.tempModel.nav_title = kLocalized("Please_enter_the_verification_code", describeStr: "请输入验证码")
                        weakSelf.tempModel.title_text  = kLongLocalized("The_verification_code_has_bee_sent_to_your_email", replace: weakSelf.tempModel.email,describeStr:"验证码已发送至您的邮箱")
                        weakSelf.tempModel.otherBtn_title = NSAttributedString(string:        kLocalized("Resend_code", describeStr: "重新发送"), attributes: [NSAttributedString.Key.foregroundColor : UIColor.colorWithHexString("#7187FF"),.underlineStyle:NSUnderlineStyle.single.rawValue])
                        weakSelf.tempModel.nextBtn_title = kLocalized("determine", describeStr: "确定")
                        weakSelf.currentPageType = .verificatio_code
                    }else{
                        weakSelf.isResend()
                        MQILoadManager.shared.makeToast(msg)
                    }
                    
                }
                break
            case .verificatio_code:
                isRefresh(true)
                let completion: ((_ success:Bool  ,_ str:String)->()) = { [weak self] (suc, msg) in
                    guard let weakSelf = self else { return }
                    MQILoadManager.shared.dismissProgressHUD()
                    weakSelf.isRefresh(false)
                    if suc {
                        if  weakSelf.type == .bind_email {
                            weakSelf.tempModel.default()
                            weakSelf.tempModel.nav_title = kLocalized("Set_password", describeStr: "设置密码")
                            weakSelf.tempModel.title_text = kLocalized("Please_set_your_password_so_that_you_can_log_in_using_emai", describeStr: "请设置您的密码，以便使用邮箱登录")
                            weakSelf.tempModel.inputText_1_placeholder =     kLocalized("Please_enter_a_new_password", describeStr: "请输入新密码")
                            weakSelf.tempModel.inputText_2_placeholder =        kLocalized("Please_enter_a_new_password_again", describeStr: "请再输入一次新密码")
//                            weakSelf.tempModel.inputText_1_rightBtn_img = "Bind_yj_img_no"
//                            weakSelf.tempModel.inputText_2_rightBtn_img = "Bind_yj_img_no"
//                            weakSelf.tempModel.inputText_2_rightBtn_img_sel = "Bind_yj_img_no"
//                            weakSelf.tempModel.inputText_1_rightBtn_img_sel = "Bind_yj_img_sel"
//                            weakSelf.tempModel.nextBtn_title = kLocalized("determine", describeStr: "确定")
                            weakSelf.currentPageType = .check_pwd
                            return
                        }
                        MQIUserManager.shared.user?.user_email = weakSelf.tempModel.email
                        MQIUserManager.shared.saveUser()
                        weakSelf.loginSuccess?()
//                        MQILoadManager.shared.makeToast(kLocalized("The_bound_mailbox_has_been_changed_successfully", describeStr: "已成功更改绑定邮箱！"))
                    }else{
                        MQILoadManager.shared.makeToast(msg)
                    }
                }
                
                if MQIUserManager.shared.checkIsLogin() {
                    check_email_code_login(tempModel.email, email_code: tempModel.code_text, send_type: tempModel.send_type, completion: completion)
                } else {
                    check_email_code(tempModel.email, email_code: tempModel.code_text, send_type: tempModel.send_type, completion: completion)
                }
                break
            case .check_pwd:
                if itemView.inputTextField.textField.text != itemView.inputTextField2.textField.text {
                    MQILoadManager.shared.makeToast("温馨提示，您两次输入的密码不一致")//addProgressHUD("温馨提示，您两次输入的密码不一致")
                    return
                } else {
                    tempModel.pwd = itemView.inputTextField.textField.text ?? ""
                }
                isRefresh(true)
                email_set_pass(tempModel.email, password: tempModel.pwd, email_code: tempModel.code_text, send_type:tempModel.send_type) {[weak self](suc, msg) in
                    guard let weakSelf = self else { return }
                    weakSelf.isRefresh(false)
                    MQILoadManager.shared.dismissProgressHUD()
                    if !suc {
                        weakSelf.isResend()
                        MQILoadManager.shared.makeToast(msg)
                    }else{
                        ///设置密码完成
                        MQIUserManager.shared.user?.user_email = weakSelf.tempModel.email
                        MQIUserManager.shared.saveUser()
                        weakSelf.itemView.nextBtn.setImage(nil, for: .normal)
                        weakSelf.loginSuccess?()
                    }
                    
                }
                break
            case .resetVerificatio_code:
                isRefresh(true)
                check_email_code_login(tempModel.email, email_code: tempModel.code_text, send_type: tempModel.send_type) { [weak self] (suc, msg) in
                    self?.isRefresh(false)
                    if suc {
                        self?.tempModel.default()
                        self?.tempModel.nav_title = kLocalized("Change_password", describeStr: "修改密码")
                        self?.tempModel.title_text =     kLocalized("Please_set_your_password_so_that_you_can_log_in_using_emai", describeStr: "请设置您的密码，以便使用邮箱登录")
                        self?.tempModel.inputText_1_placeholder =
                            kLocalized("Please_enter_a_new_password", describeStr: "请输入新密码")
                        self?.tempModel.inputText_2_placeholder =
                            kLocalized("Please_enter_a_new_password_again", describeStr: "请再输入一次新密码")
//                        self?.tempModel.inputText_1_rightBtn_img = "Bind_yj_img_no"
//                        self?.tempModel.inputText_2_rightBtn_img = "Bind_yj_img_no"
//                        self?.tempModel.inputText_1_rightBtn_img_sel = "Bind_yj_img_sel"
//                        self?.tempModel.inputText_2_rightBtn_img_sel = "Bind_yj_img_sel"
                        
                        self?.tempModel.nextBtn_title = kLocalized("determine", describeStr: "确定")
                        self?.currentPageType = .check_pwd
                    } else {
                        MQILoadManager.shared.makeToast(msg)
                    }
                }
                break
                
        
            default:
                return
            }
            
           break
        default:
            return
        }
        
}
    
   
        
    /// 邮箱登录
    func loginToEmail(){
        guard  tempModel.email.count > 0 else {return}
            isRefresh(true)
            check_email(tempModel.email) {[weak self](msg) in
                guard let weakSelf = self else { return }
                MQILoadManager.shared.dismissProgressHUD()
                weakSelf.isRefresh(false)
                if let msg  = msg {
                    if msg.count > 0 {
                        MQILoadManager.shared.makeToast(msg)
                    }else{
//                        weakSelf.isRefresh(true)
//                        weakSelf.send_email(weakSelf.tempModel.email, send_type: weakSelf.tempModel.send_type, completion: { (suc, msg) in
//                            MQILoadManager.shared.dismissProgressHUD()
//                             weakSelf.isRefresh(false)
//                            if suc {
                                /// 注册
                                weakSelf.tempModel.default()
                                 weakSelf.tempModel.nav_title = kLocalized("Email_registration", describeStr: "邮箱注册")
                                weakSelf.tempModel.title_text1  = kLocalized("Your_email_address_is_not_registered_yet", describeStr: "您的邮箱尚未注册")
                                 weakSelf.tempModel.title_text  = kLongLocalized("We_have_sent_a_registration_verification_email_to_your_emai_address_yet", replace: weakSelf.tempModel.email)
//                                "我们已向已您的邮箱\(weakSelf.tempModel.email)，发送注册验证邮件，请注意查收"
                        weakSelf.tempModel.otherBtn_title = NSAttributedString(string:        kLocalized("Resend_code", describeStr: "重新发送"), attributes: [NSAttributedString.Key.foregroundColor : UIColor.colorWithHexString("#7187FF"),.underlineStyle:NSUnderlineStyle.single.rawValue])
                                weakSelf.tempModel.nextBtn_title = kLocalized("Next_step", describeStr: "下一步")
                                weakSelf.currentPageType = .verificatio_code
//
//                            }else{
//                              MQILoadManager.shared.makeToast(msg)
//                            }
//                        })
//
                    }
                }else{ ///成功
                    //// 输入密码
                     weakSelf.tempModel.default()
                     weakSelf.tempModel.icon_name = "Bind_Email_img"
                     weakSelf.tempModel.title_text  =   kLongLocalized("You_log_in_using_mailbox", replace: weakSelf.tempModel.email,describeStr:"您使用邮箱")
                     weakSelf.tempModel.inputText_1_placeholder = kLocalized("Please_enter_password", describeStr: "请输入密码")
                     weakSelf.tempModel.inputText_1_rightBtn_img = "Bind_yj_img_sel"
                     weakSelf.tempModel.inputText_1_rightBtn_img_sel = "Bind_yj_img_no"
                     weakSelf.tempModel.nextBtn_title =   kLocalized("TheLogin", describeStr: "登录")
                     weakSelf.tempModel.otherBtn_title = NSAttributedString(string:  kLocalized("Forget_password", describeStr: "忘记密码"), attributes: [NSAttributedString.Key.foregroundColor : UIColor.colorWithHexString("#7187FF")])
                     weakSelf.currentPageType = .change_pwd
                }
            }
        
    }
    

}


//MARK:  UITextFieldDelegate
extension  MQIBindOperation:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        editorFunc()
        return  textField.resignFirstResponder()
    }
    
    
    @objc func inputTextFunc(sender:UITextField)  {
        guard let text =  sender.text else {
            (sender.superview as! MQIBindInputView).setSelectedView()
            return }
        (sender.superview as! MQIBindInputView).setSelectedView(text.count > 0)
        if currentPageType == .check_email {
            if sender == itemView.inputTextField.textField {
                if !validateEmail(email: text) {
                    itemView.nextBtn.isEnabled = false
                }else{
                    itemView.nextBtn.isEnabled = true
                    tempModel.email =  text
                }
            }
        }
        else if  currentPageType ==  .change_pwd {
            if text.count  > 5 {
                itemView.nextBtn.isEnabled = true
                if sender == itemView.inputTextField.textField {
                    tempModel.pwd = text
                }
            }else{
                itemView.nextBtn.isEnabled =  false
            }
            
            
        }
            
        else if currentPageType == .input_nickname {
            if sender == itemView.inputTextField.textField {
                tempModel.nickname = text
            }
            
            if sender == itemView.inputTextField2.textField {
                tempModel.pwd = text
            }
            
            if tempModel.pwd.count > 5 && tempModel.pwd.count < 19  && (tempModel.nickname.count > 0 && tempModel.nickname.count <= 16) {
                itemView.nextBtn.isEnabled = true
            }else{
                itemView.nextBtn.isEnabled = false
            }
            
        }
            
        else if currentPageType == .check_pwd {
            if text.count < 6 {
                itemView.nextBtn.isEnabled =  false
                return
            } else if text.count > 18 {
                sender.text = text.substring(NSRange(location: 0, length: 18))
            }
            itemView.nextBtn.isEnabled = true
//
//            if sender == itemView.inputTextField.textField {
//                tempModel.pwd = text
//            }
//
//            if sender == itemView.inputTextField2.textField {
//                tempModel.pwd2 = text
//            }
//
//            if tempModel.pwd.count > 5 && tempModel.pwd.count < 19  && tempModel.pwd2.count > 5 && tempModel.pwd2.count < 19 &&  tempModel.pwd == tempModel.pwd2 {
//                itemView.nextBtn.isEnabled = true
//            }else{
//                itemView.nextBtn.isEnabled = false
//            }
            
        }
    }
    
    
    
    
}


//MARK:  API
extension MQIBindOperation {
    ///检查账号是否被注册
    func check_email(_ email:String,completion:((_ str:String?)->())?)  {
        if isTest {  completion?(nil) ;return}
        MQIuser_check_email(email: email)
            .request({ (_, _, result:MQIResultaDataModel) in
                if result.exists == "1" {
                    completion?(nil)
                }else{
                    completion?("")
                }
            })  {(errorMsg, errorCode) in
                completion?(errorMsg)
        }
    }
    
    ///发送邮件验证码
    func send_email(_ email:String,send_type:String,completion:((_ success:Bool  ,_ str:String)->())?)  {
        if isTest {  completion?(true, "");return}
        MQIuser_send_email(email: email, send_type: send_type)
            .request({ (_, _, result:MQIResultaDataModel) in
                if result.code == "200" {
                    completion?(true, result.desc)
                }else{
                    completion?(false, result.desc)
                }
            })  {(errorMsg, errorCode) in
                completion?(false,errorMsg)
        }
    }
    
    ///发送邮件验证码 登录
    func send_email_login(_ email:String,send_type:String,code:String,completion:((_ success:Bool  ,_ str:String)->())?)  {
        if isTest {   completion?(true, "");return}
        MQIuser_send_email_login(email: email, send_type: send_type, code: code)
            .request({ (_, _, result:MQIResultaDataModel) in
                if result.code == "200" {
                    completion?(true, result.desc)
                }else{
                    completion?(false, result.desc)
                }
            })  {(errorMsg, errorCode) in
                completion?(false,errorMsg)
        }
    }
    

    ///用户.邮箱验证
    func check_email_code(_ email:String,email_code:String,send_type:String,completion:((_ success:Bool  ,_ str:String)->())?)  {
        //
        if isTest {    completion?(true, "");return}
        MQIuser_check_emailcodenRequest(email: email, email_code: email_code,send_type:send_type)
            .request({ (_, _, result:MQIResultaDataModel) in
                if result.code == "200" {
                    completion?(true, result.desc)
                }else{
                    completion?(false, result.desc)
                }
            })  {(errorMsg, errorCode) in
                completion?(false,errorMsg)
        }
    }
    ///用户.邮箱验证
    func check_email_code_login(_ email:String,email_code:String,send_type:String,completion:((_ success:Bool  ,_ str:String)->())?)  {
        
        if isTest { completion?(true, "");return}
        MQIuser_check_emailcode_loginRequest(email: email, email_code: email_code,send_type:send_type)
            .request({ (_, _, result:MQIResultaDataModel) in
                if result.code == "200" {
                    
                    completion?(true, result.desc)
                }else{
                    completion?(false, result.desc)
                }
            })  {(errorMsg, errorCode) in
                completion?(false,errorMsg)
        }
    }
    
    
    ///用户.邮箱注册
    func register_email(_ email:String,password:String,nickname:String,completion:((_ success:Bool  ,_ str:String)->())?)  {
        if isTest { completion?(true, "");return}
        MQIuser_email_registerRequest(email: email, Pwd: password,nickname:nickname)
            .request({(_, _, result:MQIResultaDataModel) in
                paseUserObject(result)
                MQIUserManager.shared.user?.user_email_verify = "1"
                MQIUserManager.shared.saveUser()
                MQIUserManager.shared.updateUserState(checkedIn: 1, lastLoginType: LoginType.Email.rawValue)
                UserNotifier.postNotification(.login_in)
                completion?(true, "")
            })  {(errorMsg, errorCode) in
                completion?(false,errorMsg)
        }
    }
    
    
    //MARK:  登录以后操作 =--------
    ///用户.登录
    func email_login(_ email:String,password:String,completion:((_ success:Bool  ,_ str:String)->())?)  {
        if isTest { completion?(true, "");return}
        MQIuser_email_loginRequest(email: email, Pwd: password)
            .request({(_, _, result:MQIResultaDataModel) in
                paseUserObject(result)
                MQIUserManager.shared.saveUser()
                MQIUserManager.shared.updateUserState(checkedIn: 1, lastLoginType: LoginType.Email.rawValue)
                UserNotifier.postNotification(.login_in)
                completion?(true, "")
            })  {(errorMsg, errorCode) in
                completion?(false,errorMsg)
        }
    }
    
    
    ///用户.重置密码
    func email_set_pass(_ email:String,password:String,email_code:String,send_type:String,completion:((_ success:Bool  ,_ str:String)->())?)  {
        if isTest { completion?(true, "");return}
        MQIuser_email_set_pass(email: email, Pwd: password, email_code: email_code, send_type: send_type)
            .request({(_, _, result:MQIResultaDataModel) in
                paseUserObject(result)
                MQIUserManager.shared.user?.user_email_verify = "1"
                MQIUserManager.shared.saveUser()
                MQIUserManager.shared.updateUserState(checkedIn: 1, lastLoginType: LoginType.Email.rawValue)
                UserNotifier.postNotification(.login_in)
                completion?(true, "")
            })  {(errorMsg, errorCode) in
                completion?(false,errorMsg)
        }
    }
    ///用户.密码验证身份
    func password_check(_ password:String,completion:((_ success:Bool  ,_ str:String)->())?)  {
        if isTest {  completion?(true, "");return}
        MQIuser_password_check( password: password)
            .request({[weak self](_, _, result:MQIResultaDataModel) in
                self?.tempModel.reset_codel = result.code
                completion?(true, "")
            })  {(errorMsg, errorCode) in
                completion?(false,errorMsg)
        }
    }
    
    
}




//MARK:  设置UI
private extension MQIBindOperation {
    
      func defaultUI()  {
        itemView.defaultUIHidden()
        itemView.titleLable.textAlignment = .center
        itemView.titleLable1.textAlignment = .center
        itemView.inputTextField.text = tempModel.inputText_1
        itemView.inputTextField2.text = tempModel.inputText_2
        itemView.titleLable.text = tempModel.title_text
        itemView.titleLable1.text = tempModel.title_text1
        itemView.inputTextField.placeholder = tempModel.inputText_1_placeholder
        itemView.inputTextField2.placeholder = tempModel.inputText_2_placeholder
        itemView.nextBtn.setTitle(tempModel.nextBtn_title, for: .normal)
        itemView.otherBtn.setAttributedTitle(tempModel.otherBtn_title, for: .normal)
        itemView.icon.image = UIImage(named: tempModel.icon_name)
        
        if let image1 = UIImage(named: tempModel.inputText_1_rightBtn_img) {
           itemView.inputTextField.rightBtn.setImage(image1, for: .normal)
             itemView.inputTextField.rightBtn.setImage(UIImage(named: tempModel.inputText_1_rightBtn_img_sel), for: .selected)
            itemView.inputTextField.rightBtn.isEnabled = true
            if !tempModel.inputText_1_is_Clean {
               itemView.inputTextField.textField.isSecureTextEntry = true
            }
           
        }
        if let image2 = UIImage(named: tempModel.inputText_2_rightBtn_img) {
            itemView.inputTextField2.rightBtn.setImage(image2, for: .normal)
            itemView.inputTextField2.rightBtn.setImage(UIImage(named: tempModel.inputText_2_rightBtn_img_sel), for: .selected)
            itemView.inputTextField2.rightBtn.isEnabled = true
            if !tempModel.inputText_2_is_Clean {
                 itemView.inputTextField2.textField.isSecureTextEntry = true
            }
          
        }
         itemView.inputTextField.is_Clean = tempModel.inputText_1_is_Clean
         itemView.inputTextField2.is_Clean = tempModel.inputText_2_is_Clean
        itemView.nextBtn.setImage(nil, for: .normal)
        itemView.isShowRefreshAnimation = false
        changeTitle?(tempModel.nav_title)
        
       }
    
      func check_email() {
        defaultUI()
        itemView.icon.isHidden = false
        
        itemView.icon.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(34)
//            make.height.equalTo(74)
//            make.width.equalTo(68)
            make.centerX.equalToSuperview()
        }
        itemView.inputTextField.isHidden = false
        itemView.inputTextField.snp.remakeConstraints { (make) in
            make.top.equalTo(itemView.icon.snp.bottom).offset(68)
            make.height.equalTo(30)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        itemView.nextBtn.isHidden = false
        itemView.nextBtn.tag = 101
        itemView.nextBtn.dsySetCorner(radius: 20)
        itemView.nextBtn.snp.remakeConstraints { (make) in
            make.top.equalTo( itemView.inputTextField.snp.bottom).offset(31)
            make.height.equalTo(40)
            make.width.equalTo(249)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
    }
    
      func verificatio_code() {
        defaultUI()
     
        if type  == .login {
            itemView.titleLable1.isHidden = false
            itemView.titleLable1.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().offset(22)
                make.left.equalToSuperview().offset(55)
                make.right.equalToSuperview().offset(-55)
            }
        }
        
        itemView.titleLable.isHidden = false
        let  isTop = itemView.titleLable1.isHidden
        itemView.titleLable.snp.remakeConstraints { (make) in
            if isTop {
                make.top.equalToSuperview().offset(24)
            }else{
                make.top.equalTo(itemView.titleLable1.snp.bottom).offset(10)
            }
            make.left.equalToSuperview().offset(55)
            make.right.equalToSuperview().offset(-55)
        }
        itemView.codeView.isHidden = false
        itemView.codeView.snp.remakeConstraints { (make) in
            make.top.equalTo(itemView.titleLable.snp.bottom).offset(49)
            make.height.equalTo(40)
            make.centerX.equalTo( itemView.titleLable)
            make.width.equalTo(249)
        }
        
        itemView.nextBtn.isHidden = false
        itemView.nextBtn.tag = 201
        itemView.nextBtn.dsySetCorner(radius: 20)
        itemView.nextBtn.snp.remakeConstraints { (make) in
            make.top.equalTo( itemView.codeView.snp.bottom).offset(44)
            make.height.equalTo(40)
            make.width.equalTo(249)
            make.centerX.equalToSuperview()
        }
        
        itemView.otherBtn.isHidden = false
        itemView.otherBtn.tag = 202
        itemView.otherBtn.snp.remakeConstraints { (make) in
            make.top.equalTo( itemView.nextBtn.snp.bottom).offset(24)
            make.height.equalTo(22)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
        
        
    }
    
      func check_pwd() {
        defaultUI()
        itemView.titleLable.isHidden = false
        itemView.titleLable.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        itemView.inputTextField.isHidden = false
        itemView.inputTextField.snp.remakeConstraints { (make) in
            make.top.equalTo(itemView.titleLable.snp.bottom).offset(49)
            make.height.equalTo(30)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        itemView.inputTextField2.isHidden = false
        itemView.inputTextField2.snp.remakeConstraints { (make) in
            make.top.equalTo(itemView.inputTextField.snp.bottom).offset(35)
            make.height.equalTo(30)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        itemView.nextBtn.isHidden = false
        itemView.nextBtn.tag = 301
        itemView.nextBtn.dsySetCorner(radius: 20)
        itemView.nextBtn.snp.remakeConstraints { (make) in
            make.top.equalTo( itemView.inputTextField2.snp.bottom).offset(90)
            make.height.equalTo(40)
            make.width.equalTo(249)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
        
    }
    
      func change_pwd() {
        defaultUI()
        itemView.icon.isHidden = false
        itemView.icon.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(34)
            make.height.equalTo(74)
            make.width.equalTo(68)
            make.centerX.equalToSuperview()
        }
        itemView.titleLable.isHidden = false
        itemView.titleLable.snp.remakeConstraints { (make) in
            make.top.equalTo( itemView.icon.snp.bottom).offset(13)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        itemView.inputTextField.isHidden = false
        itemView.inputTextField.snp.remakeConstraints { (make) in
            make.top.equalTo(itemView.icon.snp.bottom).offset(68)
            make.height.equalTo(30)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        itemView.otherBtn.isHidden = false
        itemView.otherBtn.tag = 402
        itemView.otherBtn.snp.remakeConstraints { (make) in
            make.top.equalTo( itemView.inputTextField.snp.bottom).offset(8)
            make.height.equalTo(22)
            make.right.equalTo( itemView.inputTextField)
        }
        
        itemView.nextBtn.isHidden = false
        itemView.nextBtn.tag = 401
        itemView.nextBtn.dsySetCorner(radius: 20)
        itemView.nextBtn.snp.remakeConstraints { (make) in
            make.top.equalTo( itemView.inputTextField.snp.bottom).offset(65)
            make.height.equalTo(40)
            make.width.equalTo(249)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    
    func input_nickname() {
        defaultUI()
        itemView.inputTextField.isHidden = false
        itemView.inputTextField.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(40)
            make.height.equalTo(30)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        itemView.inputTextField2.isHidden = false
        itemView.inputTextField2.snp.remakeConstraints { (make) in
            make.top.equalTo(itemView.inputTextField.snp.bottom).offset(35)
            make.height.equalTo(30)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
    
        itemView.nextBtn.isHidden = false
        itemView.nextBtn.tag = 401
        itemView.nextBtn.dsySetCorner(radius: 20)
        itemView.nextBtn.snp.remakeConstraints { (make) in
            make.top.equalTo( itemView.inputTextField2.snp.bottom).offset(51)
            make.height.equalTo(40)
            make.width.equalTo(249)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
 
    }
    
    func  resetVerificatio_code() {
        defaultUI()
        itemView.icon.isHidden = false
        itemView.icon.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(34)
            //            make.height.equalTo(74)
            //            make.width.equalTo(68)
            make.centerX.equalToSuperview()
        }
        itemView.titleLable.isHidden = false
        itemView.titleLable.snp.remakeConstraints { (make) in
            make.top.equalTo(itemView.icon.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(55)
            make.right.equalToSuperview().offset(-55)
        }
        itemView.codeView.isHidden = false
        itemView.codeView.snp.remakeConstraints { (make) in
            make.top.equalTo(itemView.titleLable.snp.bottom).offset(49)
            make.height.equalTo(40)
            make.centerX.equalTo( itemView.titleLable)
            make.width.equalTo(249)
        }
        
        itemView.nextBtn.isHidden = false
        itemView.nextBtn.tag = 201
        itemView.nextBtn.dsySetCorner(radius: 20)
        itemView.nextBtn.snp.remakeConstraints { (make) in
            make.top.equalTo( itemView.codeView.snp.bottom).offset(44)
            make.height.equalTo(40)
            make.width.equalTo(249)
            make.centerX.equalToSuperview()
        }
        
        itemView.otherBtn.isHidden = false
        itemView.otherBtn.tag = 202
        itemView.otherBtn.snp.remakeConstraints { (make) in
            make.top.equalTo( itemView.nextBtn.snp.bottom).offset(24)
            make.height.equalTo(22)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
        
    }
    
    
}


extension MQIBindOperation {
    
    struct BindTempModel {
        var nav_title:String
        
        var title_text:String
        var title_text1:String
        var otherBtn_title:NSAttributedString
        var nextBtn_title:String
        var inputText_1:String
        var inputText_2:String
        var inputText_1_placeholder:String
        var inputText_2_placeholder:String
        
        var inputText_1_rightBtn_img:String
        var inputText_2_rightBtn_img:String
        var inputText_1_rightBtn_img_sel:String
        var inputText_2_rightBtn_img_sel:String
        
        
        var inputText_1_is_Clean:Bool
        var inputText_2_is_Clean:Bool
        
        var code_text:String
        var icon_name:String
        
        var email:String
        var pwd:String
        var pwd2:String
        var nickname:String
        
        
        var send_type:String
        var reset_codel:String
        
        var refresh_img_name:String
        
        init() {
            nav_title = kLocalized("Email_login", describeStr: "邮箱登录")
            otherBtn_title = NSAttributedString(string:kLocalized("Resend_code", describeStr: "重新发送"), attributes: [NSAttributedString.Key.foregroundColor : UIColor.colorWithHexString("#7187FF"),.underlineStyle:NSUnderlineStyle.single.rawValue])
            nextBtn_title = kLocalized("Next_step", describeStr: "下一步")
            inputText_1_placeholder = kLocalized("Please_ente_email", describeStr: "请输入邮箱")
            inputText_2_placeholder = kLocalized("Please_enter_password", describeStr: "请输入密码")
            title_text1 = ""
            title_text = ""
            inputText_1 = ""
            inputText_2 = ""
            code_text = ""
            icon_name = ""
            email = ""
            pwd = ""
            pwd2 = ""
            nickname = ""
            inputText_1_rightBtn_img = ""
            inputText_2_rightBtn_img = ""
            inputText_1_rightBtn_img_sel = ""
            inputText_2_rightBtn_img_sel = ""
            send_type = ""
            reset_codel = ""
            inputText_2_is_Clean = false
            inputText_1_is_Clean = false
            refresh_img_name = ""
        }
        
        mutating func `default`() {
            inputText_1 = ""
            inputText_2 = ""
            inputText_1_rightBtn_img = ""
            inputText_2_rightBtn_img = ""
            inputText_1_rightBtn_img_sel = ""
            inputText_2_rightBtn_img_sel = ""
            otherBtn_title = NSAttributedString()
            nextBtn_title = ""
            inputText_1_placeholder = ""
            inputText_2_placeholder = ""
            title_text1 = ""
            title_text = ""
            inputText_2_is_Clean = false
            inputText_1_is_Clean = false
            refresh_img_name = ""
        }
    }
    
}


