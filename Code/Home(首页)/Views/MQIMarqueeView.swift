//
//  MQIMarqueeView.swift
//  CQSC
//
//  Created by BigMac on 2019/12/26.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQIMarqueeView: UIView {

    var bgView: UIView!
    var leftImageView: UIImageView!
    var rollingView: YPBannerView!
    var rightImageView: UIImageView!
    
    var tapIndexBlock:((_ index: Int)->())?
    
    var adListArray: [MQIPopupAdsenseListModel]? {
        didSet {
            if let adListArray = adListArray {
                var itemsArray = [String]()
                for indexModel in adListArray {
                    let currentDate = getCurrentStamp()
                    mqLog("当前时间戳 \(currentDate)")
                    if currentDate >= indexModel.start_time.integerValue() && currentDate < indexModel.end_time.integerValue() {
                        itemsArray.append(indexModel.title)
                    }
                }
                rollingView.dataArray = itemsArray
            }
        }
    }
    
    override init(frame: CGRect) {
          super.init(frame: frame)
          addUI()
      }
      
      required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
          addUI()
      }
    
    func addUI() {
        
        bgView = UIView()
        bgView.backgroundColor = UIColor.colorWithHexString("#F5F6FF")
        bgView.layer.cornerRadius = 19
        self.addSubview(bgView)
        
        leftImageView = UIImageView(image: UIImage(named: "honk"))
        bgView.addSubview(leftImageView)
        
        rollingView = YPBannerView(frame: .zero)
        //GCMarqueeView(frame: .zero, type: .btt)
        rollingView.scrollDirection = .Vertical
        bgView.addSubview(rollingView)
        
        rightImageView = UIImageView(image: UIImage(named: "rightArrow"))
        bgView.addSubview(rightImageView)
        
        rollingView.selectHandler = {[weak self](indexPath) in
            guard let weakSelf = self else { return }
            weakSelf.tapIndexBlock?(indexPath.row)
        }
    }
    
      override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.frame = CGRect(x: 20, y: 0, width: self.width - 40, height: 32)
        bgView.centerY = self.height / 2.0
        
        leftImageView.frame = CGRect(x: 18, y: 0, width: 16, height: 16)
        leftImageView.centerY = bgView.height / 2.0
        rightImageView.frame = CGRect(x: bgView.width - 6 - 15, y: 0, width: 6, height: 11)
        rightImageView.centerY = bgView.height / 2.0
        
        let left: CGFloat = leftImageView.maxX + 8
        let width = screenWidth - 2 * Book_Store_Manger - left
        rollingView.frame = CGRect(x: left, y: 0, width: width, height: bgView.height)
    }
    
    static func getHeight() -> CGFloat {
        return 32+20
    }
    
}
