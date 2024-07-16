//
//  PieEmotionChart.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 05.07.2024.
//

import Charts
import SwiftData
import SwiftUI

struct PieEmotionChart: View {
    
    @Query(sort: \JournalEntry.date) var entries: [JournalEntry]
    @Binding var showChart: Bool
    
    var isWeekTheSelectedRange: Bool
    
    var body: some View {
        
        let emotionEntries: [EmotionEntry] = entries.map {
            EmotionEntry(date: normalizeDate($0.date), emotion: $0.emotion)
        }
        
        let currentMonthDateRange = getCurrentMonthDateRange()
        let currentMonthEntries = emotionEntries.filter {
            guard let dateRange = currentMonthDateRange else { return false }
            return $0.date >= dateRange.startDate && $0.date <= dateRange.endDate
        }
        
        let currentWeekDateRange = getCurrentWeekDateRange()
        let currentWeekEntries = emotionEntries.filter {
            guard let dateRange = currentWeekDateRange else { return false }
            return $0.date >= dateRange.startDate && $0.date <= dateRange.endDate
        }
        
        var entriesFromSelectedRange: [EmotionEntry] {
            if isWeekTheSelectedRange {
                return currentWeekEntries
            } else {
                return currentMonthEntries
            }
        }
        
        Chart(emotions, id: \.self) { item in
            SectorMark(
                angle: .value(
                    "Numar",
                    entriesFromSelectedRange.filter {
                        $0.emotion?.name ?? "" == item.name
                    }.count
                ),
                innerRadius: .ratio(0.5),
                angularInset: 2
            )
            .cornerRadius(2)
            .foregroundStyle(Color(item.color))
//            .foregroundStyle(by: .value("Emotie", item.name))
        }
        .chartLegend(alignment: .center, spacing: 24)
        .chartForegroundStyleScale(
            domain: showChart ? emotions.map { $0.name } : [],
            range: emotions.map { Color($0.color) }
        )
    }
}

#Preview {
    PieEmotionChart(showChart: .constant(true), isWeekTheSelectedRange: false)
        .padding(32)
        .modelContainer(previewContainer)
}
