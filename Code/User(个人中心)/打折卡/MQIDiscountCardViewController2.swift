//
//  MQIDiscountCardViewController2.swift
//  CQSC
//
//  Created by moqing on 2019/7/4.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

enum DiscountCardType {
    case buy /// 未购买
    case have /// 已拥有
}

let card_LeftMargin:CGFloat = 37
let card_LeftMargin2:CGFloat = 22
class MQIDiscountCardViewController2: MQIBaseViewController {

    var type:DiscountCardType  = .buy{
        didSet(oldValue) {
//             getData()
        }
    }
    fileprivate var tableView:MQITableView!
    fileprivate var fixedData = [[String:String]]()
    fileprivate var customNavView:UIView!
    fileprivate var headerView:MQICardHeaderView!
    fileprivate var footerView:MQICardFooterView!
    fileprivate var textView:UITextView!
    fileprivate var dicModel: MQIDiscountCardInfo = MQIDiscountCardInfo(){
        didSet(oldValue) {
            product_id = dicModel.product_id
            headerView.type = type
//            tableView.tableHeaderView = headerView
            headerView.cardBacView.sd_setImage(with: URL(string: dicModel.buy_image_url))
            headerView.moneyLabel.text =  dicModel.currencyStr+dicModel.priceStr+"/\(kLocalized("month"))"
            if  dicModel.rule_desc.count > 0 {
                footerView.contentText = dicModel.rule_desc
                 tableView.tableFooterView = footerView
            }

            if dicModel.privileges.count > 0 {
                setProvisionsData(type: "Card_identity_cell", key: "row", value: "\(dicModel.privileges.count)")
            }
            
            rank_strArr.removeAll()
            for model in  dicModel.discount_rank {
                rank_strArr.append(["title":"用户\(model.user_nick)累计已","sub_title":"节省\(model.reduction_coin)\(COINNAME)"])
            }
           
            if rank_strArr.count > 0 {
                setProvisionsData(type: "Card_Title_cell", key: "sectionheightForHeader", value: "39")
                
            }
            
            self.tableView.reloadData()
            
        }
    }
    
    
    fileprivate var dicInfoModel: MQIDiscountCardInfo = MQIDiscountCardInfo(){
        didSet(oldValue) {
            product_id = dicInfoModel.product_id
//            tableView.tableHeaderView = headerView
            headerView.cardBacView.sd_setImage(with: URL(string: dicInfoModel.bought_image_url))
            guard let user  = MQIUserManager.shared.user else {
                return
            }
            headerView.nameLabel.text = user.user_nick
            
           
            headerView.headIconImg.sd_setImage(with: URL(string: user.user_avatar),
                                               placeholderImage: UIImage(named: "mine_header"),
                                               options: .allowInvalidSSLCertificates,
                                               completed: { (i, error, type, u) in
                                                
            })
            headerView.openBtn.setTitle(kLocalized("Immediately_a_renewal"), for: .normal)
            
            if dicInfoModel.total_reduction_replace_text.count > 0 {
                headerView.saveLabel.attributedText = NSMutableAttributedString(string: dicInfoModel.total_reduction_replace_text)
            }else{
                let arrs =  NSMutableAttributedString(string: kLocalized("Discount_CARDS_accumulate"))
                arrs.append(NSAttributedString(string: "\(dicInfoModel.total_reduction_coin)\(COINNAME)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.colorWithHexString("#EB5567")]))
                headerView.saveLabel.attributedText = arrs
                
            }
          
            headerView.dateLabel.text =  getTimeStampToString(dicInfoModel.expiry_time,format: "yyyy.MM.dd")+"到期"
            
            
            rank_strArr.removeAll()
   
            for i in  0..<dicInfoModel.discount_rank.count {
                let model = dicInfoModel.discount_rank[i]
                
                rank_strArr.append(["title":"\(i+1). \(kLongLocalized("User_accumulates_savings", replace: model.user_nick))","sub_title":"\(model.reduction_coin)\(COINNAME)"])
            }
            if rank_strArr.count > 0 {
               setProvisionsData(type: "Card_rank_cell", key: "sectionheightForHeader", value: "36")
               setProvisionsData(type: "Card_rank_cell", key: "row", value: "\(rank_strArr.count)")
            }
           
            if  dicInfoModel.banner.image_url.count > 0 {
                 setProvisionsData(type: "Card_banner_cell", key: "row", value: "1")
            }
          
            if dicInfoModel.privileges.count > 0 {
                setProvisionsData(type: "Card_Title_identity_cell", key: "row", value: "1")
            }
//            setProvisionsData(type: "Card_tj_cell", key: "row", value: "1")
           
            if  dicInfoModel.tj.limit_time.integerValue() > getCurrentStamp() {
                createTimer()
                setProvisionsData(type: "Card_tj_cell", key: "row", value: "1")
            }
          
            self.tableView.reloadData()
        }
        
    }
    fileprivate  var rank_strArr = [[String:String]]()
    fileprivate  var   product_id:String = ""
    fileprivate var bouncedModel:MQIComplexResultModel?
    
   fileprivate let  inPurchaseManager  = MQIIAPManager.shared
    //创建定时器
    fileprivate var timer_Update:Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = kLocalized("discountCard", describeStr: "打折卡")
        setupUI()
        inPurchaseManager.clean()
        showPromptView()
     
        if MQIUserDiscountCardInfo.default?.cardState == "2"  {
            type = .have
        }else{
            type = .buy
        }
        MQIUserDiscountCardInfo.reload()
        headerView.type = type
        configFixedData()
        getData()
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self)
        if  timer_Update != nil {
            timer_Update.invalidate()
            timer_Update = nil
        }
    }
   
    func getData() {
        if type == .buy {
            addPreloadView()
            MQIProduct_discount2Request().request({ [weak self](_, _, dc:MQIDiscountCardInfo) in
                self?.dicModel = dc
                self?.dismissPreloadView()
                self?.dismissWrongView()
            }) {[weak self]  (msg, code)  in
                self?.dismissPreloadView()
                self?.addWrongView(msg, refresh: {
                    self?.getData()
                })
                MQILoadManager.shared.makeToast(msg)
            }
        }else{
             addPreloadView()
            MQIMydiscount_detailRequest(offset: "0", limit: "10").request({ [weak self](_, _, dc:MQIDiscountCardInfo) in
                self?.dicInfoModel = dc
                self?.dismissPreloadView()
                self?.dismissWrongView()
            }) {[weak self]  (msg, code)  in
                self?.dismissPreloadView()
                self?.addWrongView(msg, refresh: {
                    self?.getData()
                })
                MQILoadManager.shared.makeToast(msg)
            }
        }
        
        
    }
    
    func setupUI() {
        hiddenNav()
//        contentView.y = 0
        contentView.height +=  contentView.y
         contentView.y  = 0
//        contentView.frame = CGRect(x: 0,y: 0, width: view.width,  height:view.height)
        addTopView()
        addHeaderAndFooterView()
        addTableView()

    }
    
    //MARK:定时器  为了同步，只能放在这里，不能放每个cell里
    func createTimer() {
        if timer_Update == nil {
            timer_Update = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MQIDiscountCardViewController2.timerCountDown), userInfo: nil, repeats: true)
            RunLoop.main.add(timer_Update, forMode:RunLoop.Mode.common)
        }
    }
    @objc func timerCountDown() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:MQICardTJTableViewCell_Timer_Notification), object: nil)
    }
    
    func addHeaderAndFooterView() {
        headerView = MQICardHeaderView(frame: CGRect(x: 0, y: nav.maxY, width: contentView.width, height: MQICardHeaderView.getDefaultHeight()))
    
        contentView.addSubview(headerView)
        footerView = MQICardFooterView(frame: CGRect(x: 0, y: 0, width: contentView.width, height: MQICardFooterView.getDefaultHeight()))
        
        headerView.clickBlick = { [weak self] (tag) in
            if tag == 101 {
                self?.showDetailsMaskView()
            }else{
                self?.toPay()
            }
          
        }
    }
    
    func addTableView() {
        tableView = MQITableView()
        contentView.addSubview(tableView)
        tableView.backgroundColor = UIColor.white
//        tableView.tableHeaderView = headerView
//        tableView.tableFooterView = footerView
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.gyDelegate = self
        tableView.registerCell(MQICardbIdentityTableViewCell.self, xib: false)
        tableView.registerCell(MQICardTitleTableViewCell.self, xib: false)
        tableView.registerCell(MQICardbBtnTableViewCell.self, xib: false)
        tableView.registerCell(MQICardTitleIdentityCellTableViewCell.self, xib: false)
        tableView.registerCell(MQICardBannerCellTableViewCell.self, xib: false)
        tableView.registerCell(MQICardRankCellTableViewCell.self, xib: false)
        tableView.registerCell(MQICardTJTableViewCell.self, xib: false)
        
        
        tableView.frame =  CGRect(x: 0,y: headerView.maxY-40, width: contentView.width,  height:contentView.height - headerView.maxY+40)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
//        let bacView = UIView(frame: CGRect (x: 0, y: -tableView.height, width: screenWidth, height: tableView.height))
//        bacView.backgroundColor = UIColor.colorWithHexString("2C2B40")
//        tableView.addSubview(bacView)
    }

    
    /// 上部导航栏
    func addTopView() {
        
        customNavView = UIView(frame: CGRect (x: 0, y: 0, width: screenWidth, height: x_statusBarAndNavBarHeight))
        customNavView.backgroundColor = UIColor.colorWithHexString("2C2B40")
        contentView.addSubview(customNavView)
        customNavView.alpha = 0
        
        let alphaView = UIView (frame: customNavView.bounds)
        alphaView.backgroundColor = UIColor.colorWithHexString("2C2B40")
        view.addSubview(alphaView)
        
        let titlelable =  UILabel(frame: CGRect(x: 15, y: status.maxY,  width: 100, height: 42))
        titlelable.font  = UIFont.boldSystemFont(ofSize: 18)
        titlelable.textAlignment = .center
        titlelable.textColor = kUIStyle.colorWithHexString("#FFFFFF")
        alphaView.addSubview(titlelable)
        titlelable.centerX  = customNavView.centerX
        titlelable.text =  self.tabBarController?.selectedViewController?.tabBarItem.title
        titlelable.text = title
        
        let searchbutton = getBackBtn()
        searchbutton.frame = CGRect(x: 15, y:0, width: root_nav_height, height: root_nav_height)
        searchbutton.addTarget(self, action: #selector(backAction), for: UIControl.Event.touchUpInside)
        searchbutton.centerY =    titlelable.centerY
        searchbutton.tintColor = UIColor.white
        alphaView.addSubview(searchbutton)
        
    }
    
    
    
    
}

extension MQIDiscountCardViewController2:MQITableViewDelegate {
    
    //MARK:  tableView代理
    func numberOfTableView(_ tableView: MQITableView) -> Int {
         return fixedData.count
    }
    func numberOfRow(_ tableView: MQITableView!, section: Int) -> Int {
        return fixedData[section]["row"]!.integerValue()
    }
    func heightForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> CGFloat {
        let type = fixedData[indexPath.section]["type"]
        switch type {
        case "Card_Title_cell":
            return MQICardTitleTableViewCell.getHeight(nil)
        case "Card_identity_cell":
         return  MQICardbIdentityTableViewCell.getHeight(nil)
        case "Card_btn_cell":
          return MQICardbBtnTableViewCell.getHeight(nil)
        case "Card_Title_identity_cell":
            return MQICardTitleIdentityCellTableViewCell.getHeight(nil)
        case "Card_banner_cell":
            return MQICardBannerCellTableViewCell.getHeight(nil)
        case "Card_rank_cell":
            return MQICardRankCellTableViewCell.getHeight(nil)
        case "Card_tj_cell":
            return MQICardTJTableViewCell.getHeight(nil)
        default:
            return MQICardbIdentityTableViewCell.getHeight(nil)
        }
    }
    func cellForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> UITableViewCell {
        
        
        let type = fixedData[indexPath.section]["type"]
        switch type {
        case "Card_Title_cell":
            let cell = tableView.dequeueReusableCell(MQICardTitleTableViewCell.self, forIndexPath: indexPath)
            cell.subTitle.text = dicModel.average_reduction
            return cell
            
        case "Card_identity_cell":
            let cell = tableView.dequeueReusableCell(MQICardbIdentityTableViewCell.self, forIndexPath: indexPath)
           let model = dicModel.privileges[indexPath.row]
            cell.iconImg.sd_setImage(with: URL(string:model.image_url))
            cell.title.text = model.name
            cell.subTitle.text = model.intro
            return cell
        case "Card_btn_cell":
            let cell = tableView.dequeueReusableCell(MQICardbBtnTableViewCell.self, forIndexPath: indexPath)
            if dicModel.price.count > 0 {
              cell.moneyLabel.text =  "\(kLocalized("Price"))：\(dicModel.currencyStr)\( dicModel.priceStr)/\(kLocalized("month"))"
            }
            cell.clickBlick = { [weak self] in
                self?.toPay()
            }
            return cell
            
        case "Card_Title_identity_cell":
            let cell = tableView.dequeueReusableCell(MQICardTitleIdentityCellTableViewCell.self, forIndexPath: indexPath)
            cell.privileges = dicInfoModel.privileges
            cell.clickBlock = {[weak self] (tag) in
                /// 规则说明
                if tag == 22 {
                    if let weakSelf  = self {
                        weakSelf.showRulesMaskView(weakSelf.dicInfoModel.rule_desc)
                    }
                }
            }
            return cell
        case "Card_banner_cell":
            let cell = tableView.dequeueReusableCell(MQICardBannerCellTableViewCell.self, forIndexPath: indexPath)
            cell.bannerImg.sd_setImage(with: URL(string:  dicInfoModel.banner.image_url))
            cell.clickBlock = {[weak self] in
                if let url = URL(string:self?.dicInfoModel.banner.url ?? " "){
                     MQIOpenlikeManger.openLike(url)
                }
              
            }
            return cell
        case "Card_rank_cell":
            let cell = tableView.dequeueReusableCell(MQICardRankCellTableViewCell.self, forIndexPath: indexPath)
            let dic = rank_strArr[indexPath.row]
            cell.title.text = dic["title"]
            cell.subTitle.text = dic["sub_title"]
            return cell
        case "Card_tj_cell":
            let cell = tableView.dequeueReusableCell(MQICardTJTableViewCell.self, forIndexPath: indexPath)
            
            let model = dicInfoModel.tj
            cell.title1.text = model.name
            
            for i in  0..<cell.itmes.count {
                let item = cell.itmes[i]
                if i < model.books.count {
                    let itmeModel = model.books[i]
                    item.isHidden = false
                    item.imgView.sd_setImage(with: URL(string: itmeModel.book_cover), placeholderImage: bookPlaceHolderImage)
                    item.title.text = itmeModel.book_name
                }
            }
            cell.timeIntervalSecond = model.limit_time
            

            cell.clickBlock = { (tag) in
                MQIUserOperateManager.shared.toReader(  model.books[tag-100].book_id)
                
            }
            return cell
  
        default:
            
            return MQITableViewCell()
        }
        
    }
//    func didSelectRowAtIndexPath(_ tableView: MQITableView!, indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
//    }
//    func heightForFooter(_ tableView: MQITableView!, section: NSInteger) -> CGFloat {
//        return 400
//    }
//    func viewForFooter(_ tableView: MQITableView!, section: NSInteger) -> UIView? {
//        let view = UIView()
//       
//        return view
//    }
    func heightForHeader(_ tableView: MQITableView!, section: NSInteger) -> CGFloat {
        
        
       return fixedData[section]["sectionheightForHeader"]!.CGFloatValue()

    }

    func viewForHeader(_ tableView: MQITableView!, section: NSInteger) -> UIView? {
      
        let bacView = UIView()
        if type == .buy {
            bacView.backgroundColor = UIColor.colorWithHexString("#F8F8F8")
            let iconBtn = UIButton()
            iconBtn.setImage(UIImage(named: "apay_radio_Image"), for: .normal)
            iconBtn.setTitle("动态：", for: .normal)
            iconBtn.setTitleColor(UIColor.colorWithHexString("#2C2B40"), for: .normal)
            iconBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            iconBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            bacView.addSubview(iconBtn)
            iconBtn.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(card_LeftMargin)
            }
            let cycleView = ZBCycleVerticalView()
            cycleView.backgroundColor = bacView.backgroundColor
            bacView.addSubview(cycleView)
            cycleView.snp.makeConstraints { (make) in
                make.height.equalToSuperview()
                make.left.equalTo(iconBtn.snp.right).offset(5)
                make.right.greaterThanOrEqualToSuperview().offset(-card_LeftMargin-5)
                make.centerY.equalToSuperview()
            }
            cycleView.direction = .up
            cycleView.showTime = 3
            cycleView.dataArray = rank_strArr
            cycleView.block = { (index) in
                
            }
        }else{
           bacView.backgroundColor = UIColor.white
            let lineView = UIView()
            lineView.backgroundColor = mainColor
            bacView.addSubview(lineView)
            lineView.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(card_LeftMargin2)
                make.top.equalToSuperview().offset(15)
                make.width.equalTo(2)
                make.height.equalTo(15)
            }
            
            let title = UILabel()
            title.font = UIFont.boldSystemFont(ofSize: 16)
            title.textColor  = UIColor.colorWithHexString("#333333")
            title.textAlignment = .left
            bacView.addSubview(title)
            title.snp.makeConstraints { (make) in
                make.left.equalTo(lineView).offset(5)
                make.centerY.equalTo(lineView)
            }
            title.text = "省钱榜"
        }
        

        return bacView
    }
    
    
    func gScrollViewDidScroll(_ tableView: MQITableView) {
        let offsetY = tableView.contentOffset.y
        mqLog(offsetY)

        
        
    }
    
    
}

extension MQIDiscountCardViewController2 {
    
    func showPromptView() {
        inPurchaseManager.callbackPromptBlock = {[weak self] (model:MQIComplexResultModel) in
            self?.bouncedModel = model
        }
    }
    
    func toPay() {
        
        if !MQIUserManager.shared.checkIsLogin() {
            MQIUserOperateManager.shared.toLoginVC { [weak self]  in
//                  MQILoadManager.shared.addProgressHUD("正在更新用户信息")
//                MQIUserDiscountCardInfo.reload(isMandatory: true) {
//                     MQILoadManager.shared.dismissProgressHUD()
//
//                    if MQIUserDiscountCardInfo.default?.cardState == "2" {
//                       MQILoadManager.shared.makeToast("更新完成")
//                    }
//                }
                self?.toPay()
            }
            return
        }
  
        if product_id.count < 3 {
            MQILoadManager.shared.makeToast("充值失败")
             return
        }
        
        MQILoadManager.shared.addProgressHUD("")
        inPurchaseManager.callbackBlock = {[weak self] (suc: Bool,  msg: String) in
            if let weakSelf = self  {
                if !suc {
                    if  msg.contains("DSYCALLBACK_1") {
                        MQILoadManager.shared.dismissProgressHUD()
                        let msgNEW = msg.replacingOccurrences(of: "DSYCALLBACK_1", with: "")
                        MQILoadManager.shared.makeToast(msgNEW)
                    }else{
                        MQILoadManager.shared.dismissProgressHUD()
                        MQILoadManager.shared.addProgressHUD(msg)
                    }
                }else{
                   
                    MQILoadManager.shared.makeToast(msg)
                     MQILoadManager.shared.addProgressHUD("正在更新用户信息")
                    let dc = MQIUserDiscountCardInfo.default
                    MQIUserDiscountCardInfo.reload(isMandatory: true) {
                        MQILoadManager.shared.dismissProgressHUD()
                         MQILoadManager.shared.makeToast("更新完成")
                        if weakSelf.type == .buy{
                            weakSelf.type = .have
                            weakSelf.headerView.type = .have
                        }
                       weakSelf.showBouncedView(dc)
                        weakSelf.configFixedData()
                        weakSelf.getData()
                    }

                }
            }
            
        }
        inPurchaseManager.requestProductId(productId: product_id)
        
    }
    
    func showBouncedView(_ dc:MQIUserDiscountCardInfo?)  {
        
        if let model = bouncedModel {
            let rmodel = MQIResultsPageModel()
            if model.data.banner.image_url.count > 0 {
                rmodel.type = .banner
                rmodel.lineTitle = model.data.banner.title
                rmodel.banner_Img_url = model.data.banner.image_url
                rmodel.linkStr = model.data.banner.url
            } else if model.data.tj.books.count > 0 {
                rmodel.type = .recommended
                rmodel.lineTitle = model.data.tj.name
                for itm in model.data.tj.books {
                    let model = MQIResultsPageModel()
                    model.book_img_url = itm.book_cover
                    model.book_title = itm.book_name
                    model.book_id  = itm.book_id
                   rmodel.itmeData.append(model)
                }
            }else{
                rmodel.type = .prompt
            }
            rmodel.prompt_img_name = "tk_dh_img"
            
            
     

            if dc?.cardState == "1"  || dc?.cardState == "2"{
                rmodel.title1 = rmodel.setAtts(str: kLocalized("Continue_FeiChengGong"))
            }else{
                rmodel.title1 = rmodel.setAtts(str:  kLongLocalized("BuySuccess", replace: "购买"))
            }
         
            if model.data.result.desc.count > 0 {
                rmodel.title2 = MQIOpenlikeManger.getParsingAtts("\(model.data.result.desc)", textAlignment: .center)
            }
           
            rmodel.btnTitle = kLocalized("I_know_the")
            MQILoadManager.shared.showResultsPageView(rmodel, callbackBlock: { (book_id, link_url) in
                if book_id != nil {
                    MQIUserOperateManager.shared.toReader(book_id!)
                    return
                }
                if link_url != nil {
                    MQIOpenlikeManger.openLike(URL(string: link_url!))
                    return
                }
                })
        }
      
        
    }
}

extension  MQIDiscountCardViewController2 {
    
    func configFixedData() {
        
        if type == .buy {
            fixedData  = [
                [
                    "type":"Card_Title_cell",
                    "sectionheightForHeader": "0",
                    "row":"1",
                    ],
                [
                    "type":"Card_identity_cell",
                     "sectionheightForHeader": "0",
                    "row":"0",
                    ],
                
                [
                    "type":"Card_btn_cell",
                    "sectionheightForHeader": "0",
                    "row":"1",
                    
                    ],
                
            ]
        }else{
            fixedData  = [
                [
                    "type":"Card_Title_identity_cell",
                    "sectionheightForHeader": "0",
                    "row":"0",
                 
                    ],
                [
                    "type":"Card_banner_cell",
                    "sectionheightForHeader": "0",
                    "row":"0",
                    ],
                
                [
                    "type":"Card_rank_cell",
                    "sectionheightForHeader": "0",
                    "row":"0",
                    
                    ],
                [
                    "type":"Card_tj_cell",
                    "sectionheightForHeader": "0",
                    "row":"0",
                    
                    ],
                
            ]
        }
        
        
    }
    
    func setProvisionsData(type:String,key:String,value:String) {
        for i in 0..<fixedData.count {
            if fixedData[i]["type"] == type {
                fixedData[i].updateValue(value, forKey: key)
                return
            }
        }
    }
}


extension MQIDiscountCardViewController2 {
    
    ///打折卡明细弹框
    func showDetailsMaskView()  {
        let maskView = UIView(frame: view.bounds)
        maskView.backgroundColor = UIColor.colorWithHexString("000000", alpha: 0.2)
        view.addSubview(maskView)
        view.bringSubviewToFront(maskView)
        maskView.dsyAddTap(self, action: #selector(clcikDetailsMaskView(tap: )))
        
        let bacView = UIView(frame:  CGRect(x: kUIStyle.scale1PXW(30), y: 0, width: view.width-kUIStyle.scale1PXW(60), height: 450))
        bacView.backgroundColor = UIColor.white
        bacView.tag = 100
        maskView.addSubview(bacView)
        bacView.dsySetCorner(radius: 10)
        bacView.centerY = maskView.centerY-20
        bacView.dsyAddTap(self, action: #selector(clcikMaskView(tap: )))
        
        let detail = MQIDiscountCardDetailsMaskView(frame: bacView.bounds)
        bacView.addSubview(detail)
        detail.clickBcolck = {
            maskView.removeFromSuperview()
            
        }
        
    }
    
    
    @objc   func clcikDetailsMaskView(tap:UITapGestureRecognizer) {
        if tap.view?.tag == 100 { return }
        tap.view?.removeFromSuperview()
    }
    ///打折卡规则弹框
    func showRulesMaskView(_ text:String)  {
        
        let maskView = UIView(frame: view.bounds)
        maskView.backgroundColor = UIColor.colorWithHexString("000000", alpha: 0.2)
        view.addSubview(maskView)
        view.bringSubviewToFront(maskView)
        maskView.dsyAddTap(self, action: #selector(clcikMaskView(tap: )))
        
        let bacView = UIView(frame:  CGRect(x: 30, y: 0, width: view.width-60, height: 450))
        bacView.backgroundColor = UIColor.white
        bacView.tag = 100
        maskView.addSubview(bacView)
        bacView.dsySetCorner(radius: 4)
        bacView.centerY = maskView.centerY-20
        bacView.dsyAddTap(self, action: #selector(clcikMaskView(tap: )))
        
        let lineView = UIView(frame: CGRect(x: 30, y: 30, width: bacView.width-60, height: 1))
        lineView.backgroundColor = mainColor
        bacView.addSubview(lineView)
        
        let titleLable = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 24))
        titleLable.backgroundColor = UIColor.white
        titleLable.font  = kUIStyle.sysFontDesign1PXSize(size: 15)
        titleLable.textColor = lineView.backgroundColor
        titleLable.textAlignment = .center
        titleLable.numberOfLines  = 1
        titleLable.adjustsFontSizeToFitWidth = true
        bacView.addSubview(titleLable)
        titleLable.text = kLocalized("规则说明")
        titleLable.centerX = lineView.centerX
        titleLable.centerY = lineView.centerY
        
        
        
        textView = UITextView(frame: CGRect(x: 26, y: titleLable.maxY, width:bacView.width-52 ,height: bacView.height-titleLable.maxY-20))
        textView.font = kUIStyle.sysFont(size: 14)
        textView.textColor = kUIStyle.colorWithHexString("#666666")
        textView.showsHorizontalScrollIndicator =  false
        textView.showsVerticalScrollIndicator = true
        textView.isEditable = false
        textView.isSelectable = false
        bacView.addSubview(textView)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = 5
        let att = NSMutableAttributedString.init(string: text, attributes: [NSAttributedString.Key.font : textView.font!, NSAttributedString.Key.paragraphStyle:paragraphStyle,.foregroundColor:textView.textColor!])
        
        textView.attributedText = att
        
    }
    
    
    @objc   func clcikMaskView(tap:UITapGestureRecognizer) {
        if tap.view?.tag == 100 { return }
        tap.view?.removeFromSuperview()
    }
}

