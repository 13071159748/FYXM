//
//  MQIPhoneLoginViewController.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIPhoneLoginViewController: MQIBaseViewController {

    fileprivate var loginView:MQILoginView!
    var finishBlock: (() -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = kLocalized("TheLogin")
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(MQIPhoneLoginViewController.handleTap(sender:))))
        loginView = MQILoginView.init(frame: CGRect (x: 0, y: nav.height + status.height, width: screenWidth, height: self.view.height - nav.height - status.height))
        self.view.addSubview(loginView)
        loginView.loginFinish = {[weak self]() -> Void in
            if let strongSelf = self {
                after(0.8, block: {() -> Void in
                    strongSelf.popVC(completion: {() -> Void in
                        strongSelf.finishBlock?()
                    })
                })
            }
        }
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
                //                vc.completion = { ()->Void in
                //                        weakSelf.popVC(completion: {
                //                            weakSelf.finishBlock?()
                //                            })
                //                        }
                vc.tit = kLocalized("ForgetYourPassword")
                weakSelf.pushVC(vc)
            }
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            loginView.phoneText.resignFirstResponder()
            loginView.passwordText.resignFirstResponder()
            loginView.leftImg1.isHidden = false
            loginView.leftImg2.isHidden = false
            loginView.phoneText.placeholder = kLocalized("PleaseEnterYourCellPhoneNumber")
            loginView.phoneText.frame = CGRect (x: 54 * gdscale, y: loginView.phoneText.frame.origin.y, width: 250 * gdscale, height: 30 * hdscale)
            loginView.passwordText.placeholder = kLocalized("PleaseEnterYourPassword")
            loginView.passwordText.frame = CGRect (x: 54 * gdscale, y: loginView.passwordText.frame.origin.y, width: 250 * gdscale, height: 30 * hdscale)
            loginView.removeRedLine()
        }
        sender.cancelsTouchesInView = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        loginView.removeRedLine()
    }
    deinit {
        
    }


}
