//
//  MQIUserViewController.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/6/27.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit
import FSPagerView

class MQIUserViewController: MQIBaseViewController {

    /// 本地分类数据
    fileprivate var infoDatas = [[[String: String]]]()
    var gtableView: MQITableView!
    var loginOutBlock: (() -> ())?
    /// 隐藏Cell
    var isHiddenCell: Bool = false
    fileprivate var needRefreshCoin: Bool = false

    var headerView: UIView!
    fileprivate var customNavView: UIView!
    fileprivate var numberOfMessageLabel: UILabel!
    var adsenseView = UserAdsenseView()
    /// 有 未支付订单的 标识
    fileprivate var order_tag: String? {
        didSet(oldValue) {
            gtableView.reloadData()
        }
    }
    /// 小红点提示
    var notificationModel = MQINotificationModel() {
        didSet(oldValue) {
            MQIUserOperateManager.shared.isOtherPay = notificationModel.pay.multiparty
            setMessageNum(addContentText("to_messageCenter"))
            gtableView.reloadData()
        }
    }

    var popupAdsenseModel = MQIPopupAdsenseModel() {
        didSet(oldValue) {
            if popupAdsenseModel.total != 0 {
                // 有数据
                gtableView.reloadData()
            } else {

            }
        }
    }

    lazy var viewPager: FSPagerView = {
        let viewPager = FSPagerView()
        viewPager.frame = CGRect(x: 20, y: 20, width: screenWidth - 40, height: 99)
        viewPager.dsySetCorner(radius: 6)
        viewPager.dataSource = self
        viewPager.delegate = self
        viewPager.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cellId")
        //设置自动翻页事件间隔，默认值为0（不自动翻页）
        viewPager.automaticSlidingInterval = 3.0
        //设置页面之间的间隔距离
        viewPager.interitemSpacing = 8.0
        //设置可以无限翻页，默认值为false，false时从尾部向前滚动到头部再继续循环滚动，true时可以无限滚动
        viewPager.isInfinite = true
//        //设置转场的模式
//        viewPager.transformer = FSPagerViewTransformer(type: FSPagerViewTransformerType.depth)

        return viewPager
    }()

    lazy var pagerControl: FSPageControl = {
        let pageControl = FSPageControl(frame: CGRect(x: 50, y: 70, width: 80, height: 20))
        //设置下标的个数
        pageControl.numberOfPages = 8
        //设置下标位置
        pageControl.contentHorizontalAlignment = .center
        //设置下标指示器边框颜色（选中状态和普通状态）
        pageControl.setStrokeColor(.white, for: .normal)
        pageControl.setStrokeColor(.gray, for: .selected)
        //设置下标指示器颜色（选中状态和普通状态）
        pageControl.setFillColor(.white, for: .normal)
        pageControl.setFillColor(.gray, for: .selected)
        //设置下标指示器图片（选中状态和普通状态）
        //pageControl.setImage(UIImage.init(named: "1"), for: .normal)
        //pageControl.setImage(UIImage.init(named: "2"), for: .selected)
        //绘制下标指示器的形状 (roundedRect绘制绘制圆角或者圆形)
        pageControl.setPath(UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: 5, height: 5), cornerRadius: 4.0), for: .normal)
        //pageControl.setPath(UIBezierPath(rect: CGRect(x: 0, y: 0, width: 8, height: 8)), for: .normal)
        pageControl.setPath(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 5, height: 5)), for: .selected)
        return pageControl

    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        hiddenNav()
        contentView.frame = CGRect(x: 0,
            y: 0,
            width: view.width,
            height: view.height - x_TabbarHeight)

        addTop()
        UserNotifier.addObserver(self, selector: #selector(MQIUserViewController.refreshCurrentContent), notification: .login_in)
        UserNotifier.addObserver(self, selector: #selector(MQIUserViewController.refreshCurrentContent), notification: .login_out)
        UserNotifier.addObserver(self, selector: #selector(MQIUserViewController.refreshCoin), notification: .refresh_coin)
        UserNotifier.addObserver(self, selector: #selector(MQIUserViewController.judge_signdFinish), notification: .sign_finish)

        infoConfig()/// 配置数据
        addTable() /// 添加table
        gtableView.frame = contentView.bounds

        checkHeader()/// 设置金额视图


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isHiddenCell = !MQIPayTypeManager.shared.isAvailable()
        if needRefreshCoin {
            needRefreshCoin = false
        } else {
            userInfo_RequestCoin({ (suc, msg) in
            })
        }
        checkHeader()
        getUserUsercenterNotification()
        getPopupAdsenseList()
    }


    override func switchLanguage() {
        super.switchLanguage()
        infoConfig()
        checkHeader()
        gtableView.reloadData()
    }
    /// 上部导航栏
    func addTop() {

        customNavView = UIView(frame: CGRect (x: 0, y: 0, width: screenWidth, height: x_statusBarAndNavBarHeight))
        customNavView.backgroundColor = UIColor.white
        view.addSubview(customNavView)

//        let  searchbutton = view.addCustomButton(CGRect.init(x: 20, y:kUIStyle.kStatusBarHeight+15, width: 40, height: 40), title: nil, action: {[weak self] (btn) in
//            if let weakSelf = self{
//                weakSelf.goSettingVC()
//            }
//        })
//
//        let image =  UIImage(named: "CHK_info_SetUp_image")?.withRenderingMode(.alwaysTemplate)
//        searchbutton.setImage(image, for: .normal)
//        searchbutton.tintColor = UIColor.black
//        searchbutton.contentHorizontalAlignment = .right
//        searchbutton.contentVerticalAlignment = .bottom
//        customNavView.addSubview(searchbutton)

        let messageButton = view.addCustomButton(CGRect.init(x: customNavView.width - 62, y: kUIStyle.kStatusBarHeight + 15, width: 40, height: 40), title: nil, action: { [weak self] (btn) in
                if let weakSelf = self {
                    weakSelf.goMessageVC()
                }
            })
        let messageImage = UIImage(named: "CHK_info_msg_image")?.withRenderingMode(.alwaysTemplate)
        messageButton.setImage(messageImage, for: .normal)
        messageButton.tintColor = UIColor.black
        customNavView.addSubview(messageButton)
        messageButton.contentHorizontalAlignment = .right
        messageButton.contentVerticalAlignment = .bottom

//        searchbutton.maxY = customNavView.height
        messageButton.maxY = customNavView.height
        messageButton.maxX = customNavView.width - 20
//        searchbutton.maxX = messageButton.x-30


        numberOfMessageLabel = UILabel()
        numberOfMessageLabel.font = UIFont.systemFont(ofSize: 7)
        numberOfMessageLabel.textColor = UIColor.white
        numberOfMessageLabel.dsySetCorner(radius: 6)
        numberOfMessageLabel.textAlignment = .center
        numberOfMessageLabel.backgroundColor = UIColor.colorWithHexString("EB5567")
        customNavView.addSubview(numberOfMessageLabel)
        guard let masgImg = messageButton.imageView else { return }
        numberOfMessageLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(masgImg.snp.top)
            make.width.height.equalTo(12)
            make.centerX.equalTo(masgImg.snp.right)
        }
        setMessageNum("")

    }

    func setMessageNum(_ num: String) {
        if num == "" || num == "0" {
            numberOfMessageLabel.isHidden = true
            return
        } else {
            numberOfMessageLabel.isHidden = false
        }
        guard let num = Int(num) else { return }
        numberOfMessageLabel.text = (num > 99) ? "99" : "\(num)"

    }


    func addTable() -> Void {

        headerView = UIView(frame: CGRect (x: 0, y: 0, width: screenWidth, height: 240 + x_statusBarAndNavBarHeight))
        let footerView = UIView(frame: CGRect (x: 0, y: 0, width: screenWidth, height: 50))

        gtableView = MQITableView()
        contentView.addSubview(gtableView)
        gtableView.backgroundColor = RGBColor(244, g: 244, b: 244)
        gtableView.tableHeaderView = headerView
        gtableView.tableFooterView = footerView
        gtableView.separatorStyle = .none
        gtableView.showsVerticalScrollIndicator = false
        gtableView.gyDelegate = self
        gtableView.registerCell(MQIListItemTableViewCell.self, xib: false)
        gtableView.registerCell(MQIUserInfoMoneyUITableViewCell.self, xib: false)
        gtableView.frame = contentView.bounds
        if #available(iOS 11.0, *) {
            gtableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }

    }



    @objc func refreshCurrentContent() {
        MQISignManager.shared.refresh()
        userInfoHeaderViewCell?.reloadView()
        UIView.performWithoutAnimation {
            self.gtableView.reloadData()
        }
    }


    fileprivate var userInfoHeaderViewCell: MQIUserInfoHeaderView?

    func checkHeader() {

        if userInfoHeaderViewCell == nil {
            userInfoHeaderViewCell = MQIUserInfoHeaderView(frame: headerView.bounds)
            headerView.addSubview(userInfoHeaderViewCell!)
        }
        if MQIUserManager.shared.checkIsLogin() == false {
            userInfoHeaderViewCell?.isLogin = false
            userInfoHeaderViewCell?.tapActionBlock = { [weak self]() -> Void in
                if let weakSelf = self {
                    weakSelf.userInfo_toLoginVC()
                }

            }
        } else {
            userInfoHeaderViewCell?.isLogin = true
            userInfoHeaderViewCell!.user = MQIUserManager.shared.user!
            userInfoHeaderViewCell?.tapActionBlock = { [weak self]() -> Void in
                if let weakSelf = self {
                    let userDetailVC = MQIUserDetailViewController.create() as! MQIUserDetailViewController
                    userDetailVC.loginOutBlock = { [weak self]() -> Void in
                        if let weakSelf = self {
                            weakSelf.loginOut()
                        }
                    }
                    weakSelf.pushVC(userDetailVC)
                }
            }
        }
        userInfoHeaderViewCell?.tapActionPayBlock = { [weak self]() -> Void in
            if let weakSelf = self {
                if MQIUserManager.shared.checkIsLogin() {
                    weakSelf.userInfoJumpVC("to_Pay")
                } else {
                    MQIloginManager.shared.toLogin(kLocalized("SorryYouHavenLoggedInYet"), finish: { [weak self]() -> Void in
                            if let weakSelf = self {
                                weakSelf.userInfoJumpVC("to_Pay")
                            }
                        })
                }
            }

        }
        userInfoHeaderViewCell?.tapActionGivingBlock = { [weak self]() -> Void in
            if let weakSelf = self {
                if MQIUserManager.shared.checkIsLogin() {
                    weakSelf.userInfoJumpVC("to_Giving_records")
                } else {
                    MQIloginManager.shared.toLogin(kLocalized("SorryYouHavenLoggedInYet"), finish: { [weak self]() -> Void in
                            if let weakSelf = self {
                                weakSelf.userInfoJumpVC("to_Giving_records")
                            }
                        })
                }
            }

        }

        userInfoHeaderViewCell?.tapActionSignBlock = {
            MQIUserOperateManager.shared.toSignVC()
        }
        userInfoHeaderViewCell?.tapActionCardBlock = {
            MQIOpenlikeManger.toDCVC()
        }

    }

    @objc func judge_signdFinish() {
        gtableView.reloadData()
    }
    @objc func refreshCoin() {
        needRefreshCoin = true
        userInfo_RequestCoin({ (suc, msg) in
        })


    }

    deinit {
        mqLog("MQIUserInfo dealloc")

    }
}


extension MQIUserViewController: MQITableViewDelegate {

    //MARK:  tableView代理
    func numberOfTableView(_ tableView: MQITableView) -> Int {
        return infoDatas.count
    }
    func numberOfRow(_ tableView: MQITableView!, section: Int) -> Int {

        return infoDatas[section].count
    }
    func heightForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> CGFloat {
        if !MQIPayTypeManager.shared.isAvailable() {
            let jumpLogo = infoDatas[indexPath.section][indexPath.row]["jumpLogo"]
            if cellHidden(jumpLogo) {
                return 0
            }
        }

        return MQIListItemTableViewCell.getHeight(nil)

    }
    func heightForFooter(_ tableView: MQITableView!, section: NSInteger) -> CGFloat {

        if section == infoDatas.count - 1 {
            return 0
        } else if section == 0 && self.popupAdsenseModel.total != 0 {
            return 120
        } else {
            return 10
        }

    }
    func viewForFooter(_ tableView: MQITableView!, section: NSInteger) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 10))
        view.backgroundColor = UIColor.colorWithHexString("#F8F8F8")
        if section == 0 && self.popupAdsenseModel.total != 0 {
            let view = UIView()
            view.backgroundColor = .white
            view.frame = CGRect(x: 20, y: 10, width: tableView.bounds.width - 40, height: 120)
            view.addSubview(self.viewPager)
            self.pagerControl.numberOfPages = self.popupAdsenseModel.total
            view.addSubview(self.pagerControl)
            pagerControl.snp.makeConstraints { (make) in
                make.right.equalTo(-10)
                make.bottom.equalTo(0)
                make.width.equalTo(80)
                make.height.equalTo(20)
            }
            return view
        }
        return view
    }
    func cellForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(MQIListItemTableViewCell.self, forIndexPath: indexPath)
        let title = infoDatas[indexPath.section][indexPath.row]["title"]
        cell.addUserInfoNext()
        let typeimage = UIImage(named: infoDatas[indexPath.section][indexPath.row]["img"]!)
        cell.icon.image = typeimage
        //            cell.icon.tintColor = layerColor
        cell.titleLabel.text = title
        let jumpLogo = infoDatas[indexPath.section][indexPath.row]["jumpLogo"]
        if isHiddenCell {
            if cellHidden(jumpLogo) {
                cell.contentView.isHidden = true
            } else {
                cell.contentView.isHidden = false
            }
        }

        cell.addContentLabel(addContentText(jumpLogo))
//        cell.setRedCount(num: addContentText(jumpLogo))
//        if infoDatas[indexPath.section][indexPath.row]["jumpLogo"] == "to_messageCenter" && notificationModel.message_center.show {
//            cell.redCount.isHidden = false
//        } else {
//            cell.redCount.isHidden = true
//        }

        if jumpLogo == "to_Help_Feedback" {
            cell.addNoticeView()
            cell.noticeView?.isHidden = !notificationModel.feedback.show
        }

        if jumpLogo == "to_Pay" {
            cell.addNoticeView()
            cell.noticeView?.isHidden = (self.order_tag == nil) ? true : false
        }
        return cell

    }
    
    func didSelectRowAtIndexPath(_ tableView: MQITableView!, indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let jumpLogo = infoDatas[indexPath.section][indexPath.row]["jumpLogo"]
        if jumpLogo == "" || jumpLogo == nil { return }

        if needToLogin(jumpLogo) {
            if MQIUserManager.shared.checkIsLogin() {
                userInfoJumpVC(jumpLogo)
            } else {
                MQIloginManager.shared.toLogin(kLocalized("SorryYouHavenLoggedInYet"), finish: { [weak self]() -> Void in
                        if let weakSelf = self {
                            weakSelf.userInfoJumpVC(jumpLogo)
                        }
                    })
            }
        } else {
            userInfoJumpVC(jumpLogo)
        }
    }
}
//MARK:操作方法
extension MQIUserViewController {
    func toVC(_ vc: UIViewController) {
        pushVC(vc)

    }

    @objc func goSettingVC() {
        let setVC = MQIUserSettingViewController.create()!
        toVC(setVC)
    }
    @objc func goMessageVC() {
        let setVC = MQIMessageCenterViewController()
        if MQIUserManager.shared.checkIsLogin() {
            toVC(setVC)
        } else {
            let loginVC = MQILoginViewController.create() as! MQILoginViewController
            loginVC.finishBlock = { [weak self] in
                self?.toVC(setVC)
            }
            toVC(loginVC)
        }


    }


    func getCell(indexPath: IndexPath) -> UITableViewCell? {
        return gtableView.cellForRow(at: indexPath)
    }

    //隐藏cell
    func cellHidden(_ jumpLogo: String? = "") -> Bool {
        switch jumpLogo {
        case"to_Reward_record"/*打赏记录*/, "to_Conversion_Code"/*兑换码*/:
            return !MQIPayTypeManager.shared.isAvailable()
        default:
            return false
        }
    }

    ///右边文字显示
    func addContentText(_ jumpLogo: String? = "") -> String {
        switch jumpLogo {
        case"to_Pay"/*充值*/:
            if notificationModel.pay.show && MQIPayTypeManager.shared.isAvailable() {
                return notificationModel.pay.message
            } else {
                return ""
            }

        case"to_Welfare_Centre"/*福利中心*/:
            if notificationModel.task_daily.show {
                return notificationModel.task_daily.message
            } else {
                return ""
            }
        case"to_Help_Feedback"/*反馈帮助*/:
            if notificationModel.feedback.show {
                return notificationModel.feedback.message
            } else {
                return ""
            }
        case"to_messageCenter"/*消息数*/:
            if notificationModel.message_center.show {
                return notificationModel.message_center.unread_num
            } else {
                return ""
            }

        default:
            return ""
        }
    }


    func showNoticeView(_ jumpLogo: String? = "") -> Bool {
        switch jumpLogo {
        case"to_Help_Feedback"/*反馈帮助*/:
            return notificationModel.feedback.show
//        case"to_Welfare_Centre"/*福利中心*/:
//             return notificationModel.feedback.show
        default:
            return false
        }
    }

    func needToLogin(_ jumpLogo: String? = "") -> Bool {
        
        switch jumpLogo {
        case "to_BusinessContact", "to_Help_Feedback", "to_Event","to_Reading_Records","to_Conversion_Code","to_MyAccount":
            return true
        default:
            return false
        }
    }
    func userInfo_toLoginVC() {
        let loginVC = MQILoginViewController.create() as! MQILoginViewController
        loginVC.finishBlock = { () -> Void in
            loginVC.popVC()

        }
        self.toVC(loginVC)
    }

    /// 根据定义好的标识跳转
    func userInfoJumpVC(_ jumpLogo: String? = "") {

        switch jumpLogo {
        case "to_Pay": /// 充值
            MQIOpenlikeManger.toPayVC(toPayChannel: .normalToPay, nil)
            return
        case "to_coupons": /// 优惠券
            let couponsVC = MQICouponVC()//优惠
            toVC(couponsVC)
            return
        case "to_Giving_records": /// 赠送记录
            let remiumListVC = MQIPremiumListViewController.create()!
            toVC(remiumListVC)
            return
        case "to_Welfare_Centre": /// 福利中心
            let welfareCentreVC = MQIWelfareCentreViewController()
            toVC(welfareCentreVC)
            return
        case "to_Recharge_Record": /// 充值记录
            let vc = MQIUserPayListViewController.create()!//充值记录
            toVC(vc)
            return
        case "to_Subscription_Record": /// 订阅记录
            let vc = MQIUserConsumeViewController.create()! //订阅记录
            toVC(vc)
            return
        case "to_Reading_Records": /// 网络阅读记录
            let vc = MQIUserReadRecordViewController()//阅读记录
            vc.title = kLocalized("The_books_I_read")
            toVC(vc)
            return
        case "to_Reward_record": /// 打赏记录
            let vc = MQIRewardLogList()//打赏记录
            toVC(vc)
            return
        case "to_Help_Feedback": /// 帮助与反馈
            let vc = MQIUserHelpVC()/// 帮助与反馈
            vc.title = kLocalized("feedback")
            vc.url = feedBackHttpURL()
            toVC(vc)
            return

        case "to_Share": ///分享
            MQISocialManager.shared.sharedApp()
            return
        case "to_BusinessContact": ///商务联系
            toVC(MQIAboutViewController.create()!)
            return
        case "to_My_Collection": ///我的收藏
            toVC(MQIAddToViewController())
            return

        case "to_customer_service":
            MQIOpenlikeManger.toQIYU()
            return

        case "to_facebook":
            let fbURL = "https://m.facebook.com/%E4%BC%A0%E5%A5%87%E4%B9%A6%E5%9F%8E-328745117640590/"
            guard let url = URL(string: fbURL) else { return }
            UIApplication.shared.openURL(url)
            return
        case "to_MyAccount": ///我的账户
            toVC(MQIMAccountInfoViewController())
            return
        case "to_Set": ///设置
            goSettingVC()
            return
        case "to_Conversion_Code": /// 兑换
            toVC(MQIConversionCodeViewController())
            return
        case "to_Event": /// 活动中心
            toVC(MQIEventCenterViewController())
            return
        default:
            return
        }

    }

    func loginOut() {
        MQIUserManager.shared.loginOut("") { [weak self] (suc) in
            MQILoadManager.shared.makeToast(kLocalized("AccountHasBeenLoggedOut"))
            if let strongSelf = self {
                strongSelf.userInfo_toLoginVC()
            }
        }
    }

    /// 获取时间戳
    func getNowTime (date: NSDate? = NSDate()) -> Int {
        return Int(date!.timeIntervalSince1970)
    }


    //MARK:   用户中心 配置
    func infoConfig() -> Void {
        infoDatas = [
            [
                ["title": kLocalized("Recharge", describeStr: "充值"),
                    "img": "CHK_info_pay_image",
                    "jumpLogo": "to_Pay"
                ],
                ["title": kLocalized("WelfareCentre", describeStr: "福利中心"),
                    "img": "CHK_info_Welfare_image",
                    "jumpLogo": "to_Welfare_Centre"
                ],

            ],
            [
                ["title": kLocalized("event_center", describeStr: "活动中心"),
                    "img": "CHK_event_center",
                    "jumpLogo": "to_Event"
                ],

                ["title": kLocalized("MyAccount", describeStr: "我的账户"),
                    "img": "CHK_info_account_image",
                    "jumpLogo": "to_MyAccount"
                ],
                ["title": kLocalized("The_books_I_read", describeStr: "我读过的书"),
                    "img": "CHK_info_Reading_Records_image",
                    "jumpLogo": "to_Reading_Records"
                ],
            ],
            [

                ["title": kLocalized("customerService", describeStr: "客服中心"),
                    "img": "CHK_customer_service_image",
                    "jumpLogo": "to_customer_service"
                ],
                ["title": kLocalized("FeedbackEenter", describeStr: "反馈"),
                    "img": "CHK_info_Feedback_image",
                    "jumpLogo": "to_Help_Feedback"
                ],
                ["title": kLocalized("exchange_code", describeStr: "兑换码"),
                    "img": "CHK_conversion_code-1",
                    "jumpLogo": "to_Conversion_Code"
                ],
                ["title": kLocalized("ShareWithYourFriends", describeStr: "分享"),
                    "img": "CHK_info_service_image",
                    "jumpLogo": "to_Share"
                ],
//
                ["title": kLocalized("Set", describeStr: "设置"),
                    "img": "user_info_sz_img",
                    "jumpLogo": "to_Set"
                ]


            ]
        ]


    }
}

//MARK:  数据请求
extension MQIUserViewController {

    //刷新余额
    func userInfo_RequestCoin(_ completion: ((_ suc: Bool, _ msg: String) -> ())?) {
        MQIUserManager.shared.updateUserInfo { (_, _) in
            self.checkHeader()
        }
        MQIUserDiscountCardInfo.reload(isMandatory: true) {
            self.checkHeader()
        }
    }

    /// 人中心\红点提示
    func getUserUsercenterNotification() -> Void {
        MQIGetUserNotification()
            .request({ [weak self] (request, response, result: MQINotificationModel) in
                self?.notificationModel = result

            }) { (errorMsg, errorCode) in
                mqLog("\(errorMsg)")
        }

        /// 是否有未支付的订单
        MQIIAPManager.shared.query_order { [weak self] (model) in
            if model == nil {
                self?.order_tag = nil
            } else {
                self?.order_tag = "1"
            }
        }
    }

    func getPopupAdsenseList() {
        MQIPopupAdsenseRequest(pop_position: "19").request({ [weak self](request, response, result: MQIPopupAdsenseModel) in
            self?.popupAdsenseModel = result
        }) { (err_msg, err_code) in

            MQILoadManager.shared.makeToast(err_msg)
        }
    }
}

extension MQIUserViewController: FSPagerViewDelegate, FSPagerViewDataSource {

    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.popupAdsenseModel.popupAdsenseList.count
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cellId", at: index)
        if self.popupAdsenseModel.popupAdsenseList.count > 0 {
            let model = self.popupAdsenseModel.popupAdsenseList[index]
            cell.imageView?.sd_setImage(with: URL(string: model.image), placeholderImage: UIImage(named: goodBookPlaceHolderImg), options: [], completed: nil)
        }
        return cell
    }

    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        MQIOpenlikeManger.openLike(self.popupAdsenseModel.popupAdsenseList[index].url)
    }

    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pagerControl.currentPage = targetIndex
    }

    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pagerControl.currentPage = pagerView.currentIndex
    }

}

