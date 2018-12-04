//
//  ViewController.swift
//  MoneyMoney
//
//  Created by 黄丹 on 2018/11/30.
//  Copyright © 2018 薛永伟. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var startBtn: UIButton!
    
    fileprivate var start:Date!
    fileprivate var end:Date!
    fileprivate var salary:Double!
    
    fileprivate var todayEarn = 10.0
    fileprivate var each = 0.01
    @IBOutlet weak var label: UILabel!
    lazy var timer: Timer = {
        weak var wkself = self
        let timer = Timer.init(timeInterval: 0.2, target: wkself, selector: #selector(updateEarnLabel), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        return timer
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateEarnLabel()
      
    }
    
    @objc func updateEarnLabel(){
        
        switch MoneyService.shared.state {
        case .noInitialization:
            self.label.text  = "点击开始，开启每秒幸福感"
            startBtn.isSelected = false
        case .rest:
            startBtn.isSelected = true
            self.label.text = String.init(format: "¥ %.4f", MoneyService.shared.earnMoney)
        case .work:
            startBtn.isSelected = true
            self.label.text = String.init(format: "¥ %.4f", MoneyService.shared.earnMoney)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startBtn.isSelected = DataCenter.workInfo.statrDate != nil
        
        self.timer.fire()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onBtnClick(_ sender: UIButton) {
        self.performSegue(withIdentifier: "edit", sender: self)
    }
    
}

