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
    var itemModel:MQ_ClassificationItemModel? {
        didSet(oldValue) {
            if let model =  itemModel{
                bookCover.sd_setImage(with: URL(string:model.image_url), placeholderImage: UIImage(named: book_PlaceholderImg))
                bookTitlelable.text = model.name
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
        self.dsySetCorner(radius: 4)

        
        bookCover  = UIImageView()
        contentView.addSubview(bookCover)
        bookCover.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let coverView = UIView()
        coverView.backgroundColor = kUIStyle.colorWithHexString("000000", alpha: 0.13)
        contentView.addSubview(coverView)
        coverView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        bookTitlelable = UILabel()
        bookTitlelable.textColor = kUIStyle.colorWithHexString("ffffff")
        bookTitlelable.textAlignment = .left
        bookTitlelable.font = kUIStyle.sysFontDesign1PXSize(size: 16)
        contentView.addSubview(bookTitlelable)
        
        bookTitlelable.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kUIStyle.scale1PXH(14))
            make.left.equalToSuperview().offset(kUIStyle.scale1PXW(12))
            make.right.lessThanOrEqualToSuperview()
        }
        
     
        
    }
    private static let w = (screenWidth - kUIStyle.scale1PXW(10)*3)/2
    class func getSize() -> CGSize {
        return CGSize(width: w, height: kUIStyle.scale1PXH(100))
    }
    
}
