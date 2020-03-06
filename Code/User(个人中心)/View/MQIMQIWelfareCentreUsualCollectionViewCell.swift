//
//  MQIMQIWelfareCentreUsualCollectionViewCell.swift
//  CHKReader
//
//  Created by moqing on 2019/1/25.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

//// 日常任务cell
class MQIMQIWelfareCentreUsualCollectionViewCell: MQICollectionViewCell {
    /// 图标
    var icon:UIImageView!
    /// 标题
    var title:UILabel!
    /// 活动金额
    var moneyBtn:UIButton!
    /// 内容
    var content:UILabel!
    /// 领取按钮
    var receiveBtn:UIButton!
    /// 进度视图
    var receiveBacView:UIView!
    /// 进度视图
    var receiveView:UIView!
    /// 进度提示
    var progressLable:UILabel!
    
    var type:receiveType = .btn{
        didSet(oldValue) {
            switch type {
            case .btn:
                receiveBtn.isHidden = false
                receiveBacView.isHidden = true
                progressLable.isHidden = true
                receiveView.isHidden = true
                break
            case .Progress:
                receiveBtn.isHidden = true
                receiveBacView.isHidden = false
                progressLable.isHidden = false
                receiveView.isHidden = false
                break
                
            }
        }
    }
    /// 进度
    var progress:Float = 0 {
        didSet(oldValue) {
            if progress >= 1 || progress < 0 {
                type = .btn
                return
            }
            receiveView.snp.removeConstraints()
            receiveView.snp.makeConstraints { (make) in
                make.left.top.height.equalTo(receiveBacView)
                make.width.equalTo(receiveBacView).multipliedBy(progress)
            }
        }
    }
    
    /// 完成状态
    var state:WelfareState? = .unfinished{
        didSet(oldValue) {
            setBtnState(state)
        }
    }
    
    /// 设置状态按钮状态
    func setBtnState(_ state:WelfareState?) -> Void {
        
        switch state {
        case .complete?: /// 完成
            receiveBtn.setTitle(kLocalized("HasBeenCompleted"), for: .normal)
            receiveBtn.setTitleColor(kUIStyle.colorWithHexString("767676"), for: .normal)
            receiveBtn.backgroundColor = kUIStyle.colorWithHexString("BDBDBD")
            receiveBtn.dsySetBorderr(color: receiveBtn.backgroundColor!, width: 1)
            return
        case .unfinished?: /// 未完成
            //            receiveBtn.setTitle(kLocalized("PickUp"), for: .normal)
            receiveBtn.backgroundColor = UIColor.white
            receiveBtn.setTitleColor(mainColor, for: .normal)
            receiveBtn.dsySetBorderr(color:  mainColor, width: 1)
            return
        case .ToReceive?: /// 待领取
            receiveBtn.setTitle(kLocalized("PickUp"), for: .normal)
            receiveBtn.setTitleColor(kUIStyle.colorWithHexString("ffffff"), for: .normal)
            receiveBtn.backgroundColor = mainColor
            receiveBtn.dsySetBorderr(color:  mainColor, width: 1)
            return
        case .cancel?: /// 过期
            receiveBtn.setTitle("过期", for: .normal)
            receiveBtn.backgroundColor = kUIStyle.colorWithHexString("BDBDBD")
            receiveBtn.setTitleColor(kUIStyle.colorWithHexString("767676"), for: .normal)
            receiveBtn.dsySetBorderr(color:receiveBtn.backgroundColor!, width: 1)
            return
            
        case .none:
            
            return
        }
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        receiveView.width = 80
    }
    func setupUI() {
        //// 页面会有1px的间距显示很奇怪,这样先解决了吧。
        let bacview = UIView()
        bacview.backgroundColor = self.backgroundColor
        contentView.addSubview(bacview)
        bacview.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: -1, left: 0, bottom: -1, right: 0))
        }
        
        icon  = UIImageView()
        icon.backgroundColor = UIColor.gray
        contentView.addSubview(icon)
        
        icon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(kUIStyle.scaleW(60))
            make.left.equalTo(18)
        }
//        icon.dsySetCorner(radius: kUIStyle.scaleW(30))
        icon.isHidden = true
        
        title = UILabel()
        title.textColor =  .black
        title.font = kUIStyle.sysFontDesignSize(size: 30)
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView.snp.centerY)
//            make.left.equalTo(icon.snp.right).offset(18)
             make.left.equalTo(10)
            make.height.equalTo(kUIStyle.scaleH(40))
        }
        
        moneyBtn = UIButton()
        moneyBtn.titleLabel?.font = kUIStyle.sysFontDesignSize(size: 22)
        moneyBtn.setTitleColor(kUIStyle.colorWithHexString("FF6296"), for: .normal)
        moneyBtn.setImage(UIImage(named: "Welfare_db"), for: .normal)
        moneyBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        contentView.addSubview(moneyBtn)
        moneyBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(title)
            make.left.equalTo(title.snp.right).offset(11)
            make.height.equalTo(title)
        }
        
        
        receiveBtn = UIButton()
        receiveBtn.titleLabel?.font = kUIStyle.sysFontDesignSize(size: 26)
        receiveBtn.setTitleColor(kUIStyle.colorWithHexString("FFFFFF"), for: .normal)
        receiveBtn.backgroundColor = mainColor
        //        receiveBtn.setTitle(kLocalized("PickUp"), for: .normal)
        
        receiveBtn.isUserInteractionEnabled = false
        contentView.addSubview(receiveBtn)
        receiveBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
            make.height.equalTo(kUIStyle.scaleH(56))
            make.width.equalTo(kUIStyle.scaleH(130))
        }
        receiveBtn.dsySetCorner(radius: 3)
        receiveBtn.isHidden = true
        
        content = UILabel()
        content.textColor =  kUIStyle.colorWithHexString("BDBDBD")
        content.font = kUIStyle.sysFontDesignSize(size: 22)
        content.textAlignment = .left
        contentView.addSubview(content)
        content.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom)
            make.left.equalTo(title)
            make.height.equalTo(kUIStyle.scaleH(32))
            make.right.lessThanOrEqualTo(receiveBtn.snp.left)
        }
        
        
        receiveBacView = UIView()
        contentView.addSubview(receiveBacView)
        receiveBacView.snp.makeConstraints { (make) in
            make.centerY.equalTo(content)
            make.right.width.equalTo(receiveBtn)
            make.height.equalTo(kUIStyle.scaleH(12))
        }
        receiveBacView.dsySetBorderr(color: mainColor, width: 1)
        receiveBacView.dsySetCorner(radius: kUIStyle.scaleH(6))
        receiveBacView.isHidden = true
        
        receiveView  = UIView()
        receiveView.backgroundColor = mainColor
        contentView.addSubview(receiveView)
        receiveView.dsySetCorner(radius: kUIStyle.scaleH(6))
        receiveView.isHidden = true
        
        progressLable = UILabel()
        progressLable.textColor = mainColor
        progressLable.font = kUIStyle.sysFontDesignSize(size: 26)
        progressLable.textAlignment = .center
        progressLable.adjustsFontSizeToFitWidth = true
        progressLable.minimumScaleFactor = 0.7
        contentView.addSubview(progressLable)
        progressLable.snp.makeConstraints { (make) in
            make.bottom.equalTo(receiveBacView.snp.top).offset(-8)
            make.right.equalTo(receiveBacView)
            make.height.equalTo(kUIStyle.scaleH(36))
            make.width.equalTo(receiveBacView)
        }
        
        let bottomLine = GYLine(frame: CGRect(x: 10, y: bacview.height - gyLine_height, width: contentView.frame.width - 20, height: gyLine_height))
        bottomLine.backgroundColor = UIColor(hex: "#F2F2F2")
        contentView.addSubview(bottomLine)
        
    }
    
    class func getSize() -> CGSize {

        return CGSize(width: screenWidth - 10, height: kUIStyle.scaleH(130))
    }
}


class MQIWelfareCentreNew_userCollectionViewCell: MQICollectionViewCell {
    /// 图标
    var icon:UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.dsySetCorner(radius: 8)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    func setupUI() {
        icon  = UIImageView()
        icon.backgroundColor = UIColor.gray
        contentView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    class func getSize() -> CGSize {
        return CGSize(width: screenWidth-30, height: kUIStyle.scaleH(240))
    }
}
