//
//  ZileBuneVsProasteChartView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 04.07.2024.
//

import Charts
import SwiftData
import SwiftUI

struct ZileBuneVsProasteChartView: View {
    
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
        
        let goodDays = entriesFromSelectedRange.filter {
            $0.emotion?.name ?? "" == emotions[4].name ||
            $0.emotion?.name ?? "" == emotions[3].name
        }
        let badDays = entriesFromSelectedRange.filter {
            $0.emotion?.name ?? "" == emotions[1].name ||
            $0.emotion?.name ?? "" == emotions[0].name
        }
        
        Chart {
            BarMark(
                x: .value("Tip de zi", "Zile fericite"),
                y: .value(
                    "Numar",
                    goodDays.count
                )
            )
            .foregroundStyle(Color(emotions[4].color))
//            BarMark(
//                x: .value("Tip de zi", "Zile bune"),
//                y: .value(
//                    "Numar",
//                    entriesFromSelectedRance.count - goodDays.count - badDays.count
//                )
//            )
//            .foregroundStyle(Color(emotions[2].color))
            BarMark(
                x: .value("Tip de zi", "Zile proaste"),
                y: .value(
                    "Numar",
                    badDays.count
                )
            )
            .foregroundStyle(Color(emotions[0].color))
        }
        .chartYAxis {
            AxisMarks { value in
                if !showChart {
                    AxisValueLabel {
                        EmptyView()
                    }
                } else {
                    AxisValueLabel()
                }
            }
        }
    }
}

#Preview {
    ZileBuneVsProasteChartView(showChart: .constant(true), isWeekTheSelectedRange: false)
        .modelContainer(previewContainer)
}
