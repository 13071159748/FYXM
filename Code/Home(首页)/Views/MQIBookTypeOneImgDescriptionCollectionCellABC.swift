//
//  MQIBookTypeOneImgDescriptionCollectionCellABC.swift
//  CQSCReader
//
//  Created by moqing on 2019/2/21.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQIBookTypeOneImgDescriptionCollectionCellABC:MQICollectionViewCell {
    var coverImageView:MQIShadowImageView!
    var nameLabel: UILabel!
    
    var bookNameText: String = "" {
        didSet{
            nameLabel.text = bookNameText
        }
    }
    //连载状态
    var book_StatusLabel:UILabel!
    var statusText:String  = "" {
        didSet {
            book_StatusLabel.text = statusText
        }
        
    }
    
    var class_nameLabel:UILabel!
    var classText:String! = "" {
        didSet{
            if classText == "0" {
               self.class_nameLabel.text  = ""
            }else{
               self.class_nameLabel.text = classText
            }
            
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTypeSimpleView()
        self.backgroundColor = UIColor.white
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    func addTypeSimpleView() {
        
        coverImageView = MQIShadowImageView(frame: CGRect.zero)
        contentView.addSubview(coverImageView!)
        coverImageView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(MQIBookTypeOneImgDescriptionCollectionCellABC.image_h*0.75)
        }
        
        nameLabel = createLabel(CGRect.zero, font: systemFont(14), bacColor: UIColor.white, textColor: UIColor.colorWithHexString("#23252C"), adjustsFontSizeToFitWidth: false, textAlignment: .left, numberOfLines: 2)
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(coverImageView.snp.right).offset(10)
            make.right.equalToSuperview()
            make.top.equalTo(coverImageView)
        }
        
        book_StatusLabel = UILabel()
        book_StatusLabel.textColor = UIColor.colorWithHexString("#9DA0A9")
        book_StatusLabel.font = UIFont.systemFont(ofSize: 13)
        book_StatusLabel.textAlignment = .left
        contentView.addSubview(book_StatusLabel)
        book_StatusLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLabel)
            make.centerY.equalToSuperview()
        }
        
        class_nameLabel = UILabel(frame: CGRect.zero)
        class_nameLabel.textColor =  UIColor.colorWithHexString("#9DA0A9")
        class_nameLabel.font = UIFont.systemFont(ofSize: 13)
        class_nameLabel.textAlignment = .left
        contentView.addSubview(class_nameLabel)
        class_nameLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLabel)
            make.bottom.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        
    }
    
   
    private static let image_h = kUIStyle.scale1PXH(96)
    private static let w = (screenWidth-Book_Store_Manger*3-1)/2
    
    class func getSize() -> CGSize {
        return CGSize(width:w, height: image_h)
    }
    

}
