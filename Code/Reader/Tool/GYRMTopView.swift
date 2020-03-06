//
//  GYRMTopView.swift
//  Reader
//
//  Created by CQSC  on 2017/6/23.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYRMTopView: GYRMBaseView {
    
    fileprivate(set) var backBtn: UIButton!
    
    fileprivate(set) var moreBtn: UIButton!
    fileprivate(set) var buyBtn: UIButton!
    fileprivate(set) var editBtn: UIButton!
    fileprivate(set) var errorBtn: UIButton!
    
    fileprivate(set) var actionView: GYRMTopActionView!
    
    //public var rewardBtn: UIButton!
    
    
    var titleColor = RGBColor(231, g: 231, b: 231)
    
    override func addSubviews() {
        super.addSubviews()
        
        backBtn = getBackBtn()
        backBtn.tintColor = UIColor.white
        backBtn.addTarget(self, action: #selector(GYRMTopView.buttonAction(_:)), for: .touchUpInside)
        self.addSubview(backBtn)
        
        moreBtn = createButton(CGRect.zero,
                                 normalTitle: nil,
                                 normalImage: UIImage(named: "readerTool_more"),
                                 selectedTitle: nil,
                                 selectedImage: nil,
                                 normalTilteColor: nil,
                                 selectedTitleColor: nil,
                                 bacColor: UIColor.clear,
                                 font: nil,
                                 target: self,
                                 action: #selector(GYRMTopView.moreBtnAction(_:)))
        self.addSubview(moreBtn)
        
        errorBtn = createButton(CGRect.zero,
                                normalTitle: "",
                                normalImage: UIImage(named: "reader_top_bc"),
                                selectedTitle: nil,
                                selectedImage: nil,
                                normalTilteColor: mainColor,
                                selectedTitleColor: nil,
                                bacColor: UIColor.clear,
                                font: UIFont.systemFont(ofSize: 12),
                                target: self,
                                action: #selector(GYRMTopView.errorBtnAction(_:)))
        self.addSubview(errorBtn)
        errorBtn.imageView?.contentMode = .scaleAspectFit
        
        editBtn = createButton(CGRect.zero,
                                 normalTitle: "评论",
                                 normalImage: nil,//UIImage(named: "reader_top_edit"),
                                 selectedTitle: nil,
                                 selectedImage: nil,
                                 normalTilteColor: UIColor.white,
                                 selectedTitleColor: nil,
                                 bacColor: UIColor.clear,
                                 font: UIFont.systemFont(ofSize: 12),
                                 target: self,
                                 action: #selector(GYRMTopView.editBtnAction(_:)))
        self.addSubview(editBtn)
        editBtn.dsySetCorner(radius: 10)
        editBtn.dsySetBorderr(color: UIColor.white, width: 1)
        editBtn.imageView?.contentMode = .scaleAspectFit
        
        buyBtn = createButton(CGRect.zero,
                                 normalTitle: "订阅",
                                 normalImage: nil,//UIImage(named: "reader_top_buy"),
                                 selectedTitle: nil,
                                 selectedImage: nil,
                                 normalTilteColor: UIColor.colorWithHexString("7187FF"),
                                 selectedTitleColor: nil,
                                 bacColor: UIColor.clear,
                                 font:  UIFont.systemFont(ofSize: 12),
                                 target: self,
                                 action: #selector(GYRMTopView.buyBtnAction(_:)))
        self.addSubview(buyBtn)
        buyBtn.dsySetCorner(radius: 10)
        buyBtn.dsySetBorderr(color: UIColor.colorWithHexString("7187FF"), width: 1)

       
        checkBuyBtn()
    }
    
    //MARK: --
    
    func checkBuyBtn(_ hidden:Bool = true) {
        buyBtn.isHidden = hidden
    }
    
    @objc func buttonAction(_ button: UIButton) {
        readMenu.back()
    }
    //评论
    @objc func editBtnAction(_ button: UIButton) {
        if readMenu.vc.isCreating { return }
        func action() {
             if self.readMenu == nil { return }
            readMenu.delegate.readMenuClickComment!(readMenu: readMenu)
            buyBtn.isSelected = false
            readMenu.subscribeView(isShow: false, currentChapter: nil, completion: nil)
            
            moreBtn.isSelected = false
            readMenu.topActionView(isShow: false, completion: nil)
            
            //关打赏
            readMenu.topActionView.showReward = false
            readMenu.rewardView(isShow: false, completion: nil)
            //关掉设置
            readMenu.novelsSettingView(isShow: false) {[weak self]()->Void in
                if let weakSelf = self {
                    weakSelf.readMenu.bottomView(isShow: true, completion: nil)
                }
            }
        }
        if MQIUserManager.shared.checkIsLogin() {
            action()
        }else{
            MQIUserOperateManager.shared.toLoginVC({
                action()
            })
        }

        
    }
    //更多
    @objc func moreBtnAction(_ button: UIButton) {
         if readMenu.vc.isCreating { return }
        button.isSelected = !button.isSelected
        readMenu.topActionView(isShow: button.isSelected, completion: nil)
        
        buyBtn.isSelected = false
        readMenu.subscribeView(isShow: false, currentChapter: nil, completion: nil)

        //关打赏
        readMenu.topActionView.showReward = false
        readMenu.rewardView(isShow: false, completion: nil)
        //关掉设置
        readMenu.novelsSettingView(isShow: false) {[weak self]()->Void in
            if let weakSelf = self {
                weakSelf.readMenu.bottomView(isShow: true, completion: nil)
            }
        }
        
    }
    
    //订阅
    @objc func buyBtnAction(_ button: UIButton) {
        if readMenu.vc.isCreating { return }
//        readMenu.delegate?.readMenuClickBuy?(readMenu: readMenu)
       
        if GYBookManager.shared.isFree_limit_time{  MQILoadManager.shared.makeToast("本书限时免费中，可以尽情观看哦。");return  }
        
        func action() {
            if self.readMenu == nil { return }
            button.isSelected = !button.isSelected
            let chapter = readMenu.vc.readModel.readRecordModel.readChapterModel
            readMenu.subscribeView(isShow: button.isSelected, currentChapter: chapter, completion: nil)
            //        readMenu.rewardView(isShow: false, completion: nil)
            //更多消失
            moreBtn.isSelected = false
            readMenu.topActionView(isShow: false, completion: nil)
            
            //关打赏
            readMenu.topActionView.showReward = false
            readMenu.rewardView(isShow: false, completion: nil)
            //关掉设置
            //        readMenu.novelsSettingView(isShow: false, completion: nil)
            readMenu.novelsSettingView(isShow: false) {[weak self]()->Void in
                if let weakSelf = self {
                    weakSelf.readMenu.bottomView(isShow: true, completion: nil)
                }
            }
        }
        
        if MQIUserManager.shared.checkIsLogin() {
            action()
        }else{
            MQIUserOperateManager.shared.toLoginVC({
                action()
            })
        }

    }
    
    //报错
    @objc func errorBtnAction(_ button: UIButton) {
        if readMenu.vc.isCreating { return }
        func action() {
            if self.readMenu == nil { return }
            button.isSelected = !button.isSelected
            readMenu.delegate.readMenuClickAnError!(readMenu: readMenu)
            //更多消失
            moreBtn.isSelected = false
            readMenu.topActionView(isShow: false, completion: nil)
            
            //关打赏
            readMenu.topActionView.showReward = false
            readMenu.rewardView(isShow: false, completion: nil)
            //关掉设置
            //        readMenu.novelsSettingView(isShow: false, completion: nil)
            readMenu.novelsSettingView(isShow: false) {[weak self]()->Void in
                if let weakSelf = self {
                    weakSelf.readMenu.bottomView(isShow: true, completion: nil)
                }
            }

        }
        if MQIUserManager.shared.checkIsLogin() {
            action()
        }else{
            MQIUserOperateManager.shared.toLoginVC({
                action()
            })
        }

        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backBtn.frame = CGRect(x: 15,
                               y: root_status_height,
                               width: root_nav_height,
                               height: root_nav_height)
        
        moreBtn.frame = CGRect(x: self.width-5-root_nav_height,
                               y: root_status_height,
                               width: root_nav_height,
                               height: root_nav_height)
        
        errorBtn.frame = CGRect(x: 0,
                                y: 0,
                                width: 40,
                                height: 20)
        errorBtn.centerY = moreBtn.centerY
        errorBtn.maxX = moreBtn.x
        
        editBtn.frame = CGRect(x: 0 ,
                                 y: 0,
                                 width: 40,
                                 height: 20)
        editBtn.centerY = moreBtn.centerY
        editBtn.maxX = errorBtn.x - 10
//        editBtn.isHidden  = true
        
        
//        buyBtn.frame = CGRect(x: 0 ,
//                               y: 0,
//                               width: 40,
//                               height: 20)
//        buyBtn.centerY = moreBtn.centerY
//        buyBtn.maxX = errorBtn.x - 10
        
        
        buyBtn.frame = CGRect(x: 0,
                              y: 0,
                              width: 40,
                              height: 20)

        buyBtn.centerY = moreBtn.centerY
        buyBtn.maxX = editBtn.x - 15
    }
}

