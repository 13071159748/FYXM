//
//  MQIUserBindPhoneVC.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIUserBindPhoneVC: MQIBaseViewController {

    var userbindView: MQIUserBindPhoneView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = kLocalized("BindingMobilePhone")
        //绑定
        userbindView = MQIUserBindPhoneView(frame: contentView.bounds)
        
        userbindView.completion = {[unowned self]() -> Void in
            self.popVC()
        }
        contentView.addSubview(userbindView)
        
        
    }
    //    override func popVC() {
    //        self.popVC {[weak self] in
    //            if let strongSelf = self {
    //                strongSelf.popBlock?()
    //            }
    //        }
    //    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        MQIRegisterManager.shared.count = 0
        MQIRegisterManager.shared.timer.fireDate = Date.distantFuture
        MQIRegisterManager.shared.allow = true
        MQIRegisterManager.shared.changeEnd?()
        
    }
    deinit {
        mqLog("UserBindVC dealloc")
    }

}
