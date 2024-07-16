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
            ScrollView {
                HStack {
                    Spacer(minLength: 0)
                    
                    LazyVStack(spacing: 0) {
                        ForEach(entries) { entry in
                            NavigationLink(destination: EntryView(entry: entry)) {
                                HStack(alignment: .center, spacing: 32) {
                                    ZStack {
                                        Circle()
                                            .foregroundColor(Color(entry.emotion?.color ?? ""))
                                            .blur(radius: 6.4)
                                        Circle()
                                            .stroke(Color(entry.emotion?.color ?? ""), lineWidth: 2)
                                            .brightness(0.1)
                                            .padding(16)
                                    }
                                    .frame(width: 120, height: 120)
                                    
                                    HStack(spacing: 0) {
                                        Divider()
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("\(entry.date.formatted(date: .numeric, time: .omitted))")
                                                .font(.title3)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.primary)
                                            
                                            Text("Te-ai simtit \(entry.emotion?.name.lowercased() ?? "").")
                                                .foregroundColor(.secondary)
                                                .font(.subheadline)
                                                .multilineTextAlignment(.leading)
                                                .lineLimit(4)
                                        }
                                        .padding(.horizontal, 26)
                                        
                                        Spacer(minLength: 0)
                                    }
                                    .frame(height: 160)
                                    .background(Color(.systemBackground).opacity(0.99))
                                    .background(.thinMaterial)
                                    .padding(.leading, -90)
                                    .shadow(color: Color(.black).opacity(0.1), radius: 8, x: -2, y: 0)
                                }
                                .padding(.leading, 28)
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .shadow(color: .purple.opacity(0.02), radius: 12, x: 2, y: 6)
                                .shadow(color: .blue.opacity(0.04), radius: 12, x: 0, y: 0)
                                .shadow(color: .primary.opacity(0.05), radius: 16, x: 2, y: 6)
                                .padding(.top, 28)
                            }
                            .id(entry.date.formatted(date: .numeric, time: .omitted))
                        }
                    }
                    .frame(maxWidth:  MaxWidths().maxStandardWidth)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 28)
                    
                    Spacer(minLength: 0)
                }
            }
            .onAppear {
                DispatchQueue.main.async {
                    proxy.scrollTo(Date().formatted(date: .numeric, time: .omitted), anchor: .top)
                }
            }
        }
//        .toolbar {
//            Button(action: {
//                withAnimation {
//                    JournalEntry.addEntry(
//                        modelContext: modelContext,
//                        summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Egestas dui id ornare arcu odio ut sem nulla. Turpis tincidunt id aliquet risus feugiat in ante. Amet luctus venenatis lectus magna fringilla. Convallis convallis tellus id interdum velit laoreet id.",
//                        date: Calendar.current.date(byAdding: .month, value: -3, to: Date())!,
//                        emotion: emotions[3],
//                        causes: [Cause(name: "Cauza 1"), Cause(name: "Cauza 2")],
//                        selectedTips: ["Categoria 1": Tip.sampleTips[0], "Categoria 2": Tip.sampleTips[1]]
//                    )
//                }
//            }) {
//                Text("Add")
//            }
//        }
    }
}

#Preview {
    NavigationView {
        EntriesListView()
            .navigationTitle("Activitate")
            .navigationBarTitleDisplayMode(.inline)
    }
    .modelContainer(previewContainer)
}
