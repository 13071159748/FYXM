//
//  MQIReadPageTableViewCell.swift
//  Reader
//
//  Created by CQSC  on 2017/6/22.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class MQIReadPageTableViewCell: MQITableViewCell {
    
    public var readView: MQIReadView?
    public var udReadView: MQIReadView?
    public var readCoverView: MQIReadCoverView?
    //    public var readEndView:GDReadEndView?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor.clear
        
        setupUI()
    }
    deinit {
        //此处记录
        readView = nil
        udReadView = nil
        readCoverView = nil
   
    }
    
    
    func addReadView(_ frameRef: CTFrame?) {
        if readView == nil {
            readView = MQIReadView()
            readView!.backgroundColor = UIColor.clear
            contentView.addSubview(readView!)
        }
        
        readView!.frameRef = frameRef
    }
    //    func addReadEndView() {
    //        if readEndView == nil {
    //            readEndView = GDReadEndView()
    //            contentView.addSubview(readEndView!)
    //        }
    //
    //    }
    func addReadCoverView(_ book: MQIEachBook) {
        if readCoverView == nil {
            readCoverView = MQIReadCoverView()
            readCoverView!.backgroundColor = UIColor.clear
            contentView.addSubview(readCoverView!)
        }
        
        readCoverView!.book = book
    }
    
    func addUDReadView(_ frameRef: CTFrame?, height: CGFloat = 0) {
        if udReadView == nil {
            udReadView = MQIReadView()
            udReadView!.backgroundColor = UIColor.clear
            contentView.addSubview(udReadView!)
        }
        
        udReadView?.frameRefHeight = height
        udReadView?.frameRef = frameRef
    }
    
    func setupUI() {
        backgroundColor = UIColor.clear
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if let readView = readView {
            readView.frame = bounds
        }
        //        if let endView = readEndView {
        //            endView.frame = bounds
        //        }
        if let readCoverView = readCoverView {
            readCoverView.frame = bounds
        }
        
        if let udReadView = udReadView {
            let pageLayout = GetPageVCLayout()
            udReadView.frame = CGRect(x: pageLayout.margin_left,
                                      y: 0,
                                      width: GetReadViewFrame().width,
                                      height: height)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}
