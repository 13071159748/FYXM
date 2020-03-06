//
//  MQIUserDetailNickNameVC.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIUserDetailNickNameVC: MQIBaseViewController {
    var textField :UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = kLocalized("ModifyTheNickname")
        
        contentView.backgroundColor = RGBColor(244, g: 244, b: 244)
        
        let textbackView = UIView (frame: CGRect (x: 0, y: 15.5, width: screenWidth, height: 43))
        textbackView.backgroundColor = UIColor.white
        contentView.addSubview(textbackView)
        textField = UITextField(frame: CGRect (x: 10, y: 0, width: screenWidth-20, height: 43))
        textField.clearButtonMode = .whileEditing
        if let user = MQIUserManager.shared.user {
            textField.text =  user.user_nick
        }
        textbackView.addSubview(textField)
        
        let messageLabel = createLabel(CGRect (x: 16.5, y: textField.maxY + 15.5, width: screenWidth - 33, height: 40), font: UIFont.systemFont(ofSize: 12), bacColor: nil, textColor: UIColor.colorWithHexString("#898A92"), adjustsFontSizeToFitWidth: nil, textAlignment: .left, numberOfLines: 0)
        messageLabel.text = "\(kLocalized("WarmPrompt"))：\(kLocalized("NicknamesWillBeUsedAsYourIdentityInTheComments"))"
        contentView.addSubview(messageLabel)
        
        let changeBtn = UIButton(type: .custom)
        changeBtn.frame = CGRect (x: (screenWidth - 235)/2, y: 185, width: 235, height: 40)
        changeBtn.layer.cornerRadius = 20
        changeBtn.clipsToBounds = true
        changeBtn.layer.borderColor = mainColor.cgColor
        changeBtn.layer.borderWidth = 1
        changeBtn.addTarget(self, action: #selector(MQIUserDetailNickNameVC.changeBtnClick(_:)), for: .touchUpInside)
        changeBtn.setTitle(kLocalized("SaveTheChange"), for: .normal)
        changeBtn.setTitleColor(mainColor, for: .normal)
        contentView.addSubview(changeBtn)
    }
    @objc func changeBtnClick(_ sender:UIButton) {
        
        
        guard  let nickName = textField.text else {
            MQILoadManager.shared.makeToast(kLocalized("PleaseEnterNicknam"))
            
            return
        }
        let space = (nickName as NSString).replacingOccurrences(of: " ", with: "")
        
        guard space != "" else {
            MQILoadManager.shared.makeToast(kLocalized("PleaseEnterNicknam"))
            return
        }
        
        
        //        let donotWant = CharacterSet.init(charactersIn:" ")
        //        let nick = nickName.trimmingCharacters(in: donotWant)
        //        if nick.count < nickName.count {
        //            //不能有空格
        //            MQILoadManager.shared.makeToast("昵称应为字母数字和下划线等符号的组合")
        //            return
        //        }
        if nickName.count > 16 {
            MQILoadManager.shared.makeToast(kLocalized("NicknameLengthCannotExceedCharacte"))
            return
        }
        
        
        GDUserNickRequest(user_nick: nickName).request({ [weak self](request, response, result:MQIBaseModel) in
            MQILoadManager.shared.makeToast(kLocalized("ModifyTheSuccess"))
            if let user = MQIUserManager.shared.user {
                user.user_nick = nickName
            }
            MQIUserManager.shared.saveUser()
            UserNotifier.postNotification(.login_in)
            if let weakSelf = self {
                after(0.5, block: {
                    weakSelf.popVC()
                })
                
            }
            
            
        }) { (errmsg, errcode) in
            MQILoadManager.shared.makeToast(errmsg)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
