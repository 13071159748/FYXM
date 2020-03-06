//
//  MQIWelfareCentreSignCollectionViewCell.swift
//  CHKReader
//
//  Created by moqing on 2019/1/25.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQIWelfareCentreSignCollectionViewCell: MQICollectionViewCell {

    var signModel: MQIWelfareModel? {
        didSet(oldValue) {
            if signModel != nil {
                signBtnBacView.list = signModel!.list
                if let user = MQIUserManager.shared.user {

                    for item in signBtnBacView.list {
                        if item.status == "signed" {
                            signtTitle.attributedText = getAtts(item.signed_day)
                        }
                    }

                    signBtn.setTitle((user.sign_in ? kLocalized("AlreadySignedIn") : "签到"), for: .normal)
                    isSign = user.sign_in
                } else {
                    for item in signBtnBacView.list {
                        if item.status == "signed" {
                            signtTitle.attributedText = getAtts(item.signed_day)
                        }
                    }
                    isSign = false
                }

                bacImage.sd_setImage(with: URL(string: signModel!.background_url))
            }
        }
    }

    var isSign: Bool = false {
        didSet(oldValue) {
            signBtn.setTitle((isSign ? kLocalized("AlreadySignedIn") : "签到"), for: .normal)
            signBtn.isUserInteractionEnabled = !isSign
        }
    }
    var clickSignBlock: (() -> ())?

    var bacImage: UIImageView!
    var signBtnBacView: MQINewSignBaseView!
    var signtTitle: UILabel!
    var signBtn: UIButton!
    var signInfoBtn = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    func setupUI() {

        let accessImage2 = UIImageView()
        accessImage2.image = UIImage(named: "sign_top_bg")
        contentView.addSubview(accessImage2)
        accessImage2.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalTo(kUIStyle.kScrWidth)
            make.height.equalTo(146)
            make.centerX.equalToSuperview()
        }

        bacImage = UIImageView()
//        bacImage.backgroundColor = kUIStyle.colorWithHexString("ffffff", alpha: 0.5)
        contentView.addSubview(bacImage)
        bacImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(kUIStyle.kScrWidth)
            make.height.equalTo(kUIStyle.kScrWidth * 0.5)
            make.centerX.equalToSuperview()
        }

        let signBacView = UIImageView()
        contentView.addSubview(signBacView)
        signBacView.image = UIImage(named: "sign_background")
        signBacView.isUserInteractionEnabled = true
        signBacView.dsySetCorner(radius: 8)
        signBacView.snp.makeConstraints { (make) in
            make.top.equalTo(40)
            make.height.equalTo(186)
            make.left.equalToSuperview().offset(-5)
            make.right.equalToSuperview().offset(5)
        }

        signtTitle = UILabel()
        signtTitle.font = kUIStyle.sysFontDesign1PXSize(size: 18)
        signtTitle.textAlignment = .left
        signtTitle.textColor = UIColor.black
        signtTitle.isUserInteractionEnabled = true
        signtTitle.numberOfLines = 1
        signBacView.addSubview(signtTitle)
        signtTitle.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(34)
            make.height.equalTo(25)
            make.right.equalTo(-130)
        }
        signtTitle.attributedText = getAtts("0")

        signInfoBtn = UIButton()
        signInfoBtn.setImage(UIImage(named: "sign_info"), for: .normal)
        signBacView.addSubview(signInfoBtn)
        signInfoBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.centerY.equalTo(signtTitle)
            make.left.equalTo(signtTitle.mj_textWith() + 20)
        }

        let signDescLabel = UILabel()
        signDescLabel.font = kUIStyle.sysFontDesign1PXSize(size: 12)
        signDescLabel.textAlignment = .left
        signDescLabel.textColor = UIColor(hex: "#666666")
        signBacView.addSubview(signDescLabel)
        signDescLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(signtTitle.snp.bottom).offset(4)
            make.height.equalTo(17)
            make.right.equalTo(-130)
        }
        signDescLabel.text = "每日签到送书券，连续7天有惊喜！"

        signBtn = UIButton()
        signBtn.setTitle("签到", for: .normal)
        signBtn.setTitleColor(UIColor(hex: "#BF5A00"), for: .normal)
        signBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)

        signBtn.setBackgroundImage(UIImage(named: "sign_btn"), for: .normal)
        signBtn.addTarget(self, action: #selector(signBtnClick), for: .touchUpInside)
        signBacView.addSubview(signBtn)
        signBtn.snp.makeConstraints { (make) in
            make.width.equalTo(92)
            make.top.equalTo(34)
            make.height.equalTo(50)
            make.right.equalTo(-20)
        }

        signBtnBacView = MQINewSignBaseView()
        contentView.addSubview(signBtnBacView)
        signBtnBacView.snp.makeConstraints { (make) in
            make.top.equalTo(signDescLabel).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(signBacView).offset(-20)
        }
    }

    func getAtts(_ text1: String) -> NSAttributedString {
        let cionColor: UIColor = UIColor.colorWithHexString("#FF4800")
        let titleColor: UIColor = UIColor.colorWithHexString("#333333")

        var coinCountStr = ""
        var titleStr = ""

        let numStr = text1
        coinCountStr = "已连续签到"
        titleStr = "天"

        let att1 = NSMutableAttributedString.init(string: coinCountStr, attributes: [NSAttributedString.Key.font: kUIStyle.boldSystemFont1PXDesignSize(size: 18), NSAttributedString.Key.foregroundColor: titleColor])
        let att2 = NSAttributedString.init(string: numStr, attributes: [NSAttributedString.Key.font: kUIStyle.sysFontDesign1PXSize(size: 18), NSAttributedString.Key.foregroundColor: cionColor])
        let att3 = NSMutableAttributedString.init(string: titleStr, attributes: [NSAttributedString.Key.font: kUIStyle.boldSystemFont1PXDesignSize(size: 18), NSAttributedString.Key.foregroundColor: titleColor])
        att1.append(att2)
        att1.append(att3)
        return att1 as NSAttributedString
    }

    func addDefineLayer(_ view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [kUIStyle.colorWithHexString("FFA774").cgColor, kUIStyle.colorWithHexString("FF5D44").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1.0)
        gradientLayer.frame = view.frame
        view.layer.addSublayer(gradientLayer)
    }

    @objc func signBtnClick() {
        clickSignBlock?()

    }

    class func getSize() -> CGSize {
        return CGSize(width: screenWidth - 30, height: 186 + 40)
    }

}


class MQINewSignBaseView: UIView {

    var list = [MQIWelfareItemModel]() {
        didSet(oldValue) {
            addItems()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func addItems() {
        if self.subviews.count == list.count && list.count > 0 {
            let lastIndex = self.subviews.count - 1
            for i in 0..<self.subviews.count {
                let item = self.subviews[i] as! MQINewSignItemView
                let data = list[lastIndex - i]
                var placeholderImage = UIImage(named: "New_Sign_no_img")
                item.signed = "0"
                if data.status == "signed" {
                    placeholderImage = UIImage(named: "New_Sign_sel_img")
                    item.signed = "1"
                }
                if i == 0 {
                    placeholderImage = UIImage(named: "New_Sign_final_img")
                    item.signed = "-1"

                }
                if data.status == "signed" {
                    item.imgae.image = placeholderImage
                } else {
                    if data.icon_url != "" {
                        item.imgae.sd_setImage(with: URL(string: data.icon_url),
                            placeholderImage: placeholderImage,
                            options: .allowInvalidSSLCertificates,
                            completed: { (i, error, type, u) in
                            })
                    }else {
                        item.imgae.image = placeholderImage
                    }
                }

                item.lable.text = "+" + data.premium
                item.dateLable.text = kLongLocalized("The_day", replace: data.signed_day)

            }

        } else {
            for view in self.subviews {
                view.removeFromSuperview()
            }
            var lastIndex = list.count - 1
            if lastIndex < 0 { lastIndex = 0 }
            for i in 0..<list.count {
                let oldItem = self.subviews.last
                let item = MQINewSignItemView()
                item.tag = 100 + lastIndex - i
                addSubview(item)
                item.snp.makeConstraints { (make) in
                    make.top.equalToSuperview()
                    if oldItem != nil {
                        make.right.equalTo(oldItem!.snp.left)
                    } else {
                        make.right.equalToSuperview()
                    }
                    make.bottom.equalToSuperview()
                    make.width.equalToSuperview().dividedBy(7)
                }
                let data = list[lastIndex - i]
                var placeholderImage = UIImage(named: "New_Sign_no_img")
                item.signed = "0"
                if data.status == "signed" {
                    placeholderImage = UIImage(named: "New_Sign_sel_img")
                    item.signed = "1"
                }
                if i == 0 {
                    placeholderImage = UIImage(named: "New_Sign_final_img")
                    item.signed = "-1"
                }
                if data.status == "signed" {
                    item.imgae.image = placeholderImage
                } else {
                    if data.icon_url != "" {
                        item.imgae.sd_setImage(with: URL(string: data.icon_url),
                            placeholderImage: placeholderImage,
                            options: .allowInvalidSSLCertificates,
                            completed: { (i, error, type, u) in
                            })
                    } else {
                        item.imgae.image = placeholderImage
                    }
                }

                item.lable.text = "+" + data.premium
                item.dateLable.text = kLongLocalized("The_day", replace: data.signed_day)
            }
        }
    }


    class MQINewSignItemView: UIView {
        var lable: UILabel!
        var dateLable: UILabel!
        var imgae: UIImageView!
        var rightView: UIView!
        ////线颜色  0 默认色 1 选中色 -1 不显示
        var signed: String = "0" {
            didSet(oldValue) {
                rightView.isHidden = false
                if signed == "1" {
                    rightView.backgroundColor = kUIStyle.colorWithHexString("#FF4343")
                    lable.textColor = UIColor.colorWithHexString("FE630A")
                    // imgae.dsySetBorderr(color: kUIStyle.colorWithHexString("#FF4343"), width: 0.5)
                } else if signed == "-1" {
                    rightView.isHidden = true
                }
                else {
                    rightView.backgroundColor = kUIStyle.colorWithHexString("#FFE4E3")
                    lable.textColor = UIColor.colorWithHexString("9DA0A9")
                    // imgae.dsySetBorderr(color: kUIStyle.colorWithHexString("#FFE4E3"), width: 0.5)
                }
            }
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        let imagThan: CGFloat = 66 / 120
        func setupUI() -> () {


            dateLable = UILabel()
            dateLable.font = kUIStyle.sysFontDesign1PXSize(size: 11)
            dateLable.textAlignment = .center
            dateLable.adjustsFontSizeToFitWidth = true
            dateLable.textColor = UIColor.colorWithHexString("999999")
            dateLable.isUserInteractionEnabled = true
            addSubview(dateLable)
            dateLable.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
            }
            imgae = UIImageView()
            imgae.isUserInteractionEnabled = true
            imgae.contentMode = .scaleAspectFit
            addSubview(imgae)
            imgae.snp.makeConstraints { (make) in
                make.top.greaterThanOrEqualToSuperview()
                make.bottom.equalTo(dateLable.snp.top)
                make.width.equalTo(33)
                make.centerX.equalToSuperview()
            }

            lable = UILabel()
            lable.font = kUIStyle.sysFontDesign1PXSize(size: 11)
            lable.textAlignment = .center
            lable.adjustsFontSizeToFitWidth = true
            lable.textColor = UIColor.colorWithHexString("9DA0A9")
            lable.isUserInteractionEnabled = true
            addSubview(lable)
            lable.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(imgae.snp.top).offset(9)
            }

            rightView = UIView()
            rightView.backgroundColor = kUIStyle.colorWithHexString("FFC5BD")
            addSubview(rightView)
            rightView.snp.makeConstraints { (make) in
                make.centerY.equalTo(imgae.snp.bottom).offset(-16)
                make.height.equalTo(1)
                make.left.equalTo(imgae.snp.right).offset(-2)
                make.width.equalTo(14)
            }


        }


    }

}
