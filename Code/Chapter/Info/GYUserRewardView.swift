//
//  GYUserRewardView.swift
//  Reader
//
//  Created by CQSC  on 2016/12/8.
//  Copyright © 2016年  CQSC. All rights reserved.
//

import UIKit


class GYUserRewardView: UIView {

    var bacView: UIView!
    var bookView: UIImageView!
    var titleLabel: UILabel!
    
    var titles = [100, 200, 300, 5000, 10000, 20000]
    var rewardBtns = [UIButton]()
    
    var rewardCoin: ((_ coin: Int) -> ())?
    
    var book: MQIEachBook! {
        didSet {
            
        
            titleLabel.text =  kLongLocalized("GiveItAReward", replace: book.book_name)
//            titleLabel.text = "给 \(book.book_name) 打赏一下吧"
            bookView.sd_setImage(with: URL(string: book.book_cover), placeholderImage: bookPlaceHolderImage)
        }
    }
    
    let font = UIFont.systemFont(ofSize: 15)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func configUI() {
        self.backgroundColor = UIColor.clear
        
        let topSpace: CGFloat = 30
        let leftSpace: CGFloat = 20
        
        bacView = UIView(frame: CGRect(x: 0, y: topSpace, width: self.bounds.width, height: self.bounds.height-topSpace))
        bacView.backgroundColor = UIColor.white
        self.addSubview(bacView)
        
        let bookViewWidth: CGFloat = 80
        let bookViewHeight: CGFloat = bookViewWidth*87/62
        bookView = UIImageView(frame: CGRect(x: leftSpace, y: 0, width: bookViewWidth, height: bookViewHeight))
        self.addSubview(bookView)
        
        let originX = bookView.frame.maxX+20
        titleLabel = createLabel(CGRect(x: originX, y: 20, width: bacView.bounds.width-originX-5, height: 21), font: UIFont.systemFont(ofSize: 18), bacColor: nil, textColor: blackColor, adjustsFontSizeToFitWidth: nil, textAlignment: .left, numberOfLines: nil)
        bacView.addSubview(titleLabel)
        
        let btnSpace: CGFloat = 10
        let  c = bacView.bounds.width-2*leftSpace-2*btnSpace
        let btnWidth = c/3
        let btnHeight = btnWidth*48/106
        
        let btnViewHeight = btnHeight*2+3*btnSpace
        let btnView = UIView(frame: CGRect(x: 0, y: bacView.bounds.height-btnViewHeight, width: bacView.bounds.width, height: btnViewHeight))
        btnView.backgroundColor = UIColor.clear
        bacView.addSubview(btnView)
        
        let rewardBorderColor = RGBColor(142, g: 209, b: 244)
        var line: CGFloat = 0
        var row: CGFloat = 0
        for i in 0..<titles.count {
            if i > 2 {
                row = CGFloat(i-3)
                line = 1
            }else {
                row = CGFloat(i)
                line = 0
            }
            
            let button = createButton(CGRect(x: leftSpace+(btnWidth+btnSpace)*row, y: line*(btnHeight+btnSpace), width: btnWidth, height: btnHeight),
                                      normalTitle: "\(titles[i])\r\n\(COINNAME)",
                                      normalImage: nil,
                                      selectedTitle: nil,
                                      selectedImage: nil,
                                      normalTilteColor: mainColor,
                                      selectedTitleColor: nil,
                                      bacColor: nil,
                                      font: font,
                                      target: self,
                                      action: #selector(GYUserRewardView.buttonAcdtion(_:)))
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .center
            button.contentHorizontalAlignment = .center
            button.contentVerticalAlignment = .center
            button.tag = btnTag+i
            button.layer.borderColor = rewardBorderColor.cgColor
            button.layer.borderWidth = 1.0
            button.layer.cornerRadius = 5
            btnView.addSubview(button)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    @objc func buttonAcdtion(_ button: UIButton) {
        let coin = titles[button.tag-btnTag]
        rewardCoin?(coin)
    }
    
    class func getHeight() -> CGFloat {
        let btnSpace: CGFloat = 10
        let topSpace: CGFloat = 20
        let leftSpace: CGFloat = 20
        let bookViewWidth: CGFloat = 80
        let bookViewHeight: CGFloat = bookViewWidth*87/62
        
        let btnWidth = (screenWidth-2*leftSpace-2*btnSpace)/3
        let btnHeight = btnWidth*48/106
        
        return topSpace*2+btnHeight*2+btnSpace+bookViewHeight+20
    }

}
