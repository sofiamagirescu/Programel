//
//  DateExtension.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 25.06.2024.
//

import Foundation

extension Date {
    var startOfMonth: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }
    
    var endOfMonth: Date {
        Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
    }
    
    var calendarMonthDays: [Date] {
        var days: [Date] = []
        let calendar = Calendar.current
        let startOfMonth = self.startOfMonth
        let endOfMonth = self.endOfMonth
        
        var currentDate = startOfMonth
        
        while currentDate <= endOfMonth {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return days
    }
    
    func isSameDay(as otherDate: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: otherDate)
    }
}
