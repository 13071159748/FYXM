//
//  GYShelfTiledCell.swift
//  Reader
//
//  Created by CQSC  on 16/7/15.
//  Copyright © 2016年  CQSC. All rights reserved.
//

import UIKit


class MQIShelfTiledCell: MQICollectionViewCell {
    
    public var bookCover: GYBookCoverView!
    
    var indexPath: IndexPath!
    weak var delegate: MQIShelfCellDelegate?
    
    let textFont = UIFont.systemFont(ofSize: 12)
    let textColor = RGBColor(101, g: 101, b: 101)
    
    var book: MQIEachBook! {
        didSet {
            bookCover.titleLabel.text = book.book_name
            bookCover.coverImage.sd_setImage(with: URL(string: book.book_cover), placeholderImage: bookPlaceHolderImage)
            
            bookCover.isUpdate = !book.book_isUpdate
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configUI() {
        isUserInteractionEnabled = true
        addLongPress(self, action: #selector(MQIShelfTiledCell.longPressAction(_:)), view: self)
        
        bookCover = GYBookCoverView(frame: CGRect.zero)
        bookCover.addUpdateLable()
        bookCover.addEditView()
        bookCover.bookCoverSel = {[weak self](sel) -> Void in
            if let strongSelf = self {
                strongSelf.delegate?.cellEditSel(strongSelf.book)
            }
        }
        contentView.addSubview(bookCover)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let space: CGFloat = 20
        
        let bookCoverSize = GYBookCoverView.getSize(height: contentView.height-2*space)
        bookCover.frame = CGRect(x: (self.width-bookCoverSize.width)/2,
                                 y: space,
                                 width: bookCoverSize.width,
                                 height: bookCoverSize.height)
        
    }
    
    @objc func longPressAction(_ t: UILongPressGestureRecognizer) {
        if t.state == .began {
            delegate?.longPress(book)
        }
    }
    
    
    class func getSize() -> CGSize {
        let count: CGFloat = 3
        
        let bookWidth = (screenWidth-2*MQIBaseShelfVC_Tiled_Edge_Space)/count-0.5
        let size = CGSize(width: bookWidth, height: GYBookCoverView.getSize(bookWidth).height-20)
        return size
        
    }
    
}



//import UIKit

//
//class GYShelfTiledCell: MQICollectionViewCell {
//
//    @IBOutlet weak var icon: MQIBookImageView!
//    @IBOutlet weak var textLabel: UILabel!
//    @IBOutlet weak var editView: UIView!
//    @IBOutlet weak var editBtn: UIButton!
//
//    @IBOutlet weak var updateImageView: UIImageView!
//    @IBOutlet weak var updateLabel: UILabel!
//
//    var indexPath: IndexPath!
//    var isRecentVC: Bool = false
//
//    let textFont = UIFont.systemFont(ofSize: 12)
//    let textColor = RGBColor(101, g: 101, b: 101)
//
//    var book: MQIEachBook! {
//        didSet {
//            textLabel.text = book.book_name
//            icon.bookView.sd_setImage(with: URL(string: book.book_cover), placeholderImage: bookPlaceHolderImage)
//            updateLabel.isHidden = !book.book_isUpdate
//            updateImageView.isHidden = !book.book_isUpdate
//        }
//    }
//
//    var isEdit: Bool = false {
//        didSet {
//            editView.isHidden = !isEdit
//            editBtn.isHidden = !isEdit
//        }
//    }
//    var delegate: GYShelfCellDelegate?
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        configUI()
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configUI()
//    }
//
//    func configUI() {
//        addLongPress(self, action: #selector(GYShelfTiledCell.longPressAction(_:)), view: self)
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        isEdit = false
//        editBtn.setImage(shelfEditSelImage, for: .selected)
//        editBtn.setImage(shelfTiledUnEditSelImage, for: .normal)
//
//        textLabel.textColor = textColor
//        textLabel.font = textFont
//        textLabel.lineBreakMode = .byCharWrapping
//
//        updateLabel.font = UIFont.systemFont(ofSize: 12)
//        updateLabel.adjustsFontSizeToFitWidth = true
//    }
//
//    class func getSize() -> CGSize {
//        let count: CGFloat = 3 //每行个数
//        let bookSpace: CGFloat = 30
//        let bookWidth = (screenWidth-bookSpace*(count+1))/count
//        let height = bookWidth*87/62+42
//        return CGSize(width: (screenWidth-2*MQIBaseShelfVC_Tiled_Edge_Space)/3-0.5, height: height)
//    }
//
//    @IBAction func editBtnAction(_ sender: AnyObject) {
//        editBtn.isSelected = !editBtn.isSelected
//        delegate?.cellEditSel(book)
//    }
//    func longPressAction(_ t: UILongPressGestureRecognizer) {
////        if isRecentVC == true {
////            return
////        }
//
//        if t.state == .began {
////            isEdit = !isEdit
//            delegate?.longPress(book)
//        }
//
//    }
//
//}
