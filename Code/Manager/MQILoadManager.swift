//
//  MQILoadManager.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/6/27.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

import MBProgressHUD
import Toast_Swift
import PSAlertView

enum MQIAlertType {
    case alert
    case custom
}
class MQILoadManager: NSObject {
    fileprivate static var __once: () = {
        Inner.instance = MQILoadManager()
    }()
    
    var progressHUD: MBProgressHUD!
    
    var window: UIWindow!
    var maskView_: UIView!
    var sBlock: (() -> Void)?
    var buttons: NSMutableArray!
    
    override init() {
        super.init()
        buttons = NSMutableArray(capacity: 1)
        
        window = getWindow()
        progressHUD = MBProgressHUD(frame: window.bounds)
        maskView_ = getMaskView(window.bounds)
    }
    
    struct Inner {
        static var token: Int = 0
        static var instance: MQILoadManager?
    }
    
    
    class var shared: MQILoadManager {
        _ = MQILoadManager.__once
        return Inner.instance!
    }
    
    func addProgressHUD(_ message: String) {
        window.addSubview(progressHUD)
        window.bringSubviewToFront(progressHUD)
        progressHUD.label.text = message
        progressHUD.show(animated: true)
    }
    
    
    
    func dismissProgressHUD() {
        progressHUD.hide(animated: true);
        progressHUD.removeFromSuperview()
    }
    
    func addProgressHUDInView(_ view: UIView, message: String) {
        view.addSubview(progressHUD)
        view.bringSubviewToFront(progressHUD)
        progressHUD.label.text = message
        progressHUD.show(animated: true)
    }
    
    func makeToast(_ message: String,duration:TimeInterval = 1.5) {
        window.rootViewController!.view.makeToast(message, duration: duration, position: .center)
    }
    
    func makeToastBottom(_ message: String,duration:TimeInterval = 1.5) {
        window.rootViewController!.view.makeToast(message, duration: duration, position: .bottom)
    }
    
    func makeToastInView(_ view: UIView,message: String) {
        view .makeToast(message, duration: 1.5, position: .center)
    }
    
    func addAlert_oneBtn(_ title: String, msg: String,trueBtnTitle: String = kLocalized("determine"),block: @escaping () -> Void) {
        let alert = PSPDFAlertView(title: title, message: msg)
        alert?.addButton(withTitle: trueBtnTitle, block: { (n) -> Void in
            block()
        })
        alert?.show()
    }
    @discardableResult func addAlert(_ title: String = kLocalized("Warn"), msg: String, trueBtnTitle: String = kLocalized("determine"), type: MQIAlertType = .alert, cancelBtnTitle: String = kLocalized("Cancel"),  block: @escaping (() -> ()), cancelBlock: (() -> Void)? = nil) -> PSPDFAlertView? {
        
//        guard type == .alert else {
//            addPayLoginAlert(msg, sureBlock: {
//                block()
//            }) {
//                cancelBlock?()
//            }
//            addPayLoginAlert(title) {
//                cancelBlock?()
//            }
//            return nil
//        }
//
        let alert = PSPDFAlertView(title: title, message: msg)
        alert!.addButton(withTitle: trueBtnTitle, block: { (n) -> Void in
            block()
        })
        alert?.setCancelButtonWithTitle(cancelBtnTitle, block: { (n) -> Void in
            cancelBlock?()
        })
        alert?.show()
        return alert!
        
    }
    
    var cancelBlock:(()->())?
    //固定大小
    func addPayLoginAlert(_ msg:String ,successBlock:((_ type:LoginType)->())?, cancelBlock:(()->())?){
        self.cancelBlock = nil
        self.cancelBlock = cancelBlock
        window.viewWithTag(73631)?.removeFromSuperview()
        let bacView = UIView(frame: window.bounds)
        bacView.backgroundColor = UIColor.colorWithHexString("#000000", alpha: 0.5)
        bacView.tag = 73631
        window.addSubview(bacView)
        window.bringSubviewToFront(bacView)
        bacView.dsyAddTap(self, action: #selector(dismissLoginAlertView(tap:)))
        
        let alertView = UIView(frame: CGRect (x: 0, y: 0, width: kUIStyle.scale1PXW(278), height: kUIStyle.scale1PXW(264)))
        alertView.center = bacView.center
        alertView.backgroundColor = UIColor.white
        bacView.addSubview(alertView)
        alertView.layer.cornerRadius = 14
        alertView.clipsToBounds = true
        
        let topview = UIImageView(frame: CGRect (x: 0, y: 0, width: kUIStyle.scale1PXW(96), height:  kUIStyle.scale1PXW(96)))
        topview.backgroundColor = mainColor
        bacView.addSubview(topview)
        topview.layer.cornerRadius =  kUIStyle.scale1PXW(48)
        topview.clipsToBounds = true
//        topview.dsySetBorderr(color: UIColor.white, width: 5)
        topview.centerX = bacView.width*0.5
        topview.centerY = alertView.y+10
        topview.image = UIImage(named: "login_top_img")
        
        let messageLabel = UILabel(frame: CGRect (x: 10, y: topview.height*0.5+20, width: alertView.width-20, height: 20))
        messageLabel.textColor = UIColor.colorWithHexString("666666")
        messageLabel.textAlignment = .center
        messageLabel.font = kUIStyle.sysFontDesign1PXSize(size: 16)
        messageLabel.text = kLocalized("One_click_login_start_the_fantasy_reading_journey")
        messageLabel.textAlignment = .center
        alertView.addSubview(messageLabel)
        
        let  facebookBtn = alertView.addCustomButton(CGRect(x: 0, y: 0, width:kUIStyle.scale1PXW(231), height: kUIStyle.scale1PXW(42)), title: kLongLocalized("ToLogin", replace: "Facebook", isFirst: true)) { (btn) in
             btn.superview!.superview?.removeFromSuperview()
            successBlock?(.Facebook)
        }
        facebookBtn.dsySetCorner(radius:  facebookBtn.height*0.5)
        facebookBtn.setTitleColor(UIColor.white, for: .normal)
        facebookBtn.titleLabel?.font = kUIStyle.sysFontDesign1PXSize(size: 15)
        facebookBtn.backgroundColor = UIColor.colorWithHexString("33599E")
        facebookBtn.centerX = alertView.width*0.5
        facebookBtn.y = messageLabel.maxY + kUIStyle.scale1PXW(20)
        
        let  googleBtn = alertView.addCustomButton(CGRect(x: 0, y: 0, width:facebookBtn.width, height: facebookBtn.height), title: kLongLocalized("ToLogin", replace: "Google", isFirst: true)) { (btn) in
             btn.superview!.superview?.removeFromSuperview()
             successBlock?(.Google)
        }
        googleBtn.setTitleColor(UIColor.white, for: .normal)
        googleBtn.titleLabel?.font = kUIStyle.sysFontDesign1PXSize(size: 15)
        googleBtn.dsySetCorner(radius: googleBtn.height*0.5)
        googleBtn.backgroundColor = UIColor.colorWithHexString("F1392C")
        googleBtn.centerX = facebookBtn.centerX
        googleBtn.y = facebookBtn.maxY +  kUIStyle.scale1PXW(20)
        
        
      let  otherBtn = alertView.addCustomButton(CGRect(x: 10, y: 0, width:messageLabel.width, height: 20), title: "") { (btn) in
            btn.superview!.superview?.removeFromSuperview()
            successBlock?(.other)
        }
        
        otherBtn.maxY = alertView.height-15
        otherBtn.titleLabel?.font = kUIStyle.sysFontDesign1PXSize(size: 14)
        otherBtn.setAttributedTitle(NSMutableAttributedString.init(string:kLocalized("Login_by_othe_mean"), attributes: [.underlineStyle:NSUnderlineStyle.single.rawValue,.foregroundColor:mainColor]), for: .normal)

        bacView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            bacView.alpha = 1
        }
        
    }
    
    @objc func dismissLoginAlertView(tap:UITapGestureRecognizer) {
        tap.view?.removeFromSuperview()
          self.cancelBlock?()
    }
  
    
    func showResultsPageView(_ model:MQIResultsPageModel,callbackBlock:((_ book_id:String?,_ linkUrl:String?)->())?)  {
        DispatchQueue.main.async {
            let rView = MQIResultsPageView(frame: UIScreen.main.bounds)
            rView.model = model
            rView.callbackBlock = callbackBlock
            self.window.addSubview(rView)
            
            
        }
    }
}


