//
//  MQ_ClassificationCollectionViewCell.swift
//  Reader
//
//  Created by moqing on 2018/11/6.
//  Copyright © 2018 Moqing. All rights reserved.
//

import UIKit

class MQIClassificationCollectionViewCell: MQICollectionViewCell {
    fileprivate var bookCover:UIImageView!
    fileprivate var bookTitlelable:UILabel!
    fileprivate var infolable:UILabel!
    var itemModel:MQIClassificationItemModel? {
        didSet(oldValue) {
            if let model =  itemModel{
                bookCover.sd_setImage(with: URL(string:model.image_url), placeholderImage: UIImage(named: book_PlaceholderImg))
                bookTitlelable.text = model.name
//                infolable.text = "现代修真 / 奇幻修真 / 洪荒封神"
            }
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

          contentView.backgroundColor = UIColor.white
//        let  bacView = UIView()
//        bacView.backgroundColor = UIColor.white
//        bacView.layer.shadowOpacity = 1
//        bacView.layer.shadowColor = UIColor.colorWithHexString("BBD8F1", alpha: 0.6).cgColor
//        bacView.layer.shadowOffset = CGSize(width: 0, height:3 )
//        bacView.layer.shadowRadius = 3
//        bacView.clipsToBounds = false
//        contentView.addSubview(bacView)
//        bacView.snp.makeConstraints { (make) in
//            make.left.bottom.right.equalTo(contentView)
//            make.height.equalToSuperview().multipliedBy(0.7)
//        }
//
        bookCover  = UIImageView()
        bookCover.contentMode = .scaleAspectFit
        contentView.addSubview(bookCover)
        bookCover.snp.makeConstraints { (make) in
          make.right.equalToSuperview().offset(-15)
          make.top.equalToSuperview().offset(15)
          make.width.equalTo(kUIStyle.scale1PXW(60))
          make.height.equalTo(kUIStyle.scale1PXW(60)*0.67)
            
        }
 
        
        bookTitlelable = UILabel()
        bookTitlelable.textColor = kUIStyle.colorWithHexString("383A46")
        bookTitlelable.textAlignment = .left
        bookTitlelable.numberOfLines =  0
        bookTitlelable.font = kUIStyle.sysFontDesign1PXSize(size: 16)
        contentView.addSubview(bookTitlelable)
        bookTitlelable.snp.makeConstraints { (make) in
         make.left.equalToSuperview().offset(15)
         make.right.equalTo(bookCover.snp.left).offset(5)
         make.top.equalTo(bookCover)
        }
        
        infolable =  UILabel()
        infolable.textColor = kUIStyle.colorWithHexString("C8C8CE")
        infolable.textAlignment = .left
        infolable.numberOfLines =  0
        infolable.font = kUIStyle.sysFontDesign1PXSize(size: 9)
        contentView.addSubview(infolable)
        infolable.snp.makeConstraints { (make) in
            make.left.equalTo(bookTitlelable)
            make.right.equalTo(bookCover)
            make.bottom.equalToSuperview().offset(-6)
        }
        

    }
    
    private static let w = (screenWidth - kUIStyle.scale1PXW(15)*2-kUIStyle.scale1PXW(10))*0.5
    class func getSize() -> CGSize {
        return CGSize(width: w, height: w*0.46)
    }
    
}
