//
//  MQIBookStoreNavViewABC.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/2.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIBookStoreNavViewABC: UIView {
    var navDatas:[MQIMainNavModel]! {
        didSet {
            createNavButtonNew(navDatas)
            
        }
    }
    var bookStoreNavBtnClick:((_ index:NSInteger)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createBSNavUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createBSNavUI()
    }
    
    func createBSNavUI() {
        self.backgroundColor = UIColor.white
        self.isUserInteractionEnabled = true
        while self.subviews.count > 0 {
            self.subviews.last?.removeFromSuperview()
        }
    }
    
    func createNavButtonNew(_ datas:[MQIMainNavModel]) {
        if self.subviews.count != datas.count {
            while self.subviews.count > 0 {
                self.subviews.last?.removeFromSuperview()
            }
            let btnWidth = screenWidth / CGFloat(datas.count)
            for i in 0..<datas.count {
                let button = TopImgBtn(frame: CGRect (x: CGFloat(i)*btnWidth, y: 0, width: btnWidth, height: self.height))
                button.tag = i
                button.addTarget(self, action: #selector(self.buttonClick(_:)), for: .touchUpInside)
                self.addSubview(button)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14*mqscale)
                button.setTitle(datas[i].title, for: .normal)
                button.setTitleColor(UIColor.colorWithHexString("#425154"), for: .normal)
                button.sd_setImage(with: URL(string:datas[i].icon), for: .normal, placeholderImage: UIImage(named: nav_PlaceholderImg))
                
            }
        }else{
                for i in 0..<datas.count {
                if let button =  self.subviews[i] as? UIButton {
                    button.setTitle(datas[i].title, for: .normal)
                    button.tag = i
                    button.sd_setImage(with: URL(string:datas[i].icon), for: .normal, placeholderImage: UIImage(named: nav_PlaceholderImg))
                }
            }
            
        }
  
    }
    
    func createNavButton() {
        
        for singleview in subviews {
            singleview.removeFromSuperview()
        }
       
        
        let btnWidth = screenWidth / CGFloat(navDatas.count)
        for i in 0..<navDatas.count
        {
            let button = createButton(CGRect (x: CGFloat(i)*btnWidth, y: 0, width: btnWidth, height: self.height), target: self, action: #selector(MQIBookStoreNavViewABC.buttonClick(_:)))
            button.tag = i
            self.addSubview(button)

            let imageView = UIImageView(frame: CGRect (x: 0, y: 0, width: 30*gdscale, height:30*gdscale))
            imageView.center = CGPoint(x: btnWidth/2, y: (10+15)*gdscale)
            imageView.sd_setImage(with: URL(string:navDatas[i].icon), placeholderImage: UIImage(named: nav_PlaceholderImg))
            button.addSubview(imageView)

            let title_font = 13*mqscale
            let title = createLabel(CGRect (x: 0, y: imageView.maxY+10*gdscale, width: btnWidth, height: title_font), font: systemFont(title_font), bacColor: nil, textColor: UIColor.colorWithHexString("#666666"), adjustsFontSizeToFitWidth: false, textAlignment: .center, numberOfLines: 1)
            title.text = navDatas[i].title
            button.addSubview(title)
            

        }
        
       
        
    }
    @objc func buttonClick(_ sender:UIButton) {
        bookStoreNavBtnClick?(sender.tag)
        
    }
}


/// 下部图片 上部文字 btn
class TopImgBtn: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
           commonInit()
    }
    
    //设置按钮的基本属性
    func commonInit() {
        self.titleLabel?.textAlignment = .center
        self.imageView?.contentMode = .scaleAspectFit
        self.titleLabel?.numberOfLines = 1
        self.titleLabel?.lineBreakMode = .byTruncatingTail
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        
        let imageW = contentRect.width
        let imageH = contentRect.size.height * 0.5
        return CGRect(x: 0, y: contentRect.size.height*0.1, width: imageW, height: imageH )
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleX:CGFloat = 0.0
        let titleY = contentRect.size.height * 0.6
        let titleH = contentRect.size.height - titleY
        return CGRect(x: titleX, y:titleY, width: contentRect.width, height: titleH )
    }
}

