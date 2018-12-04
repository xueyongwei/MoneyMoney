//
//  WorkDay.swift
//  MoneyMoney
//
//  Created by 薛永伟 on 2018/12/3.
//  Copyright © 2018年 薛永伟. All rights reserved.
//

import UIKit

class WorkDay: NSObject {
    
    static var currentEarn = 0
    
    class func start(){
        
    }
    
    class func workDaysInformation() -> (isWorkDay:Bool,workDays:Int,didWorkedDaysThisMonth:Int)? {
        
        var calendar = Calendar.current
        calendar.firstWeekday = 1;
        
        let now = Date()
        let todayCompent = calendar.dateComponents([.year,.month,.day], from: now)
        
        guard let daysInMonth = calendar.range(of: .day, in: .month, for: now) else{
            return nil
        }
        
        var firstDayCompent = calendar.dateComponents([.year,.month,.day], from: now)
        firstDayCompent.day = 1
        guard let firstDayOfMonth = calendar.date(from: firstDayCompent),let firstWeekDay = calendar.ordinality(of: .weekday, in: .weekOfMonth, for: firstDayOfMonth) else{
            return nil
        }
//        美国时间周日-周六为 1-7
//        guard let userWorkDays = UserDefaults.standard.array(forKey: "userWorkDays") as? [Int] else {return nil}
        let userWorkDays = [2,3,4,5,6]
        var weak = firstWeekDay
        
        var worksDay = 0
        var isworkDay = false
        var didWorkedDaysThisMonth = 0
        
        for day in daysInMonth{
            
            weak = weak % 7
            
            if todayCompent.day == day {
                didWorkedDaysThisMonth = worksDay
            }
            
            if userWorkDays.contains(weak) {//工作
                worksDay += 1
                if todayCompent.day == day {
                    isworkDay = true
                }
            }
            
            weak += 1
            
        }
        return (isworkDay,worksDay,didWorkedDaysThisMonth)
        
    }
    
    
    /// 每天挣多少钱
    class func dayEarn() -> Double {
        guard let data = DataCenter.readData(),let salary = data.salary  else{
            return 0.0
        }
        
        guard let dateInfo = self.workDaysInformation() else {return 0.0}
        
        let dayEarn = salary / Double(dateInfo.workDays)
        return dayEarn
    }
    /// 每秒挣多少钱
    fileprivate static var privateSecondEarn:Double?
    class func secondEarn() -> Double{
        if let ue = self.privateSecondEarn {return ue}
        let dayEarn = self.dayEarn()
        let secondEarn = dayEarn / 24 / 60 / 60
        self.privateSecondEarn = secondEarn
        return secondEarn
    }
    
    /// 到现在已经已经挣了多少钱
    static func hadEarnNow() -> Double{
        let now = Date()
        
        guard let dateInfo = self.workDaysInformation() else {return 0.0}
        let passedDayEarnd = Double(dateInfo.didWorkedDaysThisMonth) * self.dayEarn()
        
        let calender = Calendar.current
        
        
        guard let data = DataCenter.readData(),let start = data.statrDate  else{
            return 0.0
        }
        
        var startCompent = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: start)
        let nowCompent = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: now)
        
        startCompent.year = nowCompent.year
        startCompent.month = nowCompent.month
        startCompent.day = nowCompent.day
        
        guard let todayStartDate = calender.date(from: startCompent) else {return 0.0}
        
        let todaySecond = now.timeIntervalSince(todayStartDate)
        let todayEarned = todaySecond * self.secondEarn()
        
//        guard let hour = todayCompent.hour - s,let minute = todayCompent.minute,let second = todayCompent.second else { return 0.0 }
//
//        let sectond =  (hour * 60 + minute ) * 60 + second
//        guard let passedSecondToday = calender.range(of: .second, in: .day, for: now) else{
//            return 0.0
//        }
//        let todayEarned = Double(passedSecondToday.count) * self.secondEarn()
        
        return passedDayEarnd + todayEarned
        
    }
}
