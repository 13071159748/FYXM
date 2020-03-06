//
//  MQIForgetPsdViewController.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIForgetPsdViewController: MQIBaseViewController {

    var forgetView: MQIForgetPsdView!
    var isChange :Bool = false
    var tit :String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        title = tit
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(MQIForgetPsdViewController.handleTap(sender:))))
        forgetView = MQIForgetPsdView.init(frame: CGRect (x: 0, y: nav.height + status.height, width: screenWidth, height: self.view.height - nav.height - status.height))
        forgetView.isChange = self.isChange
        self.view.addSubview(forgetView)
        forgetView.registerFinish = {[weak self]() -> Void in
            if let weakSelf = self {
                weakSelf.popVC()
            }
        }
    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            forgetView.phoneText.resignFirstResponder()
            forgetView.codeText.resignFirstResponder()
            forgetView.passwordText.resignFirstResponder()
            forgetView.leftImg1.isHidden = false
            forgetView.leftImg2.isHidden = false
            forgetView.leftImg3.isHidden = false
            forgetView.phoneText.placeholder = kLocalized("PleaseEnterYourCellPhoneNumber")
            forgetView.phoneText.frame = CGRect (x: 54 * gdscale, y: forgetView.phoneText.frame.origin.y, width: 250 * gdscale, height: 30 * hdscale)
            forgetView.passwordText.placeholder = kLocalized("PleaseEnterYourPassword")
            forgetView.passwordText.frame = CGRect (x: 54 * gdscale, y: forgetView.passwordText.frame.origin.y, width: 250 * gdscale, height: 30 * hdscale)
            forgetView.codeText.placeholder = kLocalized("PleaseEnterTheVerificationCode")
            forgetView.codeText.frame = CGRect (x: 54 * gdscale, y: forgetView.codeText.frame.origin.y, width: 250 * gdscale, height: 30 * hdscale)
            forgetView.removeRedLine()
        }
        sender.cancelsTouchesInView = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
//        YPRegisterManager.shared.count = 0
//        YPRegisterManager.shared.timer.fireDate = Date.distantFuture
//        YPRegisterManager.shared.allow = true
//        YPRegisterManager.shared.changeEnd?()
        
    }
    deinit {
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        forgetView.removeRedLine()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
