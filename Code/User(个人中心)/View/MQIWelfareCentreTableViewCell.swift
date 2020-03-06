//
//  MQIWelfareCentreTableViewCell.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/9/12.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


enum receiveType {
    case btn
    case Progress
}

/// 书架选中状态
enum WelfareState:String {
    case complete   = "already_received"/// 完成
    case unfinished = "hang_in_the_air" /// 未完成
    case ToReceive  = "receive" /// 待领取
    case cancel  = "cancel" /// 过期
}

class MQIWelfareCentreTableViewCell: MQITableViewCell {

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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        receiveView.width = 80
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        icon  = UIImageView()
        icon.backgroundColor = UIColor.gray
        contentView.addSubview(icon)
   
        icon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(kUIStyle.scaleW(60))
            make.left.equalTo(18)
        }
        icon.dsySetCorner(radius: kUIStyle.scaleW(30))
        
        title = UILabel()
        title.textColor =  kUIStyle.colorWithHexString("323333")
        title.font = kUIStyle.sysFontDesignSize(size: 30)
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView.snp.centerY)
            make.left.equalTo(icon.snp.right).offset(18)
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
            make.right.equalTo(-18)
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
        receiveBacView.dsySetBorderr(color: kUIStyle.colorWithHexString("AAAAAA"), width: 1)
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
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
