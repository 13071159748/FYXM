//
//  MQIApplePayCollectionViewCell.swift
//  CQSC
//
//  Created by moqing on 2019/2/25.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit
import SnapKit

class MQIApplePayCollectionViewCell: MQICollectionViewCell {

    var model: MQIApplePayItemModel? {
        didSet(oldValue) {
            if let model = model {
                moneyLabel.text = model.currencyStr + " \(model.priceValue.floatValue() / 100)"

                if model.prize != "" {
                    cellBackgroundImageView.image = UIImage(named: "pay_cell_bg")
                    prizeLabel.isHidden = false
                    prizeLabel.text = model.prize
                    centerYConstraint?.update(offset: -10)
                    prizeWConstraint?.update(offset: prizeLabel.mj_textWith() + 28)
                } else {
                    cellBackgroundImageView.image = UIImage(named: "")
                    prizeLabel.isHidden = true
                    centerYConstraint?.update(inset: 0)
                }

//                priceLable.text =  model.name
                if model.premium == "" {
//                    discountLable.text  = " "
                    priceLable.text = model.name
                } else {
//                    discountLable.text = "赠送\(model.premium)"
//                    self.priceBottomConstraint?.update(offset: 0)
                    priceLable.text = model.name + "+" + model.premium
                }
                if model.badge_text.count > 0 {
                    badgeBtn.isHidden = false
                    saleImage.image = nil
                    badgeBtn.setTitle("   " + model.badge_text + "   " + " ", for: .normal)
                    if model.badge_color.count > 5 {
                        badgeBtn.tintColor = kUIStyle.colorWithHexString(model.badge_color)
                    } else {
                        badgeBtn.tintColor = kUIStyle.colorWithHexString("#5A94FF")
                    }
                } else {
                    badgeBtn.isHidden = true
                    saleImage.image = nil
//                    if model.first == "1" || model.type == "acvi" {
//                        saleImage.image = UIImage(named: "first")
//                    }else if model.recommend == "1" || model.type == "recommend"{
//                        saleImage.image = UIImage(named: "pre")
//                    }else{
//                        saleImage.image = nil
//                    }

                }

            }
        }
    }

    var centerYConstraint: Constraint?
    var prizeWConstraint: Constraint?
    var prizeLabel = UILabel()

    var isSelectedItem: Bool = false {
        didSet(oldValue) {
            if isSelectedItem {
                bacView.dsySetBorderr(color: UIColor.colorWithHexString("EB5567"), width: 1)
            } else {
                bacView.dsySetBorderr(color: UIColor.clear, width: 1)
            }
        }
    }

    var priceBottomConstraint: Constraint? = nil

    var moneyLabel: UILabel!
    var priceLable: UILabel!
    var icon: UIImageView!
    var discountLable: UILabel!
    var saleImage: UIImageView!
    var bacView: UIView!
    var cellBackgroundImageView = UIImageView()
    var badgeBtn: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupUI() -> Void {
        bacView = UIView()
        bacView.backgroundColor = UIColor.white
        bacView.frame = contentView.bounds
        contentView.addSubview(bacView)
//        let bgImage = UIImageView(image: #imageLiteral(resourceName: "topUpItemBG"))
//        bacView.addSubview(bgImage)
//        bgImage.snp.makeConstraints { (make) in
//            make.top.bottom.left.right.equalToSuperview()
//        }
        bacView.addSubview(cellBackgroundImageView)
        cellBackgroundImageView.snp.makeConstraints { (make) in
            make.left.equalTo(-5)
            make.top.equalTo(-5)
            make.right.bottom.equalTo(5)
        }

        saleImage = UIImageView(image: UIImage(named: "pre"))
        bacView.addSubview(saleImage)
        saleImage.backgroundColor = UIColor.clear
        saleImage.contentMode = .scaleAspectFit
        saleImage.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.height.width.equalTo(35)
        }

        moneyLabel = UILabel()
        moneyLabel.textColor = kUIStyle.colorWithHexString("#333333")
        moneyLabel.font = UIFont.systemFont(ofSize: 14)
        moneyLabel.textAlignment = .left
        moneyLabel.adjustsFontSizeToFitWidth = true
        bacView.addSubview(moneyLabel)


        priceLable = UILabel()
        priceLable.textColor = UIColor.colorWithHexString("#EB5567")
        priceLable.font = UIFont.systemFont(ofSize: 16)
        priceLable.textAlignment = .left
        priceLable.adjustsFontSizeToFitWidth = true
        bacView.addSubview(priceLable)

        discountLable = UILabel()
        discountLable.textColor = kUIStyle.colorWithHexString("5A94FF")
        discountLable.font = UIFont.systemFont(ofSize: 10)
        discountLable.textAlignment = .center
        discountLable.adjustsFontSizeToFitWidth = true
//        bacView.addSubview(discountLable)
//        discountLable.snp.makeConstraints { (make) in
//            make.top.equalTo(priceLable.snp.bottom).offset(3)
//            make.right.equalToSuperview().offset(-5)
//            make.left.equalToSuperview().offset(5)
//            make.height.equalTo(14)
//        }
//
        badgeBtn = UIButton()
        badgeBtn.setBackgroundImage(UIImage(named: "Pay_label_Img")?.withRenderingMode(.alwaysTemplate), for: .normal)
        badgeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        badgeBtn.tintColor = kUIStyle.colorWithHexString("EB5567")
        badgeBtn.setTitleColor(UIColor.colorWithHexString("000000"), for: .normal)
        bacView.addSubview(badgeBtn)
        badgeBtn.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.height.equalTo(20)
        }

        moneyLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(57 + 24)
            make.height.equalTo(28)
            make.right.equalToSuperview()
        }

        priceLable.snp.makeConstraints { (make) in
            centerYConstraint = make.centerY.equalToSuperview().constraint

            make.left.equalTo(20)
            make.height.equalTo(22)
        }
        bacView.addSubview(prizeLabel)
        prizeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(priceLable.snp.bottom).offset(3)
            make.centerX.equalTo(priceLable)
            make.height.equalTo(16)
            prizeWConstraint = make.width.equalTo(137).constraint
        }

        prizeLabel.backgroundColor = UIColor(hex: "#F8E71C")
        prizeLabel.font = UIFont.systemFont(ofSize: 10)
        prizeLabel.textAlignment = .center
        prizeLabel.textColor = .black

    }


    func getAtStr(str: String) -> NSMutableAttributedString {
        let att1 = NSMutableAttributedString(string: str)
        att1.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11)], range: NSRange.init(location: str.count - 2, length: 2))
        return att1
    }


    class func getPaySize() -> CGSize {
        return CGSize(width: _payCollectionViewCellW, height: _payCollectionViewCellH)
    }

}
fileprivate let _payCollectionViewCellW: CGFloat = screenWidth - 40
fileprivate let _payCollectionViewCellH: CGFloat = 60

class MQIApplePayBtnCollectionViewCell: MQICollectionViewCell {

    var model: MQIApplePayItemModel? {
        didSet(oldValue) {
            if let model = model {
                titleText = model.currencyStr + " \(model.priceValue.floatValue() / 100)"
            } else {
                titleText = ""
            }
        }
    }
    fileprivate var title: UILabel!//标题
    var titleText: String = "" {
        didSet(oldValue) {
            title.text = "充值\(titleText)"
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }

    func setupUI() {
        let bacView = UIView()
        bacView.backgroundColor = #colorLiteral(red: 0.4431372549, green: 0.5294117647, blue: 1, alpha: 1)
        contentView.addSubview(bacView)
        bacView.layer.cornerRadius = 25
        bacView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(36)
            make.right.equalToSuperview().offset(-36)
            make.height.equalToSuperview()
        }
        addDefineLayer(bacView, bacView.bounds)


        title = UILabel()
        title.textColor = .white
        title.font = kUIStyle.sysFontDesign1PXSize(size: 16)
        title.textAlignment = .center
        bacView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }

    }
    private func addDefineLayer(_ view: UIView, _ frame: CGRect) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [kUIStyle.colorWithHexString("#65AAFF", alpha: 1).cgColor, kUIStyle.colorWithHexString("#53A0FD", alpha: 1).cgColor, kUIStyle.colorWithHexString("#67D2FF", alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1.0)
        gradientLayer.frame = frame
        view.layer.addSublayer(gradientLayer)
        gradientLayer.cornerRadius = 20
    }

    class func getSize() -> CGSize {
        return CGSize(width: screenWidth, height: 42 + 9)
    }
}



