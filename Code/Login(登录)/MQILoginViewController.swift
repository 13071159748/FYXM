//
//  MQILoginVC.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit
import GoogleSignIn

class MQILoginViewController: MQIBaseViewController {

    
    typealias MQICallBck = (() -> ())
    var finishBlock: MQICallBck?
    var toRegister: MQICallBck?
    var toForget: MQICallBck?
    var registerFinish: MQICallBck?
    var backToLoginBlock: MQICallBck?
    var isMobile:Bool = false
    var isAudit:Bool = false
    
//    @IBOutlet weak var loginView: MQILoginView!
    var loginView: MQILoginView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{ return .default }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = kLocalized("TheLogin")
        self.fd_interactivePopDisabled = true
        
        if isMobile {
//            buttonView.isHidden = true
            loginView = MQILoginView.init(frame: CGRect (x: 0, y: nav.height + status.height, width: screenWidth, height: self.view.height - nav.height - status.height))
            self.view.addSubview(loginView)
            loginView.isAudit = isAudit
            loginView.loginFinish = {[weak self]() -> Void in
                if let strongSelf = self {
                    after(0.8, block: {() -> Void in
                        strongSelf.popVC(completion: {() -> Void in
                            MQIUserManager.shared.updateUserState(checkedIn: 1, lastLoginType:1000)
                            strongSelf.finishBlock?()
                        })
                    })
                }
            }
            
            if !isAudit {
                loginView.toRegister = {[weak self]() -> Void in
                    if let weakSelf = self {
                        let regisVC = MQIRegViewController()
                        regisVC.completion = { ()->Void in
                            weakSelf.popVC(completion: {
                                weakSelf.finishBlock?()
                            })
                        }
                        weakSelf.pushVC(regisVC)
                    }
                }
                loginView.toForget = {[weak self]() -> Void in
                    if let weakSelf = self {
                        let vc = MQIForgetPsdViewController()
                        vc.tit = kLocalized("ForgetYourPassword")
                        weakSelf.pushVC(vc)
                    }
                }
            }
       
        }else{
//            buttonView.isHidden = false
            nav.alpha = 0
            status.alpha = 0
            MQIloginManager.shared.configLoginSDK(UIApplication.shared)
            configUI()
        }
        

    }
   
    
    
    @IBOutlet weak var nav_view_height: NSLayoutConstraint!
    @IBOutlet weak var nav_title: UILabel!
    func configUI(){
        nav_view_height.constant = nav.height + status.height
        nav_title.text = kLocalized("TheLogin")

        let buttonView = MQILoginFirstView(frame: CGRect (x: 0, y:  nav_view_height.constant, width: screenWidth, height: self.view.height -  nav_view_height.constant))
        buttonView.backgroundColor = UIColor.clear
        self.view.addSubview(buttonView)
        //第三方登录
        buttonView.otherActionBlock = {[weak self](type:LoginType)-> Void in
            if let weakSelf = self {
                if type == .Mobile {
                    let vc = MQILoginViewController.create() as! MQILoginViewController
                    vc.isMobile  = true
                    vc.isAudit = true
                    vc.finishBlock = {() -> Void in
                        MQIUserManager.shared.updateUserState(checkedIn: 1, lastLoginType: type.rawValue)
                        MQIloginManager.shared.type = .Mobile
                        MQIUserManager.shared.saveHistoryLogData()
                        weakSelf.finishBlock?()
                    }
                    weakSelf.pushVC(vc)
                    return
                }
                
                if type == .Email {
                    let  vc = MQIBindEmailViewController()
                     vc.type = .login
                     weakSelf.pushVC(vc)
                    vc.loginSuccess = { [weak self] in
                        guard let weakSelf = self else { return }
                        MQIUserManager.shared.updateUserState(checkedIn: 1, lastLoginType: type.rawValue)
                        MQIloginManager.shared.type = .Email
                        weakSelf.popVC(completion: {() -> Void in
                              weakSelf.finishBlock?()
                        })
                    
                    }
                    return
                }
                MQIloginManager.shared.fromVC = self
                MQIloginManager.shared.loginSuccess = {(success:Bool) -> Void in
                    if success {
                        after(0.5, block: {
                            weakSelf.finishBlock?()
                        })
                    }
        
                }
            MQIloginManager.shared.type = type
            }
        }
        //"服务条款
        buttonView.promptActionBlock = {[weak self](tag:Int)-> Void in
            if let weakSelf = self {
                    if tag == 100 {
                        mqLog("服务条款")
                        let vc = MQIWebVC()
                        vc.url = The_Terms_Of_Service
                        weakSelf.pushVC(vc)
                        
                        }else{
                        mqLog("隐私策略")
                        let vc = MQIWebVC()
                        vc.url = Privacy_Agreement
                        weakSelf.pushVC(vc)
                }
            }
          
        }
        //登录历史
        buttonView.clickloginHistoryActionBlock = {
            
            MQIloginHistoryView.showBouncedView(delegate: self) { (c) in
                
            }
        }

    }
    @IBAction func customBackAction(_ sender:UIButton) {
        backAction()
    }

}
