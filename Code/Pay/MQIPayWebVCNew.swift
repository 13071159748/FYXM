//
//  MQIPayWebVCNew.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/9.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//
                                   
import UIKit

let MQIPayVC_left: CGFloat = 10
class MQIPayWebVCNew:  MQIWebVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pay_RequestCoupons()
    }
    
    func pay_RequestCoupons() {
        MQICouponManager.shared.payRootConfig {[weak self]()->Void in
            if let weakSelf = self {
                weakSelf.webView.reload()
            }
        }
    }
    deinit{
        mqLog("我销毁啦")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
