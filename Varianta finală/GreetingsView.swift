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
    
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var firebaseViewModel: FirebaseViewModel
    
    @State private var areSettingsPresented = false
    @State private var isJournalViewPresented = false
    @State private var isMasterEntriesViewPresented = false
    
    var showDailyDoseButton: Bool {
//        entries.contains { $0.date == .now }
        true
    }
    
    @State private var selectedTab = 0
    @State private var hideHeader: Bool? = false
    
    @State private var shouldBeGrid = false
    
    @State private var homeView = HomeScreenCardsTabView(quote: Quote(id: "", quote: "Stivie pregateste totul pentru tine...", person: "STIMIA"))
    @State private var challangeView = DailyChallangeTabView(hideHeader: .constant(false))
    @State private var tipsView = CardTipsTabView(shouldBeGrid: false, hideHeader: .constant(false))
    
    var body: some View {
        
        var headerText: String {
            switch selectedTab {
            case 1:
                return "Activitatea\nde astăzi"
            case 2:
                return "Sfaturile lui Stevie\npentru tine"
            default:
                return "Ce mai faci,\n\(userInfo.userFirstName)?"
            }
        }

        GeometryReader { geometry in
            
            ZStack(alignment: .center) {
                Color.secondary.opacity(0.12)
                    .edgesIgnoringSafeArea(.all)
                RadialGradientBackgroundView(shrink: .constant(false), color: userInfo.favoriteColor)
                    .opacity(selectedTab == 0 ? 0.8 : 0.2)
                    .animation(.smooth(duration: 0.4), value: selectedTab)
                    .edgesIgnoringSafeArea(.all)
                
                
                VStack(spacing: 16) {
                    
                    
                    VStack(alignment: .center, spacing: 8) {
                        HStack(spacing: 20) {
                            Button(action: {
                                areSettingsPresented = true
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "gear")
                                    Text("Setari")
                                }
                            }
                            Text("\(Date.now.formatted(date: Date.FormatStyle.DateStyle.numeric, time: Date.FormatStyle.TimeStyle.omitted))")
//                            Text("\(Date.now.formatted(date: Date.FormatStyle.DateStyle.omitted, time: Date.FormatStyle.TimeStyle.shortened))")
                        }
                        .textCase(.uppercase)
                        .font(.subheadline)
                        
                        Text(headerText)
                            .font(.custom("DMSerifDisplay-Regular", size: 36))
                            .multilineTextAlignment(.center)
                    }
                    //                    .foregroundColor(selectedTab == 0 ? .white : .primary)
                    .foregroundColor(.primary)
                    .frame(maxWidth: MaxWidths().maxStandardWidth)
//                        .padding(.top, 12)
                    .padding(.bottom, (hideHeader ?? false) ? -1000 : 0)
                    .opacity((hideHeader ?? false) ? 0 : 1)
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
//                    TabView(selection: $selectedTab) {
                    VStack {
                        switch selectedTab {
                        case 0:
                            homeView
                        case 1:
                            challangeView
                        case 2:
                            tipsView
                        default:
                            homeView
                        }
                    }
//                    .tabViewStyle(.page(indexDisplayMode: .never))
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
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    VStack(spacing: 16) {
                        
                        if showDailyDoseButton {
                            Button(action: {
                                isJournalViewPresented = true
                            }) {
                                HStack {
                                    Spacer()
                                    Text("Începe Doza Zilnică")
                                        .font(.headline)
                                        .foregroundColor(Color(.systemBackground))
                                    Spacer()
                                }
                                .padding(.vertical, 16)
                                .background(
                                    ZStack {
                                        Color.primary
                                    }
                                )
                                .cornerRadius(8)
                            }
                        }
                        
                        if !(hideHeader ?? false) {
                            HStack {
                                TabBarButton(
                                    index: 0,
                                    name: "Acasa",
                                    imageName: "house",
                                    action: {
                                        withAnimation {
                                            selectedTab = 0
                                        }
                                    },
                                    selectedIndex: $selectedTab
                                )
                                
//                                Spacer()
//                                
//                                TabBarButton(
//                                    index: 1,
//                                    name: "Provocare",
//                                    imageName: "wand.and.stars",
//                                    action: {
//                                        withAnimation {
//                                            selectedTab = 1
//                                        }
//                                    },
//                                    selectedIndex: $selectedTab
//                                )
                                
                                Spacer()
                                
                                TabBarButton(
                                    index: 2,
                                    name: "Sfaturi",
                                    imageName: "list.clipboard",
                                    action: {
                                        withAnimation {
                                            selectedTab = 2
                                        }
                                    },
                                    selectedIndex: $selectedTab
                                )
                                
                                Spacer()
                                
                                TabBarButton(
                                    index: 3,
                                    name: "Activitate",
                                    imageName: "calendar",
                                    action: {
                                        isMasterEntriesViewPresented = true
                                    },
                                    selectedIndex: $selectedTab
                                )
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 6)
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(color: .primary.opacity(0.08), radius: 12, x: 6, y: 2)
                            .shadow(color: userInfo.favoriteColor.opacity(0.04), radius: 12, x: 6, y: 2)
                        }
                    }
                    .frame(maxWidth: MaxWidths().maxStandardWidth)
                }
                .frame(maxHeight: 700)
                .padding([.horizontal, .top], 32)
                .padding(.top, hideHeader ?? false ? -32 : 0)
                .padding(.top, hideHeader ?? false && !showDailyDoseButton ? -32 : 0)
                .padding(.bottom, hideHeader ?? false && !showDailyDoseButton ? -64 : 0)
                .padding(.bottom, 16)
                .animation(.smooth(duration: 0.2).delay(0.1), value: selectedTab)
            }
            .onAppear {
                shouldBeGrid = geometry.size.width > MaxWidths().shouldTipsBeGrid
                
                challangeView = DailyChallangeTabView(hideHeader: $hideHeader)
                tipsView = CardTipsTabView(shouldBeGrid: shouldBeGrid, hideHeader: $hideHeader)
            }
            .onChange(of: firebaseViewModel.quotes) {
                if !firebaseViewModel.quotes.isEmpty {
                    withAnimation {
                        homeView = HomeScreenCardsTabView(
                            quote: firebaseViewModel.quotes.shuffled().first ??
                            Quote(
                                id: "",
                                quote: "Suntem ceea ce facem în mod repetat. Prin urmare, excelența nu este o acțiune, ci un obicei.",
                                person: "Aristotel"
                            )
                        )
                    }
                }
            }
            
            .sheet(
                isPresented: $areSettingsPresented,
                content: {
                    SettingsView()
                }
            )
            
            .fullScreenCover(
                isPresented: $isJournalViewPresented,
                content: {
                    NavigationStack {
                        JournalView()
                    }
                }
            )
            
            .fullScreenCover(
                isPresented: $isMasterEntriesViewPresented,
                content: {
                    NavigationSplitView {
                        MasterEntriesView()
                            .navigationDestination(for: JournalEntry.self) {
                                EntryView(entry: $0)
                            }
                    } detail: {
                        ContentUnavailableView {
                            Label("Selecteaza o pagina de jurnal", systemImage: "books.vertical")
                        }
                    }
                }
            )
        }
    }
}

#Preview {
    NavigationStack {
        GreetingsView()
    }
    .environmentObject(UserInfo(inMemoryOnly: false))
    .environmentObject(FirebaseViewModel())
    .modelContainer(previewContainer)
}
