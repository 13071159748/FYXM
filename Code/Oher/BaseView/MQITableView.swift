//
//  MQITableView.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/2.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit

import Foundation

import UITableView_FDTemplateLayoutCell

@objc protocol  MQITableViewDelegate: NSObjectProtocol {
    func cellForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> UITableViewCell
    func numberOfRow(_ tableView: MQITableView!, section: Int) -> Int
    
    @objc optional func refreshData()
    @objc optional func loadMoreData()
    @objc optional func numberOfTableView(_ tableView: MQITableView) -> Int
    @objc optional func heightForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> CGFloat
    @objc optional func viewForHeader(_ tableView: MQITableView!, section: NSInteger) -> UIView?
    @objc optional func heightForHeader(_ tableView: MQITableView!, section: NSInteger) -> CGFloat
    @objc optional func viewForFooter(_ tableView: MQITableView!, section: NSInteger) -> UIView?
    @objc optional func heightForFooter(_ tableView: MQITableView!, section: NSInteger) -> CGFloat
    @objc optional func didSelectRowAtIndexPath(_ tableView: MQITableView!, indexPath: IndexPath)
    @objc optional func commitEditingStyle(_ tableView: MQITableView, editingStyle: UITableViewCell.EditingStyle, indexPath: IndexPath)
    @objc optional func editingStyleForRowAtIndexPath(_ tableView: MQITableView, indexPath: IndexPath) -> UITableViewCell.EditingStyle
    @objc optional func willBeginEditingRowAtIndexPath(_ tableView: MQITableView, indexPath: IndexPath)
    @objc optional func didEndEditingRowAtIndexPath(_ tableView: MQITableView, indexPath: IndexPath?)
    @objc optional func canEditRowAtIndexPath(_ tableView: MQITableView, indexPath: IndexPath) -> Bool
    @objc optional func titleForDeleteConfirmationButtonForRowAtIndexPath(_ tableView: MQITableView, indexPath: IndexPath) -> String?
    @objc optional func sectionIndexTitlesForTableView(_ tableView: MQITableView) -> [String]?
    @objc optional func didHighlightRowAtIndexPath(_ tableView: MQITableView!, indexPath: IndexPath)
    @objc optional func didUnHighlightRowAtIndexPath(_ tableView: MQITableView!, indexPath: IndexPath)
    @objc optional func didEndDisplaying(_ tableView: MQITableView!, _ cell: UITableViewCell, indexPath: IndexPath)
    @objc optional func gScrollViewWillBeginDragging(_ tableView: MQITableView)
    @objc optional func gScrollViewWillBeginDecelerating(_ tableView: MQITableView)
    @objc optional func gScrollViewDidScroll(_ tableView: MQITableView)
    @objc optional func gScrollViewDidEndDecelerating(_ tableView: MQITableView!)
    @objc optional func gScrollViewDidEndDragging(_ tableView: MQITableView, willDecelerate decelerate: Bool)
    
}

enum MQITableViewDirection {
    case up
    case down
}
class MQITableView: UITableView, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    weak var gyDelegate: MQITableViewDelegate?
    
    var direction: MQITableViewDirection = MQITableViewDirection.down
    var lastOffsetY: CGFloat = 0
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.tableFooterView = UIView()
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tableFooterView = UIView()
        self.delegate = self
        self.dataSource = self
//        fatalError("init(coder:) has not been implemented")
    }

    
    init(frame: CGRect) {
        super.init(frame: frame, style: .plain)
        
        self.tableFooterView = UIView()
        self.delegate = self
        self.dataSource = self
    }
    
    //MARK:UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = gyDelegate?.numberOfTableView?(tableView as! MQITableView)
        if count != nil {
            return count!
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = gyDelegate?.numberOfRow(tableView as! MQITableView, section: section)
        if count != nil {
            return count!
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = gyDelegate?.viewForHeader?(tableView as! MQITableView, section: section)
        if view != nil {
            return view
        }else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = gyDelegate?.heightForHeader?(tableView as! MQITableView, section: section)
        if height != nil {
            return height!
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = gyDelegate?.viewForFooter?(tableView as! MQITableView, section: section)
        if view != nil {
            return view
        }else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let height = gyDelegate?.heightForFooter?(tableView as! MQITableView, section: section)
        if height != nil {
            return height!
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 44
        let h = gyDelegate?.heightForRow?(tableView as! MQITableView, indexPath: indexPath)
        if h != nil {
            height = h!
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = gyDelegate?.cellForRow(tableView as! MQITableView, indexPath: indexPath)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        gyDelegate?.didHighlightRowAtIndexPath?(tableView as! MQITableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        gyDelegate?.didUnHighlightRowAtIndexPath?(tableView as! MQITableView, indexPath: indexPath)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return gyDelegate?.sectionIndexTitlesForTableView?(tableView as! MQITableView)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        gyDelegate?.didEndDisplaying?(tableView as! MQITableView, cell, indexPath: indexPath)
    }
    
    
    //MARK:UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastOffsetY = scrollView.contentOffset.y
        gyDelegate?.gScrollViewWillBeginDragging?(scrollView as! MQITableView)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > lastOffsetY {
            direction = MQITableViewDirection.up
        }else {
            direction = MQITableViewDirection.down
        }
        gyDelegate?.gScrollViewWillBeginDecelerating?(scrollView as! MQITableView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        gyDelegate?.gScrollViewDidScroll?(scrollView as! MQITableView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let c = scrollView.contentOffset
        if c.y == scrollView.contentSize.height - self.frame.size.height ||
            scrollView.contentSize.height < self.frame.size.height {
            //                println("滑动到最下边了")
        }
        gyDelegate?.gScrollViewDidEndDecelerating?(scrollView as! MQITableView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
    
    @objc(scrollViewDidEndDragging:willDecelerate:) func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        gyDelegate?.gScrollViewDidEndDragging?(scrollView as! MQITableView, willDecelerate: decelerate)
    }
    
    //MARK:UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gyDelegate?.didSelectRowAtIndexPath?(tableView as! MQITableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        gyDelegate?.commitEditingStyle?(tableView as! MQITableView, editingStyle: editingStyle, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let style = gyDelegate?.editingStyleForRowAtIndexPath?(tableView as! MQITableView, indexPath: indexPath)
        if let style = style {
            return style
        }
        return .none
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        gyDelegate?.willBeginEditingRowAtIndexPath?(tableView as! MQITableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        gyDelegate?.didEndEditingRowAtIndexPath?(tableView as! MQITableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let bool = gyDelegate?.canEditRowAtIndexPath?(tableView as! MQITableView, indexPath: indexPath) {
            return bool
        }else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        if let str = gyDelegate?.titleForDeleteConfirmationButtonForRowAtIndexPath?(tableView as! MQITableView, indexPath: indexPath) {
            return str
        }else {
            return nil
        }
    }
    
}

extension MQITableView {
    
    func g_heightForCell<T: UITableViewCell>(_: T.Type, configuration: @escaping ((Any?) -> Void)) -> CGFloat //where T: ReusableView
    {
    
        
        return fd_heightForCell(withIdentifier: T.reuseIdentifier, configuration: configuration)
    }
    
    func g_heightForCell<T: UITableViewCell>(_: T.Type, cacheBy: IndexPath, configuration: @escaping ((Any?) -> Void)) -> CGFloat //where T: ReusableView
    {
        return fd_heightForCell(withIdentifier: T.reuseIdentifier, cacheBy: cacheBy, configuration: configuration)
    }
    
    func g_heightForCell<T: UITableViewCell>(_: T.Type, cacheByKey: NSCopying, configuration: @escaping ((Any?) -> Void)) -> CGFloat //where T: ReusableView
    {
        return fd_heightForCell(withIdentifier: T.reuseIdentifier, cacheByKey: cacheByKey, configuration: configuration)
    }
    
    func g_heightForHeaderFooterView<T: UITableViewCell>(_: T.Type, configuration: @escaping ((Any?) -> Void)) -> CGFloat //where T: ReusableView
    {
        return fd_heightForHeaderFooterView(withIdentifier: T.reuseIdentifier, configuration: configuration)
    }
    
    
}

extension MQITableView {
    
    func registerCell<T: UITableViewCell>(_: T.Type, xib: Bool) {
        if xib == true {
            let nib = UINib(nibName: T.nibName, bundle: nil)
            register(nib, forCellReuseIdentifier: T.reuseIdentifier)
        }else {
            register(T.myClass, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    //    func registerHeaderFooter<T: UITableViewHeaderFooterView>(_: T.Type, xib: Bool) where T: ReusableView, T:LoadableView {
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(_: T.Type, xib: Bool){
        if xib == true {
            let nib = UINib(nibName: T.nibName, bundle: nil)
            register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }else {
            register(T.myClass, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    //    func dequeueReusableCell<T: UITableViewCell>(_: T.Type, forIndexPath indexPath: IndexPath) -> T where T:ReusableView {
    func dequeueReusableCell<T: UITableViewCell>(_: T.Type, forIndexPath indexPath: IndexPath) -> T {
        
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
    
    func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>(_: T.Type) -> T// where T:ReusableView
    {
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Could not dequeue headerfooter with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
    
}

extension UIView {
    class func loadNib<T: UIView>(_: T.Type) -> T //where T: LoadableView
    {
        guard let view = (Bundle.main.loadNibNamed(T.nibName, owner: nil, options: nil)! as NSArray)[0] as? T else {
            fatalError("failed loadNibNamed with \(T.nibName)")
        }
        return view
    }
}

protocol LoadableView:class { }

extension LoadableView where Self:UIView {
    
    static var nibName:String {
        // notice the new describing here
        // now only one place to refactor if describing is removed in the future
        return String(describing: self)
    }
    
    static var myClass: AnyClass {
        return self
    }
}

extension UIView: LoadableView {}

protocol ReusableView:class {}

extension ReusableView where Self:UIView {
    
    static var reuseIdentifier:String {
        return String(describing: self)
    }
    
}

extension UIView: ReusableView {}

