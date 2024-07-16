//
//  EntryView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 22.06.2024.
//

import SwiftData
import SwiftUI

struct EntryView: View {
    
    // ANIMATIE CARDTIPSVIEW, PAS 1
    @StateObject private var visibilityState = VisibilityState()
    
    @Bindable var entry: JournalEntry
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    // ANIMATIE CARDTIPSVIEW, PAS 2
    @State private var animateAreaAroundCardTips = false
    
    @State private var resetCardTipsAnimationOnEntryChange = false
    
    @State private var showRecommendations = true
    @State private var showQuestions = false
    @State private var showActivities = false
    
    @State private var showDeleteAlert = false
    
    var body: some View {
        GeometryReader { geometry in
            let shouldBeGrid = geometry.size.width > MaxWidths().shouldTipsBeGrid
            
            ZStack {
                RadialGradientBackgroundView(shrink: .constant(true), color: Color(entry.emotion?.color ?? ""))
                    .opacity(0.4)
                
                ScrollView {
                    HStack {
                        Spacer(minLength: 0)
                        
                        VStack(alignment: .center, spacing: 28) {
                            VStack(spacing: 24) {
                                ZStack {
                                    Circle()
                                        .foregroundColor(Color(entry.emotion?.color ?? ""))
                                        .blur(radius: 8)
                                    Circle()
                                        .stroke(Color(entry.emotion?.color ?? ""), lineWidth: 2)
                                        .brightness(0.1)
                                        .padding(16)
                                }
                                .frame(width: 128, height: 128)
                                
                                Text("Stare generala:")
                                Text(entry.emotion?.color ?? "")
                                    .font(.custom("DMSerifDisplay-Regular", size: 36))
                                    .padding(.top, -24)
                            }
                            .padding(.top, 6)
                            .padding(.bottom, -6)
                            
                            if entry.causes != [] {
                                causeGrid
                                    .frame(maxWidth: MaxWidths().maxStandardWidth)
                                    .padding(.bottom, 12)
                            }
                            
                            if entry.selectedTips != [:] {
                                VStack(spacing: 30) {
                                    
                                    Button(action: {
                                        showRecommendations.toggle()
                                        visibilityState.visibleCardID = nil
                                    }) {
                                        HStack {
                                            Text("Sfaturile lui Stevie")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .multilineTextAlignment(.leading)
                                            
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .imageScale(.large)
                                                .fontWeight(.medium)
                                                .rotationEffect(.degrees(showRecommendations ? 0 : -90))
                                        }
                                    }
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: MaxWidths().maxStandardWidth)
                                    .padding(.horizontal, 6)
                                    
                                    if showRecommendations {
                                        tipCards(shouldBeGrid: shouldBeGrid)
                                            .frame(maxWidth: shouldBeGrid ? MaxWidths().maxExpandedContentWidth : MaxWidths().maxStandardWidth - 100)
                                            .padding(.top, 6)
                                            .padding(.bottom, 16)
                                    }
                                }
                                
                                Divider()
                                    .frame(maxWidth: shouldBeGrid && showRecommendations ? MaxWidths().maxExpandedContentWidth : MaxWidths().maxStandardWidth + 100)
                                    .padding(.bottom, shouldBeGrid ? 12 : 0)
                            }
                            Text(entry.summary)
                                .frame(maxWidth: MaxWidths().maxStandardWidth + 100)
                        }
                        .padding(.horizontal, 32)
                        .padding(.vertical, 28)
                        
                        Spacer(minLength: 0)
                    }
                    .animation(.smooth, value: showRecommendations)
                    // ANIMATIE CARDTIPSVIEW, PAS 3
                    .animation(.smooth, value: animateAreaAroundCardTips)
                }
                .transaction { transaction in
                    transaction.animation = nil
                }
            }
            .toolbar {
                Menu(content: {
                    Button(action: {
                        showDeleteAlert = true
                    }) {
                        Label(
                            title: { Text("Sterge pagina") },
                            icon: { Image(systemName: "trash") }
                        )
                    }
                }) {
                    Image(systemName: "ellipsis.circle")
                }
            }
            .alert("Esti sigur?", isPresented: $showDeleteAlert) {
                Button("Sterge", role: .destructive) {
                    Task {
                        dismiss()
                        try await Task.sleep(for: .seconds(0.05))
                        withAnimation {
                            modelContext.delete(entry)
                        }
                    }
                }
                Button("Anuleaza", role: .cancel) { }
            } message: {
                Text("Stergerea acestei pagini nu poate fi anulata ulterior.")
            }
            .onChange(of: entry) {
                visibilityState.visibleCardID = nil
                resetCardTipsAnimationOnEntryChange.toggle()
            }
            .navigationTitle("\(entry.date.formatted(date: .abbreviated, time: .omitted))")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    
    var causeGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Spacer()
                Text("M-am simtit asa datorita:")
                    .font(.subheadline.smallCaps())
                Spacer()
            }
            FlowLayout(items: entry.causes.map { $0.name }, spacing: 2, content: { text in
                Text(text)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 14)
                    .background(
                        ZStack {
                            Color.black.opacity(1)
                            Color(entry.emotion?.color ?? "")
                                .opacity(0.32)
                                .saturation(2.4)
                        }
                    )
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            })
            .padding(.horizontal, -4)
        }
        .padding(.top, 22)
        .padding(.bottom, 20)
        .padding(.horizontal, 30)
        .background(
            ZStack {
                Color(.systemBackground).opacity(0.6)
                Color(entry.emotion?.color ?? "").opacity(0.04)
            }
        )
        .background(
            .regularMaterial
        )
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 12, x: 6, y: 6)
    }
    
    func tipCards(shouldBeGrid: Bool) -> some View {
        HStack {
            if !shouldBeGrid || entry.selectedTips?.keys.count == 1 {
                VStack(spacing: 42) {
                    ForEach(entry.selectedTips?.keys.sorted() ?? [], id: \.self) { title in
                        CardTipsView(
                            tips: entry.selectedTips?[title] ?? [],
                            title: title,
                            organizedSelectedTips: Binding(
                                get: { entry.selectedTips ?? [:] },
                                set: { entry.selectedTips = $0 }
                            ),
                            shouldBeGrid: shouldBeGrid,
                            visibilityState: visibilityState,
                            showIndexByPosition: true,
                            isAbleToDelete: true,
                            extraAction: {
                                animateAreaAroundCardTips.toggle()
                            },
                            resetAnimation: resetCardTipsAnimationOnEntryChange
                        )
                        // ANIMATIE CARDTIPSVIEW, PAS 4
                        .animation(.smooth, value: entry.selectedTips?[title])
                    }
                }
            } else {
                HStack {
//                    Spacer(minLength: 0)
                    
                    var iPadIsolatedTipsGrid: [String] {
                        if visibilityState.visibleCardID == nil {
                            entry.selectedTips?.keys.sorted() ?? []
                        } else {
//                            (findDictionaryWithTip(using: visibilityState.visibleCardID ?? UUID(), in: entry.selectedTips)?.keys.sorted())!
//                            if let selectedTips = entry.selectedTips {
//                                if let foundDictionary = findDictionaryWithTip(using: visibilityState.visibleCardID ?? UUID(), in: [selectedTips]) {
//                                    return foundDictionary.keys.sorted()
//                                }
//                            }
//                            return []
                            
                            Array(arrayLiteral:
                                (entry.selectedTips?.keys.filter {
                                    $0 == visibilityState.visibleCardID
                                } ?? []).first ?? ""
                            )
                        }
                    }
                    
//                    var iPadIsolatedTipsGrid: [String] {
//                        if visibilityState.visibleCardID == nil {
//                            return entry.selectedTips?.keys.sorted() ?? []
//                        } else {
//                            if let selectedTips = entry.selectedTips {
//                                if let foundDictionary = findDictionaryWithTip(using: visibilityState.visibleCardID!, in: [selectedTips]) {
//                                    return foundDictionary.keys.sorted()
//                                }
//                            }
//                            return []
//                        }
//                    }
                    
                    LazyVGrid(
                        columns: Array(repeating: .init(.flexible()), count: visibilityState.visibleCardID == nil ? 2 : 1),
                        alignment: .center, spacing: 28
                    ) {
                        ForEach(iPadIsolatedTipsGrid, id: \.self) { title in
                            VStack {
                                CardTipsView(
                                    tips: entry.selectedTips?[title] ?? [],
                                    title: title,
                                    organizedSelectedTips: Binding(
                                        get: { entry.selectedTips ?? [:] },
                                        set: { entry.selectedTips = $0 }
                                    ),
                                    shouldBeGrid: shouldBeGrid,
                                    visibilityState: visibilityState,
                                    animationDelay: 0.02,
                                    showIndexByPosition: true,
                                    isAbleToDelete: true,
                                    extraAction: {
                                        animateAreaAroundCardTips.toggle()
                                    },
                                    resetAnimation: resetCardTipsAnimationOnEntryChange
                                )
                                // ANIMATIE CARDTIPSVIEW, PAS 4 (iPad)
                                .animation(.smooth, value: entry.selectedTips?[title])
                                Spacer(minLength: 12)
                            }
                        }
                    }
                    .padding(.top, 12)
                    // ANIMATIE CARDTIPSVIEW, PAS 5 (doar iPad)
                    .animation(.smooth(duration: 0.52), value: visibilityState.visibleCardID)
//                    .transition(.opacity)
                    
//                    Spacer(minLength: 0)
                }
            }
        }
    }
    
    func findDictionaryWithTip(using visibleCardID: UUID, in tipsArray: [[String: [Tip]]]) -> [String: [Tip]]? {
        for dictionary in tipsArray {
            for (_, tips) in dictionary {
                if tips.contains(where: { $0.id == visibleCardID }) {
                    return dictionary
                }
            }
        }
        return nil
    }

    var gameSummary: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .bottom) {
                Color.gray
                    .frame(height: 200)
                
                LinearGradient(colors: [.black.opacity(0), .black], startPoint: .top, endPoint: .bottom)
                    .frame(height: 100)
                    .opacity(0.6)
                
                VStack(spacing: 4) {
                    Text("Numele jocului")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("pentru antrenarea atentiei")
                        .font(.subheadline.smallCaps())
                }
                .foregroundColor(.white)
                .padding(.vertical, 16)
                .padding(.horizontal, 22)
            }
            .cornerRadius(12)
            .padding(.bottom, 12)
            
            HStack(spacing: 12) {
                VStack(alignment: .trailing) {
                    Text("Scor:")
                    Text("Recordul tau:")
                }
                VStack(alignment: .leading) {
                    Text("1000")
                    Text("1000")
                }
                .bold()
            }
            .padding(.leading, -6)
        }
        .padding(20)
        .background(
            Color(.white.opacity(1))
        )
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 12, x: 6, y: 6)
    }
    
    
    
    var shadowWork: some View {
        Text("")
    }
}

#Preview {
    PreviewModel { entry in
        NavigationStack {
            EntryView(entry: entry)
        }
    }
}
