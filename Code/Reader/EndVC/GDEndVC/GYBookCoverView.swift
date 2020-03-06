//
//  GYBookCoverView.swift
//  Reader
//
//  Created by CQSC  on 2017/6/30.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYBookCoverView: UIView {
    
    public var coverImage: UIImageView!
//    fileprivate var bacImageView: UIImageView!
    public var titleLabel: UILabel!
    
    fileprivate var updateLabel: UILabel?
    fileprivate var updateImageView: UIImageView?
    
    fileprivate var editView: UIView?
    
    public var editBtn: UIButton?
    
    fileprivate let titleFont = systemFont(14)
    fileprivate let titleColor = UIColor.colorWithHexString("#232323")
    
    public var isUpdate: Bool! {
        didSet {
            if let updateImageView = updateImageView, let updateLabel = updateLabel {
                updateLabel.isHidden = !isUpdate
                updateImageView.isHidden = !isUpdate
                
                updateLabel.isHidden = isUpdate
                updateImageView.isHidden = isUpdate
            }
        }
    }
    
    public var isEdit: Bool = false {
        didSet {
            if let editView = editView, let editBtn = editBtn {
                editView.isHidden = !isEdit
                editBtn.isHidden = !isEdit
            }
        }
    }
    
    public var bookCoverSel: ((_ sel: Bool) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }
    
    func configUI() {

        
        coverImage = UIImageView(frame: CGRect.zero)

        addSubview(coverImage)
        
        titleLabel = createLabel(CGRect.zero,
                                 font: titleFont,
                                 bacColor: UIColor.clear,
                                 textColor: titleColor,
                                 adjustsFontSizeToFitWidth: false,
                                 textAlignment: .left,
                                 numberOfLines: 2)
        titleLabel.lineBreakMode = .byCharWrapping
        addSubview(titleLabel)
        
    }
    
    func addUpdateLable() {
        if updateImageView == nil {
            updateImageView = UIImageView(image: UIImage(named: "shelf_update"))
            coverImage.addSubview(updateImageView!)
        }
        
        if updateLabel == nil {
            updateLabel = createLabel(CGRect.zero,
                                      font: systemFont(10),
                                      bacColor: UIColor.clear,
                                      textColor: UIColor.white,
                                      adjustsFontSizeToFitWidth: true,
                                      textAlignment: .center,
                                      numberOfLines: 2)
            updateLabel!.text = "更\n新"
            updateImageView!.addSubview(updateLabel!)
        }
    }
    
    func addEditView() {
        if editView == nil {
            editView = UIView(frame: CGRect.zero)
            editView!.backgroundColor = UIColor(white: 0, alpha: 0.5)
            coverImage.addSubview(editView!)
        }
        
        if editBtn == nil {
            editBtn = createButton(CGRect.zero,
                                   normalTitle: nil,
                                   normalImage: shelfTiledUnEditSelImage,
                                   selectedTitle: nil,
                                   selectedImage: shelfEditSelImage,
                                   normalTilteColor: nil,
                                   selectedTitleColor: nil,
                                   bacColor: UIColor.clear,
                                   font: nil,
                                   target: self,
                                   action: #selector(GYBookCoverView.editBtnAction(_:)))
            editView!.addSubview(editBtn!)
        }
    }
    
    @objc func editBtnAction(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        bookCoverSel?(btn.isSelected)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        coverImage.frame = CGRect(x: 0, y: 14, width: 190/2, height: 258/2)
        
        titleLabel.frame = CGRect (x: 0, y: (coverImage?.maxY)!+2, width: 190/2, height: 32)
        
        if let updateImageView = updateImageView, let updateLabel = updateLabel {
            updateImageView.frame = CGRect(x: 0.5, y: 0.5, width: 15, height: 15*124/58)
            updateLabel.frame = updateImageView.bounds
        }
        
        if let editView = editView, let editBtn = editBtn {
            editView.frame = CGRect(x: 0,
                                    y: coverImage.height*187/192-30,
                                    width: coverImage.width,
                                    height: 30)
            
            editBtn.frame = CGRect(x: 0, y: 0, width: editView.height, height: editView.height)
        }
        
    }
    
    class func getSize(_ width: CGFloat = 0, height: CGFloat = 0) -> CGSize {
        if width > 0 {
            
            return CGSize(width: width, height: 214*width/130)
        }else if height > 0 {
            return CGSize(width: 130*height/214, height: height+20)
        }else {
            return CGSize (width: width, height: height+20)
        }
    }

}
