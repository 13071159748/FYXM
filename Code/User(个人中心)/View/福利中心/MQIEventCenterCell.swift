//
//  MQIEventCenterCell.swift
//  CQSC
//
//  Created by moqing on 2019/12/24.
//  Copyright © 2019 _CHK_. All rights reserved.
//

class MQIEventCenterCell: UITableViewCell {

    var dateLable: UILabel!
    var contentLable: UILabel!
    var titleLable: UILabel!
    var statusView: UIView!
    var contentTextView: MQILinkTextView!
    var topImage = UIImageView()
    var fireImage = UIImageView()
    var statusLabel = UILabel()

    var model: MQITaskListModel! {
        didSet(oldValue) {
            titleLable.text = model.event_name
            dateLable.text = getTimeStampToString(model.active_time, format: "yyyy.MM.dd") + "-" + getTimeStampToString(model.expiry_time, format: "yyyy.MM.dd")
            // pointView.isHidden = (model.status_code == "readed") ? true : false
            contentLable.text = model.event_desc
            contentLable.snp.remakeConstraints { (make) in
                make.height.equalTo(getNormalStrH(str: model.event_desc, strFont: 12, w: screenWidth - 60))
                make.left.right.equalTo(titleLable)
                make.top.equalTo(titleLable.snp.bottom).offset(4)

            }

            if self.model.event_status == "2" {
                let imageView = UIImageView()
                imageView.frame = CGRect(x: 0, y: 0, width: 335, height: 102)
                imageView.sd_setImage(with: URL(string: model.img), placeholderImage: UIImage(named: "small_book_placeHolder"))
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                    self.topImage.image = imageView.image!.getGrayImage()
                }
            } else {
                topImage.sd_setImage(with: URL(string: model.img), placeholderImage: UIImage(named: goodBookPlaceHolderImg))
            }

            if self.model.fire_status == "1" {
                fireImage.isHidden = false
                statusView.snp.remakeConstraints { (make) in
                    make.bottom.equalTo(24)
                    make.right.equalTo(24)
                    make.height.equalTo(48)
                    make.width.equalTo(89 + 24)
                }
            } else {
                fireImage.isHidden = true
                statusView.snp.remakeConstraints { (make) in
                    make.bottom.equalTo(24)
                    make.right.equalTo(24)
                    make.height.equalTo(48)
                    make.width.equalTo(73 + 24)
                }
            }

            if model.event_status == "2" {
                statusView.backgroundColor = UIColor(hex: "#CBCBCB")
                statusLabel.text = "已经结束"
            } else if model.event_status == "0"{
                statusView.backgroundColor = UIColor(hex: "#EB5567")
                statusLabel.text = "即将开始"
            } else{
                statusView.backgroundColor = UIColor(hex: "#EB5567")
                statusLabel.text = "正在进行"
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        setupUI()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        setupUI()
    }

    func setupUI() {
        let contentBacImageView = UIImageView()
        contentBacImageView.image = UIImage(named: "event_bg")
        contentView.addSubview(contentBacImageView)
        contentBacImageView.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalTo(-6)
            make.bottom.equalTo(9)
        }
        
        let contentBacView = UIView()
        contentBacView.dsySetCorner(radius: 4)
        contentBacView.backgroundColor = UIColor.white
        contentView.addSubview(contentBacView)
        contentBacView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.bottom.equalToSuperview()
        }

        contentBacView.addSubview(topImage)
        topImage.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(102)
        }

        titleLable = UILabel()
        titleLable.font = UIFont.boldSystemFont(ofSize: 14)
        titleLable.textColor = .black
        titleLable.textAlignment = .left
        contentBacView.addSubview(titleLable)
        titleLable.snp.makeConstraints { (make) in
            make.left.equalTo(topImage.snp.left).offset(11)
            make.top.equalTo(topImage.snp.bottom).offset(5)
            make.height.equalTo(20)
            make.right.equalTo(-10)
        }
        
        contentLable = UILabel()
        contentLable.font = kUIStyle.sysFontDesign1PXSize(size: 12)
        contentLable.textColor = UIColor.colorWithHexString("333333")
        contentLable.textAlignment = .left
        contentLable.numberOfLines = 0
        contentBacView.addSubview(contentLable)
        contentLable.snp.makeConstraints { (make) in
            make.left.equalTo(titleLable)
            make.right.equalTo(titleLable)
            make.top.equalTo(titleLable.snp.bottom).offset(6)
        }
        
        dateLable = UILabel()
        dateLable.font = kUIStyle.sysFontDesign1PXSize(size: 10)
        dateLable.textColor = kUIStyle.colorWithHexString("333333")
        dateLable.textAlignment = .left
        contentBacView.addSubview(dateLable)
        dateLable.snp.makeConstraints { (make) in
            make.bottom.equalTo(-8)
            make.right.left.equalTo(titleLable)
            make.height.equalTo(14)
            make.top.equalTo(contentLable.snp.bottom).offset(6)
        }

        statusView = UIView()
        statusView.dsySetCorner(radius: 18)
        statusView.backgroundColor = UIColor(hex: "#EB5567")
        contentBacView.addSubview(statusView)
        statusView.snp.makeConstraints { (make) in
            make.bottom.equalTo(24)
            make.right.equalTo(24)
            make.height.equalTo(48)
            make.width.equalTo(73)
        }

        fireImage.image = UIImage(named: "event_fire")
        fireImage.isHidden = true
        statusView.addSubview(fireImage)
        fireImage.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.left.equalTo(12)
            make.height.equalTo(16)
            make.width.equalTo(13)
        }

        statusLabel.font = UIFont.systemFont(ofSize: 12)
        statusLabel.textColor = UIColor(hex: "#FEFEFE")
        statusView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(fireImage)
            make.right.equalTo(-34)
            make.height.equalTo(17)
            make.width.equalTo(50)
        }
    }
    
     func getNormalStrSize(str: String? = nil, attriStr: NSMutableAttributedString? = nil, font: CGFloat, w: CGFloat, h: CGFloat) -> CGSize {
        if str != nil && str != ""{
            let strSize = (str! as NSString).boundingRect(with: CGSize(width: w, height: h), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: font)], context: nil).size
            return strSize }
        if attriStr != nil && str != ""{
            let strSize = attriStr!.boundingRect(with: CGSize(width: w, height: h), options: .usesLineFragmentOrigin, context: nil).size
            return strSize
        }
        return CGSize.zero
    }

     func getNormalStrW(str: String, strFont: CGFloat, h: CGFloat) -> CGFloat {
        return getNormalStrSize(str: str, font: strFont, w: CGFloat.greatestFiniteMagnitude, h: h).width
    }

     func getNormalStrH(str: String, strFont: CGFloat, w: CGFloat) -> CGFloat {
        return getNormalStrSize(str: str, font: strFont, w: w, h: CGFloat.greatestFiniteMagnitude).height
    }
}
