
//
//  WorkDayTableViewController.swift
//  MoneyMoney
//
//  Created by 薛永伟 on 2018/12/4.
//  Copyright © 2018年 薛永伟. All rights reserved.
//

import UIKit

class WorkDayTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        
         self.clearsSelectionOnViewWillAppear = false

        
    }
    
    fileprivate var hadAppear = false
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if hadAppear == false{
            let lines = self.tableView.numberOfRows(inSection: 0)
            for line in 1..<lines-1 {
                let indexPath = IndexPath.init(row: line, section: 0)
                self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
            hadAppear = true
        }
        
        
    }

  
    
    
    

}
class WorkDayTableViewCell:UITableViewCell {
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            
            self.accessoryType = UITableViewCell.AccessoryType.checkmark
        }else{
            self.accessoryType = UITableViewCell.AccessoryType.none
        }
    }
}
extension WorkDayTableViewController {
    
}
