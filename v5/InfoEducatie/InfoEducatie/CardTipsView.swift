//
//  StyleChatText.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 23.06.2024.
//

import SwiftUI

class VisibilityState: ObservableObject {
    @Published var visibleCardID: String?
}

struct CardTipsView: View {
    
    var tips: [Tip]
    var title: String
    
    @State var appearAnimation = false
    
    @State private var deleteAnimation = false
    @Binding var organizedSelectedTips: [String: [Tip]]
    
    var shouldBeGrid = false
    var visibilityState: VisibilityState?
    var animationDelay: Double = 0.0
    
    var showIndexByPosition = false
    var isAbleToDelete = false
    
    var extraAction: (() -> Void)?
    
    var resetAnimation: Bool = false
    
    var body: some View {
        VStack(spacing: 14) {
            headerView(tips: tips, title: title)
            tipsView(tips: tips, title: title)
                .animation(.smooth, value: appearAnimation)
        }
        .onAppear {
            if tips.count == 1 {
                appearAnimation = true
            }
        }
        .onChange(of: tips.count) {
            if tips.count == 1 {
                visibilityState?.visibleCardID = nil
            }
        }
        .onChange(of: resetAnimation) {
            appearAnimation = false
            if tips.count == 1 {
                appearAnimation = true
            }
        }
    }
    
    private func headerView(tips: [Tip], title: String) -> some View {
        HStack(spacing: 16) {
//            Spacer(minLength: 0)
            
            if tips.count != 1 {
                Button(action: {
                    withAnimation {
                        if appearAnimation {
                            DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
                                visibilityState?.visibleCardID = nil
                            }
                            appearAnimation = false
                        } else {
                            visibilityState?.visibleCardID = title
                            DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
                                appearAnimation = true
                            }
                        }
                    }
                    
                    (extraAction ?? {})()
                }) {
                    Image(systemName: appearAnimation ? "rectangle.compress.vertical" : "rectangle.expand.vertical")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .font(.headline)
                        .foregroundColor(.accentColor)
                        .padding(10)
                        .background(Color(.systemBackground).opacity(0.5))
                        .clipShape(Circle())
                }
            }
            
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .multilineTextAlignment(tips.count == 1 ? .center : .leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
//            Spacer(minLength: 0)
        }
        .animation(.smooth, value: appearAnimation)
        .padding(.leading, -10)
    }
    
    private func tipsView(tips: [Tip], title: String) -> some View {
        HStack {
            if !shouldBeGrid || tips.count == 1 {
                VStack(spacing: appearAnimation ? 14 : -94) {
                    ForEach(Array(tips.count < 4 ? tips.enumerated() : (appearAnimation ? tips.enumerated() : Array(tips[0...2]).enumerated())), id: \.element.id) { index, tip in
                        tipCardView(tip: tip, index: index, tipsCount: tips.count, title: title)
                    }
                }
                .padding(.horizontal, 28)
                .padding(.top, 16)
            } else {
                HStack {
                    Spacer(minLength: 0)
                    
                    LazyVGrid(
                        columns: Array(repeating: .init(.flexible()), count: appearAnimation ? 2 : 1),
                        spacing: appearAnimation ? 14 : 0
                    ) {
                        ForEach(Array(tips.count < 4 ? tips.enumerated() : (appearAnimation ? tips.enumerated() : Array(tips[0...2]).enumerated())), id: \.element.id) { index, tip in
                            tipCardView(tip: tip, index: index, tipsCount: tips.count, title: title)
                                .padding(.top, (index != 0 && !appearAnimation) ? -94 : 0)
                                .padding(.horizontal, 3)
                        }
                    }
                    .frame(maxWidth: MaxWidths().maxTipCardWidth * 2 + 14)
                    .padding(.horizontal, 28)
                    .padding(.top, 16)
                    
                    Spacer(minLength: 0)
                }
            }
        }
    }
    
    private func tipCardView(tip: Tip, index: Int, tipsCount: Int, title: String) -> some View {
        
        var everySingleSelectedTip: [Tip] {
            organizedSelectedTips.flatMap { $0.value }
        }
        var isSelected: Bool {
            everySingleSelectedTip.contains(tip)
        }
        
        return ZStack {
            let deleteAction = {
                if let tipIndex = organizedSelectedTips[title]?.firstIndex(of: tip) {
                    organizedSelectedTips[title]?.remove(at: tipIndex)
                    organizedSelectedTips[title]?.removeAll { $0 == tip }
                    
                    if organizedSelectedTips[title]?.isEmpty ?? false {
                        organizedSelectedTips.removeValue(forKey: title)
                    }
                }
                
                (extraAction ?? {})()
            }
            
            if !appearAnimation {
                if index == 0 {
                    TipView(tip: tip, listIndex: index + 1, isSelected: isSelected, shouldBeTransparentIfNotSelected: $appearAnimation, showIndexByPosition: showIndexByPosition, isAbleToDelete: false, deleteAction: { })
                } else {
                    Color(.systemBackground)
                        .cornerRadius(16)
                        .frame(height: 104)
                        .frame(maxWidth: MaxWidths().maxTipCardWidth)
                        .shadow(color: .primary.opacity(0.08), radius: 12, x: 2, y: 4)
                }
            } else {
                TipView(tip: tip, listIndex: index + 1, isSelected: isSelected, shouldBeTransparentIfNotSelected: $appearAnimation, showIndexByPosition: showIndexByPosition, isAbleToDelete: isAbleToDelete, deleteAction: {
                    withAnimation {
                        deleteAction()
                        deleteAnimation.toggle()
                    }
                })
                .animation(.smooth, value: deleteAnimation)
                .onTapGesture {
                    if !isAbleToDelete {
                        withAnimation(.bouncy(duration: 0.6)) {
                            if isSelected {
                                if let tipIndex = organizedSelectedTips[title]?.firstIndex(of: tip) {
                                    organizedSelectedTips[title]?.remove(at: tipIndex)
                                    organizedSelectedTips[title]?.removeAll { $0 == tip }
                                    
                                    if organizedSelectedTips[title]?.isEmpty ?? false {
                                        organizedSelectedTips.removeValue(forKey: title)
                                    }
                                }
                            } else {
                                if organizedSelectedTips[title] == nil {
                                    organizedSelectedTips[title] = []
                                }
                                organizedSelectedTips[title]?.append(tip)
                            }
                        }
                    }
                }
            }
        }
        .zIndex(Double(tipsCount - index))
        .rotationEffect(
            .degrees(
                Double(appearAnimation ? 0 : (index * 3 - 2))
            )
        )
        .onTapGesture {
            if !appearAnimation {
                withAnimation {
                    visibilityState?.visibleCardID = title
                }
                
                withAnimation {
                    DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
                        appearAnimation = true
                    }
                }
                
                (extraAction ?? {})()
            }
        }
    }
}

struct CardTipsViewWrapper: View {
    @State private var organizedSelectedTips: [String: [Tip]] = [:]

    var body: some View {
        ZStack {
            Color(.systemGray6)
                .edgesIgnoringSafeArea(.all)
            ScrollView(showsIndicators: false) {
                
                let text = """
                Sigur, Calin! Time management-ul este esențial pentru a-ți menține echilibrul și a te simți bine.
                Iată câteva sfaturi care ar putea să te ajute:
                @TITLE@
                ***Sfaturi pentru Time Management***
                @LIST@
                5. **Prioritizează-ți sarcinile** - Folosește matricea Eisenhower pentru a decide ce este urgent și important.
                2. **Setează obiective clare** - Definește-ți obiective specifice, măsurabile, realizabile, relevante și limitate în timp (SMART) Folosește matricea Eisenhower pentru a decide ce este urgent și important. Folosește matricea Eisenhower pentru a decide ce este urgent și important. Folosește matricea Eisenhower pentru a decide ce este urgent și important. Folosește matricea Eisenhower pentru a decide ce este urgent și important.
                1. **Folosește un calendar sau o agendă** - Planifică-ți ziua în avans și alocă timp pentru fiecare activitate.
                @LIST@
                Alte informații care nu trebuie incluse.
                """
                
                CardTipsView(
                    tips: extractTips(from: text),
                    title: extractTitle(from: text),
                    organizedSelectedTips: $organizedSelectedTips,
                    showIndexByPosition: true,
                    isAbleToDelete: true
                )
                .frame(maxWidth: MaxWidths().maxExpandedContentWidth)
                .safeAreaPadding(32)
            }
        }
    }
}


#Preview {
    CardTipsViewWrapper()
}
