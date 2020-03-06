//
//  MQIMAccountInfoViewController.swift
//  TSYQKReader
//
//  Created by moqing on 2018/10/23.
//  Copyright © 2018 _CHK_. All rights reserved.
//

import UIKit
var udc_model: MQIUserDiscountCardInfo?
class MQIMAccountInfoViewController: MQIBaseViewController {
    /// 本地分类数据
    fileprivate var infoDatas = [[[String:String]]]()
    var gtableView:MQITableView!
    var infoHeaderView: DiscountCardInfoView!
    /// 隐藏Cell
    var  isHiddenCell:Bool  = false
    fileprivate var needRefreshCoin: Bool = false
    /// 小红点提示
    var notificationModel = MQINotificationModel() {
        didSet(oldValue) {
            MQIUserOperateManager.shared.isOtherPay = notificationModel.pay.multiparty
            gtableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = kLocalized("MyAccount")
         UserNotifier.addObserver(self, selector: #selector(MQIMAccountInfoViewController.refreshCoin), notification: .refresh_coin)
        
        if MQIPayTypeManager.shared.type == .inPurchase {
            isHiddenCell = true
        }else{
            isHiddenCell = false
        }
        infoConfig()/// 配置数据
        addTableView()
        reloadHead()
//        addHeaderView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserUsercenterNotification()
        
//        MQIMydiscountsimpleRequest().request({ (_, _, udc: MQIUserDiscountCardInfo) in
////            guard !udc.discount_desc.isEmpty else { return }
//            udc_model = udc
//            self.reloadHead()
//            self.gtableView.reloadData()
//        }, failureHandler: { (msg, code) in
//            udc_model = MQIUserDiscountCardInfo()
//            self.reloadHead()
//            self.gtableView.reloadData()
//        })
    }
    
    func addTableView() -> Void {
        gtableView = MQITableView()
        contentView.addSubview(gtableView)
        gtableView.separatorStyle = .none
        gtableView.showsVerticalScrollIndicator = false
        gtableView.gyDelegate = self
        gtableView.registerCell(MQIListItemTableViewCell.self, xib: false)
        gtableView.frame = contentView.bounds
        let backView = UIView(frame: CGRect (x: 0, y: -1000, width: screenWidth, height: 1000))
        backView.layer.addDefineLayer(backView.bounds)
        gtableView.addSubview(backView)
        
        
    }

    func reloadHead() {
        guard MQIPayTypeManager.shared.isAvailable() else { return }
        guard !(udc_model?.isVip ?? true) else {
            gtableView.tableHeaderView = nil
            infoHeaderView = nil
            return
        }
        if gtableView.tableHeaderView == nil {
            let height = (screenWidth - 48) * 90 / 335
            let  headerView = UIView(frame: CGRect (x: 0, y: 0, width: screenWidth, height: height + 20))
            gtableView.tableHeaderView = headerView
            
            let headerBacView = DiscountCardInfoView(frame: CGRect(x: 26, y: 20, width: headerView.width - 48, height: height))
            headerView.addSubview(headerBacView)
            infoHeaderView = headerBacView
        }
        infoHeaderView?.detailedLabel.text = udc_model?.desc
        infoHeaderView?.timeLabel.text = "\(kLocalized("DueTime", describeStr: "到期时间"))：\(getTimeStampToString(udc_model?.expiry_time ?? ""))"
        
        
    }


}
extension MQIMAccountInfoViewController  {
    class DiscountCardInfoView: UIView {
        
        
        var detailedLabel: UILabel!
        var timeLabel: UILabel!
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupUI()
        }
        
        func setupUI() {
            let bg = UIImageView(frame: bounds)
            bg.image = #imageLiteral(resourceName: "my_count_dcInfo_bg")
            addSubview(bg)
            let titleLabel = createLabel(CGRect(x: 18, y: 15, width: screenWidth - 36, height: 25),
                                         font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium),
                                         bacColor: .clear,
                                         textColor: #colorLiteral(red: 0.537254902, green: 0.2549019608, blue: 0.05098039216, alpha: 1),
                                         adjustsFontSizeToFitWidth: false,
                                         textAlignment: .left,
                                         numberOfLines: 0)
            titleLabel.text = kLocalized("discountCardTitle", describeStr: "已开通畅读打折卡")
            addSubview(titleLabel)
            detailedLabel = createLabel(CGRect(x: 18, y: titleLabel.maxY + 2, width: screenWidth - 36, height: 16),
                                            font: UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.medium),
                                            bacColor: .clear,
                                            textColor: #colorLiteral(red: 0.537254902, green: 0.2549019608, blue: 0.05098039216, alpha: 1),
                                            adjustsFontSizeToFitWidth: false,
                                            textAlignment: .left,
                                            numberOfLines: 0)
            addSubview(detailedLabel)
            
            
            timeLabel = createLabel(CGRect(x: 18, y: detailedLabel.maxY + 2, width: screenWidth - 36, height: 16),
                                        font: UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.medium),
                                        bacColor: .clear,
                                        textColor: #colorLiteral(red: 0.537254902, green: 0.2549019608, blue: 0.05098039216, alpha: 1),
                                        adjustsFontSizeToFitWidth: false,
                                        textAlignment: .left,
                                        numberOfLines: 0)
            addSubview(timeLabel)
            
            
        }
    }
    
    
}

extension MQIMAccountInfoViewController:MQITableViewDelegate {
    
    func numberOfTableView(_ tableView: MQITableView) -> Int {
        return infoDatas.count
    }
    func numberOfRow(_ tableView: MQITableView!, section: Int) -> Int {
        
        return infoDatas[section].count
    }
    func heightForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> CGFloat {
        if isHiddenCell {
            if cellHidden(infoDatas[indexPath.section][indexPath.row]["jumpLogo"]){
                return 0
            }
        }
        return MQIListItemTableViewCell.getHeight(nil)
        
    }
    func cellForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(MQIListItemTableViewCell.self, forIndexPath: indexPath)
        let title = infoDatas[indexPath.section][indexPath.row]["title"]
        cell.addUserInfoNext()
        let typeimage = UIImage(named: infoDatas[indexPath.section][indexPath.row]["img"]!)
        cell.icon.image = typeimage
        cell.titleLabel.text = title
        let jumpLogo = infoDatas[indexPath.section][indexPath.row]["jumpLogo"]
        if isHiddenCell {
            if cellHidden(jumpLogo){
                cell.contentView.isHidden = true
            }else{
                cell.contentView.isHidden = false
            }
        }
//        if infoDatas[indexPath.section][indexPath.row]["jumpLogo"] == "to_messageCenter" && notificationModel.message_center.show {
//            cell.redCount.isHidden = false
//        } else {
//            cell.redCount.isHidden = true
//        }
        
        return cell
    }
    
  
    func didSelectRowAtIndexPath(_ tableView: MQITableView!, indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        userInfoJumpVC(infoDatas[indexPath.section][indexPath.row]["jumpLogo"])
        
    }
    
    
    //隐藏cell
    func cellHidden(_ jumpLogo:String? = "") -> Bool {
        switch jumpLogo {
        case"to_Reward_record"/*打赏记录*/:
            return true
        default:
            return false
        }
    }
    func toVC(_ vc: UIViewController) {
        pushVC(vc)
        
    }
    
    /// 根据定义好的标识跳转
    func userInfoJumpVC(_ jumpLogo:String? = "") {
        switch jumpLogo {
        case "to_Pay" : /// 充值
            MQIUserOperateManager.shared.toPayVC(toPayChannel: .normalToPay, nil)
            return
        case "to_Recharge_Record" : /// 充值记录
            let vc = MQIUserPayListViewController.create()!//充值记录
            toVC(vc)
            return
        case "to_Giving_records" : /// 赠送记录
            let remiumListVC = MQIPremiumListViewController.create()!//优惠
            toVC(remiumListVC)
            return
        case "to_Subscription_Record" : /// 订阅记录
            let vc = MQIUserConsumeViewController.create()!//订阅记录
            toVC(vc)
            return
        case "to_Reward_record" : /// 打赏记录
            let vc = MQIRewardLogList()//打赏记录
            toVC(vc)
            return
        case "to_CardCoupon_Record" : ///卡券列表
            let vc = MQICardCouponViewController()
            toVC(vc)
            return
        default:
            return
        }
        
    }
    
    @objc func refreshCoin() {
//        infoHeaderView.moneyUser = MQIUserManager.shared.user
//        MQIUserManager.shared.userInfo_RequestCoin {[weak self] (suc, msg) in
//            if suc {
//                self?.infoHeaderView.moneyUser = MQIUserManager.shared.user
//            }
//        }
        
        
    }
    
    
    func infoConfig() -> Void {
        
        infoDatas = [
            [
                ["title":kLocalized("PrepaidPhoneRecords"),
                 "img":"CHK_info_payList_image",
                 "jumpLogo":"to_Recharge_Record"
                ],
                ["title": kLocalized("ComplimentaryRecord"),
                 "img":"CHK_info_PresentList_image",
                 "jumpLogo":"to_Giving_records"
                ],
                ["title":kLocalized("ExceptionalRecord"),
                 "img":"CHK_info_ConsumerList_image",
                 "jumpLogo":"to_Reward_record"
                ],
                ["title":kLocalized("SubscribeToTheRecord"),
                 "img":"CHK_info_SubscribeList_image",
                 "jumpLogo":"to_Subscription_Record"
                ],
                ["title":kLocalized("CardCouponRecord"),
                 "img":"CHK_info_CardCoupon_image",
                 "jumpLogo":"to_CardCoupon_Record"]
            ]
        ]
    }
}
//MARK:  数据请求
extension MQIMAccountInfoViewController {
    
    //刷新余额
    func userInfo_RequestCoin(_ completion: ((_ suc: Bool, _ msg: String) -> ())?) {
        MQIUserManager.shared.updateUserCoin(completion)
    }
    
    /// 人中心\红点提示
    func getUserUsercenterNotification() -> Void {
        MQIGetUserNotification()
            .request({[weak self]  (request, response, result:MQINotificationModel ) in
                self?.notificationModel = result
                
            }) { (errorMsg, errorCode) in
                mqLog("\(errorMsg)")
        }
    }
    
    
}
