//
//  GDReadProgressView.swift
//  Reader
//
//  Created by CQSC  on 2018/1/26.
//  Copyright © 2018年  CQSC. All rights reserved.
//
//阅读进度
import UIKit


class GDReadProgressView: UIView {

    var bottomActionView:UIView!
    var actionToChapterBlock:(()->())?
    var actionCancelBlock:(()->())?
    init(frame:CGRect,model:MQIReadProgressModel) {
        super.init(frame: frame)
        addActionView(readModel: model)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    @objc func forbiddenges() {}
    func addActionView(readModel:MQIReadProgressModel) {
        
        addTGR(self, action: #selector(GDReadProgressView.forbiddenges), view: self)
        
        bottomActionView = UIView(frame: CGRect(x: 0, y: screenHeight - x_TabbatSafeBottomMargin - 180, width: screenWidth, height: 180))
        self.addSubview(bottomActionView)
        bottomActionView.backgroundColor = UIColor.white
        
        let titleLabel = UILabel(frame: CGRect.init(x: 10, y: 0, width: self.width-20, height: bottomActionView.height-45))
        
        let titleColor = UIColor.colorWithHexString("#333333")
        let chapterColor = RGBColor(238, g: 137, b: 93)
        let attStr = NSMutableAttributedString(string: "您已看到 ", attributes:
            [NSAttributedString.Key.font : systemFont(16),
             NSAttributedString.Key.foregroundColor : titleColor])
        
        let attStr2 = NSMutableAttributedString(string: "\(readModel.chapter_title)", attributes:
            [NSAttributedString.Key.font : systemFont(16),
             NSAttributedString.Key.foregroundColor : chapterColor])

        let attStr3 = NSMutableAttributedString(string: " ，是否跳转？", attributes:
            [NSAttributedString.Key.font : systemFont(16),
             NSAttributedString.Key.foregroundColor : titleColor])
        attStr.append(attStr2)
        attStr.append(attStr3)
        
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.attributedText = attStr
        bottomActionView.addSubview(titleLabel)
        
        let cancelBtn = bottomActionView.addCustomButton(CGRect.init(x: 0, y: bottomActionView.height - 45, width: self.width/2, height: 45), title: kLocalized("Cancel")) {[weak self] (sender) in
            if let weakSelf = self {
                weakSelf.cancelClick(sender)

            }
        }
        cancelBtn.setTitleColor(UIColor.colorWithHexString("#666666"), for: .normal)
        cancelBtn.backgroundColor = UIColor.colorWithHexString("#dadada")
        let sureBtn = bottomActionView.addCustomButton(CGRect.init(x: self.width/2, y: bottomActionView.height - 45, width: self.width/2, height: 45), title: "跳转") {[weak self] (sender) in
            if let weakSelf = self {
                weakSelf.btnClick(sender)

            }
        }
        sureBtn.backgroundColor = mainColor
        sureBtn.setTitleColor(UIColor.white, for: .normal)
    }
    
    func btnClick(_ sender:UIButton) {
        actionToChapterBlock?()
    }
    func cancelClick(_ sender:UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomActionView.y = screenHeight
        }) { (isFinish) in
            self.actionCancelBlock?()
        }
        
    }
    deinit {

    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
class GDReadProgressManager:NSObject {
    fileprivate var bookIds :[String] = [String]()
    
    fileprivate var progPath:String! {
        if MQIUserManager.shared.checkIsLogin() == false {
            return MQIFileManager.getCurrentStoreagePath("progress_Normalbids.db")
        }else {
            return MQIFileManager.getCurrentStoreagePath("progress_\(MQIUserManager.shared.user!.user_id)bids.db")

        }
    }
    
    static var shared:GDReadProgressManager {
        struct Static {
            static let instance = GDReadProgressManager()
        }
        return Static.instance
    }
    @discardableResult func check_bid_alreadyAlert(_ bid:String) -> Bool{
        getLocal_user_bids()
        if bookIds.contains(bid) {
            return true
        }
        return false
    }
    func getLocal_user_bids() {
        bookIds.removeAll()
        if let bids = NSKeyedUnarchiver.unarchiveObject(withFile: progPath) as? [String] {
            bookIds = bids
        }
    }
    func saveLocal_user_bids(_ bid:String) {
        if bookIds.contains(bid) == false{
            bookIds.append(bid)
        }
        if bookIds.count >= 0 {
            dispatchArchive(bookIds, path: progPath)
        }
    }
    
    
    
}
