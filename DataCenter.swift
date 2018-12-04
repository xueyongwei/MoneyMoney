//
//  DataCenter.swift
//  MoneyMoney
//
//  Created by 黄丹 on 2018/11/30.
//  Copyright © 2018 薛永伟. All rights reserved.
//

import UIKit

class DataCenter: NSObject {
    
    static var workInfo = WorkInfo()
    
    static var tempWorkInfo = WorkInfo()
    
    static func synchronize(){
        self.workInfo = self.tempWorkInfo
        let usf = UserDefaults.init(suiteName: "group.com.ylmf.money")
        usf?.setValue(workInfo.statrDate, forKey: "statrDate")
        usf?.setValue(workInfo.endDate, forKey: "endDate")
        usf?.setValue(workInfo.salary, forKey: "salary")
        usf?.setValue(workInfo.workDays, forKey: "workDays")
        usf?.synchronize()
        MoneyService.shared.start()
    }

    static func readData() -> WorkInfo? {
        let usf = UserDefaults.init(suiteName: "group.com.ylmf.money")
        let salary = usf?.value(forKey: "salary") as? Double
        let endDate = usf?.value(forKey: "endDate") as? Date
        let statrDate = usf?.value(forKey: "statrDate") as? Date
        let workDays = usf?.value(forKey: "workDays") as? [Int]
        let info = WorkInfo.init(statrDate: statrDate, endDate: endDate, salary: salary,workDays:workDays)
        return info
    }
}

extension DataCenter{
    struct WorkInfo {
        var statrDate:Date?
        var endDate:Date?
        var salary:Double?
        var workDays:[Int]?
    }
}
