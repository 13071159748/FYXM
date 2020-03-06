//
//  MQIloginHistoryView.swift
//  CQSCReader
//
//  Created by moqing on 2019/2/22.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQIloginHistoryView: UIView {

    var clickBlock:((_ isClose:Bool)->())?
    var tableView:MQITableView!
    var dataArr = [MQIUserModel]()
    
    weak var delegate: UIViewController?
    
    
    var clickChangeUser: (() -> ())?
    override init(frame: CGRect) {
        super.init(frame: frame)
   
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(_ block:((_ isClose:Bool)->())?) {
        clickBlock = block
    }
    
    @discardableResult  class  func showBouncedView(_ isPrompt:Bool=false , delegate: UIViewController? = nil, block:((_ isClose:Bool)->())?) -> MQIloginHistoryView {
        let bouncedView = MQIloginHistoryView(frame: UIScreen.main.bounds)
        UIApplication.shared.keyWindow!.addSubview(bouncedView)
        bouncedView.clickBlock = block
        bouncedView.defaultAnimation()
        bouncedView.setupUI()
       
        bouncedView.delegate = delegate
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
        let  contentView = UIView(frame: CGRect(x: 16, y: 0, width: screenWidth - 32, height: screenWidth - 32))
        contentView.backgroundColor = UIColor.white
        contentView.dsySetCorner(radius: 8)
        addSubview(contentView)
        contentView.centerX = screenWidth*0.5
        contentView.centerY = screenHeight*0.5
        addContentSubView(contentView)
        
        
//        if UserDefaults.standard.object(forKey: "1.2.0_hs_up") == nil {
//            do {
//                let us_id = XMDBTool.shared.allUser().map { return  MQIUserModel(jsonDict: $0 as? [String : Any] ?? [:]) }.map { return $0.user_id }
//                ///把不包含的存一下
//                try MQIUserManager.shared.historyLogData.filter { return !us_id.contains($0.user_id)  }.forEach {
//                    try XMDBTool.shared.insert(user: $0)
//                }
//            } catch {
//                dataArr = MQIUserManager.shared.historyLogData
//            }
//            UserDefaults.standard.set(true, forKey: "1.2.0_hs_up")
//            dataArr = XMDBTool.shared.allUser().map { return MQIUserModel(jsonDict: $0 as? [String : Any] ?? [:]) }
//        } else {
//            dataArr = MQIUserManager.shared.historyLogData
//        }
        MQIUserManager.shared.getHistoryLogDataFunc()
        dataArr = MQIUserManager.shared.historyLogData
        tableView.reloadData()
    }
    
    
    fileprivate  func addContentSubView(_ view:UIView)  {

        tableView = MQITableView(frame: CGRect(x: 10, y: 10, width:view.width-20, height: view.height-20))
        tableView.separatorStyle = .none
        tableView.gyDelegate = self
        view.addSubview(tableView)
        tableView.registerCell(MQIloginHistoryTableViewCell.self, xib: false)
        
    }
    
    
//    func getAtts(_ text:String) -> NSAttributedString{
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .left
//        paragraphStyle.lineSpacing = 5
//        let att = NSMutableAttributedString.init(string: text, attributes: [NSAttributedString.Key.font : textView.font!,NSAttributedString.Key.paragraphStyle:paragraphStyle])
//        return att as NSAttributedString
//    }
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

//MARK:  MQITableViewDelegate
extension MQIloginHistoryView:MQITableViewDelegate {
    
    func numberOfTableView(_ tableView: MQITableView) -> Int {
        return 1
    }
    
    func numberOfRow(_ tableView: MQITableView!, section: Int) -> Int {
        
        return dataArr.count
    }
    
    func heightForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> CGFloat {
       return 74
    }
    func viewForHeader(_ tableView: MQITableView!, section: NSInteger) -> UIView? {
        
        let headerView = UIView()
        let titleLable = UILabel()
        titleLable.font  = kUIStyle.sysFontDesign1PXSize(size: 15)
        titleLable.textColor = UIColor.colorWithHexString("333333")
        titleLable.textAlignment = .center
        titleLable.numberOfLines  = 0
        titleLable.adjustsFontSizeToFitWidth = true
        titleLable.backgroundColor = UIColor.white
        titleLable.text = kLocalized("View_login_history")
        headerView.addSubview(titleLable)
        titleLable.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let  lineView =  UIView()
        lineView.backgroundColor = UIColor.colorWithHexString("EDEDEF")
        headerView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        return headerView
    }
    
    func heightForHeader(_ tableView: MQITableView!, section: NSInteger) -> CGFloat {
        return 40
    }
    
    func cellForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(MQIloginHistoryTableViewCell.self, forIndexPath: indexPath)
        cell.selectionStyle = .none
        let model = dataArr[indexPath.row]
        cell.accountLable.text = "账户：" + (model.nick)
        cell.IDLable.text = "ID:" + (model.user_id)
        cell.type =  LoginType.createType("\(model.lastLoginType)")
        cell.btn.isHidden = model.token.isEmpty
//        cell.promptView.isHidden = (indexPath.row == 0 ) ? false:true
        cell.clickBtn = { _ in
            if MQIUserManager.shared.checkIsLogin() {
                MQIUserManager.shared.loginOut("", finish: { (_) in
                    MQIUserManager.shared.user = model
                    MQIUserManager.shared.updateUserState(checkedIn: 1, lastLoginType: model.lastLoginType)
                    
                })
            } else {
                MQIUserManager.shared.user = model
                MQIUserManager.shared.updateUserState(checkedIn: 1, lastLoginType: model.lastLoginType)
            }
            self.closeAction()
            self.clickChangeUser?()
            self.delegate?.navigationController?.popViewController(animated: true)
        }
        return cell
        
    }
    
    func didSelectRowAtIndexPath(_ tableView: MQITableView!, indexPath: IndexPath) {
        mqLog("\(indexPath.row)")
        
        
    }
    
    
    
}


class MQIloginHistoryTableViewCell: MQITableViewCell {
    var bacView:UIView!
    var accountLable:UILabel!
    var IDLable:UILabel!
    var loginType:UIImageView!
    var promptView:UIView!
    var btn: UIButton!
    
    var type:LoginType = .other {
        didSet(oldValue) {
            switch type {
            case .Wechat:
               loginType.image = UIImage(named: "login_wechat")
                return
            case .Facebook:
                loginType.image = UIImage(named: "login_facebook")
                return
            case .Twitter:
                 loginType.image = UIImage(named: "login_twitter_image")
                return
            case .Linkedin:
                loginType.image = UIImage(named: "login_line")
                return
            case .Google:
                loginType.image = UIImage(named: "login_google")
                return
            case .Mobile:
                loginType.image = UIImage(named: "login_mobile")
                return
            default:
               loginType.image = UIImage(named: "")
               mqLog("其他")
               return
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI()  {
       
        let  lineView =  UIView()
        lineView.backgroundColor = UIColor.colorWithHexString("EDEDEF")
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(1)
        }
        
        loginType = UIImageView()
        loginType.contentMode = .scaleAspectFit
        contentView.addSubview(loginType)
        loginType.dsySetCorner(radius: 12)
        loginType.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        btn = UIButton()
        btn.addTarget(self, action: #selector(clickBtn(btn:)), for: .touchUpInside)
        btn.dsySetCorner(radius: 4)
        btn.setTitle("切换", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.3019607843, blue: 0.6235294118, alpha: 1)
        contentView.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-26)
            make.width.equalTo(47)
            make.height.equalTo(22)
            make.centerY.equalToSuperview()
        }
        
        accountLable = UILabel()
        accountLable.font  = kUIStyle.sysFontDesign1PXSize(size: 14)
        accountLable.textColor = UIColor.colorWithHexString("323333")
        accountLable.textAlignment = .left
//        accountLable.adjustsFontSizeToFitWidth = true
//        accountLable.minimumScaleFactor = 0.8
        accountLable.text = kLocalized("View_login_history")
        contentView.addSubview(accountLable)
        accountLable.snp.makeConstraints { (make) in
            make.left.equalTo(loginType.snp.right).offset(13)
            make.bottom.equalTo(contentView.snp.centerY).offset(-2)
            make.right.equalTo(btn.snp.left).offset(-5)
        }
        
        IDLable =  UILabel()
        IDLable.font  = kUIStyle.sysFontDesign1PXSize(size: 14)
        IDLable.textColor = UIColor.colorWithHexString("323333")
        IDLable.textAlignment = .left
//        IDLable.adjustsFontSizeToFitWidth = true
//        accountLable.minimumScaleFactor = 0.8
        IDLable.text = kLocalized("View_login_history")
        contentView.addSubview(IDLable)
        IDLable.snp.makeConstraints { (make) in
           make.left.right.equalTo(accountLable)
           make.top.equalTo(contentView.snp.centerY).offset(2)
        }
        
        
        
        
        
        
//        promptView  = UIView()
//        promptView.dsySetCorner(radius: 3)
//        promptView.backgroundColor = UIColor.colorWithHexString("FF4A9E")
//        contentView.addSubview(promptView)
//        promptView.snp.makeConstraints { (make) in
//            make.width.height.equalTo(6)
//            make.centerY.equalTo(loginType)
//            make.left.equalTo(loginType.snp.right)
//        }
    }
    
    
    var clickBtn: ((UIButton) -> ())?
    @objc func clickBtn(btn: UIButton) {
        clickBtn?(btn)
    }
}
