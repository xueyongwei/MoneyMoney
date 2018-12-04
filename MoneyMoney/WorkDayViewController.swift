//
//  WorkDayViewController.swift
//  MoneyMoney
//
//  Created by 薛永伟 on 2018/12/4.
//  Copyright © 2018年 薛永伟. All rights reserved.
//

import UIKit

class WorkDayViewController: UIViewController {

    var tableView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onOkClick(_ sender: UIButton) {
        guard let selectedIndexPaths = tableView?.indexPathsForSelectedRows else {
            
            let alv = UIAlertController.init(title: "如果一周都不上班", message: "那肯定是有人在撒谎，谁？", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "我呀", style: .default, handler: nil)
            let cancle = UIAlertAction.init(title: "我呀", style: .default, handler: nil)
            alv.addAction(ok)
            alv.addAction(cancle)
            self.present(alv, animated: true, completion: nil)
            
            return
        }
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "SalaryViewController", sender: self)
        }
        
        let weakDays = selectedIndexPaths.map({return $0.row})
        DataCenter.tempWorkInfo.workDays = weakDays
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WorkDayTableViewController" {
            let vc = segue.destination as! WorkDayTableViewController
            self.tableView = vc.tableView
        }
    }
 

}
