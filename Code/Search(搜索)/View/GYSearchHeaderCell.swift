//
//  GYSearchHeaderCell.swift
//  Reader
//
//  Created by CQSC  on 2017/6/8.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYSearchHeaderCell: MQICollectionViewCell {

    @IBOutlet weak var searchIcon: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!

    var imageTintColor = RGBColor(175, g: 175, b: 175)
    var textFont = systemFont(15)
    var textColor = RGBColor(85, g: 85, b: 85)
    
    var deleteBlock: ((_ key: String) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        searchIcon.image = UIImage(named: "search_icon")!.withRenderingMode(.alwaysTemplate)
        searchIcon.tintColor = imageTintColor
        
        deleteBtn.tintColor = imageTintColor
        
        textLabel.font = textFont
        textLabel.textColor = textColor
        
        addLine(0, lineColor: RGBColor(244, g: 244, b: 244), directions: .bottom)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        if let text = textLabel.text {
            deleteBlock?(text)
        }
    }
    
    class func getSize() -> CGSize {
        return CGSize(width: screenWidth, height: 45)
    }

}
