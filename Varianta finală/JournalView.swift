//
//  JournalView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 19.02.2024.
//

import SwiftUI

struct JournalView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var visible = false
    @State private var disableButtonWhileAnimating = true
    var disableButton: Bool {
        disableButtonWhileAnimating ||
        (colors.isEmpty && index == 0) ||
        (selectedCauses.isEmpty && index == 1) ||
        (!canFinishQuizSection && index == 3)
    }
    
    @State private var showButtonAfterKeyboard = true
    @State private var index = 0
    
    var accentColor: Color {
        if !colors.isEmpty {
            Color.average(colors: colors)
                .darken(by: 0.5)
                .saturation(3.0)
        } else {
            Color.secondary
        }
    }
    
    @StateObject private var openAIService = OpenAIService()
    @EnvironmentObject var firebaseViewModel: FirebaseViewModel
    
    @State private var selectedEmotions: [Emotion] = []
    @State private var selectedCauses: [Cause] = []
    @State private var organizedSelectedTips: [String: [Tip]] = [:]
    
    @State private var recommendedLesson: Lesson? = nil
    @State private var recommendedChallenge: Challenge? = nil
    
//    var colors: [Color] = [.red, .indigo]
    var colors: [Color] {
        selectedEmotions.map { Color($0.colorName) }
    }
    
    @State private var geometryHeight: CGFloat = 800
    
    @State private var summaryMessage = "openAIService.summaryMessage"
    @State private var canFinishQuizSection = false
    @State private var canFinishRecommendedContentSection = false
    @State private var healthState = "optim"
    
    var body: some View {
        
        let sections: [AnyView] = [
            AnyView(
                LogFeelingsView(
                    isHeaderVisible: visible,
                    emotions: $selectedEmotions
                )
                .mask(
                    VStack(spacing: 0) {
                        LinearGradient(colors: [.red.opacity(0), .red], startPoint: .top, endPoint: .bottom).frame(height: 6)
                        Color.red
                        LinearGradient(colors: [.red.opacity(0), .red], startPoint: .bottom, endPoint: .top).frame(height: 6)
                    }
                )
                .padding([.horizontal, .top], -32)
                .padding(.bottom, -20)
                .frame(maxWidth: MaxWidths().maxStandardWidth)
            ),
            AnyView(
                LogCausesView(
                    isHeaderVisible: visible, 
                    accentColor: Color(accentColor),
                    selectedCauses: $selectedCauses
                )
//                .frame(maxHeight: 400)
                .padding(.bottom, -20)
                .frame(maxWidth: MaxWidths().maxStandardWidth - 100)
            ),
            AnyView(
                ChatView(chatMessages:
                    [],
//                    ChatMessage.sampleMessages,
                    accentColor: accentColor,
                    emotions: $selectedEmotions,
                    causes: $selectedCauses,
                    organizedSelectedTips: $organizedSelectedTips
                )
                .padding(.bottom, -22)
                .environmentObject(openAIService)
            ),
            AnyView(
                QuizView(
                    accentColor: accentColor,
                    isHeaderVisible: visible,
                    canFinish: $canFinishQuizSection,
                    healthState: $healthState
                )
                .mask(
                    VStack(spacing: 0) {
                        LinearGradient(colors: [.red.opacity(0), .red], startPoint: .top, endPoint: .bottom).frame(height: 6)
                        Color.red
                        LinearGradient(colors: [.red.opacity(0), .red], startPoint: .bottom, endPoint: .top).frame(height: 6)
                    }
                )
                .padding([.horizontal, .top], -32)
                .padding(.bottom, -20)
            ),
            
            AnyView(
                RecommendedContentView(
                    accentColor: accentColor,
                    canFinish: $canFinishRecommendedContentSection,
                    selectedEmotions: $selectedEmotions,
                    healthState: $healthState,
                    recommendedLesson: $recommendedLesson,
                    recommendedChallenge: $recommendedChallenge
                )
                .mask(
                    VStack(spacing: 0) {
                        LinearGradient(colors: [.red.opacity(0), .red], startPoint: .top, endPoint: .bottom).frame(height: 6)
                        Color.red
                        LinearGradient(colors: [.red.opacity(0), .red], startPoint: .bottom, endPoint: .top).frame(height: 6)
                    }
                )
                .padding([.horizontal, .top], -32)
                .padding(.bottom, -20)
            )
        ]
        
        
        
        
        
        
        
        
        GeometryReader { geometry in
            ZStack {
                
                Color.secondary.opacity(0.6)
                    .edgesIgnoringSafeArea(.all)
                BlurryBackgroundView(
                    colors: .constant(colors),
                    blurAmmount: 90
                )
                .animation(.smooth, value: colors)
                .opacity(index == 0 ? 0.32 : 0.1)
                
                Color(.systemBackground)
                    .opacity(0.8)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .center, spacing: 12) {
                    
                    Spacer(minLength: 0)
                    
                    sections[index]
                        .staggeredAppear(isVisible: visible, index: 0)
                        .frame(maxWidth: MaxWidths().maxExpandedContentWidth)
                    
                    Spacer(minLength: 0)
                    
                    ZStack {
                        if index != 2 {
                            Button(action: {
                                if index == (sections.count - 1) {
                                   JournalEntry.addEntry(
                                       modelContext: modelContext,
                                       summary: summaryMessage,
                                       date: Date(),
                                       emotions: selectedEmotions,
                                       causes: selectedCauses,
                                       selectedTips: organizedSelectedTips,
                                       lesson: recommendedLesson ?? Lesson(), 
                                       challenge: recommendedChallenge ?? Challenge()
                                   )
                                    
                                    DispatchQueue.main.async {
                                        dismiss()
                                    }
                                } else {
                                    visible = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        withAnimation {
                                            index += 1
                                        }
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                                        withAnimation {
                                            visible = true
                                        }
                                    }
                                }
                            }) {
                                HStack {
                                    Spacer()
                                    Text(index == sections.count - 1
                                         ? "Termina"
                                         : "Urmatorul"
                                    )
                                    .font(.headline)
                                    Spacer()
                                }
                                .foregroundColor(.white)
                                .padding(index == 2 ? 0 : 16)
                                .background(
                                    ZStack {
                                        if index == 2 {
                                            Color.clear
                                        } else {
                                            accentColor
                                        }
                                    }
                                    .animation(.smooth, value: colors)
                                )
                                .cornerRadius(8)
                            }
                            .opacity(disableButton ? 0.5 : 1)
                            .disabled(disableButton)
                            .animation(.smooth, value: disableButton)
                            
                        } else {
                            Button(action: {
//                                openAIService.summarizeConversation()
                                
                                // pentru a testa
                                visible = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation {
                                        index += 1
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                                    withAnimation {
                                        visible = true
                                    }
                                }
                                
                            }) {
                                HStack {
                                    Spacer()
                                    
                                    if openAIService.isSummaryLoading {
                                        ProgressView()
                                    } else {
                                        Text("Finalizeaza Sesiunea")
                                            .font(.headline)
                                    }
                                    
                                    Spacer()
                                }
                            }
                            .staggeredAppear(isVisible: index == 2, index: 1)
                        }
                    }
                    .frame(maxWidth: MaxWidths().maxStandardWidth)
                    .padding(.top, 18)
                    .animation(.smooth, value: index)
                }
                .padding(.horizontal, 32)
                .padding(.top, 24)
                .padding(.bottom, index == 2 ? 18 : 24)
            }
            .navigationBarHidden(true)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    visible = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    disableButtonWhileAnimating = false
                }
            }
            .onChange(of: visible) {
                disableButtonWhileAnimating = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                    disableButtonWhileAnimating = false
                }
            }
            .onChange(of: openAIService.isSummaryLoading) {
                if !openAIService.isSummaryLoading, openAIService.summaryMessage != "" {
                    
                    summaryMessage = openAIService.summaryMessage
                    
                    visible = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            index += 1
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                        withAnimation {
                            visible = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    JournalView()
        .environmentObject(FirebaseViewModel())
        .modelContainer(previewContainer)
}
