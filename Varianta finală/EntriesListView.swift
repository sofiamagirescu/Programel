//
//  EntriesListView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 01.07.2024.
//

import SwiftData
import SwiftUI

struct EntriesListView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query(sort: \JournalEntry.date) var entries: [JournalEntry]
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 24) {
                Text("Count: \(entries.count)")
                    .foregroundColor(.secondary)
                
                Button(action: {
                    JournalEntry.addEntry(
                        modelContext: modelContext,
                        summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Egestas dui id ornare arcu odio ut sem nulla. Turpis tincidunt id aliquet risus feugiat in ante. Amet luctus venenatis lectus magna fringilla. Convallis convallis tellus id interdum velit laoreet id. \(entries.count)",
                        date: Calendar.current.date(byAdding: .day, value: -20, to: Date())!,
                        emotions: [EmotionsData().emotions[3], EmotionsData().emotions[5]],
                        causes: [Cause(name: "Cauza 1"), Cause(name: "Cauza 2")],
                        selectedTips: ["Categoria 1": Tip.sampleTips[0], "Categoria 2": Tip.sampleTips[1]], 
                        lesson: Lesson(),
                        challenge: Challenge()
                    )
                }) {
                    HStack {
                        Spacer()
                        Text("Add")
                        Spacer()
                    }
                    .font(.headline)
                    .padding(6)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal, 32)
                .padding(.top, -8)
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        ForEach(entries) { entry in
                            HStack(spacing: -20) {
                                Button(action: {
                                    modelContext.delete(entry)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.white)
                                        .padding(12)
                                        .background(Color.red)
                                        .clipShape(Circle())
                                }
                                .zIndex(1)
                                
                                NavigationLink(destination: EntryView(entry: entry)) {
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Text("\(entry.date.formatted(date: .numeric, time: .omitted))")
                                            Text("\(entry.id)")
                                                .font(.title3)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.primary)
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal, 26)
                                    .frame(height: 120)
                                    .background(Color(.systemBackground))
                                    .cornerRadius(12)
                                    .shadow(color: .purple.opacity(0.02), radius: 12, x: 2, y: 6)
                                    .shadow(color: .blue.opacity(0.04), radius: 12, x: 0, y: 0)
                                    .shadow(color: .primary.opacity(0.05), radius: 16, x: 2, y: 6)
                                }
                                .zIndex(0)
                            }
                            .id(entry.date.formatted(date: .numeric, time: .omitted))
                        }
                    }
                    .frame(maxWidth:  MaxWidths().maxStandardWidth)
                    .padding(.bottom, 28)
                    .padding(.horizontal, 32)
                }
                .animation(.smooth, value: entries)
            }
            .padding(.top, 16)
        }
    }
}

#Preview {
//    NavigationView {
        EntriesListView()
//            .navigationTitle("Activitate")
//            .navigationBarTitleDisplayMode(.inline)
//    }
//    .modelContainer(previewContainer)
    .modelContainer(for: JournalEntry.self)
}
