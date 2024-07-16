//
//  FluctuatingEmotionChart.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 04.07.2024.
//

import Charts
import SwiftData
import SwiftUI

struct FluctuatingEmotionChart: View {
    
    @Query(sort: \JournalEntry.date) var entries: [JournalEntry]
    @Binding var showChart: Bool
    
    var isWeekTheSelectedRange: Bool
    
    var body: some View {
        
        let emotionEntries: [EmotionEntry] = entries.map {
            EmotionEntry(date: normalizeDate($0.date), emotion: $0.emotion)
        }

        let entriesByDate = Dictionary(grouping: emotionEntries, by: { $0.date })
        
        if let dateRange = (isWeekTheSelectedRange ? getCurrentWeekDateRange() : getCurrentMonthDateRange()) {
            let allDates = generateDatesForCurrentMonth(dateRange: dateRange)
            Chart {
                // Dummy points to ensure all rows are visible
                ForEach(emotions.indices, id: \.self) { index in
                    PointMark(
                        x: .value("Zi", allDates.first!),
                        y: .value("Stare", index)
                    )
                    .foregroundStyle(Color.clear)
                }
                
                ForEach(allDates, id: \.self) { date in
                    if let entry = entriesByDate[date]?.first,
                       let emotionName = entry.emotion?.name,
                       let yValue = emotionMapping[emotionName] {
                        PointMark(
                            x: .value("Zi", date),
                            y: .value("Stare", yValue)
                        )
                        .foregroundStyle(Color(entry.emotion?.color ?? emotions[2].color))
                    } else {
                        RectangleMark(
                            x: .value("Zi", date)
                        )
                        .foregroundStyle(Color.clear)
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .trailing) { value in
                    let index = value.index
                    if index < emotions.count {
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel {
                            Text(abbreviate(emotions[index].name))
                                .padding(.leading, 6)
                        }
                    }
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: isWeekTheSelectedRange ? 1 : 5)) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        let dateFormatter: DateFormatter = {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "d.MM" // Format for abbreviated month and day
                            return formatter
                        }()
                        
                        if let dateValue = value.as(Date.self) {
                            if showChart {
                                Text(dateFormatter.string(from: dateValue))
                                    .padding(.top, 12)
                            } else {
                                EmptyView()
                            }
                        }
                    }
                }
            }
        } else {
            Text("Oops, ceva nu e bine... Incearca din mai tarziu!")
        }
    }
}

#Preview {
    FluctuatingEmotionChart(showChart: .constant(true), isWeekTheSelectedRange: false)
        .padding(32)
        .modelContainer(previewContainer)
}
