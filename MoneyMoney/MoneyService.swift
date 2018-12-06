//
//  MoneyService.swift
//  MoneyMoney
//
//  Created by 薛永伟 on 2018/12/4.
//  Copyright © 2018年 薛永伟. All rights reserved.
//

import UIKit

class MoneyService: NSObject {
    
    static var shared = MoneyService()
    // 状态
    var state = TodayState.noInitialization
    // 挣了多少了
    var earnMoney:Double = 0.0
    // 每秒收入
    fileprivate var secondSalary:Double = 0.0
    fileprivate var incomUnitSecond = 0.2
    
    lazy var timer: Timer = {
        let timer = Timer.init(timeInterval: incomUnitSecond, target: self, selector: #selector(income), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        return timer
    }()
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(start), name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }
    
    /// 持续收入
    @objc func income(){
        guard self.state == .working else{return}
        self.earnMoney += (self.secondSalary * incomUnitSecond)
    }
    
    @objc func start(){
        
        guard let data = DataCenter.readData(),let start = data.statrDate, let end = data.endDate,let salary = data.salary, let userWorkDays = data.workDays else{
            self.state = .noInitialization
            return
        }
        
        var calendar = Calendar.current
        calendar.firstWeekday = 1;
        
        let now = Date()
        // 今天的成分
        let todayComponents = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: now)
        
        // 计算出本月有几天
        guard let daysInMonth = calendar.range(of: .day, in: .month, for: now) else{
            return
        }
        // 本月第一天日期成分
        var firstDayComponents = calendar.dateComponents([.year,.month,.day], from: now)
        firstDayComponents.day = 1
        
        // 本月第一天是周几
        guard let firstDayOfMonth = calendar.date(from: firstDayComponents),let firstWeekDay = calendar.ordinality(of: .weekday, in: .weekOfMonth, for: firstDayOfMonth) else{
            return
        }
        
        
        //        美国时间周日-周六为 1-7
        //        guard let userWorkDays = UserDefaults.standard.array(forKey: "userWorkDays") as? [Int] else {return nil}
//        let userWorkDays = [2,3,4,5,6]
        
        
        // 工作天数
        var workDayNumber = 0
        // 今天是否工作
        var isworkToday = false
        // 本月已工作天数
        var didWorkedDaysThisMonth = 0
        
        // 找出工作日们
        var weak = firstWeekDay
        for day in daysInMonth{
            //美国时间周日-周六为 1-7，为了计算方便，我们从0-6表示周日到周六
            weak = weak % 7
            
            if todayComponents.day == day {
                didWorkedDaysThisMonth = workDayNumber
            }
            
            if userWorkDays.contains(weak) {//工作日
                workDayNumber += 1
                if todayComponents.day == day {//今天是工作日
                    isworkToday = true
                }
            }
            weak += 1
        }
        // 今天的工作状态
        self.state = isworkToday ? TodayState.notStart : TodayState.rest
        
        // 开始工作的时间成分
        var startComponents = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: start)
        startComponents.year = todayComponents.year
        startComponents.month = todayComponents.month
        startComponents.day = todayComponents.day
        guard let todayStartWordDate = calendar.date(from: startComponents) else {
            return
        }
        // 结束工作的时间成分
        var endComponents = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: end)
        endComponents.year = todayComponents.year
        endComponents.month = todayComponents.month
        endComponents.day = todayComponents.day
        guard let todayEndWordDate = calendar.date(from: endComponents) else {
            return
        }
        
        if todayStartWordDate > now {//还没到时间
            self.state = .notStart
            return
        }
        
        
        let dailySalary = salary / Double(workDayNumber)
        
        let passeDayEarn = Double(didWorkedDaysThisMonth) * dailySalary
        
        // 今天休息，只算到过去工作日挣的钱
        if self.state == .rest {
            self.earnMoney = passeDayEarn
            return
        }
        
        
        
        
        
        let oneDayWorkSecond = end.timeIntervalSince(start)
        let todayPassedSecond = now.timeIntervalSince(todayStartWordDate)
        
        let secondSalary = dailySalary / oneDayWorkSecond
        self.secondSalary = secondSalary
        
        let todayEarned = todayPassedSecond * secondSalary
        
        if now > todayEndWordDate {
            self.state = .didEnd
            self.earnMoney =  todayEarned
            return
        }
        
        // 正在工作中
        self.state = .working
        self.earnMoney =  todayEarned
        
        
        self.timer.fire()
        return
    }
    
    /// 刷新因程序挂起导致的当前数据已失效
     @objc fileprivate func refreshDate(){
        
    }

}

extension MoneyService {
    enum TodayState {
        case noInitialization
        case rest
        case notStart
        case working
        case didEnd
    }
}
