//
//  TodayViewController.swift
//  Today
//
//  Created by 黄丹 on 2018/11/30.
//  Copyright © 2018 薛永伟. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var countLabel: UILabel!
    
    
    lazy var timer: Timer = {
        weak var wkself = self
        let timer = Timer.init(timeInterval: 0.2, target: wkself, selector: #selector(updateEarnLabel), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        return timer
    }()
    
    deinit {
        self.timer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timer.fire()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateEarnLabel()
    }
    
    @objc func updateEarnLabel(){
        
        switch MoneyService.shared.state {
        case .noInitialization:
            self.countLabel.text  = "需要打开APP先进行设置"
        case .rest:
            self.countLabel.text = "好好休息"
        case .work:
            self.countLabel.text = String.init(format: "今日收入：¥ %.2f", MoneyService.shared.earnMoney)
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
