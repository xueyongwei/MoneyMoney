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
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
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
            self.tipLabel.text = ""
            self.countLabel.text  = "点击开始，开启每秒幸福感"
            self.countLabel.textAlignment = .center
        case .rest:
            self.tipLabel.text = String.init(format: "本月累计赚了：¥ %.2f", MoneyService.shared.earnMoney)
            self.countLabel.textAlignment = .center
            self.countLabel.text = "今天不上班，好好休息"
        case .working:
            self.tipLabel.text = "今日收入："
            self.countLabel.text = String.init(format: "¥ %.2f", MoneyService.shared.earnMoney)
            self.countLabel.textAlignment = .left
        case .notStart:
            self.tipLabel.text = "未到工作时间"
            self.countLabel.text = "吃饱喝足，准备赚钱"
            self.countLabel.textAlignment = .center
        case .didEnd:
            self.tipLabel.text = String.init(format: "今日总共赚了：¥ %.2f", MoneyService.shared.earnMoney)
            self.countLabel.text = "买点东西犒劳自己吧！"
            self.countLabel.textAlignment = .center
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

