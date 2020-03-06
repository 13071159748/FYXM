//
//  MQICardTitleIdentityCellTableViewCell.swift
//  CQSC
//
//  Created by moqing on 2019/7/5.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQICardTitleIdentityCellTableViewCell: MQICardBaseTableViewCell {

    var title:UILabel!
    var clickBlock:((_ tag:Int)->())?
    var itmes = [CardIdentityItmeView]()
    var privileges = [MQIUserDiscountCardRankModel](){
        didSet(oldValue) {
            createItmes(privileges)
        }
    }
    override func setupUI() {
        bacImge.isHidden = true
        
        let lineView = UIView()
        lineView.backgroundColor = mainColor
        self.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(card_LeftMargin2)
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(2)
            make.height.equalTo(15)
        }

        title  = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor  = UIColor.colorWithHexString("#333333")
        title.textAlignment = .left
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(lineView).offset(5)
            make.centerY.equalTo(lineView)
        }
        title.text = "您当前正在享受的权益"
        
        
        let openBtn = DSYRightImgBtn()
        openBtn.tag = 22
        contentView.addSubview(openBtn)
        openBtn.setTitle("规则说明", for: .normal)
        openBtn.setTitleColor(mainColor, for: .normal)
        openBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        openBtn.setImage(UIImage(named: "dzk_gz_img"), for: .normal)
        openBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-card_LeftMargin2)
            make.left.greaterThanOrEqualTo(title.snp.right).offset(5)
            make.centerY.equalTo(title)
        }
       openBtn.addTarget(self, action: #selector(clickBtn(_:)), for: .touchUpInside)
        
        let count:Int = 3
        for i in 0..<count {
            let item = CardIdentityItmeView()
            item.tag = 100+i
            contentView.addSubview(item)
            itmes.append(item)
//            item.dsyAddTap(self, action: #selector(clickItme(tap:)))
        }
        itmes[1].snp.makeConstraints { (make) in
            make.bottom.centerX.equalToSuperview()
            make.top.equalTo(title.snp.bottom).offset(15)
            make.width.equalTo(60)
            make.height.equalTo(80)
        }
        itmes[0].snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(itmes[1])
            make.right.equalTo(itmes[1].snp.left).offset(-kUIStyle.scale1PXW(40))
            
        }
        itmes[2].snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(itmes[1])
            make.left.equalTo(itmes[1].snp.right).offset(kUIStyle.scale1PXW(40))
            
        }
    }
    func createItmes(_ datas:[MQIUserDiscountCardRankModel])  {
        if itmes.count < datas.count {
            for i in 0..<itmes.count {
                itmes[i].removeFromSuperview()
            }
            itmes.removeAll()
            
            let count:Int = datas.count
            var lastItme:CardIdentityItmeView?
            
            for i in 0..<count {
                let item = CardIdentityItmeView()
                item.tag = 100+i
                contentView.addSubview(item)
                itmes.append(item)
                if lastItme != nil {
                    item.snp.makeConstraints { (make) in
                        make.bottom.width.height.equalToSuperview()
                        make.left.equalTo(lastItme!.snp.right).offset(15)
                    }
                }else{
                    item.snp.makeConstraints { (make) in
                        make.bottom.equalToSuperview()
                        make.left.equalToSuperview()
                        make.width.equalTo(60)
                        make.height.equalTo(80)
                    }
                }
                 lastItme =   item
                item.title.text = datas[i].name
                item.imgView.sd_setImage(with: URL(string: datas[i].image_url))
            }

        }else{
            for i in 0..<itmes.count {
                if i < datas.count {
                    itmes[i].isHidden = false
                    itmes[i].title.text = datas[i].name
                    itmes[i].imgView.sd_setImage(with: URL(string: datas[i].image_url))
                }else{
                     itmes[i].isHidden = true
                }
            
            }
            
        }
        
    }
    
    @objc func clickItme(tap:UITapGestureRecognizer) {
        guard let view = tap.view else {
            return
        }
        clickBlock?( view.tag)
        
    }
    @objc func clickBtn(_ btn:UIButton)  {
           clickBlock?( btn.tag)
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
        return 136
    }
    
    class CardIdentityItmeView: UIView {
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
            imgView.contentMode = .scaleAspectFit
            addSubview(imgView)
            imgView.snp.makeConstraints { (make) in
                make.width.left.equalToSuperview()
                make.top.equalToSuperview()
            }
            
            title =  UILabel()
            title.font = UIFont.systemFont(ofSize: 13)
            title.textColor  = UIColor.colorWithHexString("#2C2B40")
            title.textAlignment = .center
            addSubview(title)
            title.snp.makeConstraints { (make) in
                make.left.right.equalTo(imgView)
                make.top.equalTo(imgView.snp.bottom).offset(2)
                make.height.equalTo(16)
                make.bottom.equalToSuperview().offset(-12)
            }
        }
        
    }
}
