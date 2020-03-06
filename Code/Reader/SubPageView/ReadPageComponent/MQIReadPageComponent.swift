//
//  MQIReadPageComponent.swift
//  DWMRead
//
//  Created by CQSC  on 2017/8/28.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


let GRefreshKeyPathContentOffset = "contentOffset"
let GRefreshKeyPathContentSize = "contentSize"
let GRefreshKeyPathPanState = "state"

class MQIReadPageComponent: UIView {

    public var criticalNum: CGFloat = 60
    weak var gscrollView: UITableView!
    public var pan: UIPanGestureRecognizer?
    
    public var refreshingBlock: (() -> ())?
    
    public var stateView: UIView!
    public var titleLabel: UILabel!
    public var activityView: UIActivityIndicatorView!
    
    init(_ tableView: MQITableView) {
        super.init(frame: CGRect(x: 0, y: 0, width: tableView.width, height: screenHeight))
        gscrollView = tableView
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configUI() {
        backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        gscrollView.alwaysBounceVertical = true
        
        createStateView()
        addObservers()
    }
    
    fileprivate func createStateView() {
        stateView = UIView(frame: CGRect.zero)
        stateView.backgroundColor = UIColor.clear
        addSubview(stateView)
        
        titleLabel = createLabel(CGRect.zero,
                                 font: boldFont(15),
                                 bacColor: UIColor.clear,
                                 textColor: UIColor.white,
                                 adjustsFontSizeToFitWidth: false,
                                 textAlignment: .left,
                                 numberOfLines: 1)
        stateView.addSubview(titleLabel)
        
        activityView = UIActivityIndicatorView(style: .white)
        activityView.backgroundColor = UIColor.clear
        activityView.startAnimating()
        stateView.addSubview(activityView)
    }
    
    fileprivate func addObservers() {
        gscrollView.addObserver(self,
                                forKeyPath: GRefreshKeyPathContentOffset,
                                options: [.new, .old],
                                context: nil)
        gscrollView.addObserver(self,
                                forKeyPath: GRefreshKeyPathContentSize,
                                options: [.new, .old],
                                context: nil)
        
        pan = gscrollView.panGestureRecognizer
        if let pan = pan {
            pan.addObserver(self,
                            forKeyPath: GRefreshKeyPathPanState,
                            options: [.new, .old],
                            context: nil)
        }
    }

    public func removeObservers() {
        gscrollView.removeObserver(self, forKeyPath: GRefreshKeyPathContentOffset)
        gscrollView.removeObserver(self, forKeyPath: GRefreshKeyPathContentSize)
        
        if pan != nil {
            pan!.removeObserver(self, forKeyPath: GRefreshKeyPathPanState)
            pan = nil
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stateView.frame = CGRect(x: 0, y: 0, width: width, height: criticalNum)
        
        let labelWidth: CGFloat = 60
        let labelSpace: CGFloat = 15
        let left = (width-37-labelWidth-labelSpace)/2
        titleLabel.frame = CGRect(x: left+37+labelSpace, y: 0, width: stateView.width, height: stateView.height)
        activityView.center = CGPoint(x: left+37/2, y: titleLabel.centerY)
    }
    func scrollViewContentSizeDidChange(_ chagne: [NSKeyValueChangeKey : Any]?) {}
    func scrollViewContentOffsetDidChange(_ chagne: [NSKeyValueChangeKey : Any]?) {}
    func scrollViewPanStateDidChange(_ chagne: [NSKeyValueChangeKey : Any]?) {}

}

extension MQIReadPageComponent {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // 遇到这些情况就直接返回
        if self.isUserInteractionEnabled == false {return}
        
        if keyPath == GRefreshKeyPathContentSize {
            scrollViewContentSizeDidChange(change)
        }
        
        if isHidden == true {return}
        
        if keyPath == GRefreshKeyPathContentOffset {
            scrollViewContentOffsetDidChange(change)
        }else if keyPath == GRefreshKeyPathPanState {
            scrollViewPanStateDidChange(change)
        }
    }
    
    
}
