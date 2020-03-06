//
//  MQISignRecommandCell.swift
//  XSDQReader
//
//  Created by _CHK_  on 2018/7/11.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit
 /*
  拉拉
  */

class MQISignRecommandCell: MQICollectionViewCell {

    var coverImageView:UIImageView!
    
    var bookTitleLabel:UILabel!
    
    var book:MQIEachBook! {
        didSet{
            
            bookTitleLabel.text = book.book_name
            //            bookTitleLabel.text = "部分的空间啊不罚款部分是否把咖啡"
            
            coverImageView.sd_setImage(with: URL(string: book.book_cover), placeholderImage: bookPlaceHolderImage)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSignCell()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    func createSignCell() {
        
        coverImageView = UIImageView(frame: CGRect.zero)
        //        coverImageView?.layer.shadowOffset = CGSize(width: 0, height: 0)
        //        coverImageView?.layer.shadowRadius = 2
        //        coverImageView?.layer.shadowOpacity = 0.5
        coverImageView.layer.cornerRadius = 2
        coverImageView.clipsToBounds = true
        contentView.addSubview(coverImageView)
        //        coverImageView.backgroundColor = UIColor.gray
        
        bookTitleLabel = UILabel(frame: CGRect.zero)
        bookTitleLabel.font = UIFont.systemFont(ofSize: 13)
        bookTitleLabel.textColor = UIColor.black
        bookTitleLabel.numberOfLines = 0
        //        bookTitleLabel.backgroundColor = UIColor.yellow
        contentView.addSubview(bookTitleLabel)
        
    }
    override func layoutSubviews() {
        let scale:CGFloat = screenWidth <= 320 ? screenWidth/375 : 1
        coverImageView.frame = CGRect(x: 0, y: 14, width: 190/2*scale, height: 258/2*scale)
        //        coverImageView?.layer.shadowPath = UIBezierPath(rect: coverImageView!.bounds).cgPath
        bookTitleLabel.frame = CGRect (x: 0, y: coverImageView.maxY+7.5, width: 190/2*scale, height: 32)
    }
    class func getSize() -> CGSize{
        let scale:CGFloat = screenWidth <= 320 ? screenWidth/375 : 1
        return CGSize(width: 190/2*scale, height: (258+40)*scale/2+(28+15+64)/2)
    }

}
