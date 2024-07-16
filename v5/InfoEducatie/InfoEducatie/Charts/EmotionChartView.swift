//
//  EmotionChartView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 04.07.2024.
//

import Charts
import SwiftData
import SwiftUI

struct ChartViewSection: View {
    
    @Binding var showChart: Bool
    var title: String
    var padding: CGFloat
    var content: (String) -> AnyView
    var extraContent: (String) -> AnyView
    
    var body: some View {
        VStack(alignment: .center, spacing: showChart ? 28 : 0) {
            HStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                Image(systemName: "chevron.down")
                    .imageScale(.large)
                    .fontWeight(.medium)
                    .rotationEffect(.degrees(showChart ? 0 : -90))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(.systemBackground).opacity(!showChart ? 0 : 1))
            .cornerRadius(12)
            .shadow(color: .purple.opacity(!showChart ? 0 : 0.02), radius: 12, x: 2, y: 6)
            .shadow(color: .blue.opacity(!showChart ? 0 : 0.04), radius: 12, x: 0, y: 0)
            .shadow(color: .primary.opacity(!showChart ? 0 : 0.05), radius: 16, x: 2, y: 6)
            .onTapGesture {
                showChart.toggle()
            }
            
            content("")
                .padding(.horizontal, showChart ? 0 : 20)
                .padding(.top, showChart ? 4 : 14)
                .padding(.bottom, showChart ? 0 : 24)
            
            if showChart {
                extraContent("")
            }
        }
        .background(Color(.systemBackground).cornerRadius(showChart ? 0 : 12))
        .shadow(color: .purple.opacity(showChart ? 0 : 0.01), radius: 12, x: 2, y: 6)
        .shadow(color: .blue.opacity(showChart ? 0 : 0.02), radius: 12, x: 0, y: 0)
        .shadow(color: .primary.opacity(showChart ? 0 : 0.05), radius: 16, x: 2, y: 6)
        .padding(padding)
        .foregroundColor(.primary)
        .onTapGesture {
            if !showChart {
                showChart.toggle()
            }
        }
    }
}

struct EmotionChartView: View {
    
    @Query(sort: \JournalEntry.date) var entries: [JournalEntry]
    
    @State private var showFluctuatingChart = false
    @State private var showPieChart = false
    @State private var showBarChart = false
    
    @Binding var selectedRange: Int
    
    var body: some View {
        ScrollView {
            HStack {
                Spacer(minLength: 0)
                
                VStack(spacing: 32) {
                    ChartViewSection(
                        showChart: $showFluctuatingChart,
                        title: "Starea generala de-a lungul timpului",
                        padding: 32,
                        content: { _ in
                            AnyView(
                                FluctuatingEmotionChart(
                                    showChart: $showFluctuatingChart,
                                    isWeekTheSelectedRange: selectedRange == 0
                                )
                                .animation(.smooth, value: selectedRange)
                                .frame(height: showFluctuatingChart ? 260 : 100)
                                .padding(.bottom, showFluctuatingChart ? 16 : 0)
                            )
                        }, extraContent: { _ in
                            AnyView(
                                EmptyView()
                            )
                        }
                    )
                    .padding(-32)
                    
                    ChartViewSection(
                        showChart: $showPieChart,
                        title: "Starea predominanta",
                        padding: 32,
                        content: { _ in
                            AnyView(
                                PieEmotionChart(
                                    showChart: $showPieChart,
                                    isWeekTheSelectedRange: selectedRange == 0
                                )
                                .animation(.smooth, value: selectedRange)
                                .frame(height: showPieChart ? 240 : 160)
                                .padding(.bottom, showPieChart ? 16 : -18)
                                .padding(.top, showPieChart ? 0 : -6)
                            )
                        }, extraContent: { _ in
                            AnyView(
                                EmptyView()
                            )
                        }
                    )
                    .padding(-32)
                    
                    ChartViewSection(
                        showChart: $showBarChart,
                        title: "Numarul de zile bune / proaste",
                        padding: 32,
                        content: { _ in
                            AnyView(
                                ZileBuneVsProasteChartView(
                                    showChart: $showBarChart,
                                    isWeekTheSelectedRange: selectedRange == 0
                                )
                                .animation(.smooth, value: selectedRange)
                                .frame(width: showBarChart ? 260 : 200)
                                .frame(height: showBarChart ? 200 : 120)
                                .padding(.bottom, showBarChart ? 16 : 0)
                            )
                        }, extraContent: { _ in
                            AnyView(
                                EmptyView()
                            )
                        }
                    )
                    .padding(-32)
                }
                .frame(maxWidth: MaxWidths().maxStandardWidth)
                .padding(32)
                .animation(.smooth, value: showFluctuatingChart)
                .animation(.smooth, value: showPieChart)
                .animation(.smooth, value: showBarChart)
                
                Spacer(minLength: 0)
            }
        }
    }
}

struct MasterEmotionChartView: View {
    
    @State private var selectedRange = 1
    
    var body: some View {
        VStack(spacing: 0) {
            Picker(selection: $selectedRange, label: Text("Priveste sub forma unui/unei...")) {
                Text("Saptamana")
                    .tag(0)
                Text("Luna")
                    .tag(1)
            }
            .pickerStyle(PalettePickerStyle())
            .frame(maxWidth: MaxWidths().maxStandardWidth)
            .padding(.horizontal, 32)
            .padding(.bottom, 20)
            
            Divider()
            
            EmotionChartView(selectedRange: $selectedRange)
        }
    }
}

#Preview {
    NavigationView {
        MasterEmotionChartView()
            .navigationTitle("Evolutia ta in aceasta:")
            .toolbarTitleDisplayMode(.inline)
    }
    .modelContainer(previewContainer)
}
