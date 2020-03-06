//
//  GDReadEndView.swift
//  CQSC
//
//  Created by moqing on 2019/3/7.
//  Copyright © 2019年 _CHK_. All rights reserved.
//

import UIKit
import SnapKit
class GDReadEndViewController: MQIBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.snp.removeConstraints()
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
        }
    }

}

private let headCellIdentifier = "headCellIdentifier"
private let commonCellIdentifier = "commonCellIdentifier"
extension GDReadEndViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = indexPath.row == 0 ? headCellIdentifier : commonCellIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        return cell
    }
    
    
}
