//
//  Date.swift
//  modooClass
//
//  Created by 조현민 on 10/07/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

extension Date {
    // 예) 20190121
    func cmpString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let day = formatter.string(from: self)
        return day
    }
    
    func string() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let day = formatter.string(from: self)
        return day
    }
    
    // 예) 2019-01-21 14:11
    func stringAll() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let day = formatter.string(from: self)
        return day
    }
    
    func cmpString2() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        let day = formatter.string(from: self)
        return day
    }
    
    // 전달의 마지막 날
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    func startOfMonth(date:Date) -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date))!
    }
    
    // 이번달의 마지막 날
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    func endOfMonth(date:Date) -> Date {
        let toDate = startOfMonth(date: date)
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: toDate)!
    }
    
    
    // 이번주의 시작 날 (일요일)
    func startOfWeek() -> Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    // 이번주의 마지막 날 (토요일)
    func endOfWeek() -> Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 6, to: sunday)!
    }
    
    // 전년도 마지막 날 (12-31)
    func startOfYear() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .year], from: Calendar.current.startOfDay(for: self)))!
    }
    
    // 이번년도 마지막 날 (12-31)
    func endOfYear() -> Date {
        return Calendar.current.date(byAdding: DateComponents(year: 1, day: -1), to: self.startOfYear())!
    }
    
    // 월 비교
    func compare(month:Date) -> Int{
        let editMonth1 = self.startOfMonth(date: self)
        let editMonth2 = self.startOfMonth(date: month)
        if editMonth1 > editMonth2 {
            // 자신이 작으면 -1
            return -1
        }else if editMonth1 < editMonth2{
            // 자신이 크면 +1
            return 1
        }else {
            // 동일하면 0 을 반환한다.
            return 0
        }
    }
    
    // 해당년도 월별 일자 출력
    static func dayOfMonths(year:Int) -> Array<Int> {
        print("\(year)년")
        var array = Array<Int>()
        for month in 0..<13 {
            var comps = DateComponents()
            comps.year = year
            comps.month = month
            comps.day = 1
            
            let calendar = Calendar.current
            let date: Date? = calendar.date(from: comps)
            
            var range: Range<Int>? = nil
            if let date = date {
                range = calendar.range(of: .day, in: .month, for: date)
            }
            let monthDayLength = range!.count
            print("\(month)월 : \(monthDayLength)일")
            array.append(monthDayLength)
        }
        return array
    }
    
    static func Get(year:Int, month:Int, day:Int) -> Date{
        
        var comps = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = day
        
        let calendar = Calendar.current
        let date: Date? = calendar.date(from: comps)
        return date!
    }
    static func GetId(year:Int, month:Int, day:Int) -> String{
        let dateInteger = ( year * 10000 ) + ( month * 100 ) + day
        return String("\(dateInteger)")
    }
    // Id
    func GetId() -> String{
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.day, .month, .year])
        let components = calendar.dateComponents(unitFlags, from: self)
        let year = components.year!
        let month = components.month!
        let day = components.day!
        let id = "\(( year * 10000 ) + ( month * 100 ) + day)"
        return id
    }
    
    
    // Date to Year
    func getYear() -> Int {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.day, .month, .year])
        let components = calendar.dateComponents(unitFlags, from: self)
        let year = components.year!
        return year
    }
    
    // Date to Month
    func getMonth() -> Int {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.day, .month, .year])
        let components = calendar.dateComponents(unitFlags, from: self)
        let month = components.month!
        return month
    }
    
    // Date to Month
    func getDay() -> Int {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.day, .month, .year])
        let components = calendar.dateComponents(unitFlags, from: self)
        let day = components.day!
        return day
    }
    
    func dateToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        let day = formatter.string(from: self)
        return day
    }
    
    func dateToStringSlash() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd EEEE"
        let day = formatter.string(from: self)
        return day
    }
    
    // change Date Format
    func changeDateFormat() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd hh:mm aa"
        let str = formatter.string(from: self)
        formatter.dateFormat = "yyyy-MM-dd hh:mm aa"
        let date = formatter.date(from: str)
        
        return date!
    }
    
    func dateCompare(date:Date) -> Int{
        let today = Date()
        let interval = today.timeIntervalSince(date)
        let days = Int(interval / 86400)
        return days
    }
    
    
}

extension String{
    func stringToDate(str:String) -> Date{
        let dateString:String = str

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date:Date = dateFormatter.date(from: dateString)!
        return date
    }
    func stringToDate2(str:String) -> Date{
        let dateString:String = str

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date:Date = dateFormatter.date(from: dateString)!
        return date
    }
}
