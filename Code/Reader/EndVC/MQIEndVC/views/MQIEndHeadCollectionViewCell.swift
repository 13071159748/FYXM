//
//  MQIEndHeadCollectionViewCell.swift
//  MoQingInternational
//
//  Created by moqing on 2019/6/19.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit
let End_Left_Margin:CGFloat = 15
class MQIEndBaseCollectionViewCell: UITableViewCell {
 
    
    class func getIdentifier() -> String {
        return  "\(self.classForCoder())_Identifier"
    }
}

enum MQIEndClickType {
    case likeBtn
    case commentBtn
    case refreshBtn
    case topBookShelf
}

class MQIEndHeadCollectionViewCell: MQIEndBaseCollectionViewCell {
    
    var title:UILabel!
    var subTitle1:UILabel!
    var clickBlock:((_ type:MQIEndClickType) -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.colorWithHexString("ffffff")
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    func setupUI()  {
        title = UILabel()
        title.font = kUIStyle.sysFontDesign1PXSize(size: 17)
        title.textColor = kUIStyle.colorWithHexString("333333")
        title.textAlignment = .left
        title.numberOfLines = 1
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-End_Left_Margin)
            make.left.equalToSuperview().offset(End_Left_Margin)
            make.top.equalToSuperview().offset(10)
        }
  
        subTitle1 = UILabel()
        subTitle1.font = kUIStyle.sysFontDesign1PXSize(size: 13)
        subTitle1.textColor = kUIStyle.colorWithHexString("E65751")
        subTitle1.textAlignment = .left
        subTitle1.numberOfLines = 1
        contentView.addSubview(subTitle1)
        subTitle1.snp.makeConstraints { (make) in
            make.left.equalTo(title)
            make.top.equalTo(title.snp.bottom).offset(13)
//            make.bottom.equalToSuperview().offset(-10)
        }
       
        subTitle1.dsyAddTap(self, action: #selector(MQIEndHeadCollectionViewCell.clickTap))
        
        
        let likeBtn = UIButton()
        likeBtn.setImage(UIImage(named: "readend_likes"), for: .normal)
        likeBtn.tag = 101
        likeBtn.addTarget(self, action: #selector(clickBtn(btn:)), for: UIControl.Event.touchUpInside)
        contentView.addSubview(likeBtn)
        likeBtn.contentHorizontalAlignment = .right
        
        let commentBtn = UIButton()
        commentBtn.setImage(UIImage(named: "readend_comment"), for: .normal)
        commentBtn.tag = 102
        commentBtn.addTarget(self, action: #selector(MQIEndHeadCollectionViewCell.clickBtn(btn:)), for: UIControl.Event.touchUpInside)
        contentView.addSubview(commentBtn)
        commentBtn.contentHorizontalAlignment = .right
        
        commentBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-End_Left_Margin)
            make.centerY.equalTo(subTitle1)
            make.width.equalTo(40)
        
        }

        
        likeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(commentBtn.snp.left).offset(-10)
            make.centerY.width.equalTo(commentBtn)
            make.left.greaterThanOrEqualTo(subTitle1.snp.right).offset(10)
        }
        
        let lineVew = UIView()
        lineVew.backgroundColor = kUIStyle.colorWithHexString("F8F8F8")
        contentView.addSubview(lineVew)
        lineVew.snp.makeConstraints { (make) in
            make.top.equalTo(subTitle1.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(10)
            make.bottom.equalToSuperview()
            
        }
        
//        contentView.snp.makeConstraints { (make) in
//              make.bottom.equalTo(subTitle1)
//             make.width.equalTo(screenWidth-2*End_Left_Margin-1)
//        }
        
    }
    
    @objc func clickBtn(btn:UIButton)  {
        
        switch btn.tag  {
        case 101: /// 点赞
            clickBlock?(.likeBtn)
            break
        case 102: /// 评论
             clickBlock?(.commentBtn)
            break
        default:
            break
        }
    
    }
    @objc  func clickTap()  {
          clickBlock?(.topBookShelf)
    }
   
    
    
}

