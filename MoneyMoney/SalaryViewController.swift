//
//  SalaryViewController.swift
//  MoneyMoney
//
//  Created by 黄丹 on 2018/11/30.
//  Copyright © 2018 薛永伟. All rights reserved.
//

import UIKit

class SalaryViewController: UIViewController {

    @IBOutlet weak var tf: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tf.becomeFirstResponder()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onOkClick(_ sender: UIButton) {
        guard let inputText = tf.text , let salary = Double(inputText)  else {
            let alv = UIAlertController.init(title: "也没有特别喜欢你", message: "只是每次见到你，\n我都算算卡里的积蓄", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "我养你啊", style: .default, handler: nil)
            alv.addAction(ok)
            self.present(alv, animated: true, completion: nil)
            return
        }
        
        DataCenter.tempWorkInfo.salary = salary
        DataCenter.synchronize()
        self.navigationController?.popToRootViewController(animated: true)
        
        
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
