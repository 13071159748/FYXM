//
//  MQIRegViewController.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIRegViewController: MQIBaseViewController {

    var regView: MQIRegView!
    var completion: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = kLocalized("registered")
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(MQIForgetPsdViewController.handleTap(sender:))))
        regView = MQIRegView.init(frame: CGRect (x: 0, y: nav.height + status.height, width: screenWidth, height: self.view.height - nav.height - status.height))
        self.view.addSubview(regView)
        regView.registerFinish = {[weak self]() -> Void in
            if let strongSelf = self {
                after(0.5, block: {
                    strongSelf.navigationController?.popToRootViewController(animated: true)
                })
            }
        }
        regView.toVC = {[weak self](vc: UIViewController) -> Void in
            if let weakSelf = self {
                weakSelf.pushVC(vc)
            }
        }
        regView.backToLoginBlock = {[weak self]() -> Void in
            if let weakSelf = self {
                weakSelf.popVC()
            }
        }
    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            regView.phoneText.resignFirstResponder()
            regView.codeText.resignFirstResponder()
            regView.passwordText.resignFirstResponder()
            regView.nickText.resignFirstResponder()
            regView.leftImg1.isHidden = false
            regView.leftImg2.isHidden = false
            regView.leftImg3.isHidden = false
            regView.leftImg4.isHidden = false
            regView.phoneText.placeholder = kLocalized("PleaseEnterYourCellPhoneNumber")
            regView.phoneText.frame = CGRect (x: 54 * gdscale, y: regView.phoneText.frame.origin.y, width: 250 * gdscale, height: 30 * hdscale)
            regView.passwordText.placeholder = kLocalized("PleaseEnterYourPassword")
            regView.passwordText.frame = CGRect (x: 54 * gdscale, y: regView.passwordText.frame.origin.y, width: 250 * gdscale, height: 30 * hdscale)
            regView.codeText.placeholder = kLocalized("PleaseEnterTheVerificationCode")
            regView.codeText.frame = CGRect (x: 54 * gdscale, y: regView.codeText.frame.origin.y, width: 250 * gdscale, height: 30 * hdscale)
            regView.nickText.placeholder = kLocalized("PleaseEnterNicknam")
            regView.nickText.frame = CGRect (x: 54 * gdscale, y: regView.nickText.frame.origin.y, width: 250 * gdscale, height: 30 * hdscale)
            regView.removeRedLine()
        }
        sender.cancelsTouchesInView = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        regView.removeRedLine()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
