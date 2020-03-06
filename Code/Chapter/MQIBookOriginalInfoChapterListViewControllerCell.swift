//
//  MQIBookOriginalInfoChapterListViewControllerCell.swift
//  CQSC
//
//  Created by moqing on 2019/3/7.
//  Copyright © 2019 _CHK_. All rights reserved.
//

import UIKit

class MQIBookOriginalInfoChapterListViewControllerCell: UITableViewCell {
    
    var chapter: MQIEachChapter! {
        didSet {
            let color = chapter.isDown == true ? titleSelColor : titleNormalColor
            chapterTitleLabel.textColor = color
            chapterTitleLabel.text = chapter.chapter_title
            if chapter.chapter_vip == true && chapter.isSubscriber == false {
                vipImg.isHidden = false
            }else {
                vipImg.isHidden = true
            }
//            vipImg.isHidden = true
        }
    }

    @IBOutlet weak var vipImg: UIImageView!
    @IBOutlet weak var chapterTitleLabel: UILabel!
    
    var titleFont = UIFont.systemFont(ofSize: 14)
    var titleNormalColor = RGBColor(31, g: 31, b: 31)
    var titleSelColor = RGBColor(33, g: 102, b: 6)

    override func awakeFromNib() {
        super.awakeFromNib()
        chapterTitleLabel.textColor = titleNormalColor
        chapterTitleLabel.font = titleFont
        addLine(14, lineColor: GYBookOriginalInfoVC_lineColor, directions: .bottom)
    }
    class func getHeight() -> CGFloat {
        return 44
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
