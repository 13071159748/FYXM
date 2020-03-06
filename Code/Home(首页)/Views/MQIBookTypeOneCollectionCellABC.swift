//
//  MQIBookTypeOneCollectionCellABC.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/2.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

////简单一本书 上面封面下面title
//let gdscale:CGFloat = screenWidth/375
//let mqscale:CGFloat = gdscale < 1 ? 1 :gdscale
//let hdscale:CGFloat = screenHeight/640
//let gd_scale:CGFloat = mqscale > 1.2 ? mqscale : mqscale


let Book_Store_Manger:CGFloat = 20
let Book_Store_TypeOne_item_Manger:CGFloat = 36
let Book_Store_TypeOne_img_w = (screenWidth - Book_Store_Manger*2-Book_Store_TypeOne_item_Manger*2)/3
let Book_Store_TypeOne_img_h = Book_Store_TypeOne_img_w*1.3218

class MQIBookTypeOneCollectionCellABC: MQICollectionViewCell {
    var coverImageView:MQIShadowImageView!
    var nameLabel: UILabel!
    
    var bookNameText: String = "" {
        didSet{
            //            nameLabel.bounds = CGRect (x: 0, y: (coverImageView?.maxY)!+8.5*gdscale, width: 96*gdscale, height: newheight + 5)
            nameLabel.text = bookNameText
            self.layoutSubviews()
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
        
        nameLabel = createLabel(CGRect.zero, font: systemFont(15), bacColor: UIColor.white, textColor: UIColor.colorWithHexString("#23252C"), adjustsFontSizeToFitWidth: false, textAlignment: .left, numberOfLines: 2)
        nameLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        contentView.addSubview(nameLabel)
        //        nameLabel.backgroundColor = UIColor.yellow
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //171
        coverImageView?.frame = CGRect (x: 0, y: 0, width:Book_Store_TypeOne_img_w , height: Book_Store_TypeOne_img_h)
//        coverImageView.centerX = self.width*0.5
        nameLabel.frame = CGRect (x: coverImageView.x, y: coverImageView.maxY+8, width: Book_Store_TypeOne_img_w, height: self.height-Book_Store_TypeOne_img_h-8)
        
    }

    class func getSize() -> CGSize {
        return CGSize(width:Book_Store_TypeOne_img_w+Book_Store_Manger*0.5, height: Book_Store_TypeOne_img_h+45)
    }
    
    
}
extension UILabel {
    func textLeftTopAlign(_ width:CGFloat,nfont:UIFont) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let attributes:[NSAttributedString.Key:Any] = [NSAttributedString.Key.font : nfont,NSAttributedString.Key.paragraphStyle : paragraphStyle]
        
        let actualRect = NSString(string: text!).boundingRect(with:CGSize.init(width: width, height: 999) ,
                                                              options: .usesLineFragmentOrigin,
                                                              attributes:attributes,
                                                              context: nil)
        self.size = CGSize(width: self.width - 5, height: actualRect.height)
        
    }
    
}
