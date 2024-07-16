//
//  ChartHelpers.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 04.07.2024.
//

import Foundation

struct EmotionEntry: Identifiable {
    let id = UUID()
    let date: Date
    let emotion: CurrentEmotion?
}

func getCurrentWeekDateRange() -> (startDate: Date, endDate: Date)? {
    let calendar = Calendar.current
    let now = Date()
    guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: now) else {
        return nil
    }
    return (startDate: weekInterval.start, endDate: weekInterval.end)
}

func getCurrentMonthDateRange() -> (startDate: Date, endDate: Date)? {
    let calendar = Calendar.current
    let now = Date()
    guard let range = calendar.range(of: .day, in: .month, for: now),
          let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)),
          let endOfMonth = calendar.date(byAdding: .day, value: range.count - 1, to: startOfMonth) else {
        return nil
    }
    return (startDate: startOfMonth, endDate: endOfMonth)
}

func generateDatesForCurrentMonth(dateRange: (startDate: Date, endDate: Date)) -> [Date] {
    var dates: [Date] = []
    var currentDate = dateRange.startDate
    let calendar = Calendar.current
    
    while currentDate <= dateRange.endDate {
        dates.append(currentDate)
        currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
    }
    
    return dates
}

func normalizeDate(_ date: Date) -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: date)
    return calendar.date(from: components) ?? date
}

let emotionMapping: [String: Int] = [
    emotions[0].name: 0,
    emotions[1].name: 1,
    emotions[2].name: 2,
    emotions[3].name: 3,
    emotions[4].name: 4
]
