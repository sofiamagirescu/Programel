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
    @State private var disableButton = true
    @State private var showButtonAfterKeyboard = true
    @State private var index = 0
    
    @StateObject private var openAIService = OpenAIService()
    
    @State private var selectedEmotion = CurrentEmotion(name: "", color: "")
    @State private var selectedCauses: [Cause] = []
    @State private var organizedSelectedTips: [String: [Tip]] = [:]
    
    @State private var selectedDate = Date.now
    
    @State private var geometryHeight: CGFloat = 800
    
    var body: some View {
        
        let sections: [JournalViewSection] = [
            JournalViewSection(
                header: "Mai intai, o intrebare simpla:",
                title: "Cum te simti in acest moment?",
                content: { _ in
                    AnyView(
                        LogEmotionView(selectedEmotion: $selectedEmotion, emotions: emotions, geometryHeight: $geometryHeight)
                            .padding(.top, 32)
                            .padding(.bottom, -24)
                            .frame(maxWidth: MaxWidths().maxStandardWidth)
                    )
                }
            ),
            JournalViewSection(
                header: "Alege ce crezi ca se aplica!",
                title: "Ma simt \(selectedEmotion.name.lowercased()) datorita...",
                content: { _ in
                    AnyView(
                        ScrollView(showsIndicators: false) {
                            VStack {
                                FlowLayout(items: causes.map { $0.name }, spacing: 4, content: { text in
                                    Button(action: {
                                        if let index = selectedCauses.firstIndex(where: { $0.name == text }) {
                                            selectedCauses.remove(at: index)
                                        } else {
                                            selectedCauses.append(Cause(name: text))
                                        }
                                    }) {
                                        Text(text)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 16)
                                            .background(selectedCauses.contains(where: { $0.name == text }) ? Color.black.opacity(0.9) : Color.white.opacity(1))
                                            .foregroundColor(selectedCauses.contains(where: { $0.name == text }) ? Color.white : Color.black)
                                            .clipShape(Capsule())
                                    }
                                })
                            }
                        }
                        .mask(
                            VStack(spacing: 0) {
                                LinearGradient(colors: [.red.opacity(0), .red], startPoint: .top, endPoint: .bottom).frame(height: 6)
                                Color.red
                                LinearGradient(colors: [.red.opacity(0), .red], startPoint: .bottom, endPoint: .top).frame(height: 6)
                            }
                        )
                        .scrollBounceBehavior(.basedOnSize)
                        .frame(maxHeight: 400)
                        .frame(maxWidth: MaxWidths().maxStandardWidth - 100)
                    )
                }
            ),
            JournalViewSection(
                header: "nil",
                title: "nil",
                content: { _ in
                    AnyView(
                        ChatView(chatMessages:
                            [],
//                            ChatMessage.sampleMessages,
//                            emotion: $selectedEmotion,
//                            causes: $selectedCauses,
                            organizedSelectedTips: $organizedSelectedTips
                        )
                        .padding(.vertical, -32)
                        .environmentObject(openAIService)
                    )
                }
            )
        ]
        
        
        
        
        
        
        
        
        GeometryReader { geometry in
            ZStack {
                RadialGradientBackgroundView(shrink: .constant(true), color: Color(selectedEmotion.color))
                    .animation(.easeInOut, value: 1)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation {
                                geometryHeight = geometry.size.height
                            }
                        }
                    }
                
                VStack(alignment: .center, spacing: 12) {
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        if sections[index].header != "nil" {
                            Text(sections[index].header)
                                .staggeredAppear(isVisible: visible, index: 1)
                            
                            Text(sections[index].title)
                                .font(.custom("DMSerifDisplay-Regular", size: 36))
                                .staggeredAppear(isVisible: visible, index: 2)
                            
                            Divider()
                                .padding(.vertical, 20)
                                .staggeredAppear(isVisible: visible, index: 2)
                        }
                    }
                    .frame(maxWidth: MaxWidths().maxStandardWidth)
                    
                    sections[index].content("")
                        .staggeredAppear(isVisible: visible, index: 3)
                        .frame(maxWidth: MaxWidths().maxExpandedContentWidth)
                    
                    Spacer()
                    
                    ZStack {
                        if index != (sections.count - 1) {
                            Button(action: {
                                visible = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    index += 1
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                                    withAnimation {
                                        visible = true
                                    }
                                }
                            }) {
                                HStack {
                                    Spacer()
                                    Text("Urmatorul")
                                        .font(.headline)
                                    Spacer()
                                }
                            }
                            .padding(.vertical, 16)
                            .background(
                                ZStack {
                                    Color.black.opacity(1)
                                    Color(selectedEmotion.color)
                                        .opacity(0.72)
                                        .saturation(2.4)
                                }
                            )
                            .cornerRadius(8)
                            .disabled(disableButton || (selectedCauses.isEmpty && index == 1))
                            .foregroundColor(.white)
                        } else {
                            
                            VStack(spacing: 16) {
                                
//                                DatePicker("Selecteaza data", selection: $selectedDate)
                                
                                // SE VERIFICA DACA INDEXUL ESTE EGAL CU NUMARUL DE ZILE DIN TRASEU
                                // DACA DA, ATUNCI UTILIZATORUL VA FI CONDUS SPRE UN VIEW CU FELICITARI SI METODE DE A VIZUALIZA EVOLUTIA, APOI SE VA AUTOEVALUA - SELECTAND IN CE ZONE CREDE CA SE MAI POATE DEZVOLTA - SI SE VA RULA DIN NOU ALGORITMUL DE SELECTARE A TRASEULUI, LUAND IN CALCUL RASPUNSURILE LUI
                                Button(action: {
                                    openAIService.summarizeConversation()
                                    
                                    // PENTRU A TESTA:
                                    //                                JournalEntry.addEntry(
                                    //                                    modelContext: modelContext,
                                    //                                    summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Egestas dui id ornare arcu odio ut sem nulla. Turpis tincidunt id aliquet risus feugiat in ante. Amet luctus venenatis lectus magna fringilla. Convallis convallis tellus id interdum velit laoreet id.",
                                    //                                    date: selectedDate,
                                    //                                    emotion: selectedEmotion,
                                    //                                    causes: selectedCauses,
                                    //                                    selectedTips: ["Categoria 1": Tip.sampleTips[0], "Categoria 2": Tip.sampleTips[1]]
                                    //                                )
                                    //
                                    //                                dismiss()
                                    
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
                                //                            .disabled(openAIService.isSummaryLoading || openAIService.isLoading || openAIService.isInitialLoading)
                                .foregroundColor(Color(selectedEmotion.color))
                                .staggeredAppear(isVisible: index == (sections.count - 1), index: 1)
                            }
                        }
                    }
                    .frame(maxWidth: MaxWidths().maxStandardWidth)
                    .padding(.top, 18)
                    .animation(.smooth, value: index)
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 28)
            }
            .navigationBarHidden(true)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    visible = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    disableButton = false
                }
            }
            .onChange(of: visible) {
                disableButton = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                    disableButton = false
                }
            }
            .onChange(of: openAIService.isSummaryLoading) {
                if !openAIService.isSummaryLoading, openAIService.summaryMessage != "" {
                    
                    JournalEntry.addEntry(
                        modelContext: modelContext,
                        summary: openAIService.summaryMessage,
                        date: selectedDate,
                        emotion: selectedEmotion,
                        causes: selectedCauses,
                        selectedTips: organizedSelectedTips
                    )
                    
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    JournalView()
}
