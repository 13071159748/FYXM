//
//  MQIResultsPageView.swift
//  CQSC
//
//  Created by moqing on 2019/7/3.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

enum ResultsType {
    case banner /// 横幅样式
    case recommended /// 推荐数据
    case prompt /// 只提示没有推荐
    case coupons /// 优惠券
}

class MQIResultsPageView: UIView {

    var type:ResultsType = .banner
    var model: MQIResultsPageModel!{
        didSet(oldValue) {
            self.type = model.type
            if type == .prompt {
                addPromptView()
            }else{
                addComplexView()
            }
        }
    }
    var callbackBlock:((_ book_id:String?,_ linkUrl:String?)->())?
    var getCouponseBlock:(()->())?
    fileprivate var bottomContentView: MQIResultsBottomContentView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI()  {
        cleanSelf()
        self.tag = 87364
        self.backgroundColor = UIColor.colorWithHexString("#000000", alpha: 0.2)
    }
    
    
    func addPromptView() {
        
        let topContentView = MQIResultsTopContentView.init(frame: CGRect.zero, type: self.type)
        topContentView.backgroundColor = UIColor.white
        addSubview(topContentView)
        topContentView.dsySetCorner(radius: 15)
        
        topContentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(kUIStyle.scale1PXW(44))
            make.right.equalToSuperview().offset(-kUIStyle.scale1PXW(44))
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
            make.height.greaterThanOrEqualTo(200).priority(.high)
            make.height.greaterThanOrEqualTo(230).priority(.low)
        }
        
        topContentView.clickBlock = { [weak self] in
            self?.dismiss()
        }
        topContentView.topImg.image = UIImage(named: model.prompt_img_name)
        topContentView.titleLabel1.attributedText = model.title1
        topContentView.titleLabel2.attributedText = model.title2
        topContentView.titleLabel3.attributedText = model.title3
        if  model.btnTitle != nil {
            topContentView.btn.setTitle(model.btnTitle, for: .normal)
        }
       
    }
    
    func addComplexView() {
        
        let topContentView = MQIResultsTopContentView.init(frame: CGRect.zero, type: self.type)
        topContentView.backgroundColor = UIColor.clear
        addSubview(topContentView)
        topContentView.layer.contents =  UIImage(named: "resultsPageView_bg_img1")?.cgImage
        
        
        let bottomContentView = MQIResultsBottomContentView.init(frame: CGRect.zero, type: self.type)
        bottomContentView.backgroundColor = UIColor.clear
        self.bottomContentView = bottomContentView
        addSubview(bottomContentView)
        bottomContentView.layer.contents =  UIImage(named: "resultsPageView_bg_img2")?.cgImage
        
        
        let centerLineView = UIView()
        centerLineView.backgroundColor = UIColor.colorWithHexString("D7D7D7")
        addSubview(centerLineView)
        
        let centerLabel = UILabel()
        centerLabel.backgroundColor = UIColor.white
        centerLabel.font = UIFont.systemFont(ofSize: 12)
        centerLabel.textColor = UIColor.colorWithHexString("999999")
        centerLabel.textAlignment = .center
        centerLabel.adjustsFontSizeToFitWidth = true
        addSubview(centerLabel)
        centerLabel.snp.makeConstraints { (make) in
            make.width.equalTo(kUIStyle.scale1PXW(88))
            make.centerY.centerX.equalTo(centerLineView)
        }
   
        centerLineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(kUIStyle.scale1PXW(54))
            make.right.equalToSuperview().offset(-kUIStyle.scale1PXW(54))
            make.height.equalTo(1)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(50)
        }
        
        topContentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(kUIStyle.scale1PXW(44))
            make.right.equalToSuperview().offset(-kUIStyle.scale1PXW(44))
            make.centerX.equalTo(centerLineView)
            make.bottom.equalTo(centerLineView)
            make.height.greaterThanOrEqualTo(200).priority(.high)
            make.height.greaterThanOrEqualTo(230).priority(.low)
        }
        
        let height = type == .coupons ? 159 : 137
        bottomContentView.snp.makeConstraints { (make) in
            make.left.right.centerX.equalTo(topContentView)
            make.top.equalTo(centerLineView.snp.bottom)
            make.height.equalTo(height)
        }
        
        topContentView.clickBlock = { [weak self] in
            self?.dismiss()
            
        }
        bottomContentView.clickBlock = { [weak self] (tag)in
            self?.dismiss()
            if tag >= 10000 {
                self?.callbackBlock?(nil,self?.model.linkStr)
            }else{
                self?.callbackBlock?(self?.model.itmeData[tag-100].book_id,nil)
            }
        }
        
        topContentView.topImg.image = UIImage(named: model.prompt_img_name)
        topContentView.titleLabel1.attributedText = model.title1
        topContentView.titleLabel2.attributedText = model.title2
        topContentView.titleLabel3.attributedText = model.title3
        if  model.btnTitle != nil {
            topContentView.btn.setTitle(model.btnTitle, for: .normal)
        }
        centerLabel.text = model.lineTitle
        
        if bottomContentView.bannerImg != nil {
            bottomContentView.bannerImg?.sd_setImage(with: URL(string: model.banner_Img_url))
        } else if type == .coupons {
            bottomContentView.couponseDatas = model.itemCouponse
        } else {
            //书籍推荐
            for i in  0..<bottomContentView.itmes.count {
                let item = bottomContentView.itmes[i]
                if i < model.itmeData.count {
                    let itmeModel = model.itmeData[i]
                    item.isHidden = false
                    item.imgView.sd_setImage(with: URL(string: itmeModel.book_img_url), placeholderImage: bookPlaceHolderImage)
                    item.title.text = itmeModel.book_title
                }else{
                    item.isHidden = true
                }
            }
        }
        
        bottomContentView.couponseItemClickBlock = {[weak self](index) in
            if let weakSelf = self {
                weakSelf.couponseEventRequest(index)
            }
        }
        
    }
    
    func cleanSelf()  {
        self.superview?.viewWithTag(87364)?.removeFromSuperview()
    }
    
    func dismiss() {
         self.removeFromSuperview()
    }
    
    //领取或者查看某个优惠券
    func couponseEventRequest(_ index: Int) {
        
        let indexModel = model.itemCouponse[index]
        mqLog("点击了优惠券 \(indexModel.prize_name), state = \(indexModel.prize_status)")
        
        if indexModel.prize_status == 2 {
            //查看  跳转我的卡券
            dismiss()
            MQIOpenlikeManger.toCardCounponVC()
            return
        }
        
        MQILoadManager.shared.addProgressHUD("")
        MQICouponseRecievePirceRequest.init(event_id: "\(indexModel.event_id)", prize_id: "\(indexModel.prize_id)").request({[weak self] (request, response, result: MQIBaseModel) in
            MQILoadManager.shared.dismissProgressHUD()
            mqLog("领取h优惠券 \(result.dict)")
            if let weakSelf = self {
                if let code = result.dict["code"] as? NSNumber {
                    if code.intValue == 200 {
                        //修改状态
                        weakSelf.changeCouponseState(index: index)
                    }
                }
                if let message = result.dict["message"] as? String {
                    MQILoadManager.shared.makeToastBottom(message)
                }
            }
        }, failureHandler: {(err_str, err_code) in
            MQILoadManager.shared.dismissProgressHUD()
        })
    }
    
    fileprivate func changeCouponseState(index: Int) {
        bottomContentView.changeIndex = index
    }
    
}

private class MQIResultsTopContentView: UIView
{
    var type:ResultsType = .prompt
    var topImg:UIImageView!
    var titleLabel1:UILabel!
    var titleLabel2:UILabel!
    var titleLabel3:UILabel!
    var btn:UIButton!
    var clickBlock:(()->())?
    init(frame: CGRect,type:ResultsType) {
        super.init(frame: frame)
        self.type = type
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI()  {
        
        topImg = UIImageView()
        topImg.contentMode = .scaleAspectFit
        addSubview(topImg)
       
        
        titleLabel1 = createRLabel(font: UIFont.boldSystemFont(ofSize: 22), textColor: mainColor, textAlignment: .center, numberOfLines: 1)
        addSubview(titleLabel1)
        
        titleLabel2 = createRLabel(font: UIFont.systemFont(ofSize: 16), textColor: kUIStyle.colorWithHexString("666666"), textAlignment: .center, numberOfLines: 0)

        addSubview(titleLabel2)
        
        titleLabel3 = createRLabel(font: UIFont.systemFont(ofSize: 11), textColor: kUIStyle.colorWithHexString("999999"), textAlignment: .center, numberOfLines: 1)
        addSubview(titleLabel3)
        
        btn = UIButton()
        btn.backgroundColor = mainColor
        btn.dsySetCorner(radius: 20)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.setTitleColor(UIColor.white, for: .normal)
        addSubview(btn)
        btn.setTitle(kLocalized("I_know_the"), for: .normal)
        btn.addTarget(self, action: #selector(clickBtn), for: UIControl.Event.touchUpInside)
        topImg.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.width.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
        titleLabel1.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(topImg.snp.bottom).offset(5)
            make.height.greaterThanOrEqualTo(1)
        }
        titleLabel2.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel1)
            make.top.equalTo(titleLabel1.snp.bottom).offset(5)
            make.height.greaterThanOrEqualTo(1)
        }
        titleLabel3.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel2)
            make.top.equalTo(titleLabel2.snp.bottom).offset(8)
            make.height.greaterThanOrEqualTo(1)
        }
        btn.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel3.snp.bottom).offset(5)
            make.width.equalTo(132)
            make.height.equalTo(40)
            if self.type == .prompt {
                make.bottom.greaterThanOrEqualToSuperview().offset(-40)
            }else{
                make.bottom.greaterThanOrEqualToSuperview().offset(-20)
            }
          
            make.centerX.equalToSuperview()
        }
//        if type == .prompt {
//
//
//        }else{
//            btn.snp.makeConstraints { (make) in
//                make.top.equalTo(titleLabel3.snp.bottom).offset(5)
//                make.width.equalTo(132)
//                make.height.equalTo(40)
//                make.bottom.greaterThanOrEqualToSuperview().offset(-20)
//                make.centerX.equalToSuperview()
//            }
//        }
    }
    
       @objc func clickBtn() {
            clickBlock?()
        }
    
}

private class MQIResultsBottomContentView: UIView
{
    
    var type:ResultsType = .banner
    var bannerImg:UIImageView?
    var btn:UIButton!
    var clickBlock:((_ tag:Int)->())?
    var couponseItemClickBlock:((_ index: Int)->())?
    var itmes = [ResultsBottomContentItmeView]()
    
    //优惠券模块
    var couponseViews = [ResultsBottomContentCouponsItmeView]()
    var couponseDatas: [MQICouponsModel]? {
        didSet {
            if couponseDatas != nil {
                addCouponsDataView()
            }
        }
    }
    var changeIndex: Int? {
        didSet {
            guard let couponseDatas = couponseDatas, let changeIndex = changeIndex else { return }
            if changeIndex < couponseDatas.count {
                mqLog("更改优惠券按钮状态 index \(changeIndex)")
                let indexModel = couponseDatas[changeIndex]
                indexModel.prize_status = 2
                couponseViews[changeIndex].model = indexModel
            }
        }
    }
    
    init(frame: CGRect,type:ResultsType) {
        super.init(frame: frame)
        self.type = type
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI()  {
        
        if type == .banner {
            addBannerView()
        } else if type == .coupons {
//            addCouponsDataView()
        } else{
            addMultipleDataView()
        }
        
    }

    func addBannerView() {
        bannerImg = UIImageView()
        addSubview(bannerImg!)
        bannerImg?.tag = 10000
        bannerImg?.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        }
        bannerImg?.dsyAddTap(self, action: #selector(clickItme(tap:)))
    }
    
    func addMultipleDataView()  {
        let bacview = UIView()
        addSubview(bacview)
        bacview.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 19, left: 28, bottom: 22, right: 28))
        }
        let count:Int = 3
     
        for i in 0..<count {
            let item = ResultsBottomContentItmeView()
            item.tag = 100+i
            bacview.addSubview(item)
            itmes.append(item)
            item.dsyAddTap(self, action: #selector(clickItme(tap:)))
        }
        
        itmes[1].snp.makeConstraints { (make) in
            make.top.bottom.centerX.equalToSuperview()
            make.width.equalTo(bacview.snp.height).multipliedBy(0.64)
        }
        itmes[0].snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(itmes[1])
            make.right.equalTo(itmes[1].snp.left).offset(-25)
            
        }
        itmes[2].snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(itmes[1])
            make.left.equalTo(itmes[1].snp.right).offset(25)
            
        }
    }
    
    func addCouponsDataView() {
        let bacview = UIView()
        addSubview(bacview)
        bacview.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 21, left: 28, bottom: 17, right: 28))
        }
        guard let couponseDatas = couponseDatas else { return }
        let count:Int = couponseDatas.count <= 3 ? couponseDatas.count : 3
        for i in 0..<count {
            let item = ResultsBottomContentCouponsItmeView()
            item.clickEvent = {[weak self] in
                if let self = self {
                    self.couponseItemClickBlock?(i)
                }
            }
            item.tag = 10+i
            bacview.addSubview(item)
            couponseViews.append(item)
            item.dsyAddTap(self, action: #selector(clickItme(tap:)))
            item.model = couponseDatas[i]
        }
        if count == 1 {
            couponseViews[0].snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(bacview.snp.height).multipliedBy(0.52)
                make.centerX.equalToSuperview()
            }
        } else if count == 2 {
            couponseViews[0].snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(bacview.snp.height).multipliedBy(0.52)
                make.centerX.equalToSuperview().multipliedBy(1/2.0)
            }
            couponseViews[1].snp.makeConstraints { (make) in
                make.width.top.bottom.equalTo(couponseViews[0])
                make.centerX.equalToSuperview().multipliedBy(3/2.0)
            }
        } else {
            couponseViews[1].snp.makeConstraints { (make) in
                make.top.bottom.centerX.equalToSuperview()
                make.width.equalTo(bacview.snp.height).multipliedBy(0.52)
            }
            couponseViews[0].snp.makeConstraints { (make) in
                make.top.bottom.width.equalTo(couponseViews[1])
                make.right.equalTo(couponseViews[1].snp.left).offset(-28)
            }
            couponseViews[2].snp.makeConstraints { (make) in
                make.top.bottom.width.equalTo(couponseViews[1])
                make.left.equalTo(couponseViews[1].snp.right).offset(28)
            }
        }
    }
    
    
    @objc func clickItme(tap:UITapGestureRecognizer) {
        guard let view = tap.view else {
            return
        }
        if let tag = tap.view?.tag {
            if tag < 100 {
                couponseItemClickBlock?(tag - 10)
                return
            }
        }
        clickBlock?(view.tag)
    }
    
    /// 推荐书籍
    class ResultsBottomContentItmeView: UIView {
        var imgView:UIImageView!
        var title:UILabel!
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupUI()
        }
        
        func setupUI()  {
            imgView = UIImageView()
            addSubview(imgView)
            imgView.snp.makeConstraints { (make) in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(self.snp.width).multipliedBy(1.3)
            }
            
            title = createRLabel(font: UIFont.boldSystemFont(ofSize: 10), textColor: UIColor.colorWithHexString("999999"), textAlignment: .left, numberOfLines: 1)
            addSubview(title)
            title.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(imgView.snp.bottom).offset(2)
            }
        }
    }
    
    /// 优惠券
    class ResultsBottomContentCouponsItmeView: UIView {
        
        var imgView: UIImageView!
        var title: UILabel!
        var button: UIButton!
        var model: MQICouponsModel? {
            didSet {
                guard let model = model else { return }
                title.text = model.prize_name
                imgView.sd_setImage(with: URL(string: model.img), placeholderImage: nil)
                button.setTitle(model.prize_status == 2 ? kLocalized("check") : kLocalized("PickUp"), for: .normal)
                button.setBackgroundColor(model.prize_status == 2 ? UIColor.colorWithHexString("#7ED321"): mainColor, for: .normal)
            }
        }
        var clickEvent: (()->())?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupUI()
        }
        
        func setupUI()  {
            imgView = UIImageView()
            addSubview(imgView)
            let ratio: CGFloat = 77.0/63.0
            imgView.snp.makeConstraints { (make) in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(self.snp.width).multipliedBy(ratio)
            }
            
            title = createRLabel(font: UIFont.boldSystemFont(ofSize: 10), textColor: UIColor.colorWithHexString("333333"), textAlignment: .center, numberOfLines: 1)
            addSubview(title)
            title.snp.makeConstraints { (make) in
                make.left.equalTo(imgView).offset(-8)
                make.right.equalTo(imgView).offset(8)
                make.top.equalTo(imgView.snp.bottom).offset(2)
//                make.height.equalTo(14)
            }
            
            button = createButton(.zero, normalTitle: kLocalized("PickUp"), normalImage: nil, selectedTitle: kLocalized("check"), selectedImage: nil, normalTilteColor: .white, selectedTitleColor: .white, bacColor: mainColor, font: systemFont(12), target: self, action: #selector(getOrCheckClick(_:)))
            button.layer.cornerRadius = 4
            button.clipsToBounds = true
            addSubview(button)
            button.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(title.snp.bottom).offset(6)
                make.height.equalTo(22)
            }
        }
        
        @objc func getOrCheckClick(_ btn: UIButton) {
            clickEvent?()
        }
        
    }
    
    
}
private  func createRLabel(font:UIFont,frame:CGRect = CGRect.zero,textColor:UIColor = UIColor.black,textAlignment:NSTextAlignment = .center,numberOfLines:Int = 1) -> UILabel {
    let label = UILabel(frame: frame)
    label.font = font
    label.textColor = textColor
    label.textAlignment = .center
    label.numberOfLines = numberOfLines
    return label
}


