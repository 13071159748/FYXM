//
//  MQIVersionBouncedView.swift
//  CQSC
//
//  Created by moqing on 2019/8/29.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQIVersionBouncedView: UIView {

    static let showKey = "VersionBouncedView_key_show"
    var clickBlock:((_ isClose:Bool)->())?
    fileprivate var titleLable:UILabel!
    fileprivate var dscLable:UILabel!
    fileprivate var titleLable2:UILabel!
    fileprivate var contentTextView:UITextView!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(_ block:((_ isClose:Bool)->())?) {
        clickBlock = block
         
    }
    
    
   class  func show() {
    if MQIUserDefaultsKeyManager.shared.version_isAvailable() {
        MQIversion_tipsRequest().request({ (_, _, model:MQIVersionModel) in
                if model.version.count > 1 && model.version != getCurrentVersion() {
                    MQIVersionBouncedView.showBouncedView( model, block: nil)
                }
            }) { (co, ms) in
                mqLog("\(ms) -- \(co)")}
        }
   
    }

    class  func showBouncedView(_ model:MQIVersionModel, block:((_ isClose:Bool)->())?) -> Void {
        let keyWindow =   UIApplication.shared.keyWindow!
        var bouncedView:MQIVersionBouncedView?
        if let bView = keyWindow.viewWithTag(219829) {
            bouncedView = bView as? MQIVersionBouncedView
            bouncedView?.frame = UIScreen.main.bounds
            bouncedView!.clickBlock = nil
        }else{
            bouncedView = MQIVersionBouncedView(frame: UIScreen.main.bounds)
            bouncedView?.tag = 219829
            keyWindow.addSubview(bouncedView!)
            
        }
        keyWindow.bringSubviewToFront(bouncedView!)
        bouncedView!.clickBlock = block
        bouncedView!.defaultAnimation()
        bouncedView!.setupUI()
        bouncedView!.contentTextView.text = model.content
//        bouncedView!.contentTextView.setContentOffset(CGPoint(x: 0, y: -10), animated: false)
        bouncedView!.titleLable.text =  "发现新版本"
        bouncedView!.dscLable.text =  model.site_name + model.version
        bouncedView!.titleLable2.text = model.title
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
        contentView.dsySetCorner(radius: 6)
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            //            make.height.equalTo(kUIStyle.kScale1PXW(142))
            make.height.greaterThanOrEqualTo(100)
            make.width.equalTo(292)
        }
        addContentSubView(contentView)
    }
    
    
    fileprivate  func addContentSubView(_ view:UIView)  {
        
        let image =  UIImageView()
        image.image = UIImage(named: "Version_huojie")
        view.addSubview(image)
        image.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(139)
        }
        
        
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.white
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(image.snp.bottom)
            make.height.equalTo(269)
        }
        
        titleLable = UILabel()
        titleLable.font  = UIFont.boldSystemFont(ofSize: 24)
        titleLable.textColor = UIColor.colorWithHexString("#FFFFFF")
        titleLable.textAlignment = .left
        titleLable.numberOfLines  = 1
        titleLable.adjustsFontSizeToFitWidth = true
        view.addSubview(titleLable)
        titleLable.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(22)
            make.right.equalTo(view.snp.centerX).offset(10)
            make.top.equalToSuperview().offset(38)
        }
     
       dscLable = UILabel()
        dscLable.font  = UIFont.boldSystemFont(ofSize: 12)
        dscLable.textColor = UIColor.colorWithHexString("#FFFFFF")
        dscLable.textAlignment = .left
        dscLable.numberOfLines  = 1
        dscLable.adjustsFontSizeToFitWidth = true
        view.addSubview(dscLable)
        dscLable.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLable)
            make.top.equalTo(titleLable.snp.bottom).offset(5)
        }
     
   
        titleLable2 = UILabel()
        titleLable2.font  = UIFont.boldSystemFont(ofSize: 16)
        titleLable2.textColor = UIColor.colorWithHexString("#333333")
        titleLable2.textAlignment = .left
        titleLable2.numberOfLines  = 1
        titleLable2.adjustsFontSizeToFitWidth = true
        view.addSubview(titleLable2)
        titleLable2.snp.makeConstraints { (make) in
            make.left.equalTo(titleLable)
            make.right.equalToSuperview().offset(-22)
            make.top.equalTo(bottomView).offset(0)
        }
      
     
        
        contentTextView = UITextView()
        contentTextView.font = UIFont.systemFont(ofSize: 14)
        contentTextView.textColor = UIColor.colorWithHexString("#666666")
        contentTextView.showsVerticalScrollIndicator = true
        contentTextView.isEditable = false
        if #available(iOS 11.0, *) {
            contentTextView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        view.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLable2)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLable2.snp.bottom).offset(10)
            make.height.equalTo(80)
        }
       
        
        
        let bottomBtn = UIButton()
        bottomBtn.backgroundColor = UIColor.white
        bottomBtn.setTitle("稍后提示", for: .normal)
        bottomBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        bottomBtn.setTitleColor(UIColor.colorWithHexString("#BEBEBE"), for: .normal)
        bottomBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        view.addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-13)
            make.centerX.equalToSuperview()
        }
        
        let topBtn = UIButton()
        topBtn.backgroundColor = UIColor.white
        topBtn.setTitle("立即升级", for: .normal)
        topBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        topBtn.setTitleColor(UIColor.colorWithHexString("FFFFFF"), for: .normal)
        topBtn.addTarget(self, action: #selector(operationAction), for: .touchUpInside)
        topBtn.backgroundColor = UIColor.colorWithHexString("#FF514A")
        topBtn.dsySetCorner(radius: 19)
        view.addSubview(topBtn)
        topBtn.snp.makeConstraints { (make) in
            make.width.equalTo(185)
            make.height.equalTo(38)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(bottomBtn.snp.top).offset(-21)
        }
        
        
    }
    
    
    @objc fileprivate   func operationAction() {
        self.alpha = 1
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (c) in
            if c {
                self.clickBlock?(false)
                MQIOpenlikeManger.openURL(URL(string: itunes_url)!)
                MQIUserDefaultsKeyManager.shared.version_Save()
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
                MQIUserDefaultsKeyManager.shared.version_Save()
                self.removeFromSuperview()
            
            }
        }
        
    }

}
