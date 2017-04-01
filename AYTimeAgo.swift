//
//  AYDate.swift
//  JoCars
//
//  Created by Ayman Rawashdeh on 3/13/17.
//  Copyright © 2017 Ayman Rawashdeh. All rights reserved.
//

import Foundation

public class AYTimeAgo {
    
    public static var sharedInstance: AYTimeAgo = AYTimeAgo()
    
    public var localeJSON: [String: AnyObject]?
    
    private init(){
        
        localeJSON = loadJSON()
    }
    
    public static func localizePlural(key: String!, value: Int) -> String{
        
        if key == nil {
            return ""
        }
        
        if let json = AYTimeAgo.sharedInstance.localeJSON,let dictionary = json[key] as? [String: String] {
            
            let timeAgo = AYTimeAgo.sharedInstance.getLocale(from: dictionary, count: value)
            
            return timeAgo ?? ""
        }
        
        return ""
    }
    
    func getLocale(from dictionary: [String: String], count: Int) -> String?{
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.locale = Locale.current
        
        for (key, value) in dictionary {
            
            let matchArray = AYRegex.matches(for: "(^exp:\\d+)-(\\d+$)", in: key)
            
            if !matchArray.isEmpty {
                
                let nsRange = NSRangeFromString(key)
                let range = Range(uncheckedBounds: (nsRange.location, nsRange.length))
                
                if range.contains(count) {
                    
                    if let num = numberFormatter.string(from: count as NSNumber) {
                        
                        return String(format: value, num)
                    }
                }
            }
        }
        
        if count == 1 {
            
            return dictionary["one"]
        }
        
        if count == 2, let two = dictionary["two"] {
            
            return two
        }
        
        if let value = dictionary["other"] {
            
            if let num = numberFormatter.string(from: count as NSNumber) {
                
                return String(format: value, num)
            }
        }
        
        return nil
        
    }
    
    
    func url() -> URL?{
        
        if let path = Bundle.main.url(forResource: Locale.current.languageCode, withExtension: "json"){
            
            return path
        }
        
        if let path = Bundle.main.url(forResource: "base", withExtension: "json"){
            
            return path
        }
        
        return nil
    }
    
    func loadJSON() -> [String : AnyObject]?{
        
        if let url = url() {
            
            do {
                
                let data = try  Data(contentsOf: url)
                let dicionary = try JSONSerialization.jsonObject(with: data, options: [])
                
                return dicionary as? [String: AnyObject]
                
            } catch  {
                
                print("error loading JSON \(url)")
            }
        }
        
        return nil
    }    
}

public class AYRegex {
    
    public static func matches(for regex: String!, in text: String!) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            let results = regex.matches(in: text, options: [], range: NSMakeRange(0, nsString.length))
            var match = [String]()
            for result in results {
                for i in 0..<result.numberOfRanges {
                    match.append(nsString.substring( with: result.rangeAt(i) ))
                }
            }
            return match
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
}

extension Date {
    
    func ay_addSeconds(value: Int) -> Date{
        
        return Calendar.current.date(byAdding: .second, value: value, to: self) ?? self
    }
    
    func ay_addMinutes(value: Int) -> Date{
        
        return Calendar.current.date(byAdding: .minute, value: value, to: self) ?? self
    }
    
    func ay_addHours(value: Int) -> Date{
        
        return Calendar.current.date(byAdding: .hour, value: value, to: self) ?? self
    }
    
    func ay_addDays(value: Int) -> Date{
        
        return Calendar.current.date(byAdding: .day, value: value, to: self) ?? self
    }
    
    func ay_addWeeks(value: Int) -> Date{
        
        return Calendar.current.date(byAdding: .weekOfYear, value: value, to: self) ?? self
    }
    
    func ay_addMonths(value: Int) -> Date{
        
        return Calendar.current.date(byAdding: .month, value: value, to: self) ?? self
    }
    
    func ay_addYears(value: Int) -> Date{
        
        return Calendar.current.date(byAdding: .year, value: value, to: self) ?? self
    }
    
    /// Returns the amount of years from another date
    func ay_years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func ay_months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func ay_weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func ay_days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func ay_hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func ay_minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func ay_seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a time ago from another date
    func ay_timeAgo(from date: Date) -> String {
        if ay_years(from: date)   > 0 {
            return AYTimeAgo.localizePlural(key: "years", value: ay_years(from: date))
        }
        if ay_months(from: date)  > 0 {
             return AYTimeAgo.localizePlural(key: "months", value: ay_months(from: date))
        }
        if ay_weeks(from: date)   > 0 {
             return AYTimeAgo.localizePlural(key: "weeks", value: ay_weeks(from: date))
        }
        if ay_days(from: date)    > 0 {
             return AYTimeAgo.localizePlural(key: "days", value: ay_days(from: date))
        }
        if ay_hours(from: date)   > 0 {
            return AYTimeAgo.localizePlural(key: "hours", value: ay_hours(from: date))
        }
        if ay_minutes(from: date) > 0 {
             return AYTimeAgo.localizePlural(key: "minutes", value: ay_minutes(from: date))
        }
        if ay_seconds(from: date) > 0 {
             return AYTimeAgo.localizePlural(key: "seconds", value: ay_seconds(from: date))
        
        }
        return ""
    }
}

