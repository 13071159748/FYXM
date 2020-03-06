//
//  GYRMTopActionView.swift
//  Reader
//
//  Created by CQSC  on 2017/11/2.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


class GYRMTopActionView: GYRMBaseView, MQITableViewDelegate {
    
    fileprivate var  titles = [kLocalized("ShareThisBook"), kLocalized("AddShelf"),kLocalized("BookInfo"),kLocalized("Exceptional")]
    fileprivate var imgs = ["info_shared", "reader_top_shelf", "reader_top_detail","reader_top_shelf"]

//    fileprivate var imgs = ["reader_top_shelf", "reader_top_reward"]
    fileprivate var gtableview: MQITableView!
    
    public var showReward: Bool = false
    
    override func addSubviews() {
        super.addSubviews()

        if MQIPayTypeManager.shared.type == .inPurchase {
            imgs = ["info_shared","reader_top_shelf", "reader_top_detail"]
            titles = [kLocalized("ShareThisBook"),kLocalized("AddShelf"),kLocalized("BookInfo")]
        }
        
        gtableview = MQITableView(frame: self.bounds)
        gtableview.gyDelegate = self
        gtableview.separatorStyle = .none
        gtableview.backgroundColor = backgroundColor
        gtableview.bounces = false
        gtableview.registerCell(GYRMTopActionViewCell.self, xib: false)
        self.addSubview(gtableview)
    }
    
    func reloadSignCell() {
        gtableview.reloadData()
    }
    
    //MARK: --
    func numberOfTableView(_ tableView: MQITableView) -> Int {
        return 1
    }
    
    func numberOfRow(_ tableView: MQITableView!, section: Int) -> Int {

        return titles.count
        
    }
    
    func heightForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> CGFloat {

        return GYRMTopActionView.getSize().height/CGFloat(titles.count)
    }
    
    func cellForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(GYRMTopActionViewCell.self, forIndexPath: indexPath)
        
        let image = UIImage(named: imgs[indexPath.row])!.withRenderingMode(.alwaysTemplate)
        cell.imageView?.image = image
        cell.imageView?.tintColor = UIColor.white
        cell.textLabel?.text = titles[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    func didSelectRowAtIndexPath(_ tableView: MQITableView!, indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
    //TODO:  分享 ====
             readMenu.delegate?.readMenuClickShared?(readMenu: readMenu)
        case 1:
            readMenu.delegate?.readMenuClickAddShelf?(readMenu: readMenu)
        case 2:
//            let bookInfoVC = GDBookInfoVC()
//            bookInfoVC.bookId = eachModel.book_id
//            pushVC(bookInfoVC)
            readMenu.delegate?.readMenuClickToDetail?(readMenu:readMenu)
        case 3:
            showReward = !showReward
            readMenu.rewardView(isShow: showReward, completion: nil)
            
            readMenu.subscribeView(isShow: false, completion: nil)
            readMenu.topView.buyBtn.isSelected = false
        default:
            break
        }
        //隐藏
        readMenu.topView.moreBtn.isSelected = false
        readMenu.topActionView(isShow: false, completion: nil)
        
        tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gtableview.frame = self.bounds
    }
    
    class func getSize() -> CGSize {
        if MQIPayTypeManager.shared.type == .inPurchase {
            return CGSize(width: 125, height: 140)
        }
        return CGSize(width: 125, height: 200)

    }
  

}


class GYRMTopActionViewCell: MQITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configUI()
    }
    
    func configUI() {
        selectionStyle = .none
        backgroundColor = UIColor.clear
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height = self.bounds.height
        let width = self.bounds.width
        let space: CGFloat = 15
        
        var originX: CGFloat = space
        if let imageView = imageView {
            imageView.frame = CGRect(x: originX, y: (height-20)/2, width: 20, height: 20)
            originX = imageView.frame.maxX+10
            
        }
        if let textLabel = textLabel {
            textLabel.frame = CGRect(x: originX, y: 0, width: width-originX-space, height: height)
        }
        
    }
}

