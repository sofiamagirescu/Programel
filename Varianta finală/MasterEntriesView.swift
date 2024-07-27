//
//  MasterEntriesView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 03.07.2024.
//

import SwiftUI

struct MasterEntriesView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var index = 0
    @State private var showEvolutionView = false
    
    var body: some View {
        GeometryReader { geometry in
            let isSideBar = geometry.size.width < MaxWidths().maxNavigationSideBarWidth
            
            VStack(spacing: 0) {
                Picker(selection: $index, label: Text("Priveste sub forma unui/unei...")) {
                    Text("Calendar")
                        .tag(0)
                    Text("Lista")
                        .tag(1)
//                    if !isSideBar {
//                        Text("Evolutie")
//                            .tag(2)
//                    }
                }
                .pickerStyle(PalettePickerStyle())
                .frame(maxWidth: MaxWidths().maxStandardWidth)
                .padding(.horizontal, 32)
                .padding(.bottom, 20)
//                
//                if isSideBar {
//                    Button(action: {
//                        showEvolutionView = true
//                    }) {
//                        Text("Vezi Evolutia")
//                            .font(.headline)
//                    }
//                    .padding(.horizontal, 32)
//                    .padding(.bottom, 18)
//                }
//                
                if index != 2 {
                    Divider()
                }
                
                ZStack {
                    EntriesCalendarView()
                        .opacity(index == 0 ? 1 : 0)
                    EntriesListView()
                        .opacity(index == 1 ? 1 : 0)
                    MasterEmotionChartView()
                        .padding(.top, -6)
                        .opacity(index == 2 ? 1 : 0)
                }
                .animation(.smooth(duration: 0.12), value: index)
            }
            .sheet(isPresented: $showEvolutionView) {
                MasterEmotionChartView()
                    .padding(.top, 20)
            }
            .toolbar {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                }
            }
            .navigationTitle("Activitate")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationSplitView {
        MasterEntriesView()
    } detail: {
//        if let entry = entries.first(where: { $0.date.isSameDay(as: .now()) }) {
//            EntryView(entry: entry)
//        } else {
        ContentUnavailableView {
            Label("Selecteaza o pagina de jurnal", systemImage: "books.vertical")
        }
        .toolbar {
            Button(action: {}) {
                Image(systemName: "xmark")
                    .font(.headline)
            }
        }
//            Text("Selecteaza o pagina de jurnal")
//        }
    }
    .modelContainer(previewContainer)
}
