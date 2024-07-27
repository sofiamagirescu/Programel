//
//  EntriesCalendarView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 25.06.2024.
//

import SwiftData
import SwiftUI

struct EntriesCalendarView: View {
    
    @Query(sort: \JournalEntry.date) var entries: [JournalEntry]
    var registeredDates: [Date] {
        entries.map { $0.date }
    }
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    // Sa inceapa cu luni in loc de duminica
    var daysOfWeek: [String] {
        let calendar = Calendar.current
        var symbols = calendar.shortWeekdaySymbols
        let firstWeekday = calendar.firstWeekday - 1
        if firstWeekday > 0 {
            symbols = Array(symbols[firstWeekday..<symbols.count]) + Array(symbols[0..<firstWeekday])
        }
        return symbols
    }
    
    var earliestDate: Date {
        registeredDates.min() ?? Date()
    }
    
    var latestDate: Date {
        registeredDates.max() ?? Date()
    }
    
    func monthsInRange() -> [Date] {
        var months: [Date] = []
        var currentDate = earliestDate.startOfMonth
        
        while currentDate <= latestDate.startOfMonth {
            months.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
        }
        
        return months
    }
    
    var body: some View {
        GeometryReader { geometry in
            let shouldBeGrid = geometry.size.width > MaxWidths().maxExpandedContentWidth - 100
            let shouldBeCompact = geometry.size.width < MaxWidths().maxNavigationSideBarWidth
            
            ScrollViewReader { proxy in
                ScrollView {
                    if !shouldBeGrid {
                        HStack {
                            Spacer(minLength: 0)
                            
                            LazyVStack {
                                ForEach(monthsInRange(), id: \.self) { monthDate in
                                    MonthView(registeredDates: registeredDates, date: monthDate, columns: columns, daysOfWeek: daysOfWeek, shouldBeCompact: shouldBeCompact)
                                        .padding(.top, 32)
                                        .padding(.bottom, 24)
                                        .id(monthDate)
                                }
                            }
                            .frame(maxWidth: 400)
                            .padding(.horizontal, 32)
                            
                            Spacer(minLength: 0)
                        }
                    } else {
                        HStack {
                            Spacer(minLength: 0)
                    
                            LazyVGrid(
                                columns: Array(repeating: .init(.flexible()), count: 2)
                            ) {
                                ForEach(monthsInRange(), id: \.self) { monthDate in
                                    VStack {
                                        MonthView(registeredDates: registeredDates, date: monthDate, columns: columns, daysOfWeek: daysOfWeek, shouldBeCompact: shouldBeCompact)
                                            .padding(.top, 42)
                                            .padding(.bottom, 24)
                                            .padding(.horizontal, 28)
                                            .id(monthDate)
                                        
                                        Spacer(minLength: 0)
                                    }
                                }
                            }
                            .frame(maxWidth: MaxWidths().maxExpandedContentWidth)
                            .padding(.horizontal, 32)
                            .padding(.bottom, 24)
                    
                            Spacer(minLength: 0)
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.async {
                        proxy.scrollTo(Date().startOfMonth, anchor: .top)
                    }
                }
            }
        }
    }
}

struct MonthView: View {
    
    @Query(sort: \JournalEntry.date) var entries: [JournalEntry]
    var registeredDates: [Date]
    
    let date: Date
    let columns: [GridItem]
    let daysOfWeek: [String]
    
    var shouldBeCompact: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(date.formatted(.dateTime.month().year()))
                    .font(.title3)
                    .fontWeight(.light)
                Spacer()
            }
            .padding(.bottom, 12)
            
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(
                        shouldBeCompact ? String(day.prefix(1)) : day
                    )
                    .font(shouldBeCompact ? .subheadline : .body)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 8)
            
            LazyVGrid(columns: columns, spacing: 16) {
                let firstDayOfMonth = date.startOfMonth
                let firstWeekday = Calendar.current.component(.weekday, from: firstDayOfMonth) - Calendar.current.firstWeekday
                let leadingSpaces = (firstWeekday + 7) % 7
                
                ForEach(0..<leadingSpaces, id: \.self) { _ in
                    Spacer()
                }
                
                ForEach(date.calendarMonthDays, id: \.self) { day in
                    VStack {
                        if registeredDates.contains(where: { $0.isSameDay(as: day) }) {
                            
                            if let entry = entries.first(where: { $0.date.isSameDay(as: day) }) {
                                NavigationLink(destination: EntryView(entry: entry)) {
                                    Text(day.formatted(.dateTime.day()))
                                        .frame(maxWidth: .infinity, minHeight: 40)
//                                        .background(Color(entry.emotion?.colorName ?? ""))
                                        .background(
                                            day.isSameDay(as: Date.now)
                                            ? Color.accentColor
                                            : Color(.systemGray6)
                                        )
                                        .foregroundColor(
                                            day.isSameDay(as: Date.now)
                                            ? .white
                                            : .primary
                                        )
                                        .underline(day.isSameDay(as: Date.now))
                                        .clipShape(Circle())
//                                        .shadow(color: Color.accentColor.opacity(0.4), radius: 6, x: 1, y: 2)
                                }
                            } else {
                                Text("?")
                                    .frame(maxWidth: .infinity, minHeight: 40)
                                    .underline(day.isSameDay(as: Date.now))
                                    .background(Color(.systemGray6))
                                    .clipShape(Circle())
                            }
                        } else {
                            Text(day.formatted(.dateTime.day()))
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .underline(day.isSameDay(as: Date.now))
                                .clipShape(Circle())
                        }
                    }
                    .font(shouldBeCompact ? .subheadline : .body)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        EntriesCalendarView()
            .navigationTitle("Activitate")
            .navigationBarTitleDisplayMode(.inline)
    }
    .modelContainer(previewContainer)
    .navigationViewStyle(.stack)
}
