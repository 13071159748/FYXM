//
//  MQIPremiumListViewController.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/9/6.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit
import SnapKit

private let cellIdentifier = "cellIdentifier"
class MQIPremiumListViewController: MQIBaseViewController {
    
    var premiumList = [MQIPremiumModel](){
        didSet(oldValue) {
            if premiumList.count == 0 {
                addNoDataView()
            }else{
                 dismissNoDataView()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var offset:Int = 0
    
    override func addNoDataView() {
        super.addNoDataView()
        self.noDataView?.icon.image = UIImage(named: "pay_no_data_img")
        self.noDataView?.titleLabel.text = kLocalized("go_find_good_books")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = kLocalized("ComplimentaryRecord")
     
        addPreloadView()
        offset = 0
        request(start_id: "\(offset)")
        
        ///添加table
        tableView.snp.removeConstraints()
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
        }
        DSYVCTool.dsyAddMJNormalHeade(tableView, refreshHFTarget: self, mjHeaderAction: #selector(refresh), model: nil)
        DSYVCTool.dsyAddMJNormalFooter(tableView, refreshHFTarget: self, mjFooterAction: #selector(refresh), model: nil)
    }

    
    @objc func refresh() {
        
        if tableView.mj_header.isRefreshing {
            offset = 0
            request(start_id: "\(offset)",isHeadeRefresh:true)
        }else{
            request(start_id: "\(offset)")
        }
    }
    
    
    func request(start_id: String, limit: String = "10",isHeadeRefresh:Bool = false)  {
        MQIGetPremiumList(start_id: start_id,limit:limit )
            .requestCollection({[weak self] (request, response, result:[MQIPremiumModel])in
                if let weakSelf = self {
                    weakSelf.offset += 10
                    weakSelf.dismissWrongView()
                    weakSelf.dismissPreloadView()
                    if isHeadeRefresh {
                        weakSelf.premiumList = result
                    }else{
                        weakSelf.premiumList.append(contentsOf: result)
                    }
                    
                    weakSelf.tableView.reloadData()
                    DSYVCTool.dsyEndRefresh( weakSelf.tableView)
                }
                
            }) { [weak self](msg, code) in
                if let weakSelf = self  {
                    weakSelf.dismissPreloadView()
                     DSYVCTool.dsyEndRefresh( weakSelf.tableView)
                    weakSelf.addWrongView(msg, refresh: {
                        weakSelf.request(start_id: start_id,isHeadeRefresh:isHeadeRefresh)
                    })
                    
                }
                
        }
        
    }
}
extension MQIPremiumListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return premiumList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MQIPremiumListTableViewCell.getHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!
        MQIPremiumListTableViewCell
        cell.selectionStyle = .none
        let model = premiumList[indexPath.row]
        cell.model = model
        return cell
    }
    
    
}

enum givingType {
    case use// 使用
    case overdue/// 过期
    case normal /// 正常
    case inTheUse /// 使用中
    
}


class MQIPremiumListTableViewCell: MQITableViewCell {
    
    //    var bacView:UIView!
    var  title:UILabel!
    var  validityLable:UILabel!
    var  givingLable:UILabel!
    var  moneyLable:UILabel!
    var  unitLable:UILabel!
    var  bgImage:UIImageView!
    //    var  bgImage2:UIImageView!
    var  statusBtn:UIButton!
    
    var model:MQIPremiumModel?{
        didSet(oldValue) {
            if  let model  = model {
                title.text =  model.type
                
                validityLable.text =  kLongLocalized("ValidUntil", replace:  getTimeStampToString(model.premium_end, format: " yyyy-MM-dd HH:mm:ss"))
                givingLable.text =   kLongLocalized("TimeOfPresentation", replace: getTimeStampToString(model.premium_create, format: " yyyy-MM-dd HH:mm:ss"))
                moneyLable.text = "+" + model.premium_coin
                
                if model.premium_remain.integerValue()  == 0 {
                    type = .use
                }
                else if model.status  == "2" {
                    type = .overdue
                }
                else{
                    if model.premium_remain !=  model.premium_coin {
                        type = .inTheUse
                    }else{
                        type = .normal
                    }
                }
            }
        }
    }
    var type:givingType = .normal{
        didSet(oldValue) {
            switch type {
            case .use:
                title.textColor = kUIStyle.colorWithHexString("666666")
                moneyLable.textColor =  kUIStyle.colorWithHexString("ADADAD")
                unitLable.textColor =    moneyLable.textColor
                bgImage.image = UIImage(named: "giving_bg2")
                statusBtn.isHidden = false
                statusBtn.setTitle(   kLocalized("Has_been_used",describeStr: "已使用"), for: .normal)
                statusBtn.tintColor = kUIStyle.colorWithHexString("D2D2D2")
                break
            case .overdue:
                statusBtn.setTitle(kLocalized("giving_expired",describeStr: "已使用"), for: .normal)
                title.textColor = kUIStyle.colorWithHexString("666666")
                moneyLable.textColor =  kUIStyle.colorWithHexString("ADADAD")
                unitLable.textColor =    moneyLable.textColor
                bgImage.image = UIImage(named: "giving_bg2")
                statusBtn.isHidden = false
                statusBtn.tintColor = kUIStyle.colorWithHexString("D2D2D2")
                break
            case .inTheUse:
                title.textColor = mainColor
                moneyLable.textColor = mainColor
                bgImage.image = UIImage(named: "giving_bg")
                statusBtn.isHidden = false
                statusBtn.setTitle(kLocalized("In_The_Use",describeStr: "使用中"), for: .normal)
                statusBtn.tintColor = mainColor
                break
                
            default:
                title.textColor = mainColor
                moneyLable.textColor = mainColor
                bgImage.image = UIImage(named: "giving_bg")
                unitLable.textColor = mainColor
                statusBtn.isHidden = true
                break
            }
            
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        selectionStyle = .none
        backgroundColor =  kUIStyle.colorWithHexString("F6F6F6")
        
        let bacView = UIView()
        bacView.backgroundColor  = UIColor.white
        contentView.addSubview(bacView)
        bacView.frame = CGRect(x: kUIStyle.scaleW(30), y: 10, width: kUIStyle.kScrWidth-kUIStyle.scaleW(60), height: kUIStyle.scaleH(180))
        bacView.dsySetCorner(radius: 8)
        
        
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named: "giving_bg")
        bgImage.tintColor = mainColor
        bacView.addSubview(bgImage)
        bgImage.frame = CGRect(x: bacView.width-kUIStyle.scaleW(234), y: 0, width: kUIStyle.scaleW(234), height: bacView.height)
        
        //        bgImage2 = UIImageView()
        //        bgImage2.image = UIImage(named: "giving_pattern")
        //        bgImage2.tintColor = mainColor
        //        bacView.addSubview(bgImage2)
        //        bgImage2.center = bgImage.center
        //
        
        title = UILabel()
        title.textColor = mainColor
        title.font = kUIStyle.boldSystemFont1PXDesignSize(size: 16)
        bacView.addSubview(title)
        title.frame = CGRect(x: 13, y: 14, width: bgImage.x, height: kUIStyle.scaleH(40))
        //        title.text = "充值赠送"
        
        validityLable = UILabel()
        validityLable.textColor = kUIStyle.colorWithHexString("666666")
        validityLable.font = kUIStyle.sysFontDesignSize(size: 24)
        bacView.addSubview(validityLable)
        validityLable.frame = CGRect(x: title.x, y: title.maxY+8, width: title.width, height: kUIStyle.scaleH(34))
        //        validityLable.text = "有效期至：2018-09-20"
        
        givingLable = UILabel()
        givingLable.textColor = kUIStyle.colorWithHexString("333333")
        givingLable.font = kUIStyle.sysFontDesignSize(size: 24)
        bacView.addSubview(givingLable)
        givingLable.frame = CGRect(x: title.x, y: validityLable.maxY+2, width: title.width, height: kUIStyle.scaleH(34))
        //        givingLable.text = "赠送时间：2018-08-20 13:21"
        
        moneyLable = UILabel()
        moneyLable.textColor = mainColor
        moneyLable.font = kUIStyle.sysFontDesignSize(size: 52)
        moneyLable.textAlignment = .center
        bacView.addSubview(moneyLable)
        moneyLable.frame = CGRect(x: bgImage.x, y: 30, width: bgImage.width, height: kUIStyle.scaleH(54))
        //        moneyLable.text = "+5000000"
        
        
        
        unitLable = UILabel()
        unitLable.textColor = mainColor
        unitLable.font = kUIStyle.sysFontDesignSize(size: 32)
        unitLable.textAlignment = .center
        bacView.addSubview(unitLable)
        unitLable.frame = CGRect(x: bgImage.x, y: moneyLable.maxY+2, width: moneyLable.width, height: kUIStyle.scaleH(34))
        unitLable.text = COINNAME_PREIUM
        
        
        
        statusBtn = UIButton()
        statusBtn.setBackgroundImage(UIImage(named: "giving_title_bg")?.withRenderingMode(.alwaysTemplate), for: .normal)
        statusBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        statusBtn.setTitleColor(UIColor.white, for: .normal)
        bacView.addSubview(statusBtn)
        statusBtn.tintColor = UIColor.colorWithHexString("D2D2D2")
        statusBtn.frame = CGRect(x: bgImage.maxX-50, y: 0, width: 50, height: 18)
        
    }
    
    
    class func getHeight() -> CGFloat {
        
        return kUIStyle.scaleH(200)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }
    
    
}








