//
//  MQIDiscountCardViewController.swift
//  CQSC
//
//  Created by moqing on 2019/5/17.
//  Copyright © 2019年 _CHK_. All rights reserved.
//

import UIKit

class MQIDiscountCardViewController: MQIBaseViewController {

    
    var image_top: UIImageView!
    
    var image_bottom: UIImageView!
    
    var total: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = kLocalized("discountCard", describeStr: "打折卡")
        configUI()
    }
    
    private func getSize(string: String?, isWidth: Bool) -> String? {
        let parameterArray = string?.components(separatedBy: "?").last?.components(separatedBy: "&")
        return  isWidth ? parameterArray?.first?.components(separatedBy: "=").last :
                          parameterArray?.last?.components(separatedBy: "=").last
        
    }
    
    
    func reloadView(topSize: CGSize?, bottomSize: CGSize?) {
        guard let topSize = topSize, let bottomSize = bottomSize else { return }
        let topHeight =  screenWidth * topSize.height / topSize.width
        let bottomHeight =  screenWidth * bottomSize.height / bottomSize.width
        
        image_top.snp.updateConstraints { (make) in
            make.height.equalTo(topHeight)
        }
        image_bottom.snp.updateConstraints { (make) in
            make.height.equalTo(bottomHeight)
        }
        scroll_contentView.snp.updateConstraints { (make) in
            make.height.equalTo(topHeight + bottomHeight + 49)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MQIDiscountCardInfoRequest().request({ (_, _, dc: MQIDiscountCardInfo) in
            guard dc.images.count == 2 else {
                self.popVC()
                self.view.makeToast("\(kLocalized("dataReturnError", describeStr: "数据返回出错"))", duration: 1.0, position: .center)
                return
            }
            let top_url = URL(string: dc.images.first ?? "")
            let bottom_url = URL(string: dc.images.last ?? "")
            ///缓存
            UserDefaults.standard.set(dc.images.first ?? "", forKey: "discountVCTopImageViewURL")
            UserDefaults.standard.set(dc.images.last ?? "", forKey: "discountVCBottomImageViewURL")
            
            let topSize: CGSize = CGSize(width: self.getSize(string: dc.images.first, isWidth: true)?.CGFloatValue() ?? 0,
                                         height: self.getSize(string: dc.images.first, isWidth: false)?.CGFloatValue() ?? 0)
            let bottomSize: CGSize = CGSize(width: self.getSize(string: dc.images.last, isWidth: true)?.CGFloatValue() ?? 0,
                                            height: self.getSize(string: dc.images.last, isWidth: false)?.CGFloatValue() ?? 0)
            self.reloadView(topSize: topSize, bottomSize: bottomSize)
            self.image_top.sd_setImage(with: top_url, placeholderImage: nil, options: [], completed: nil)
            self.image_bottom.sd_setImage(with: bottom_url, placeholderImage: nil, options: [], completed: nil)
            self.total.text = "\(kLocalized("totalPrice", describeStr: "总价"))：\(dc.currencyStr)\(dc.price.floatValue()/100)/\(kLocalized("month", describeStr: "月"))"
        }, failureHandler: { (msg, code) in
            self.popVC()
            self.view.makeToast(msg, duration: 1.0, position: .center)
        })
    }
    
    
    private var scroll_contentView: UIView!
    
    func configUI() {
        
        let topURL =  UserDefaults.standard.object(forKey: "discountVCTopImageViewURL") as? String
        let bottomURL =  UserDefaults.standard.object(forKey: "discountVCBottomImageViewURL") as? String
        let top_url = URL(string: topURL ?? "")
        let bottom_url = URL(string: bottomURL ?? "")
        
        let topSize: CGSize = CGSize(width: self.getSize(string: topURL, isWidth: true)?.CGFloatValue() ?? 0,
                                     height: self.getSize(string: topURL, isWidth: false)?.CGFloatValue() ?? 0)
        let bottomSize: CGSize = CGSize(width: self.getSize(string: bottomURL, isWidth: true)?.CGFloatValue() ?? 0,
                                        height: self.getSize(string: bottomURL, isWidth: false)?.CGFloatValue() ?? 0)
        
        
        let topHeight =  topURL == nil ? 384.0 : screenWidth * topSize.height / topSize.width
        let bottomHeight =  bottomURL == nil ? 267.0 : screenWidth * bottomSize.height / bottomSize.width

        
        
        let scrollView = UIScrollView()
        contentView.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.centerX.equalToSuperview()
        }
        scroll_contentView = UIView()
        scrollView.addSubview(scroll_contentView)
        scroll_contentView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.centerX.equalToSuperview()
            make.height.equalTo(topHeight + bottomHeight + 49)
        }
        
        image_top = UIImageView()
        scroll_contentView.addSubview(image_top)
        image_top.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(topHeight)
        }
        image_bottom = UIImageView()
        scroll_contentView.addSubview(image_bottom)
        image_bottom.snp.makeConstraints { (make) in
            make.top.equalTo(image_top.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(bottomHeight)
        }
        
        let bottomView = UIView()
        
        contentView.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(49)
        }
        bottomView.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.168627451, blue: 0.2509803922, alpha: 1)
        
        
        image_top.sd_setImage(with: top_url, placeholderImage: nil, options: [], completed: nil)
        image_bottom.sd_setImage(with: bottom_url, placeholderImage: nil, options: [], completed: nil)
        
        let btn = UIButton()
        btn.setBackgroundImage(#imageLiteral(resourceName: "discountCardBtn"), for: .normal)
        btn.setTitle("\(kLocalized("buyNow", describeStr: "立即购买"))", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.addTarget(self, action: #selector(clickBtn(btn:)), for: .touchUpInside)
        bottomView.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.bottom.top.right.equalToSuperview()
            make.width.equalTo(151)
        }
        
        total = UILabel()
        total.textColor = .white
        total.text = "\(kLocalized("totalPrice", describeStr: "总价"))：-"
        total.font = UIFont.systemFont(ofSize: 20)
        total.textAlignment = .left
        bottomView.addSubview(total)
        total.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(23)
            make.top.equalToSuperview().offset(9)
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(28)
        }
        
        
    }
    
    
    @objc func clickBtn(btn: UIButton) {
        ///点击购买
//        guard let nvcs = navigationController?.viewControllers else {  return }
//        guard let vc = nvcs.xm_index(of: nvcs.count - 2) as? MQIApplePayViewController else { return }
//        vc.pay_discount_card()
        toPay()
    }
    
    
    
    
    var inPurchaseManager = MQIIAPManager.shared
    func toPay() {
        if !MQIUserManager.shared.checkIsLogin() {
            MQIUserOperateManager.shared.toLoginVC { [weak self]  in
                self?.toPay()
            }
            return
        }
        let product_id = "cqsc.card.discount_5"
        MQILoadManager.shared.addProgressHUD("")
        inPurchaseManager.callbackBlock = { (suc: Bool,  msg: String) in
            MQIUserDiscountCardInfo.reload(isMandatory: true)
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
                MQILoadManager.shared.dismissProgressHUD()
                MQILoadManager.shared.makeToast(msg)
            }
        }
        inPurchaseManager.requestProductId(productId: product_id)
        
    }
    
    

}
