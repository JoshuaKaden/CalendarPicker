//
//  Date+Sanity.swift
//  ThreeOneOne
//
//  Created by Kaden, Joshua on 2/3/17.
//  Copyright © 2017 NYC DoITT. All rights reserved.
//

import Foundation

extension Date {
    
    var dayOfMonth: Int {
        return Calendar.current.dateComponents([.day], from: self).day!
    }
    
    var dayOfWeek: Int {
        return Calendar.current.dateComponents([.weekday], from: self).weekday!
    }
    
    var isToday: Bool {
        return Calendar.current.isDate(self, inSameDayAs: Date())
    }
    
    var isTomorrow: Bool {
        return Calendar.current.isDate(self, inSameDayAs: Date().plus(days: 1))
    }
    
    var isYesterday: Bool {
        return Calendar.current.isDate(self, inSameDayAs: Date().plus(days: -1))
    }
    
    /// If Today, Tomorrow, or Yesterday, returns that. Otherwise, returns the weekday name.
    var relativeWeekdayName: String {
        if isToday {
            return NSLocalizedString("Today", comment: "")
        }
        if isTomorrow {
            return NSLocalizedString("Tomorrow", comment: "")
        }
        if isYesterday {
            return NSLocalizedString("Yesterday", comment: "")
        }
        return DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: self) - 1]
    }
    
    var startOfMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    var endOfMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
    }
    
    var timeless: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    func isSameDay(date: Date) -> Bool {
        return Calendar.current.isDate(date, equalTo: self, toGranularity: .day)
    }
    
    func isSameMonth(date: Date) -> Bool {
        return Calendar.current.isDate(date, equalTo: self, toGranularity: .month)
    }
    
    func plus(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func plus(months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: self)!
    }
}
