//
//  MQIBindItemView.swift
//  CQSC
//
//  Created by moqing on 2019/8/23.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit


class MQIBindItemView: UIView {
    /// 标题
    var titleLable :UILabel!
    /// 标题
    var titleLable1 :UILabel!
    /// 下一步btn
    var nextBtn:MQIBindRefreshBtn!
    /// 其他功能btn
    var otherBtn:UIButton!
    /// icon
    var icon:UIImageView!
    /// 输入 TextField
    var inputTextField:MQIBindInputView!
    /// 输入 TextField2
    var inputTextField2:MQIBindInputView!
    /// 输入 codeview
    var codeView:CodeInputView!
    var codeBlock:((_ codel:String)-> ())?
    ///  旋转动画
    var isShowRefreshAnimation:Bool = false {
        didSet(oldValue) {
            if isShowRefreshAnimation {
                nextBtn.startAnimation()
            }else{
                nextBtn.stopAnimation()
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        defaultUIHidden()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:  aDecoder )
        setupUI()
        defaultUIHidden()
    }
    deinit {
        if nextBtn != nil {
             nextBtn.stopAnimation()
        }
    }
    
    func defaultUIHidden() {
      
         titleLable.isHidden = true
         titleLable1.isHidden = true
         icon.isHidden = true
         nextBtn.isHidden = true
         otherBtn.isHidden = true
         inputTextField.isHidden = true
         inputTextField2.isHidden = true
         codeView.isHidden = true
         nextBtn.tag = 0
         nextBtn.isEnabled = false
         nextBtn.isSelected  =  false
         codeBlock = nil
         inputTextField2.rightBtn.isEnabled = true
         inputTextField.rightBtn.isEnabled = true
         inputTextField2.rightBtn.isSelected = false
         inputTextField.rightBtn.isSelected = false
         codeView.cleanText()
        
         titleLable.snp.removeConstraints()
         titleLable1.snp.removeConstraints()
         icon.snp.removeConstraints()
         nextBtn.snp.removeConstraints()
         otherBtn.snp.removeConstraints()
         inputTextField.snp.removeConstraints()
         inputTextField2.snp.removeConstraints()
         codeView.snp.removeConstraints()
    }
    
    func setupUI() {
        
        titleLable = UILabel()
        titleLable.textColor = UIColor.colorWithHexString("#999999")
        titleLable.font = UIFont.systemFont(ofSize: 14)
        titleLable.numberOfLines = 0
        titleLable.textAlignment = .center
        addSubview(titleLable)
        
        titleLable1 = UILabel()
        titleLable1.textColor = UIColor.colorWithHexString("#333333")
        titleLable1.font = UIFont.boldSystemFont(ofSize: 16)
        titleLable1.numberOfLines = 1
        titleLable1.textAlignment = .center
        addSubview(titleLable1)
      
        icon = UIImageView()
        addSubview(icon)
      
        
        nextBtn = MQIBindRefreshBtn(frame: CGRect(x: 0, y: 0, width: 249, height: 40))
        nextBtn.setTitleColor(UIColor.colorWithHexString("ffffff"), for: .normal)
        nextBtn.backgroundColor = UIColor.colorWithHexString("#7187FF")
        nextBtn.setBackgroundColor(UIColor.colorWithHexString("#7187FF"), for: .normal)
        nextBtn.setBackgroundColor(UIColor.colorWithHexString("#D9DFFF"), for: .disabled)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        nextBtn.dsySetCorner(byRoundingCorners: .allCorners, radii: 20)
        addSubview(nextBtn)
    
        
        otherBtn = UIButton()
        otherBtn.setTitleColor(UIColor.colorWithHexString("#7187FF"), for: .normal)
        otherBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        addSubview(otherBtn)
      
        
        inputTextField = MQIBindInputView()
        inputTextField.placeholder = ""
        inputTextField.rightBtn.tag = 100
        inputTextField.font =  UIFont.systemFont(ofSize: 16)
        inputTextField.textColor = UIColor.colorWithHexString("000000")
        addSubview(inputTextField)
      
        
        inputTextField2 = MQIBindInputView()
        inputTextField2.rightBtn.tag = 101
        inputTextField2.placeholder = ""
        inputTextField2.font =  UIFont.systemFont(ofSize: 16)
        inputTextField2.textColor = UIColor.colorWithHexString("000000")
        addSubview(inputTextField2)
     
        inputTextField.rightBtn.addTarget(self, action: #selector(clickTexRrightBtn(_:)), for: .touchUpInside)
        inputTextField2.rightBtn.addTarget(self, action: #selector(clickTexRrightBtn(_:)), for: .touchUpInside)
        codeView  = CodeInputView.init(frame: CGRect(x: 0, y: 0, width: 249, height: 40), inputType:  6, mark: mainColor, font: kUIStyle.boldSystemFont(size: 20)) {[weak self] (code) in
            if let code = code {
                self?.codeBlock?(code)
            }
            
        }
        codeView.lineSelColor = UIColor.colorWithHexString("#7187FF")
        addSubview(codeView!)
        
    }
    
    @objc  func clickTexRrightBtn(_ btn:UIButton) {
        if  btn.isHidden{return}
         btn.isSelected = !btn.isSelected
        if btn.tag == 100  {
            if inputTextField.is_Clean {
                inputTextField.textField.text = ""
                return
            }
            if  btn.isSelected {
                let tempStr = inputTextField.textField.text
                 inputTextField.textField.text = ""
             
                inputTextField.textField.isSecureTextEntry = false
                inputTextField.textField.text = tempStr
            }else{
                let tempStr = inputTextField.textField.text
                inputTextField.textField.text = ""
                inputTextField.textField.isSecureTextEntry = true
                inputTextField.textField.text = tempStr
                
            }
        }else {
            if inputTextField2.is_Clean {
                inputTextField2.textField.text = ""
                return
            }
            if  btn.isSelected {
                let tempStr = inputTextField2.textField.text
                inputTextField2.textField.text = ""
                inputTextField2.textField.isSecureTextEntry = false
                inputTextField2.textField.text = tempStr
            }else{
                let tempStr = inputTextField.textField.text
                inputTextField2.textField.text = ""
                inputTextField2.textField.isSecureTextEntry = true
                inputTextField2.textField.text = tempStr
            }
        }
        
    }
    
    
    class MQIBindRefreshBtn: UIButton {
        
        override var isHidden: Bool{
            didSet(oldValue) {
                stopAnimation()
            }
        }
        func startAnimation()  {
            guard let imageView = imageView else {
                return
            }
            setRotationAnimation(imageView, isAnimation: true)
        }
        
        func stopAnimation()  {
            guard let imageView = imageView else {
                return
            }
            setRotationAnimation(imageView, isAnimation: false)
        }
        
        func setRotationAnimation(_ view:UIView,isAnimation:Bool ) -> Void {
            
            if isAnimation {
                if view.layer.animation(forKey: "H_MQIBindRefreshBtnBtnRotation") == nil {
                    let anim = CABasicAnimation(keyPath: "transform.rotation")
                    anim.toValue = Float.pi*2
                    anim.duration = 1
                    anim.repeatCount = MAXFLOAT
                    anim.isRemovedOnCompletion = true
                    view.layer.add(anim, forKey: "H_MQIBindRefreshBtnBtnRotation")
                }
            }else{
                view.layer.removeAnimation(forKey: "H_MQIBindRefreshBtnBtnRotation")
               
            }
            
        }
      
        
    }
    
}


class MQIBindInputView: UIView {
    var lineView:UIView!
    var rightBtn:UIButton!
    var is_Clean = false

    var delegate:UITextFieldDelegate?{
        set {
           textField.delegate = newValue
        }
        get {
           return textField.delegate
        }
    }
    var text:String?{
        set {
            textField.text = newValue
        }
        get {
            return textField.text
        }
    }
    
    var placeholder:String?{
        set {
            textField.placeholder = newValue
        }
        get {
            return textField.placeholder
        }
    }
    
    var font:UIFont?{
        set {
            textField.font = newValue
        }
        get {
            return textField.font
        }
    }
    
    var textColor:UIColor?{
        set {
            textField.textColor = newValue
        }
        get {
            return textField.textColor
        }
    }
  
    var returnKeyType:UIReturnKeyType {
        set {
            textField.returnKeyType = newValue
        }
        get {
            return textField.returnKeyType
        }
    }
    
    var keyboardType:UIKeyboardType {
        set {
            textField.keyboardType = newValue
        }
        get {
            return textField.keyboardType
        }
    }
    var textField:UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
         setupUI()
    }
    
  
    func setSelectedView(_ sel:Bool = false) {
        if !sel {
            lineView.backgroundColor = UIColor.colorWithHexString("#E2E2E2")
        }else{
            lineView.backgroundColor = UIColor.colorWithHexString("#7187FF")
        }
    }
    func setupUI() {
        lineView = UIView()
        lineView.backgroundColor = UIColor.colorWithHexString("#E2E2E2")
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
        
        rightBtn = UIButton()
        addSubview(rightBtn)
        rightBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
       
        
        textField = UITextField()
        textField.placeholder = ""
        addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-11)
            make.right.equalTo(rightBtn.snp.left).offset(-5)
        }
        self.snp.makeConstraints { (make) in
            make.bottom.equalTo(textField)
        }
        
    }
    
}
