//
//  MQIBanneStorerView.swift
//  CQSCReader
//
//  Created by moqing on 2019/2/20.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQIBanneStorerView: UIView {

    var title:UILabel!
    var monthLablel:UILabel!
    var dayLable:UILabel!
    var books = [MQIMainBannerModel](){
        didSet(oldValue) {
            title.text = books.first?.name
            refreshDayText()
            setItems(books)
            
        }
    }
    var clickItemToIndex:((_ index:Int)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI()  {
        
        
        let titleBacView = UIView(frame: CGRect(x: 0, y: 20, width: 200, height: 20))
        addSubview(titleBacView)
        titleBacView.centerX = self.width*0.5
//        titleBacView.backgroundColor = UIColor.blue
        
        title = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: titleBacView.height))
        title.textColor  = UIColor.colorWithHexString("FFFFFF")
        title.font = kUIStyle.boldSystemFont1PXDesignSize(size: 18)
        title.textAlignment = .right
        title.numberOfLines = 1
        titleBacView.addSubview(title)
   
        let  dayBacView  = UIImageView(frame: CGRect(x: title.maxX+8, y: 0, width: 30, height: title.height))
        dayBacView.image =  UIImage(named: "home_BanneStorer_top_Img")
        titleBacView.addSubview(dayBacView)
        
        monthLablel =  UILabel(frame: CGRect(x: 1, y: 4, width: dayBacView.width*0.5-2, height: dayBacView.height-6))
        monthLablel.backgroundColor = UIColor.colorWithHexString("FFFFFF", alpha: 0.5)
        monthLablel.textColor = UIColor.white
        monthLablel.font = UIFont.systemFont(ofSize: 9)
        monthLablel.textAlignment = .center
        dayBacView.addSubview(monthLablel)
        
        dayLable = UILabel(frame: CGRect(x: monthLablel.maxX+2, y: monthLablel.y, width: monthLablel.width, height: monthLablel.height))
        dayLable.backgroundColor = UIColor.colorWithHexString("FFFFFF", alpha: 0.5)
        dayLable.textColor = UIColor.white
        dayLable.font = UIFont.systemFont(ofSize: 9)
        dayLable.textAlignment = .center
        dayBacView.addSubview(dayLable)
        refreshDayText()
        
      
        
        let count:CGFloat =  4
        let left_Margin = kUIStyle.scale1PXW(20)
        let item_Margin = kUIStyle.scale1PXW(15)
        let itemW:CGFloat  = (self.width - 2*left_Margin - count*item_Margin+item_Margin)/count
        let itemH:CGFloat = itemW*1.3333+10+20
        let itemY =  titleBacView.maxY+16
        for i in 0..<Int(count) {
            let item = MQIBanneStorerItemView(frame: CGRect(x: left_Margin+CGFloat(i)*(itemW+item_Margin), y: itemY, width: itemW, height: itemH))
            item.tag = 100+i
            addSubview(item)
            item.isHidden  = true
            item.dsyAddTap(self, action: #selector(clickItem(tap:)))
        }
     
    }
    
    
    @objc func clickItem(tap:UITapGestureRecognizer)  {
        if let view = tap.view {
            clickItemToIndex?(view.tag-100)
        }
        
    }
    
    func setItems(_ books:[MQIMainBannerModel]) {
        for i in 0..<4 {
            if let item = self.viewWithTag(100+i) {
                let newItem  = item as! MQIBanneStorerItemView
                if i < books.count {
                  let model = books[i]
                    newItem.isHidden  = false
                    newItem.book_image.sd_setImage(with: URL(string:model.cover), placeholderImage: UIImage(named: book_PlaceholderImg))
                    newItem.book_Name.text =  model.book_name
                }else{
                     newItem.isHidden  = true
                }
            }
        }
    }
    
    class  func getMinX() -> CGFloat {
        let left_Margin = kUIStyle.scale1PXW(20)
        let item_Margin = kUIStyle.scale1PXW(15)
        let itemW:CGFloat  = (screenWidth - 2*left_Margin - 4*item_Margin+item_Margin)/4
        let itemH:CGFloat = itemW*1.3333+10+20
        return itemH+20+50
    }
    func refreshDayText() {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM-dd"
        dateformatter.string(from: Date())
        let dayStr = dateformatter.string(from: Date()).components(separatedBy: "-")
        monthLablel.text = dayStr[0]
        dayLable.text =  dayStr[1]
    }
    
    
   private class MQIBanneStorerItemView: UIView {
    
        var book_image:UIImageView!
        var book_Name:UILabel!
    
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        func setupUI()  {
            book_image = UIImageView()
            book_image.isUserInteractionEnabled = true
            addSubview(book_image)
            book_image.snp.makeConstraints { (make) in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(self.snp.width).multipliedBy(1.3333)
                
            }
            
            book_Name = UILabel()
            book_Name.textColor  = UIColor.colorWithHexString("FFFFFF")
            book_Name.font = kUIStyle.sysFontDesign1PXSize(size: 13)
            book_Name.textAlignment = .left
            book_Name.numberOfLines = 1
            book_Name.isUserInteractionEnabled = true
            addSubview(book_Name)
            book_Name.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(book_image.snp.bottom).offset(10)
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 24, height: 24))
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        self.layer.mask = layer
    }
    
}

