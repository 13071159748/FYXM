//
//  MQIConversionCodeViewController.swift
//  MoQingInternational
//
//  Created by moqing on 2019/5/31.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQIConversionCodeViewController: MQIBaseViewController {

    var textField:UITextField!
    var determineBtn:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        title  = kLocalized("兑换码")
        contentView.backgroundColor = UIColor.colorWithHexString("#F6F6F6")
        
        let topBacView = UIView(frame: CGRect(x: 0,y: 10,width: contentView.width,height: 44))
        topBacView.backgroundColor = UIColor.white
        contentView.addSubview(topBacView)
        
        textField = UITextField(frame: CGRect(x: 10,y: 0,width: topBacView.width-20,height: 44))
        textField.backgroundColor = UIColor.clear
        textField.delegate = self
        textField.placeholder = "请输入兑换码"
        textField.clearButtonMode = .whileEditing
        textField.layer.masksToBounds = true
        textField.returnKeyType = UIReturnKeyType.done
        textField.font = kUIStyle.sysFontDesign1PXSize(size: 15)
        topBacView.addSubview(textField)
        textField.becomeFirstResponder()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeText(no:)), name: UITextField.textDidChangeNotification, object: nil)
        
        let instructionsLable  = UILabel()
        instructionsLable.font = kUIStyle.sysFontDesign1PXSize(size: 15)
        instructionsLable.textColor = kUIStyle.colorWithHexString("999999")
        instructionsLable.textAlignment = .left
        instructionsLable.numberOfLines = 0
        contentView.addSubview(instructionsLable)
        instructionsLable.snp.makeConstraints { (make) in
            make.top.equalTo(topBacView.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)

        }
        let instructionstext = kLocalized("One_exchange_code_can_only")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .left
        let att1 = NSMutableAttributedString(string: instructionstext)
        att1.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle,
                            NSAttributedString.Key.font:instructionsLable.font ], range: NSRange.init(location: 0, length:   instructionstext.count))
        
         instructionsLable.attributedText = att1
         
        determineBtn =  UIButton()
        determineBtn.setTitle(kLocalized("determine"), for: .normal)
        determineBtn.titleLabel?.font = kUIStyle.sysFontDesign1PXSize(size: 15)
        determineBtn.setTitleColor(mainColor, for: .normal)
        determineBtn.addTarget(self, action: #selector(determineBtnAction), for: UIControl.Event.touchUpInside)
        contentView.addSubview(determineBtn)
        determineBtn.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(instructionsLable.snp.bottom).offset(40)
            make.height.equalTo(44)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.centerX.equalToSuperview()
        }
        
        determineBtn.backgroundColor = kUIStyle.colorWithHexString("ffffff")
        determineBtn.dsySetCorner(radius:22)
        determineBtn.dsySetBorderr(color: mainColor, width: 1)
        determineBtn.isSelected = false
        changeBtnState()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc  func changeText(no:Notification)  {
        guard let textField:UITextField = no.object as? UITextField else {
            return
        }
        
        changeText(textField)
        
    }
    func changeBtnState() {
//        if determineBtn.isSelected {
////            determineBtn.dsySetBorderr(color: mainColor, width: 1)
//            determineBtn.setTitleColor(mainColor, for: .normal)
//        }else{
////            determineBtn.dsySetBorderr(color: UIColor.colorWithHexString("F6F6F6"), width: 1)
//            determineBtn.setTitleColor(UIColor.colorWithHexString("999999"), for: .normal)
//
//        }
    }
    
    @objc func determineBtnAction() {
        if determineBtn.isSelected  {
             textField.resignFirstResponder()
            guard let text = textField.text  else{
                return
            }
            request(text)
         
        }else{
          MQILoadManager.shared.makeToast("兑换码输入不正确")
        }
      
    }
    
    func request(_ text:String) {
        MQILoadManager.shared.addProgressHUD("")
        MQIRedeemExchangeRequest.init(redeem_code: text).request({ (request, response, result_old: MQIBaseModel) in
             MQILoadManager.shared.dismissProgressHUD()
             MQILoadManager.shared.makeToast("兑换成功")
            
        }) { (msg, code) in
             MQILoadManager.shared.dismissProgressHUD()
            MQILoadManager.shared.makeToast(msg)
            
        }
    }
    
}


extension MQIConversionCodeViewController:UITextFieldDelegate{
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//       return  changeText()
//    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        determineBtnAction()
        return  textField.resignFirstResponder()
    }
    
   @discardableResult func changeText(_ textField:UITextField) -> Bool {
        guard let text = textField.text  else {
            return true
        }
        if text.count < 6 {
            determineBtn.isSelected = false
        }else if text.count > 64 {
            determineBtn.isSelected = false
            return  false
        }else{
            determineBtn.isSelected = true
        }
        changeBtnState()
        return true
    }
}
