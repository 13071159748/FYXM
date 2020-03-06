//
//  MQIBindEmailViewController.swift
//  CQSC
//
//  Created by moqing on 2019/8/23.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

enum StateFlow {
    case mail
}

class MQIBindEmailViewController: MQIBaseViewController {
    var type:BindCreatedPageType!
    var loginSuccess:(()->())?
    fileprivate var operation = MQIBindOperation()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let item = MQIBindItemView()
        contentView.addSubview(item)
        item.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth)
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        operation.itemView = item
       
        operation.changeTitle = { [weak self] (title) in
            guard let weakSelf = self else { return }
            weakSelf.title = title
        }
        operation.loginSuccess = {[weak self] in
            guard let weakSelf = self else { return }
             weakSelf.popVC()
             weakSelf.loginSuccess?()
        }
        operation.type = type
        
    }
    

}


