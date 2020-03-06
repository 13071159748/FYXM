//
//  GYRMSettingView.swift
//  Reader
//
//  Created by CQSC  on 2017/6/23.
//  Copyright © 2017年  CQSC. All rights reserved.
//

import UIKit


protocol GYReadSettingSubViewDelegate: NSObjectProtocol {
    func fontChange(_ plus: Bool)
    func lineHeightChange(_ value: Float)
    func paragraphHeightChange(_ value: Float)
    func letterSpaceChange(_ value: Float)
    func fontWeightChange(_ value: Int)
    func themeChange(_ index: Int)
}

class GYRMSettingView: GYRMBaseView, UIScrollViewDelegate {
    
    var fontView: GYRMSettingSubView!
//    var subViews = [GYRMSettingSubView]()
    override func addSubviews() {
        super.addSubviews()
        
        fontView = GYRMSettingSubView(frame: self.bounds, readMenu: readMenu)
        fontView.frame.origin.x = 0
        fontView.backgroundColor = UIColor.clear
        fontView.rStyle = .fontView
//        subViews.append(fontView)
        addSubview(fontView)
        
    }

    func checkSubscribe() {
//        fontView.gtableView.reloadRows(at: [IndexPath.init(row: 5, section: 0)], with: .none)
//        fontView.setSubViews[5]
        if fontView.setSubViews.count >= 6 {
            let settingView = fontView.setSubViews[5]
            settingView.checkSubscribe()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}


class GYRMSettingSubView: GYRMBaseView {
    
    var setSubViews = [GDRMSettingSubView]()

    
    var rStyle: readSettingViewSytle = .fontView {
        didSet {
//            let readStyle = GYReadStyle.shared
            
//            deTitles = [readStyle.styleModel.bookLineHeight,
//                        readStyle.styleModel.bookParagraphHeight,
//                        readStyle.styleModel.bookLetterSpace,
//                        readStyle.styleModel.bookFontWeight == 1 ? 1.0 : 2.0]
            if rStyle == .fontView {
                titles = fontTitles
            }else {
                titles = moreTitles
            }
            if gtableView != nil {
                gtableView.reloadData()
            }
        }
    }
    var gtableView: MQITableView!
    
    var titles = [String]()
//    var deTitles = [Float]()
    
    let fontTitles = ["亮度", "翻页", "字号", "排版", "背景", "自动订阅"]
    let moreTitles = ["行间距", "段间距", "文字间距", "字体粗细"]
    
    var delegate: GYReadSettingSubViewDelegate?
    
//    var changeRStyle: (() -> ())?
//    var lightChangeBlock: ((_ index: Int) -> ())?
    var refreshLineHeightCell: (() -> ())?
    
    override func addSubviews() {
        super.addSubviews()
        
        var y:CGFloat = 10
        let set_height = (self.height - 20 - x_TabbatSafeBottomMargin)/6
        for i in 0..<fontTitles.count {
            let settingView = GDRMSettingSubView(frame: CGRect (x: 0, y: y, width: self.bounds.width, height: set_height))
            settingView.readMenu = readMenu
            settingView.titleLabel.text = fontTitles[i]
            self.addSubview(settingView)
            setSubViews.append(settingView)
            switch i {
            case 0:
                settingView.addLights()
            case 1:
                settingView.addEffect()
            case 2:
                settingView.addFont()
            case 3:
                settingView.addLineHights()
            case 4:
                settingView.addBacs()
            case 5:
                settingView.addDingYue()
            default:
                break
            }
            
            y += set_height
        }
        
        
        
        
//        let space: CGFloat = 10
//        gtableView = MQITableView(frame: CGRect(x: 0, y: space, width: self.bounds.width, height: self.bounds.height-2*space))
//        gtableView.backgroundColor = UIColor.clear
//        gtableView.bounces = false
//        gtableView.separatorStyle = .none
//        gtableView.gyDelegate = self
//        gtableView.showsVerticalScrollIndicator = false
//        gtableView.showsHorizontalScrollIndicator = false
//        gtableView.registerCell(GYRMSettingCell.self, xib: false)
//        gtableView.registerCell(GYRMSettingMoreCell.self, xib: false)
//        self.addSubview(gtableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    //MARK: Action
    
    func needRefreshLineHeightCell() {
        refreshLineHeightCell?()
    }
    
}

extension GYRMSettingSubView: MQITableViewDelegate {
    //MARK: MQITableViewDelegate
    func numberOfTableView(_ tableView: MQITableView) -> Int {
        return 1
    }
    
    func numberOfRow(_ tableView: MQITableView!, section: Int) -> Int {
        return titles.count
    }
    
    func heightForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height/CGFloat(titles.count)-0.1
    }
    
    func cellForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> UITableViewCell {
        if rStyle == .fontView {
            let cell = tableView.dequeueReusableCell(GYRMSettingCell.self, forIndexPath: indexPath)
            cell.readMenu = readMenu
            cell.titleLabel.text = titles[indexPath.row]
            switch indexPath.row {
            case 0:
                cell.addLights()
            case 1:
                cell.addEffect()
            case 2:
                cell.addFont()
            case 3:
                cell.addLineHights()
            case 4:
                cell.addBacs()
            case 5:
                cell.addDingYue()
            default:
                break
            }
            return cell
        }else {
            /*
            if indexPath.row < deTitles.count {
                let cell = tableView.dequeueReusableCell(GYRMSettingMoreCell.self, forIndexPath: indexPath)
                cell.titleLabel.text = titles[indexPath.row]
                cell.deTitleLabel.text = NSString(format: "%.1f", deTitles[indexPath.row]) as String
                
                let styleModel = GYReadStyle.shared.styleModel!
                cell.actionBlock = {[weak self](plus) -> Void in
                    if let strongSelf = self {
                        switch (indexPath as IndexPath).row {
                        case 0:
                            let value = styleModel.bookLineHeight+(plus == true ? 0.1 : -0.1)
                            if value <= 0.9 && plus == false {
                                return
                            }
                            
                            if value >= 2.6 && plus == true {
                                return
                            }
                            
                            styleModel.bookLineStyle = .custom
                            styleModel.bookLineHeight = value
                            strongSelf.readMenu.delegate?.readMenuClicksetupLineHeight?(readMenu: strongSelf.readMenu, linHeight: CGFloat(value))
                            cell.deTitleLabel.text = "\(value)"
                            strongSelf.needRefreshLineHeightCell()
                        case 1:
                            let value = styleModel.bookParagraphHeight+(plus == true ? 0.1 : -0.1)
                            if value <= 0 && plus == false {
                                return
                            }
                            
                            if value >= 1.6 && plus == true {
                                return
                            }
                            
                            styleModel.bookLineStyle = .custom
                            styleModel.bookParagraphHeight = value
                            strongSelf.readMenu.delegate?.readMenuClicksetupParagraphHeight?(readMenu: strongSelf.readMenu, paragraphHeight: CGFloat(value))
                            cell.deTitleLabel.text = "\(value)"
                            strongSelf.needRefreshLineHeightCell()
                        case 2:
                            let value = styleModel.bookLetterSpace+(plus == true ? 0.1 : -0.1)
                            
                            if value <= -0.1 && plus == false {
                                return
                            }
                            
                            if value >= 1.1 && plus == true {
                                return
                            }
                            
                            styleModel.bookLineStyle = .custom
                            styleModel.bookLetterSpace = value
                            strongSelf.readMenu.delegate?.readMenuClicksetupLetterSpace?(readMenu: strongSelf.readMenu, letterSpace: CGFloat(value))
                            cell.deTitleLabel.text = "\(value)"
                            strongSelf.needRefreshLineHeightCell()
                        case 3:
                            var value = styleModel.bookFontWeight
                            
                            if plus == true {
                                if value == 2 {
                                    return
                                }
                                value = 2
                            }else {
                                if value == 1 {
                                    return
                                }
                                value = 1
                            }
                            
                            styleModel.bookFontWeight = value
                            strongSelf.readMenu.delegate?.readMenuClicksetupFontWidth?(readMenu: strongSelf.readMenu, fontWidth: CGFloat(value))
                            cell.deTitleLabel.text = "\(value).0"
                        default:
                            gLog("")
                        }
                    }
                }
                return cell
            }else {
                let cell = MQITableViewCell()
                cell.backgroundColor = UIColor.clear
                cell.contentView.backgroundColor = UIColor.clear
                return cell
            }
            */
            let cell = MQITableViewCell()
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            return cell
        }
        
    }
    
    func didSelectRowAtIndexPath(_ tableView: MQITableView!, indexPath: IndexPath) {
        
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
