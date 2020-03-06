//
//  MQIDiscountCardDetailsMaskView.swift
//  CQSC
//
//  Created by moqing on 2019/7/8.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

import MJRefresh

class MQIDiscountCardDetailsMaskView: UIView {
    
    var clickBcolck:(()->())?
    fileprivate var dc = MQIDiscountCardInfo(){
        didSet(oldValue) {
            let att1 =   NSMutableAttributedString(string: "已为您优惠\n")
            att1.append( NSAttributedString(string: "\(dc.total_reduction_chapter)次", attributes: [NSAttributedString.Key.font : kUIStyle.boldSystemFont1PXDesignSize(size: 14)]))
            navLeftTitle1.attributedText = att1
            
            let att2 =   NSMutableAttributedString(string: "已为您节省\n")
            att2.append( NSAttributedString(string: "\(dc.total_reduction_coin)\(COINNAME)", attributes: [NSAttributedString.Key.font : kUIStyle.boldSystemFont1PXDesignSize(size: 14)]))
            navLeftTitle2.attributedText = att2
            
            bottomLabel2.text = "\(dc.total_reduction_coin)\(COINNAME)"
        }
    }
    fileprivate  var dataArr =  [MQIUserDiscountCardRankModel]()
    
    fileprivate var navLeftTitle1: UILabel!
    fileprivate var navLeftTitle2 :UILabel!
    fileprivate var bottomLabel2:UILabel!
    
    fileprivate var tableView:MQITableView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        tableView.mj_header.beginRefreshing()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        setupUI()
        
    }
    
    func setupUI()  {
        
        let  titleLable = UILabel()
        titleLable.backgroundColor = UIColor.white
        titleLable.font  = kUIStyle.boldSystemFont1PXDesignSize(size: 17)
        titleLable.textColor = mainColor
        titleLable.textAlignment = .center
        titleLable.adjustsFontSizeToFitWidth = true
        addSubview(titleLable)
        titleLable.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(23)
        }
        titleLable.text = "打折卡优惠明细"
        
        
        
        let rightBtn = UIButton()
        rightBtn.backgroundColor = UIColor.white
        rightBtn.imageView?.contentMode = .scaleAspectFit
        rightBtn.setImage(UIImage(named: "close_img"), for: .normal)
        rightBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        addSubview(rightBtn)
        rightBtn.contentHorizontalAlignment = .right
        rightBtn.tintColor = UIColor.black
        rightBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-18)
            make.top.equalToSuperview().offset(18)
            make.width.equalTo(44)
            make.height.equalTo(20)
        }
        
        
        let navView = UIView()
        addSubview(navView)
        navView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(61)
            make.top.equalTo(titleLable.snp.bottom).offset(12)
        }
        
        navLeftTitle1 = UILabel()
        navLeftTitle1.font  = kUIStyle.sysFontDesign1PXSize(size: 14)
        navLeftTitle1.textColor = UIColor.colorWithHexString("#2C2B40")
        navLeftTitle1.textAlignment = .center
        navLeftTitle1.numberOfLines = 0
        navLeftTitle1.backgroundColor = UIColor.colorWithHexString("#D8DDE9")
        addSubview(navLeftTitle1)
        navLeftTitle1.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.bottom.equalTo(navView)
            make.width.equalToSuperview().multipliedBy(0.5)
            
        }
        
        navLeftTitle2 = UILabel()
        navLeftTitle2.font  = kUIStyle.sysFontDesign1PXSize(size: 14)
        navLeftTitle2.textColor = UIColor.colorWithHexString("#ffffff")
        navLeftTitle2.textAlignment = .center
        navLeftTitle2.numberOfLines = 0
        navLeftTitle2.backgroundColor = mainColor
        addSubview(navLeftTitle2)
        navLeftTitle2.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.bottom.equalTo(navView)
            make.width.equalToSuperview().multipliedBy(0.5)
            
        }
        
        
        
        let  titleLable2 = UILabel()
        titleLable2.font  = kUIStyle.boldSystemFont1PXDesignSize(size: 16)
        titleLable2.textColor = mainColor
        titleLable2.textAlignment = .center
        titleLable2.adjustsFontSizeToFitWidth = true
        addSubview(titleLable2)
        
        titleLable2.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(navView.snp.bottom).offset(10)
        }
        titleLable2.text = "打折卡会员省钱计算器"
        
        let  subTitleLable = UILabel()
        subTitleLable.backgroundColor = UIColor.white
        subTitleLable.font  = kUIStyle.sysFont(size: 12)
        subTitleLable.textColor = UIColor.colorWithHexString("#666666")
        subTitleLable.textAlignment = .center
        subTitleLable.adjustsFontSizeToFitWidth = true
        addSubview(subTitleLable)
        
        subTitleLable.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLable2.snp.bottom)
        }
        subTitleLable.text = "(系统为您展示最近的省钱明细)"
        
        let  bottomLineView = UIView()
        bottomLineView.backgroundColor = UIColor.colorWithHexString("#E2E2E2")
        addSubview(bottomLineView)
        bottomLineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        let bottomLabel1  =   UILabel()
        bottomLabel1.font  = kUIStyle.boldSystemFont1PXDesignSize(size: 13)
        bottomLabel1.textColor = UIColor.colorWithHexString("#333333")
        bottomLabel1.textAlignment = .left
        bottomLabel1.text = "已为您节省"
        addSubview(bottomLabel1)
        bottomLabel1.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(27)
            make.top.equalTo(bottomLineView.snp.bottom).offset(7)
        }
        
        
        bottomLabel2  =   UILabel()
        bottomLabel2.font  = kUIStyle.boldSystemFont1PXDesignSize(size: 13)
        bottomLabel2.textColor = UIColor.colorWithHexString("#333333")
        bottomLabel2.textAlignment = .right
        addSubview(bottomLabel2)
        bottomLabel2.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-27)
            make.top.equalTo(bottomLabel1)
        }
        
        
        
        tableView = MQITableView()
        tableView.separatorStyle = .none
        tableView.gyDelegate = self
        tableView.registerCell(MQIDiscountCardDetailsMaskViewlTableViewCell.self, xib: false)
        addSubview(tableView)
        tableView.snp.makeConstraints { (make   ) in
            make.left.equalToSuperview().offset(17)
            make.right.equalToSuperview().offset(-17)
            make.top.equalTo(subTitleLable.snp.bottom).offset(14)
            make.bottom.equalTo(bottomLineView.snp.top)
        }
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.dataArr.removeAll()
                strongSelf.getData()
            }
        })
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.getData("\(strongSelf.dataArr.count)")
            }
        })
        
        
    }
    
    func getData(_ offset:String = "0") {
        MQIUser_cost_reductionRequest.init(offset: offset, limit: "10").request({ [weak self] (_, _, dc:MQIDiscountCardInfo) in
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
            if dc.data.count == 0 {
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
            self?.dc = dc
            if offset != "0" {
                self?.dataArr.append(contentsOf: dc.data)
            }else{
                self?.dataArr = dc.data
            }
            self?.tableView.reloadData()
            
        }) {[weak self]  (msg, code)  in
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
            MQILoadManager.shared.makeToast(msg)
        }
    }
    
    @objc fileprivate  func closeAction()  {
        clickBcolck?()
    }
    
    
}

extension MQIDiscountCardDetailsMaskView:MQITableViewDelegate{
    
    func numberOfTableView(_ tableView: MQITableView) -> Int {
        return 1
    }
    func numberOfRow(_ tableView: MQITableView!, section: Int) -> Int {
        return dataArr.count
    }
    func heightForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> CGFloat {
        return MQIDiscountCardDetailsMaskViewlTableViewCell.getHeight(nil)
    }
    func cellForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(MQIDiscountCardDetailsMaskViewlTableViewCell.self, forIndexPath: indexPath)
        let model = dataArr[indexPath.row]
        cell.title.text = getTimeStampToString(model.date)
        cell.subTitle.text = model.reduction_coin + COINNAME
        return cell
        
    }
}

class MQIDiscountCardDetailsMaskViewlTableViewCell: MQICardBaseTableViewCell {
    
    var title:UILabel!
    var subTitle:UILabel!
    override func setupUI() {
        bacImge.isHidden = true
        
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.colorWithHexString("E3E6EE")
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        let dotView = UIView()
        dotView.backgroundColor = mainColor
        dotView.dsySetCorner(radius: 3)
        contentView.addSubview(dotView)
        dotView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(6)
        }
        
        title = UILabel()
        title.font = UIFont.systemFont(ofSize: 13)
        title.textColor = UIColor.colorWithHexString("#333333")
        title.lineBreakMode = .byTruncatingMiddle
        title.textAlignment = .left
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(dotView.snp.right).offset(5)
            make.centerY.equalTo(dotView)
        }
        subTitle = UILabel()
        subTitle.font = UIFont.systemFont(ofSize: 13)
        subTitle.textColor  = UIColor.colorWithHexString("#333333")
        subTitle.textAlignment = .left
        contentView.addSubview(subTitle)
        subTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(title)
            make.right.equalTo(lineView)
            
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
    override class func getHeight<T: MQIBaseModel>(_ obj: T?) -> CGFloat {
        return 28
    }
    
}
