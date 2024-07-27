//
//  HomeScreenTabViews.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 25.07.2024.
//

import SwiftData
import SwiftUI

struct HomeScreenCardsTabView: View {
    
    let quote: Quote
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack {
                Spacer().containerRelativeFrame([.horizontal, .vertical])
                    .padding(.top, -12)
                
                HomeScreenCardsView(quote: quote)
                    .padding(.horizontal, 32)
                    .padding(.top, 6)
                    .padding(.bottom, 32)
            }
        }
        .scrollBounceBehavior(.basedOnSize)
    }
}

struct DailyChallangeTabView: View {
    
    @Binding var hideHeader: Bool?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack {
                Spacer().containerRelativeFrame([.horizontal, .vertical])
                    .padding(.top, -24)
                
//                DailyChallangeView(
//                    state: "Hiper",
//                    challangeText: "Ia un creion și o hârtie și desenează ceva continuu timp de 2 minute, fără să ridici creionul. Nu uita să lași deoparte telefonul!",
//                    hideHomeScreenHeader: $hideHeader
//                )
//                .padding(.horizontal, 32)
//                .padding(.top, 6)
//                .padding(.bottom, 32)
            }
//            .transaction { transaction in
//                transaction.animation = .default
//            }
        }
//        .transaction { transaction in
//            transaction.animation = .none
//        }
        .scrollBounceBehavior(.basedOnSize)
    }
}

struct CardTipsTabView: View {
    
    @Query(sort: \JournalEntry.date) var entries: [JournalEntry]
    @State private var randomKey: String = ""
    @State private var randomTips: [Tip] = []
    
    var shouldBeGrid: Bool
    @Binding var hideHeader: Bool?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack {
                Spacer().containerRelativeFrame([.horizontal, .vertical])
                    .padding(.top, -24)
                
                if !randomTips.isEmpty {
                    CardTipsView(
                        tips: randomTips,
                        title: randomKey,
                        organizedSelectedTips: .constant(
                            [randomKey: randomTips]
                        ),
                        shouldBeGrid: shouldBeGrid,
                        showIndexByPosition: true,
                        hideHomeScreenHeader: $hideHeader
                    )
                    .padding(.horizontal, 32)
                    .padding(.top, 6)
                    .padding(.bottom, 32)
                } else {
                    Text("Cere-i lui Stivie sfaturi data viitoare")
                        .padding()
                }
                //                                .padding(.top, 32)
            }
//            .transaction { transaction in
//                transaction.animation = .default
//            }
        }
//        .transaction { transaction in
//            transaction.animation = .none
//        }
        .onAppear {
            self.pickRandomTips(from: entries)
        }
        .scrollBounceBehavior(.basedOnSize)
    }
    
    private func pickRandomTips(from entries: [JournalEntry]) {
        let latestEntries = Array(entries.prefix(3))
        var allSelectedTips: [String: [Tip]] = [:]

        for entry in latestEntries {
            if let selectedTips = entry.selectedTips {
                for (key, tips) in selectedTips {
                    allSelectedTips[key] = tips
                }
            }
        }

        if let (key, tips) = allSelectedTips.randomElement() {
            self.randomKey = key
            self.randomTips = tips
        }
    }
}
