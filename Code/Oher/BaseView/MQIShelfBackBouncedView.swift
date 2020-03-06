//
//  MQIShelfBackBouncedView.swift
//  XSDQReader
//
//  Created by moqing on 2018/12/25.
//  Copyright © 2018 _CHK_. All rights reserved.
//

import UIKit

class MQIShelfBackBouncedView: UIView {
    
    var clickBlock:((_ isClose:Bool)->())?
    var titleLable:UILabel!
    var isPrompt:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(_ block:((_ isClose:Bool)->())?) {
        clickBlock = block
    }
    
    @discardableResult  class  func showBouncedView(_ isPrompt:Bool=false ,_ block:((_ isClose:Bool)->())?) -> MQIShelfBackBouncedView {
        let keyWindow =   UIApplication.shared.keyWindow!
        var bouncedView:MQIShelfBackBouncedView?
        if let bView = keyWindow.viewWithTag(1002014) {
            bouncedView = bView as? MQIShelfBackBouncedView
            bouncedView?.frame = UIScreen.main.bounds
            bouncedView!.clickBlock = nil
        }else{
           bouncedView = MQIShelfBackBouncedView(frame: UIScreen.main.bounds)
           bouncedView?.tag = 1002014
           keyWindow.addSubview(bouncedView!)
            
        }
        keyWindow.bringSubviewToFront(bouncedView!)
        bouncedView!.isPrompt = isPrompt
        bouncedView!.clickBlock = block
        bouncedView!.defaultAnimation()
        bouncedView!.setupUI()
        return bouncedView!
    }
    
    
    
    func  defaultAnimation(){
        self.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
    
    fileprivate  func setupUI()  {
        self.backgroundColor  = kUIStyle.colorWithHexString("000000", alpha: 0.2)
        let  contentView = UIView()
        contentView.backgroundColor = UIColor.white
        contentView.dsySetCorner(radius: 6)
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            //            make.height.equalTo(kUIStyle.kScale1PXW(142))
            make.height.greaterThanOrEqualTo(100)
            make.width.equalTo(kUIStyle.scale1PXW(255))
        }
        addContentSubView(contentView)
    }
    
    
    fileprivate  func addContentSubView(_ view:UIView)  {
        
        let image =  UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: About_IconName)
        image.backgroundColor = UIColor.white
        addSubview(image)
        image.dsyAddTap(self, action: #selector(operationAction))
        image.snp.makeConstraints { (make) in
            make.centerY.equalTo(view.snp.top)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(kUIStyle.scale1PXW(60))
        }
        
        image.dsySetCorner(radius: 30)
        image.dsySetBorderr(color:UIColor.white, width: 4)
        
        titleLable = UILabel()
        titleLable.font  = kUIStyle.sysFontDesign1PXSize(size: 15)
        titleLable.textColor = UIColor.colorWithHexString("333333")
        titleLable.textAlignment = .center
        titleLable.numberOfLines  = 0
        titleLable.adjustsFontSizeToFitWidth = true
        view.addSubview(titleLable)
        titleLable.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(45)
        }
        titleLable.text = "喜欢这本书就加入书架吧～"
        
        if isPrompt {
            let rightBtn = UIButton()
            rightBtn.backgroundColor = UIColor.white
            rightBtn.setTitle("确定", for: .normal)
            rightBtn.titleLabel?.font = kUIStyle.boldSystemFont1PXDesignSize(size: 14)
            rightBtn.setTitleColor(UIColor.colorWithHexString("FF6142"), for: .normal)
            rightBtn.addTarget(self, action: #selector(operationAction), for: .touchUpInside)
            view.addSubview(rightBtn)
            rightBtn.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(kUIStyle.scale1PXH(46))
                make.top.equalTo(titleLable.snp.bottom).offset(20)
            }
            let lineView1 = UIView()
            lineView1.backgroundColor = UIColor.colorWithHexString("E1E1E1")
            view.addSubview(lineView1)
            lineView1.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.bottom.equalTo(rightBtn.snp.top)
                make.height.equalTo(1)
            }
        }else{
            let leftBtn = UIButton()
            leftBtn.backgroundColor = UIColor.white
            leftBtn.setTitle("取消", for: .normal)
            leftBtn.titleLabel?.font = kUIStyle.boldSystemFont1PXDesignSize(size: 14)
            leftBtn.setTitleColor(UIColor.colorWithHexString("999999"), for: .normal)
            leftBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
            view.addSubview(leftBtn)
            leftBtn.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.bottom.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.5)
                make.height.equalTo(kUIStyle.scale1PXH(46))
                make.top.equalTo(titleLable.snp.bottom).offset(20)
            }
            
            let rightBtn = UIButton()
            rightBtn.backgroundColor = UIColor.white
            rightBtn.setTitle("确定", for: .normal)
            rightBtn.titleLabel?.font = kUIStyle.boldSystemFont1PXDesignSize(size: 14)
            rightBtn.setTitleColor(UIColor.colorWithHexString("FF6142"), for: .normal)
            rightBtn.addTarget(self, action: #selector(operationAction), for: .touchUpInside)
            view.addSubview(rightBtn)
            rightBtn.snp.makeConstraints { (make) in
                make.right.equalToSuperview()
                make.bottom.width.height.equalTo(leftBtn)
            }
            
            
            let lineView1 = UIView()
            lineView1.backgroundColor = UIColor.colorWithHexString("E1E1E1")
            view.addSubview(lineView1)
            lineView1.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.bottom.equalTo(leftBtn.snp.top)
                make.height.equalTo(1)
            }
            
            let lineView2 = UIView()
            lineView2.backgroundColor = UIColor.colorWithHexString("E1E1E1")
            view.addSubview(lineView2)
            lineView2.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalTo(leftBtn)
                make.width.equalTo(1)
                make.height.equalTo(leftBtn).multipliedBy(0.7)
            }
            
            
        }
        
    }
    
    
    @objc fileprivate   func operationAction() {
        self.alpha = 1
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (c) in
            if c {
                self.clickBlock?(false)
                self.removeFromSuperview()
            }
        }
        
    }
    
    @objc fileprivate  func closeAction()  {
        self.alpha = 1
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (c) in
            if c {
                self.clickBlock?(true)
                self.removeFromSuperview()
            }
        }
        
    }
}

class MQIActivityRulesBouncedView: UIView {
    
    var clickBlock:((_ isClose:Bool)->())?
    var textView:UITextView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(_ block:((_ isClose:Bool)->())?) {
        clickBlock = block
    }
    
    @discardableResult  class  func showBouncedView(_ isPrompt:Bool=false ,_ block:((_ isClose:Bool)->())?) -> MQIActivityRulesBouncedView {
        let bouncedView = MQIActivityRulesBouncedView(frame: UIScreen.main.bounds)
        UIApplication.shared.keyWindow!.addSubview(bouncedView)
        bouncedView.clickBlock = block
        bouncedView.defaultAnimation()
        bouncedView.setupUI()
        bouncedView.textView.attributedText =  bouncedView.getAtts(kLocalized("checkInRules_Content"))
        
        return bouncedView
    }
    
    
    
    func  defaultAnimation(){
        self.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
        
    }
    
    fileprivate  func setupUI()  {
        self.backgroundColor  = kUIStyle.colorWithHexString("000000", alpha: 0.2)
        self.dsyAddTap(self, action: #selector(closeAction))
        let  contentView = UIView(frame: CGRect(x: 0, y: 0, width: kUIStyle.scale1PXW(300), height: kUIStyle.scale1PXH(360)))
        contentView.backgroundColor = UIColor.white
        contentView.dsySetCorner(radius: 6)
        addSubview(contentView)
        contentView.centerX = screenWidth*0.5
        contentView.centerY = screenHeight*0.5
        
        addContentSubView(contentView)
        
    }
    
    
    fileprivate  func addContentSubView(_ view:UIView)  {
        
        let titleLable = UILabel(frame: CGRect(x: 0, y: 0, width: view.width, height: 40))
        titleLable.font  = kUIStyle.sysFontDesign1PXSize(size: 15)
        titleLable.textColor = UIColor.colorWithHexString("333333")
        titleLable.textAlignment = .center
        titleLable.numberOfLines  = 0
        titleLable.adjustsFontSizeToFitWidth = true
        view.addSubview(titleLable)
        
        titleLable.text = kLocalized("checkInRules")
        
        let rightBtn = UIButton(frame: CGRect(x:view.width-30, y: 0, width: 15, height: 15))
        rightBtn.backgroundColor = UIColor.white
        rightBtn.imageView?.contentMode = .scaleAspectFit
        rightBtn.setImage(UIImage(named: "close_img"), for: .normal)
        rightBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        view.addSubview(rightBtn)
        rightBtn.tintColor = UIColor.black
        rightBtn.centerY = titleLable.centerY
        
        
        textView = UITextView(frame: CGRect(x: 10, y: titleLable.maxY, width:view.width-20, height: view.height-titleLable.maxY-10))
        textView.font = kUIStyle.sysFontDesign1PXSize(size: 13)
        textView.textColor = kUIStyle.colorWithHexString("333333")
        textView.showsHorizontalScrollIndicator =  false
        textView.showsVerticalScrollIndicator = true
        textView.isEditable = false
        textView.isSelectable = false
        view.addSubview(textView)
        
        
    }
    
    func getAtts(_ text:String) -> NSAttributedString{
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = 5
        let att = NSMutableAttributedString.init(string: text, attributes: [NSAttributedString.Key.font : textView.font!,
                                                                            NSAttributedString.Key.paragraphStyle:paragraphStyle])
        return att as NSAttributedString
    }
    @objc fileprivate   func operationAction() {
        self.alpha = 1
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (c) in
            if c {
                self.clickBlock?(false)
                self.removeFromSuperview()
            }
        }
        
    }
    
    @objc fileprivate  func closeAction()  {
        self.alpha = 1
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (c) in
            if c {
                self.clickBlock?(true)
                self.removeFromSuperview()
            }
        }
        
    }
}


class MQIActivityDownloadBouncedView: UIView {
    
    var clickBlock:((_ isClose:Bool)->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(_ block:((_ isClose:Bool)->())?) {
        clickBlock = block
    }
    
    @discardableResult  class  func showBouncedView(_ isPrompt:Bool=false ,_ block:((_ isClose:Bool)->())?) -> MQIActivityDownloadBouncedView {
        let bouncedView = MQIActivityDownloadBouncedView(frame: UIScreen.main.bounds)
        UIApplication.shared.keyWindow!.addSubview(bouncedView)
        bouncedView.clickBlock = block
        bouncedView.defaultAnimation()
        bouncedView.setupUI()
        
        return bouncedView
    }
    
    
    
    func  defaultAnimation(){
        self.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
        
    }
    
    fileprivate  func setupUI()  {
        self.backgroundColor  = kUIStyle.colorWithHexString("000000", alpha: 0.2)
//        self.dsyAddTap(self, action: #selector(closeAction))
        let  contentView = UIView(frame: CGRect(x: 0, y: 0, width: kUIStyle.scale1PXW(300), height: kUIStyle.scale1PXH(150)))
        contentView.backgroundColor = UIColor.white
        contentView.dsySetCorner(radius: 4)
        addSubview(contentView)
        contentView.centerX = screenWidth*0.5
        contentView.centerY = screenHeight*0.5
        addContentSubView(contentView)
        
    }
    
    
    fileprivate  func addContentSubView(_ view:UIView)  {
       
        let titleLable = UILabel(frame: CGRect(x: 20, y: 20, width: view.width-20, height: 20))
        titleLable.font  = kUIStyle.sysFontDesign1PXSize(size: 16)
        titleLable.textColor = UIColor.colorWithHexString("333333")
        titleLable.textAlignment = .left
        titleLable.numberOfLines  = 1
        titleLable.adjustsFontSizeToFitWidth = true
        view.addSubview(titleLable)
        titleLable.text = kLocalized("Warn")
        
      
        let rightBtn = UIButton(frame: CGRect(x:view.width-30-60, y: view.height-30-10, width: 60, height: 30))
        rightBtn.backgroundColor = UIColor.white
        rightBtn.titleLabel?.font = kUIStyle.sysFontDesign1PXSize(size: 13)
        rightBtn.setTitleColor(UIColor.colorWithHexString("7187FF"), for: .normal)
        rightBtn.setTitle(kLocalized("Down"), for: .normal)
        rightBtn.tag = 100
        rightBtn.addTarget(self, action: #selector(cilckBtnAction(_:)), for: .touchUpInside)
        view.addSubview(rightBtn)
        rightBtn.contentHorizontalAlignment = .right
        
        let contentLable = UILabel(frame: CGRect(x: titleLable.x, y: titleLable.maxY+10, width: titleLable.width, height: 50))
        contentLable.font  = kUIStyle.sysFontDesign1PXSize(size: 13)
        contentLable.textColor = UIColor.colorWithHexString("333333")
        contentLable.textAlignment = .left
        contentLable.numberOfLines  = 0
        contentLable.adjustsFontSizeToFitWidth = true
        view.addSubview(contentLable)
        contentLable.text = "即將下載本書的免費章節和全部已訂閱過的章節，是否下載?"
        
    
        
        let cancelBtn = UIButton(frame: CGRect(x:titleLable.x, y: rightBtn.y, width: 60, height: rightBtn.height))
        cancelBtn.backgroundColor = UIColor.white
        cancelBtn.titleLabel?.font = kUIStyle.sysFontDesign1PXSize(size: 13)
        cancelBtn.setTitleColor(UIColor.colorWithHexString("7187FF"), for: .normal)
        cancelBtn.setTitle(kLocalized("Cancel"), for: .normal)
        cancelBtn.tag = 101
        cancelBtn.addTarget(self, action: #selector(cilckBtnAction(_:)), for: .touchUpInside)
        view.addSubview(cancelBtn)
        cancelBtn.contentHorizontalAlignment = .left
        
        
        let rightBtn2 = UIButton(frame: CGRect(x:cancelBtn.maxX+10, y: rightBtn.y, width: rightBtn.x-cancelBtn.maxX-10, height: rightBtn.height))
        rightBtn2.backgroundColor = UIColor.white
        rightBtn2.titleLabel?.font = kUIStyle.sysFontDesign1PXSize(size: 13)
        rightBtn2.setTitleColor(UIColor.colorWithHexString("7187FF"), for: .normal)
        rightBtn2.setTitle("省流量下载", for: .normal)
        rightBtn2.tag = 102
        rightBtn2.addTarget(self, action: #selector(cilckBtnAction(_:)), for: .touchUpInside)
        view.addSubview(rightBtn2)
        rightBtn2.contentHorizontalAlignment = .right
        
    }
    
 
    @objc fileprivate   func cilckBtnAction(_ btn:UIButton) {
        
        if btn.tag == 100 {
            self.clickBlock?(false)
        }else if btn.tag == 102 {
            self.clickBlock?(true)
        }
         closeAction()
        
    }
    @objc fileprivate   func operationAction() {
        self.alpha = 1
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (c) in
            if c {
                self.removeFromSuperview()
            }
        }
        
    }
    
    @objc fileprivate  func closeAction()  {
        self.alpha = 1
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (c) in
            if c {
                self.removeFromSuperview()
            }
        }
        
    }
}



