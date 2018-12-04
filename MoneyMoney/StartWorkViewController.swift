//
//  StartWorkViewController.swift
//  MoneyMoney
//
//  Created by 黄丹 on 2018/11/30.
//  Copyright © 2018 薛永伟. All rights reserved.
//

import UIKit

class StartWorkViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onOkClick(_ sender: UIButton) {
        DataCenter.tempWorkInfo.statrDate = self.datePicker.date
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
