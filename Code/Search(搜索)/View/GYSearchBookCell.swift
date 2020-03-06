//
//  GYSearchBookCell.swift
//  Reader
//
//  Created by CQSC  on 2017/7/3.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYSearchBookCell: MQICollectionViewCell {
    
    @IBOutlet weak var icon: MQIBookImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    var indexPath: IndexPath!
    var isRecentVC: Bool = false
    
    let textFont = UIFont.systemFont(ofSize: 12)
    let textColor = RGBColor(101, g: 101, b: 101)
    
    var book: MQIEachBook! {
        didSet {
            textLabel.text = book.book_name
            icon.bookView.sd_setImage(with: URL(string: book.book_cover), placeholderImage: bookPlaceHolderImage)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        textLabel.textColor = textColor
        textLabel.font = textFont
        textLabel.textAlignment = .left
        textLabel.lineBreakMode = .byCharWrapping

    }
    
    class func getSize() -> CGSize {
        let count: CGFloat = 3 //每行个数
        let bookSpace: CGFloat = 30
        let bookWidth = (screenWidth-bookSpace*(count+1))/count
        let height = bookWidth*87/62+42
        return CGSize(width: (screenWidth-2*MQIBaseShelfVC_Tiled_Edge_Space)/3-0.5, height: height)
    }
    
    
}
