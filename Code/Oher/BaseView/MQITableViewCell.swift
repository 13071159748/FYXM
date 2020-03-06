//
//  MQITableViewCell.swift
//  YH
//
//  Created by CQSC  on 15/6/25.
//  Copyright (c) 2015年  CQSC. All rights reserved.
//

import UIKit


let GYDoneBtnCell_height: CGFloat = 70
let tableViewCell_height: CGFloat = 44
class MQITableViewCell: UITableViewCell {
    
    var bottomLine: GYLine?
    var doneBtn: UIButton?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configSelectedBac()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configSelectedBac()
    }
    
    func configSelectedBac() {
        let selectedBackground = UIView(frame: self.bounds)
        selectedBackground.backgroundColor = tableViewSelColor
        selectedBackground.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        self.selectedBackgroundView = selectedBackground
    }
    
    func configContentView() {
        
    }
    
    var btnActionBlock: ((_ btn: UIButton) -> ())?
    func addBtn(_ title: String?, titleColor: UIColor, bacColor: UIColor?, image: UIImage?, action: @escaping ((_ btn: UIButton) -> ())) {
        self.backgroundColor = UIColor.clear
        if doneBtn == nil {
            doneBtn = UIButton(type: .custom)
            doneBtn!.backgroundColor = UIColor.clear
            doneBtn!.layer.cornerRadius = 5
            doneBtn!.layer.masksToBounds = true
            doneBtn!.addTarget(self, action: #selector(MQITableViewCell.doneBtnAction(_:)), for: .touchUpInside)
            self.addSubview(doneBtn!)
        }
        btnActionBlock = action
        if let title = title {
            doneBtn!.setTitle(title, for: .normal)
            doneBtn!.titleLabel?.font = UIFont.boldSystemFont(ofSize: ipad == true ? 18 : 15)
        }
        if let bacColor = bacColor {
            doneBtn!.backgroundColor = bacColor
        }
        if let image = image {
            doneBtn!.setImage(image, for: .normal)
        }
        layoutSubviews()
    }
    
    func addBorder(_ view: UIView) {
        view.layer.borderWidth = 1.0
        view.layer.borderColor = tableViewBacColor.cgColor
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
    }
    
    func addBottomLine() {
        if bottomLine == nil {
            bottomLine = GYLine(frame: CGRect.zero)
            self.addSubview(bottomLine!)
        }
        self.layoutIfNeeded()
        self.layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let space: CGFloat = 8
        bottomLine?.frame = CGRect(x: space, y: self.bounds.height-gyLine_height, width: self.bounds.width-space, height: gyLine_height)
        
        if let doneBtn = doneBtn {
            doneBtn.frame = CGRect(x: 30, y: 25, width: self.bounds.width-60, height: self.bounds.height-30)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    //MARK: Action
    @objc func doneBtnAction(_ btn: UIButton) {
        btnActionBlock?(btn)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: class func
    class func getHeight<T: MQIBaseModel>(_ obj: T?) -> CGFloat {
        return 0
    }
    
}// indexing | processing files
