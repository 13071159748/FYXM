//
//  MQIWelfareCentreViewController.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/9/6.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

class MQIWelfareCentreViewController: MQIBaseViewController {

    var gdCollectionView: MQICollectionView!
    var footerView: UIView!
    var headerView: UIImageView!
    fileprivate var fixedData = [[String: String]]()

    var welfareModel: MQIWelfareModel? {
        didSet(oldValue) {
            if welfareModel != nil {

                setProvisionsData(type: "daily_cell", row: "\(welfareModel!.welfare_list.count)", title: kLocalized("Daily_tasks"))

                once_welfare_list = welfareModel!.once_welfare_list.filter({ $0.status_code != "already_received" })

                if MQIPayTypeManager.shared.isAvailable() {

                    if once_welfare_list.count > 0 {
                        setProvisionsData(type: "High_praise", row: "\(once_welfare_list.count)", title: "进阶任务")
                    } else {
                        setProvisionsData(type: "High_praise", row: "0", title: "")
                    }
                } else {
                    setProvisionsData(type: "High_praise", row: "0", title: "")
                }


            }
            self.gdCollectionView.reloadData()

        }
    }

    var signModel: MQIWelfareModel? {
        didSet(oldValue) {
            if signModel != nil {
                setProvisionsData(type: "Sign_in", row: "1")
            } else {
            }
            self.gdCollectionView.reloadData()

        }
    }
    
    var popupAdsenseModel: MQIPopupAdsenseModel? {
        didSet(oldValue) {
            if popupAdsenseModel?.total != 0 && self.popupAdsenseModel?.total != nil {
                setProvisionsData(type: "new_user", row: "1")
            } else {
            }
            self.gdCollectionView.reloadData()

        }
    }

    var once_welfare_list = [MQIWelfareItemModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = kLocalized("WelfareCentre")
        let bacView = UIView(frame: contentView.bounds)
        contentView.addSubview(bacView)
        // addDefineLayer(bacView)

        configFixedData()
        addCollectionView()
        DSYVCTool.dsyAddMJNormalHeade(gdCollectionView, refreshHFTarget: self, mjHeaderAction: #selector(mj_refreshAction), model: nil)

        self.addPreloadView()
        mj_refreshAction()
        MQIUserManager.shared.updateUserInfo { [weak self] (suc, msg) in
            self?.gdCollectionView.reloadData()

        }
    }

    func addDefineLayer(_ view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [kUIStyle.colorWithHexString("FF5D44").cgColor, kUIStyle.colorWithHexString("FFA774").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1.0)
        gradientLayer.frame = view.frame
        view.layer.addSublayer(gradientLayer)
    }

    @objc func mj_refreshAction() -> Void {
        getWelfareList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    func addCollectionView() {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        gdCollectionView = MQICollectionView(frame: CGRect(x: 0, y: 0, width: contentView.width, height: contentView.height - 15), collectionViewLayout: layout)
        contentView.addSubview(gdCollectionView)

        gdCollectionView.gyDelegate = self
        gdCollectionView.alwaysBounceVertical = true
        gdCollectionView.registerCell(MQICollectionViewCell.self, xib: false)
        gdCollectionView.registerCell(MQIMQIWelfareCentreUsualCollectionViewCell.self, xib: false)
        gdCollectionView.registerCell(MQIWelfareHorizonListCollectionViewCell.self, xib: false)
        gdCollectionView.registerCell(MQIWelfareCentreSignCollectionViewCell.self, xib: false)

        //  footer  header
        gdCollectionView.register(MQIWelfareCentreCollectionFooterReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "MQIWelfareCentreCollectionFooterReusableView")
        gdCollectionView.register(MQIWelfareCentreCollectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MQIWelfareCentreCollectionHeaderReusableView")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    @objc func rulesViewClick() {
        MQIActivityRulesBouncedView.showBouncedView { (c) in

        }
    }

}
extension MQIWelfareCentreViewController: MQICollectionViewDelegate {
    //MARK: Delegate
    func numberOfCollectionView(_ collectionView: MQICollectionView) -> Int {
        return fixedData.count

    }

    func numberOfItems(_ collectionView: MQICollectionView, section: Int) -> Int {
        return fixedData[section]["row"]!.integerValue()

    }

    //section四周边距
    func insetForSection(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> UIEdgeInsets {
        let type = fixedData[section]["type"]
        switch type {
        case "Sign_in":
            return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        case "new_user":
            return UIEdgeInsets(top: fixedData[section]["row"]!.CGFloatValue() * 15, left: 10, bottom: 0, right: 0)
        case "daily_cell":
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case "High_praise":
            return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        default:
            return UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)
        }

    }

    //设置footer header View
    func viewForSupplementaryElement(_ collectionView: MQICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        //header
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MQIWelfareCentreCollectionHeaderReusableView", for: indexPath) as! MQIWelfareCentreCollectionHeaderReusableView
            header.titleLable.text = fixedData[indexPath.section]["title"] ?? ""
            header.titleLable.textAlignment = .left
            //            header.addLine(0, lineColor: UIColor.colorWithHexString("F3F0F3"), directions: .bottom)
            return header

        }
        else if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "MQIWelfareCentreCollectionFooterReusableView", for: indexPath) as! MQIWelfareCentreCollectionFooterReusableView

            return footer
        }
        return UICollectionReusableView()

    }
    
    func sizeForHeader(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGSize {

        if let title = fixedData[section]["title"] {
            if title != "" {
                return MQIWelfareCentreCollectionHeaderReusableView.getSize()
            }

        }
        return CGSize.zero

    }
    func sizeForFooter(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, section: Int) -> CGSize {

        if let title = fixedData[section]["title"] {
            if title != "" {
                return MQIWelfareCentreCollectionFooterReusableView.getSize()
            }

        }
        return CGSize.zero

    }

    func sizeForItem(_ collectionView: MQICollectionView, layout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {

        let type = fixedData[indexPath.section]["type"]
        switch type {
        case "Sign_in":
            return MQIWelfareCentreSignCollectionViewCell.getSize()
        case "new_user":
            return MQIWelfareHorizonListCollectionViewCell.getSize()
        case "daily_cell":
            return MQIMQIWelfareCentreUsualCollectionViewCell.getSize()
        case "High_praise":
            return MQIMQIWelfareCentreUsualCollectionViewCell.getSize()

        default:
            return CGSize.zero
        }

    }

    func cellForRow(_ collectionView: MQICollectionView, indexPath: IndexPath) -> UICollectionViewCell {

        let type = fixedData[indexPath.section]["type"]
        switch type {
        case "daily_cell":
            let cell = collectionView.dequeueReusableCell(MQIMQIWelfareCentreUsualCollectionViewCell.self, forIndexPath: indexPath)

//            cell.rightSpace = 20
//            cell.addBottomLine()
            let bottomLine = UIView(frame: CGRect(x: 10, y: cell.height - gyLine_height, width: cell.width - 20, height: gyLine_height))
            bottomLine.backgroundColor = UIColor(hex: "#F2F2F2")
            cell.addSubview(bottomLine)
            //            cell.addLine(0, lineColor: UIColor.colorWithHexString("F3F0F3"), directions: .bottom)
            if let model = welfareModel?.welfare_list[indexPath.row] {
                cell.title.text = model.task_name

                cell.content.text = model.desc
                cell.icon.sd_setImage(with: URL(string: model.icon))
                if model.max > 0 {
                    if model.progress < model.max {
                        cell.type = .Progress
//                        cell.progressLable.text = "\(model.progress)/\(model.max)\(model.progress_unit)"
                        cell.progressLable.text = "\(model.progress)/\(model.max)" + "分钟"
                        cell.progress = Float(model.progress) / Float(model.max)
                        cell.moneyBtn.setTitle("x" + "\(model.reward_value)", for: .normal)
                        cell.state = WelfareState(rawValue: model.status_code)
                    } else {
                        cell.type = .btn
                        cell.moneyBtn.setTitle("x" + "\(model.reward_value)", for: .normal)
                        cell.receiveBtn.setTitle(model.action_name, for: .normal)
                        cell.state = WelfareState(rawValue: model.status_code)

                    }

                } else {
                    cell.type = .btn
                    cell.moneyBtn.setTitle("x" + "\(model.reward_value)", for: .normal)
                    cell.receiveBtn.setTitle(model.action_name, for: .normal)
                    cell.state = WelfareState(rawValue: model.status_code)


                }
            }

            return cell

        case "new_user":
            let cell = collectionView.dequeueReusableCell(MQIWelfareHorizonListCollectionViewCell.self, forIndexPath: indexPath)
            if self.popupAdsenseModel?.total != 0 && self.popupAdsenseModel?.total != nil {
                    cell.booksArray = self.popupAdsenseModel!.popupAdsenseList

            }
            return cell
        case "Sign_in":
            let cell = collectionView.dequeueReusableCell(MQIWelfareCentreSignCollectionViewCell.self, forIndexPath: indexPath)
            cell.signModel = self.signModel
            cell.signInfoBtn.addTarget(self, action: #selector(rulesViewClick), for: .touchUpInside)

            cell.clickSignBlock = { [weak self] in
                if let user = MQIUserManager.shared.user {
                    cell.isSign = user.sign_in
                    self?.newSign()

                } else {
                    MQIUserOperateManager.shared.toLoginVC({ [unowned cell] in
                        cell.clickSignBlock?()
                    })
                }

            }
            return cell
        case "High_praise":
            let cell = collectionView.dequeueReusableCell(MQIMQIWelfareCentreUsualCollectionViewCell.self, forIndexPath: indexPath)
            let model = once_welfare_list[indexPath.row]
            cell.title.text = model.task_name
            cell.content.text = model.desc
            cell.icon.sd_setImage(with: URL(string: model.icon))
            if model.max > 0 {
                if model.progress < model.max {
                    cell.type = .Progress
                    cell.progressLable.text = "\(model.progress)/\(model.max)" + "分钟"
                    cell.progress = Float(model.progress) / Float(model.max)
                    cell.moneyBtn.setTitle("x" + "\(model.reward_value)", for: .normal)
                    cell.state = WelfareState(rawValue: model.status_code)
                } else {
                    cell.type = .btn
                    cell.moneyBtn.setTitle("x" + "\(model.reward_value)", for: .normal)
                    cell.receiveBtn.setTitle(model.action_name, for: .normal)
                    cell.state = WelfareState(rawValue: model.status_code)

                }

            } else {
                cell.type = .btn
                cell.moneyBtn.setTitle("x" + "\(model.reward_value)", for: .normal)
                cell.receiveBtn.setTitle(model.action_name, for: .normal)
                cell.state = WelfareState(rawValue: model.status_code)


            }
            return cell

        default:

            return MQICollectionViewCell()
        }

    }


    func didSelectRowAtIndexPath(_ collectionView: MQICollectionView, indexPath: IndexPath) {
        let type = fixedData[indexPath.section]["type"]

        switch type {
        case "daily_cell":
            let cell = collectionView.cellForItem(at: indexPath) as! MQIMQIWelfareCentreUsualCollectionViewCell
            if let model = welfareModel?.welfare_list[indexPath.row] {
                if cell.state == .unfinished {
                    if model.action == "share" {
                        MQISocialManager.shared.sharedApp()
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                            self.welfareModel?.welfare_list[indexPath.row].status_code = "receive"
                            self.gdCollectionView.reloadData()
                            self.getWelfareList()
                        }

                    } else if model.action == "open.page.PAY" {
                        MQIUserOperateManager.shared.toPayVC(toPayChannel: .normalToPay) { [weak self] (suc) in
                            MQILoadManager.shared.addProgressHUD("")
                            self?.getWelfareList()
                        }
                    } else {
                        self.tabBarController?.selectedIndex = 0
                        self.popVC()
                    }
                } else if cell.state == .ToReceive {
                    if MQIUserManager.shared.checkIsLogin() {
                        btainTheRewards(id: model.id, indexPath: indexPath)
                    } else {
                        MQIUserOperateManager.shared.toLoginVC({ [weak self] in
                            self?.btainTheRewards(id: model.id, indexPath: indexPath)
                        })
                    }

                } else {

                }
            }
            return
        case "new_user":
            if let model = welfareModel {
                let vc = MQIWebVC()
                vc.url = model.banner.url
                pushVC(vc)
            }
            return
        case "High_praise":
            let model = once_welfare_list[indexPath.row]
            let cell = collectionView.cellForItem(at: indexPath) as! MQIMQIWelfareCentreUsualCollectionViewCell
            if cell.state == .unfinished {
                if model.action == "market" {
                    if MQIUserManager.shared.checkIsLogin() {
                        if let url = URL(string: itunes_url) {
                            MQIOpenlikeManger.openURL(url)
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
                                self?.receivePraise (model: model)
                            }
                        }
                    } else {
                        MQIUserOperateManager.shared.toLoginVC({ [weak self] in
                            if let url = URL(string: itunes_url) {
                                MQIOpenlikeManger.openURL(url)
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
                                    self?.receivePraise (model: model)
                                }
                            }
                        })
                    }

                } else if model.action == "bindemail" {
                    let bindVC = MQIBindEmailViewController()
                    bindVC.type = .bind_email
                    pushVC(bindVC)
                    bindVC.loginSuccess = { [weak self] in
                        guard let weakSelf = self else { return }
                        weakSelf.receivePraise (model: model)
                    }
                }
            } else if cell.state == .ToReceive {
                if MQIUserManager.shared.checkIsLogin() {
                    btainTheRewards(id: model.id, indexPath: indexPath, model: model)
                } else {
                    MQIUserOperateManager.shared.toLoginVC({ [weak self] in
                        self?.btainTheRewards(id: model.id, indexPath: indexPath, model: model)
                    })
                }

            } else {
            }

            return

        default:
            //mqLog("\(indexPath.section)==\(indexPath.row)")
            break
        }
    }
}

extension MQIWelfareCentreViewController {

    func configFixedData() {

        fixedData = [
            [
                "type": "Sign_in",
                "row": "0",
            ],

            [
                "type": "new_user",
                "row": "0",
                "title": ""
            ],
            [
                "type": "daily_cell",
                "row": "0",
            ],
            [
                "type": "High_praise",
                "row": "0",
                "title": ""
            ],

        ]

    }

    func setProvisionsData(type: String, row: String, title: String? = nil) {
        var tag: Int = 0
        for dic in fixedData {
            if dic["type"] == type {
                fixedData[tag]["row"] = row
                fixedData[tag]["title"] = title
                return
            }
            tag += 1
        }
    }
}

extension MQIWelfareCentreViewController {

    func getWelfareList() {

        let queue = DispatchQueue.global()
        let group = DispatchGroup()//创建一个组
        var err_msgNew: String = ""
        queue.async(group: group, execute: {
            group.enter()
            MQIDailyWelfareRequest().request({ [weak self] (request, response, result: MQIWelfareModel) in
                self?.welfareModel = result
                group.leave()
            }) { [weak self] (err_msg, err_code) in
                self?.welfareModel = nil
                err_msgNew = err_msg
                group.leave()
            }
        })
        queue.async(group: group, execute: {
            group.enter()
            MQIGetSignListRequest().request({ [weak self](request, response, result: MQIWelfareModel) in
                self?.signModel = result
                group.leave()

                self?.gdCollectionView.reloadData()
            }) { [weak self] (err_msg, err_code) in
                self?.signModel = nil
                err_msgNew = err_msg
                group.leave()
            }
        })
        
        queue.async(group: group, execute: {
            group.enter()
            MQIPopupAdsenseRequest(pop_position: "20").request({ [weak self](request, response, result: MQIPopupAdsenseModel) in
                self?.popupAdsenseModel = result
                group.leave()

                self?.gdCollectionView.reloadData()
            }) { [weak self] (err_msg, err_code) in
                self?.popupAdsenseModel = nil
                err_msgNew = err_msg
                group.leave()
            }
        })

        group.notify(queue: queue) { [weak self] in
            DispatchQueue.main.async {
                if let weakSelf = self {
                    if weakSelf.signModel == nil && weakSelf.welfareModel == nil {
                        weakSelf.dismissWrongView()
                        weakSelf.dismissNoDataView()
                        weakSelf.addWrongView(err_msgNew, refresh: {
                            weakSelf.getWelfareList()
                        })
                    } else {
                        mqLog("请求成功")
                        if weakSelf.signModel?.list.count == 0 && weakSelf.welfareModel?.welfare_list.count == 0 {
                            weakSelf.dismissWrongView()
                            weakSelf.addNoDataView()
                        } else {
                            weakSelf.dismissWrongView()
                            weakSelf.dismissNoDataView()
                        }
                    }
                    weakSelf.dismissPreloadView()
                    DSYVCTool.dsyEndRefresh(weakSelf.gdCollectionView)
                }
            }
        }
    }

    /// 领取奖励
    func btainTheRewards(id: Int, indexPath: IndexPath, model: MQIWelfareItemModel? = nil) -> Void {
        MQILoadManager.shared.addProgressHUD("")
        MQIBenefitsReceiveRequest(id: id).request({ [weak self](request, response, result: MQIWelfareItemModel) in
            DSYVCTool.dsyEndRefresh(self?.gdCollectionView)
            MQILoadManager.shared.dismissProgressHUD()

            if let model = self?.welfareModel?.welfare_list[indexPath.row] {
                MQILoadManager.shared.makeToast(kLongLocalized("DangdangSmalHandShakeSeeINotMuch", replace: "\(model.reward_value)", COINNAME_PREIUM))
                if MQIUserManager.shared.checkIsLogin() {
                    MQIUserManager.shared.user!.user_premium = "\(MQIUserManager.shared.user!.user_premium.integerValue() + model.reward_value)"
                    MQIUserManager.shared.saveUser()
                }

            }
            /// 刷新余额
            UserNotifier.postNotification(.refresh_coin)
            self?.welfareModel?.welfare_list[indexPath.row].status_code = "already_received"
            model?.status_code = "already_received"
            self?.gdCollectionView.reloadData()
        }) { [weak self] (err_msg, err_code) in
            MQILoadManager.shared.makeToast(kLocalized("FailedCollectionPleaseTryAgain"))
            MQILoadManager.shared.dismissProgressHUD()
            DSYVCTool.dsyEndRefresh(self?.gdCollectionView)
        }
    }


    /// 获取签到列表
    func newSign() {
        MQILoadManager.shared.addProgressHUD("")
        MQIDignContinuedtRequest().request({ [weak self](request, response, complexresult: MQIResultaDataModel) in
            UserNotifier.postNotification(.refresh_coin)
            MQIUserManager.shared.user?.sign_in = true
            MQIUserManager.shared.saveUser()
            MQIGetSignListRequest().request({ [weak self](request, response, result: MQIWelfareModel) in
                MQILoadManager.shared.dismissProgressHUD()
                self?.signModel = result
                self?.gdCollectionView.reloadData()
                self?.showBouncedView(model: complexresult, signModel: result)

            }) { [weak self] (err_msg, err_code) in
                MQILoadManager.shared.dismissProgressHUD()
                self?.signModel = nil
                self?.gdCollectionView.reloadData()
            }
        }) { (err_msg, err_code) in
            MQILoadManager.shared.dismissProgressHUD()
            MQILoadManager.shared.makeToast(err_msg)
        }
    }

    /// 领取评分奖励e
    func receivePraise (model: MQIWelfareItemModel) {
        MQILoadManager.shared.addProgressHUD("")
        MQIDaily_shareRequest(id: "\(model.id)")
            .request({ (request, response, result: MQIBaseModel) in
                MQIBenefitsReceiveRequest(id: model.id).request({ [weak self](request, response, result: MQIWelfareItemModel) in
//                    DSYVCTool.dsyEndRefresh(self?.gdCollectionView)
//                    MQILoadManager.shared.dismissProgressHUD()
                    UserNotifier.postNotification(.refresh_coin)
                    MQIDailyWelfareRequest().request({ [weak self] (request, response, result: MQIWelfareModel) in
                        MQILoadManager.shared.dismissProgressHUD()
                        MQILoadManager.shared.makeToast(kLongLocalized("DangdangSmalHandShakeSeeINotMuch", replace: "\(model.reward_value)", COINNAME_PREIUM))
                        self?.welfareModel = result
                        UserNotifier.postNotification(.refresh_coin)
                    }) { [weak self] (err_msg, err_code) in
                        MQILoadManager.shared.makeToast(err_msg)
                        MQILoadManager.shared.dismissProgressHUD()
                        DSYVCTool.dsyEndRefresh(self?.gdCollectionView)
                        self?.gdCollectionView.reloadData()
                    }

                }) { [weak self] (err_msg, err_code) in
                    MQILoadManager.shared.makeToast(err_msg)
                    MQILoadManager.shared.dismissProgressHUD()
                    DSYVCTool.dsyEndRefresh(self?.gdCollectionView)
                    self?.gdCollectionView.reloadData()
                }

            }) { (errmsg, errcode) in
                MQILoadManager.shared.makeToast(errmsg)
                MQILoadManager.shared.dismissProgressHUD()
        }


    }


    func showBouncedView(model: MQIResultaDataModel, signModel: MQIWelfareModel) {

        let rmodel = MQIResultsPageModel()
        if model.banner.image_url.count > 0 {
            rmodel.type = .banner
            rmodel.lineTitle = model.banner.title
            rmodel.banner_Img_url = model.banner.image_url
            rmodel.linkStr = model.banner.url
        } else if model.tj.books.count > 0 {
            rmodel.type = .recommended
            rmodel.lineTitle = model.tj.name
            for itm in model.tj.books {
                let model = MQIResultsPageModel()
                model.book_img_url = itm.book_cover
                model.book_title = itm.book_name
                model.book_id = itm.book_id
                rmodel.itmeData.append(model)
            }

        } else {
            rmodel.type = .prompt
        }
        rmodel.prompt_img_name = "tk_rl_img"

        if signModel.today_premium.count > 0 {
            let atts = NSMutableAttributedString()
            atts.append(rmodel.setAtts(str: kLocalized("Sign_in_successfully")))
            atts.append(rmodel.setAtts(str: "+" + signModel.today_premium, atts: [.foregroundColor: UIColor.colorWithHexString("FF1D3C")]))
            rmodel.title1 = atts
        } else {
            rmodel.title1 = rmodel.setAtts(str: kLocalized("Sign_in_successfully"))
        }


        if signModel.list.count > 0 {
            let atts = NSMutableAttributedString()
            atts.append(rmodel.setAtts(str: kLocalized("签到第")))
            let day = signModel.list.filter({ $0.status == "signed" }).count
            atts.append(rmodel.setAtts(str: "\(day)", atts: [.foregroundColor: UIColor.colorWithHexString("FF1D3C")]))
            atts.append(rmodel.setAtts(str: kLocalized("天")))
            rmodel.title2 = atts
        }


        if signModel.tomorrow_premium.count > 0 {
            let atts = NSMutableAttributedString()
            atts.append(rmodel.setAtts(str: kLocalized("明天再来可获得")))
            atts.append(rmodel.setAtts(str: "\(signModel.tomorrow_premium)\(COINNAME_PREIUM)", atts: [.foregroundColor: UIColor.colorWithHexString("FF4147")]))
            rmodel.title3 = atts

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


