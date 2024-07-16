//
//  GreetingsView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 29.04.2024.
//

import SwiftData
import SwiftUI

struct GreetingsView: View {
    
    @Query(sort: \JournalEntry.date) var entries: [JournalEntry]
    
    @State private var isJournalViewPresented = false
    @State private var isMasterEntriesViewPresented = false
    
    @State private var selectedTab = 0
    
    var body: some View {
        
        var headerText: String {
            if selectedTab == 1 {
                return "Activitatile\nde astazi"
            } else if selectedTab == 2 {
                return "Sfaturile lui Stevie\npentru tine"
            } else {
                return "Buna seara,\n\(UserInfo().userFirstName)!"
            }
        }

        GeometryReader { geometry in
            let shouldBeGrid = geometry.size.width > MaxWidths().shouldTipsBeGrid
            
            ZStack(alignment: .center) {
                ZStack {
                    if selectedTab == 0 {
                        VideoPlayerView(videoName: "8018599-hd_1920_1080_18fps", videoType: "mp4")
                            .saturation(0)
                            .edgesIgnoringSafeArea(.all)
//                        Color.black.opacity(0.1)
                        RadialGradientBackgroundView(shrink: .constant(false), color: Color("Foarte Prost"))
                            .blendMode(.overlay)
                            .environment(\.colorScheme, .dark)
                            .opacity(0.8)
                    }
                    RadialGradientBackgroundView(shrink: .constant(false), color: Color("Foarte Prost"))
                        .blendMode(selectedTab == 0 ? .overlay : .normal)
                        .opacity(0.4)
                }
                .animation(.smooth(duration: 0.4), value: selectedTab)
                .edgesIgnoringSafeArea(.all)
                
                
                VStack(spacing: 14) {
                    VStack(alignment: .center, spacing: 8) {
                        HStack(spacing: 20) {
                            Text("\(Date().formatted(Date.FormatStyle().weekday(.wide)))".uppercased())
                            Text("\(Date.now.formatted(date: Date.FormatStyle.DateStyle.numeric, time: Date.FormatStyle.TimeStyle.omitted))")
//                            Text("\(Date.now.formatted(date: Date.FormatStyle.DateStyle.omitted, time: Date.FormatStyle.TimeStyle.shortened))")
                        }
                        .font(.subheadline)
                        
                        Text(headerText)
                            .font(.custom("DMSerifDisplay-Regular", size: 36))
                            .multilineTextAlignment(.center)
                    }
                    .foregroundColor(selectedTab == 0 ? .white : .primary)
                    .frame(maxWidth: MaxWidths().maxStandardWidth)
                    .padding(.top, 12)
                    
                    Spacer(minLength: 0)
                    
                    TabView(selection: $selectedTab) {
                        Text("")
                            .tag(0)
                        
                        ScrollView(showsIndicators: false) {
                            ZStack {
                                Spacer().containerRelativeFrame([.horizontal, .vertical])
                                    .padding(.top, -32)
                                
                                DailyChallangeView(state: "Hiper", challangeText: "Închide ochii și concentrează-te pe inspirație și expirație timp de 2 minute.")
                                    .padding(.horizontal, 32)
                                    .padding(.top, 6)
                                    .padding(.bottom, 24)
                            }
                            .transaction { transaction in
                                transaction.animation = .default
                            }
                        }
                        .transaction { transaction in
                            transaction.animation = .none
                        }
                        .scrollBounceBehavior(.basedOnSize)
                        .tag(1)
                        
                        
                        ScrollView(showsIndicators: false) {
                            ZStack {
                                Spacer().containerRelativeFrame([.horizontal, .vertical])
                                    .padding(.top, -32)
                                
                                CardTipsView(
                                    tips: Tip.sampleTips[0],
                                    title: "Titlu 1",
                                    organizedSelectedTips: .constant(
                                        ["Titlu 1": Tip.sampleTips[0]]
                                    ),
                                    shouldBeGrid: shouldBeGrid,
                                    showIndexByPosition: true
                                )
                                .padding(.horizontal, 32)
                                .padding(.top, 6)
                                .padding(.bottom, 32)
//                                .padding(.top, 32)
                            }
                            .transaction { transaction in
                                transaction.animation = .default
                            }
                        }
                        .transaction { transaction in
                            transaction.animation = .none
                        }
                        .scrollBounceBehavior(.basedOnSize)
                        .tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .mask(
                        HStack(spacing: 0) {
                            LinearGradient(colors: [.red.opacity(0), .red], startPoint: .leading, endPoint: .trailing).frame(width: 6)
                            VStack(spacing: 0) {
                                LinearGradient(colors: [.red.opacity(0), .red], startPoint: .top, endPoint: .bottom).frame(height: 6)
                                Color.red
                                LinearGradient(colors: [.red.opacity(0), .red], startPoint: .bottom, endPoint: .top).frame(height: 6)
                            }
                            LinearGradient(colors: [.red.opacity(0), .red], startPoint: .trailing, endPoint: .leading).frame(width: 6)
                        }
                    )
                    .frame(maxWidth: MaxWidths().maxExpandedContentWidth)
                    .padding(.horizontal, -32)
                    
                    Spacer(minLength: 0)
                    
                    VStack(spacing: 24) {
                        Button(action: {
                            
                            // SE AFISEAZA DACA SIRUL DE ZILE INREGISTRATE *NU* CONTINE DATA DE ASTAZI
                            // SE ADAUGA 1 LA INDEXUL TRASEULUI
                            
                            isJournalViewPresented = true
                        }) {
                            HStack {
                                Spacer()
                                Text("Incepe Doza Zilnica")
                                    .font(.headline)
                                    .foregroundColor(selectedTab == 0 ? Color.white : Color(.systemBackground))
                                Spacer()
                            }
                            .padding(.vertical, 16)
                            .background(
                                ZStack {
                                    if selectedTab == 0 {
                                        ZStack {
                                            Color.black.opacity(1)
                                            Color("Foarte Prost")
                                                .saturation(2.4)
                                        }
                                        .blendMode(.colorDodge).opacity(1)
                                    } else {
                                        Color.primary
                                    }
                                }
                            )
                            .cornerRadius(8)
                        }
                        .fullScreenCover(
                            isPresented: $isJournalViewPresented,
                            content: {
                                NavigationStack {
                                    JournalView()
                                }
                            }
                        )
                        
                        // SE AFISEAZA DACA SIRUL DE ZILE INREGISTRATE CONTINE DATA DE ASTAZI
                        
                        Button(action: {
                            isMasterEntriesViewPresented = true
                        }) {
                            Text("Vezi activitatea din urma")
                                .font(.headline)
                                .foregroundColor(selectedTab == 0 ? .white : .accentColor)
                        }
                        .fullScreenCover(
                            isPresented: $isMasterEntriesViewPresented,
                            content: {
                                NavigationSplitView {
                                    MasterEntriesView()
                                        .navigationDestination(for: JournalEntry.self) {
                                            EntryView(entry: $0)
                                        }
                                } detail: {
//                                    ZStack {
//                                        if let entry = entries.first(where: { $0.date.isSameDay(as: .now) }) {
//                                            EntryView(entry: entry)
//                                        } else {
                                            ContentUnavailableView {
                                                Label("Selecteaza o pagina de jurnal", systemImage: "books.vertical")
                                            }
//                                        }
//                                    }
                                }
                            }
                        )
                    }
                    .frame(maxWidth: MaxWidths().maxStandardWidth)
                }
                .frame(maxHeight: 700)
                .padding(32)
                .animation(.smooth(duration: 0.2).delay(0.1), value: selectedTab)
            }
        }
    }
}

#Preview {
    NavigationStack {
        GreetingsView()
    }
    .modelContainer(previewContainer)
}
