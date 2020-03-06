//
//  MQIShelfTiledsCell.swift
//  Reader
//
//  Created by CQSC  on 2017/8/28.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class MQIShelfTiledsCell: MQICollectionViewCell {
    
    weak var delegate: MQIShelfCellDelegate?
    
    var coverImage: MQIShadowImageView!
    
    var bookTitleLabel: UILabel!
    var recordLabel: UILabel!
    
    var updateLabel: UILabel?
    
    var updateImageView: UIImageView?
    
    let tiledtitleFont = systemFont(14)
    
    let tiledtitleColor = UIColor.colorWithHexString("#4A4E52")
    
    fileprivate var alreadyReadLabel:UILabel!
    
    var  maskImageView:UIView!
    var  editMaskBtn:UIButton!
    
    var isBtnSelected: Bool  = false {
        didSet(oldValue) {
            if isBtnSelected {
                editMaskBtn.isSelected = true
                editMaskBtn.tintColor = mainColor
            }else{
                editMaskBtn.isSelected = false
                editMaskBtn.tintColor = UIColor.white
            }
            
        }
    }
    
    var isUpdate: Bool! {
        didSet {
            if let updateImageView = updateImageView, let updateLabel = updateLabel {
                updateLabel.isHidden = !isUpdate
                updateImageView.isHidden = !isUpdate
                
                updateLabel.isHidden = isUpdate
                updateImageView.isHidden = isUpdate
            }
        }
    }
    var book: MQIEachBook! {
        didSet {
            
          
            bookTitleLabel.text = book.book_name
            coverImage.imageView.sd_setImage(with: URL(string: book.book_cover), placeholderImage: bookPlaceHolderImage)
            isUpdate = (book.updateBook == 1) ? false:true
             recordLabel.text = ""
             recordLabel.isHidden  = true
//            if let record = MQILastReaderManager.shared.getLastReader(book.book_id) {
//                if let chapter = record.readChapterModel {
//                    if chapter.chapter_title == "" {
//                        recordLabel.text = "\(kLocalized("AlreadyRead"))：\(kLocalized("TheTirstChapt"))"
////                        kLongLocalized("ReadToTheFirstChapter", replace: "1")
//                    }else {
//                        recordLabel.text = "\(kLocalized("AlreadyRead"))：\(chapter.chapter_title)"
//                    }
//
//                }else {
//                    recordLabel.text = kLocalized("UnRead")
//                }
//            }else {
//                recordLabel.text = kLocalized("UnRead")
//            }
            layoutSubviews()
        }
        
    }
    
    
    func isEdit(_ edit:Bool)  {
        maskImageView.isHidden = !edit
        editMaskBtn.isHidden = !edit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTypeSimpleView()
        isEdit(false)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    func addTypeSimpleView() {
        isUserInteractionEnabled = true
        addLongPress(self, action: #selector(MQIShelfTiledsCell.longPressAction(_:)), view: self)
        coverImage = MQIShadowImageView(frame: CGRect.zero)
        contentView.addSubview(coverImage)
        addUpdateLable()
        bookTitleLabel = createLabel(CGRect.zero,
                                     font: tiledtitleFont,
                                     bacColor: UIColor.clear,
                                     textColor: tiledtitleColor,
                                     adjustsFontSizeToFitWidth: false,
                                     textAlignment: .left,
                                     numberOfLines: 2)
        //        bookTitleLabel.lineBreakMode = .byCharWrapping
        contentView.addSubview(bookTitleLabel)
        
        recordLabel = createLabel(CGRect.zero,
                                   font: systemFont(12),
                                   bacColor: UIColor.clear,
                                   textColor: kUIStyle.colorWithHexString("999999"),
                                   adjustsFontSizeToFitWidth: false,
                                   textAlignment: .left,
                                   numberOfLines: 1)
        contentView.addSubview(recordLabel)
        
        
        maskImageView = UIView()
//        maskImageView.layer.cornerRadius = 8
//        maskImageView.clipsToBounds = true
        maskImageView.backgroundColor = kUIStyle.colorWithHexString("000000", alpha: 0.3)
        contentView.addSubview(maskImageView)
        
        editMaskBtn = UIButton()
        let image  = UIImage(named: "CHK_shelf_edit_sel_image")?.withRenderingMode(.alwaysTemplate)
        editMaskBtn.setImage(image, for: .normal)
        editMaskBtn.tintColor = UIColor.white
//        editMaskBtn.setImage(UIImage.init(named: "CHK_shelf_edit_no_image"), for: normal)
        contentView.addSubview(editMaskBtn)
        editMaskBtn.isUserInteractionEnabled = false
        
        
    }
    func addUpdateLable() {
        if updateImageView == nil {
            updateImageView = UIImageView(image: UIImage(named: "shelf_update1"))
            coverImage.addSubview(updateImageView!)
        }
        
        if updateLabel == nil {
            updateLabel = createLabel(CGRect.zero,
                                      font: systemFont(9),
                                      bacColor: UIColor.clear,
                                      textColor: UIColor.white,
                                      adjustsFontSizeToFitWidth: true,
                                      textAlignment: .center,
                                      numberOfLines: 2)
            updateLabel!.text = kLocalized("update")
            updateLabel?.backgroundColor = mainColor
            updateImageView!.addSubview(updateLabel!)
        }
        updateImageView?.snp.makeConstraints { (make) in
            make.right.equalTo(coverImage)
            make.top.equalTo(coverImage)
            make.width.equalTo(kUIStyle.scale1PXW(25))
            make.height.equalTo(15)
        }
        updateLabel?.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        coverImage.frame = CGRect(x: 0, y: 0, width: self.width, height: self.width*1.334)
        maskImageView.frame =  coverImage.frame
        editMaskBtn.frame = CGRect(x: maskImageView.maxX-5-18, y: maskImageView.y+5, width: 18, height: 18)
        
        bookTitleLabel.frame = CGRect (x: 0, y: (coverImage?.maxY)!+2, width:coverImage.width, height:self.height-(coverImage?.maxY)!-5)
        
//        recordLabel.frame = CGRect (x: 0, y: bookTitleLabel.maxY+2, width:bookTitleLabel.width, height: recordLabel.font.pointSize+5)
//
        
//        if let updateImageView = updateImageView, let updateLabel = updateLabel {
//            updateImageView.frame = CGRect(x: 0, y: 0, width: 15, height: 15*124/58)
//            updateLabel.frame = updateImageView.bounds
//        }
     
    }
    
    @objc func longPressAction(_ t: UILongPressGestureRecognizer) {
        if t.state == .began {
            delegate?.longPress(book)
        }
    }
    
    fileprivate static  let w =  (screenWidth - 20*2 - 23*2)/3
    fileprivate static  let h = w*1.334+40
    class func getSize() -> CGSize{

          return CGSize(width: w, height:h )
    }
    
    class func getSize2() -> CGSize{
        
        return CGSize(width: w-10, height:h+10 )
    }
  
    func compressOriginalImage(_ image:UIImage ,toSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContext(toSize)
        image.draw(in: CGRect (x: 0, y: 0, width: toSize.width, height: toSize.height))
        UIGraphicsEndImageContext()
        return image
    }
}
