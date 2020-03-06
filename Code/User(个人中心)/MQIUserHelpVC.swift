//
//  MQIUserHelpVC.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIUserHelpVC: MQIWebVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let b = addRightBtn(kLocalized("feedback"), imgStr: nil)
        b.contentHorizontalAlignment = .right
        b.setTitleColor(UIColor.black, for: .normal)
        b.width += 100
        b.x -= 100
    }
    
    override func rightBtnAction(_ button: UIButton) {
        
        let vc = MQIWebVC()
        if let user = MQIUserManager.shared.user {
            vc.url = feedBackListHttpURL()+"?user_id=\(user.user_id)"
            pushVC(vc)
        }else{
            MQIUserOperateManager.shared.toLoginVC { [weak self] in
                if let user =  MQIUserManager.shared.user {
                    vc.url = feedBackListHttpURL()+"?user_id=\(user.user_id)"
                    self?.pushVC(vc)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
