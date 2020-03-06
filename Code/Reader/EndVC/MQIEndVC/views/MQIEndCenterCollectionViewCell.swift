//
//  MQIEndCenterCollectionViewCell.swift
//  MoQingInternational
//
//  Created by moqing on 2019/6/19.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQIEndCenterCollectionViewCell: MQIEndBaseCollectionViewCell {
    var title:UILabel!
    var title1:UILabel!
    var subTitle1:UILabel!
    var subTitle2:UILabel!
    var refreshBtn:MQIRefreshBtn!
    var coverImageView:MQIShadowImageView!
    var clickBlock:((_ type:MQIEndClickType) -> ())?
    
    var isShowRefreshAnimation:Bool = false {
        didSet(oldValue) {
            if isShowRefreshAnimation {
                refreshBtn.startAnimation()
            }else{
                refreshBtn.stopAnimation()
            }
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.colorWithHexString("ffffff")
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    func setupUI()  {
        title1 = UILabel()
        title1.font = kUIStyle.sysFontDesign1PXSize(size: 16)
        title1.textColor = kUIStyle.colorWithHexString("666666")
        title1.textAlignment = .left
        title1.numberOfLines = 1
        contentView.addSubview(title1)
        title1.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(End_Left_Margin)
            make.top.equalToSuperview().offset(16)
        }

        coverImageView = MQIShadowImageView()
        contentView.addSubview(coverImageView)
        let H:CGFloat = 100
        coverImageView.snp.makeConstraints { (make) in
            make.left.equalTo(title1)
            make.top.equalTo(title1.snp.bottom).offset(12)
            make.width.equalTo(H*0.75)
            make.height.equalTo(H)
            make.bottom.equalToSuperview().priority(.low)
        }
        coverImageView.backgroundColor = backgroundColor
        coverImageView.imageView.backgroundColor = backgroundColor
        coverImageView.radius =  -1
        
        title = UILabel()
        title.font = kUIStyle.sysFontDesign1PXSize(size: 20)
        title.textColor = kUIStyle.colorWithHexString("333333")
        title.textAlignment = .left
        title.numberOfLines = 1
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-End_Left_Margin)
            make.left.equalTo(coverImageView.snp.right).offset(16)
            make.top.equalTo(coverImageView)
        }
       
        
       
        subTitle1 = UILabel()
        subTitle1.font = kUIStyle.sysFontDesign1PXSize(size: 14)
        subTitle1.textColor = kUIStyle.colorWithHexString("999999")
        subTitle1.textAlignment = .left
        subTitle1.numberOfLines = 1
        contentView.addSubview(subTitle1)
        subTitle1.snp.makeConstraints { (make) in
            make.left.equalTo(title)
            make.centerY.equalTo(coverImageView).offset(8)
        }
      
   
        subTitle2 = UILabel()
        subTitle2.font = kUIStyle.sysFontDesign1PXSize(size: 10)
        subTitle2.textColor = kUIStyle.colorWithHexString("FF6D7E")
        subTitle2.textAlignment = .left
        subTitle2.numberOfLines = 1
        contentView.addSubview(subTitle2)
        subTitle2.snp.makeConstraints { (make) in
            make.left.equalTo(subTitle1)
            make.bottom.equalTo(coverImageView)
        }
//        subTitle2.dsySetBorderr(color: subTitle2.textColor, width: 1)
        
        refreshBtn = MQIRefreshBtn()
        refreshBtn.setImage(UIImage.init(named: "recommended_refresh")?.withRenderingMode(.alwaysTemplate), for: .normal)
        refreshBtn.setTitleColor(UIColor.colorWithHexString("666666"), for: .normal)
        refreshBtn.titleLabel?.font = kUIStyle.sysFontDesign1PXSize(size: 12)
        contentView.addSubview(refreshBtn)
        refreshBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-End_Left_Margin)
            make.centerY.equalTo(title1)
            make.left.greaterThanOrEqualTo(title1.snp.right).offset(10)
            make.height.equalTo(25)
        }
//        refreshBtn.contentHorizontalAlignment = .right
        refreshBtn.tintColor = UIColor.colorWithHexString("BEBEBE")
        refreshBtn.addTarget(self, action: #selector(MQIEndCenterCollectionViewCell.clickBtn(btn:)), for: UIControl.Event.touchUpInside)
        refreshBtn.setTitle( kLocalized("ChangeoOne", describeStr: "换一换"), for: .normal)
//        refreshBtn.contentHorizontalAlignment = .right
        refreshBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
//        contentView.snp.makeConstraints { (make) in
//            make.bottom.equalTo(coverImageView).offset(10)
//            make.width.equalTo(screenWidth-2*End_Left_Margin-1)
//        }
        
    }
    
    @objc func clickBtn(btn:UIButton)  {
        isShowRefreshAnimation = true
        clickBlock?(.refreshBtn)
    }
    
    class MQIRefreshBtn: UIButton {
        
        override var isHidden: Bool{
            didSet(oldValue) {
                stopAnimation()
            }
        }
        func startAnimation()  {
            guard let imageView = imageView else {
                return
            }
            setRotationAnimation(imageView, isAnimation: true)
        }
        
        func stopAnimation()  {
            guard let imageView = imageView else {
                return
            }
            setRotationAnimation(imageView, isAnimation: false)
        }
        
        func setRotationAnimation(_ view:UIView,isAnimation:Bool ) -> Void {
            
            if isAnimation {
                if view.layer.animation(forKey: "H_MQIRefreshBtnRotation") == nil {
                    let anim = CABasicAnimation(keyPath: "transform.rotation")
                    anim.toValue = Float.pi*2
                    anim.duration = 0.5
                    anim.repeatCount = MAXFLOAT
                    anim.isRemovedOnCompletion = true
                    view.layer.add(anim, forKey: "H_MQIRefreshBtnRotation")
                }
            }else{
                view.layer.removeAnimation(forKey: "H_MQIRefreshBtnRotation")
            }
            
        }
        
    }
}




