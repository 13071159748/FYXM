//
//  MQIUserAutoReaderSetVC.swift
//  XSDQReader
//
//  Created by CQSC  on 2018/7/4.
//  Copyright © 2018年 _CHK_ . All rights reserved.
//

import UIKit


class MQIUserAutoReaderSetVC: MQIRootTableVC {

    let books = GYBookManager.shared.dingyueBooks_chapter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = kLocalized("AutomaticPurchase")
        
        gtableView.registerCell(MQIUserAutoReaderSetCell.self, xib: false)
    }
    
    //MARK: --
    override func numberOfTableView(_ tableView: MQITableView) -> Int {
        return 1
    }
    
    override func numberOfRow(_ tableView: MQITableView!, section: Int) -> Int {
        return books.count <= 0 ? 1 : books.count
    }
    
    override func heightForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func cellForRow(_ tableView: MQITableView!, indexPath: IndexPath) -> UITableViewCell {
        if books.count <= 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: noData_cell, for: indexPath) as! GYNoDataCell
            cell.textLabel?.text = kLocalized("ThereIsNoBookSubscriptionAtTheMoment")
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(MQIUserAutoReaderSetCell.self, forIndexPath: indexPath)
            let book = books[indexPath.row]
            cell.textLabel?.text = book.book_name
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell.switchBlock = {(open) -> Void in
                if open == true {
                    GYBookManager.shared.addDingyueBook(book)
                }else {
                   
                    MQILoadManager.shared.addAlert(kLocalized("Warn"), msg:  kLongLocalized("DearYouMustCancelIt", replace: book.book_name), block: {
                        GYBookManager.shared.removeDingyueBook(book)
                    }, cancelBlock: {
                        cell.s.isOn = true
                    })
                    
                }
            }
            return cell
        }
    }
    
    //MARK: --
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
