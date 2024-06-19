//
//  vcuauh.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 19.02.2024.
//

import SwiftUI

struct FlowLayout<Content: View>: View {
    let items: [String]
    let spacing: CGFloat
    let content: (String) -> Content

    @State private var totalHeight
        = CGFloat.zero
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
            .frame(height: totalHeight)
        }
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        var lastElementWidth = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(self.items, id: \.self) { item in
                self.content(item)
                    .padding(.horizontal, 2)
                    .padding(.vertical, 6)
                    .alignmentGuide(.leading) { d in
                        if (abs(width - d.width) > g.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if item == self.items.last {
                            width = 0 // last item
                        } else {
                            width -= d.width + self.spacing
                        }
                        lastElementWidth = width
                        return result
                    }
                    .alignmentGuide(.top) { d in
                        let result = height
                        if item == self.items.last {
                            height = 0
                        }
                        return result
                    }
            }
        }
        .background(viewHeightReader($totalHeight))
    }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}


struct EmotionLogSection {
    var header: String
    var title: String
    var content: (String) -> AnyView
}


struct vcuauh: View {
    
    @State private var shrink = false
    @State private var visible = false
    @State private var disableButton = true
    @State private var showButtonAfterKeyboard = true
    @State private var index = 0
    
    @StateObject private var openAIService = OpenAIService()
    
    @ObservedObject private var keyboardResponder = KeyboardResponder()
    
    
    let emotions = [
        CurrentEmotion(name: "Foate prost", color: Color("Foarte Prost")),
        CurrentEmotion(name: "Prost", color: Color("Prost")),
        CurrentEmotion(name: "Bine", color: Color("Bine")),
        CurrentEmotion(name: "Fericit", color: Color("Fericit")),
        CurrentEmotion(name: "Foarte fericit", color: Color("Foarte Fericit"))
    ]
    @State var selectedEmotion = CurrentEmotion(name: "", color: .white)
    
    
    let causes = ["Sănătății", "Fitnessului", "Self-Care-ului", "Hobby-urilor", "Identității", "Conexiunii Spirituale", "Comunității", "Familiei", "Prietenilor", "Partenerului/ei", "Responsabilităților", "Școlii", "Vremii", "Evenimentelor Actuale", "Banilor"]
    @State var selectedCauses: [String] = []
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    
    var body: some View {
        
        let sections: [EmotionLogSection] = [
            EmotionLogSection(
                header: "Mai intai, o intrebare simpla:",
                title: "Cum te simti in acest moment?",
                content: { _ in
                    AnyView(
                        LogEmotionView(selectedEmotion: $selectedEmotion, emotions: emotions)
                        .padding(.top, 32)
                        .padding(.bottom, -24)
                    )
                }
            ),
            EmotionLogSection(
                header: "Alege ce crezi ca se aplica!",
                title: "Ma simt \(selectedEmotion.name.lowercased()) datorita...",
                content: { _ in
                    AnyView(
                        ScrollView(showsIndicators: false) {
                            VStack {
                                FlowLayout(items: causes, spacing: 4, content: { text in
                                    Button(action: {
                                        if selectedCauses.contains(text) {
                                            if let index = selectedCauses.firstIndex(of: text) {
                                                selectedCauses.remove(at: index)
                                            }
                                        } else {
                                            selectedCauses.append(text)
                                        }
                                    }) {
                                        Text(text)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 16)
                                            .background(selectedCauses.contains(text) ? Color.black.opacity(0.9) : Color.white.opacity(0.8))
                                            .foregroundColor(selectedCauses.contains(text) ? Color.white : Color.black)
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
                    )
                }
            ),
            EmotionLogSection(
                header: "nil",
                title: "nil",
                content: { _ in
                    AnyView(
                        ChatView(chatMessages:
                            [],
//                            ChatMessage.sampleMessages,
                            emotion: $selectedEmotion,
                            causes: $selectedCauses
                        )
                        .padding(.vertical, -32)
                        .environmentObject(openAIService)
                    )
                }
            ),
            EmotionLogSection(
                header: "nil",
                title: "nil",
                content: { _ in
                    AnyView(
                        SummaryView()
                            .environmentObject(openAIService)
                    )
                }
            )
        ]
        
        ZStack {
            JournalBackgroundView(shrink: $shrink, color: selectedEmotion.color)
                .animation(.easeInOut(duration: 1))
            
            VStack(alignment: .leading, spacing: 12) {
                
                Spacer()
                
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
                
                sections[index].content("")
                    .staggeredAppear(isVisible: visible, index: 3)
//                    .padding(.bottom, showButtonAfterKeyboard ? 0 : keyboardResponder.currentHeight - 78)
//                    .animation(.smooth)
                
                Spacer()
                
                if index != (sections.count - 1)  {
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
                    .disabled(disableButton || (selectedCauses == [] && index == 1))
//                    .staggeredAppear(isVisible: showButtonAfterKeyboard, index: showButtonAfterKeyboard ? 1 : 0, offset: 140, duration: 0.6)
                    
//                    .ignoresSafeArea(.keyboard)
//                    .animation(.easeInOut)
//                    .padding(.top, showButtonAfterKeyboard ? 0 : -100)
                    
                    .foregroundColor(.white)
                    .padding(.top, 18)
                }
            }
            .padding(32)
        }
//        .edgesIgnoringSafeArea(showButtonAfterKeyboard ? [] : .bottom)
        .navigationBarHidden(true)
        .onAppear {
            shrink = true
            visible = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                disableButton = false
            }
        }
        .onChange(of: shrink) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 2)) {
                    shrink.toggle()
                }
            }
        }
        .onChange(of: visible) {
            disableButton = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                disableButton = false
            }
        }
//        .onChange(of: keyboardResponder.isKeyboardVisible) {
//            if keyboardResponder.isKeyboardVisible == false {
//                withAnimation(.none) {
//                    showButtonAfterKeyboard = true
//                }
//            } else {
//                withAnimation {
//                    showButtonAfterKeyboard = false
//                }
//            }
//        }
    }
}

struct JournalBackgroundView: View {
    @Binding var shrink: Bool
    var color: Color
    
    @State private var hueRotationAngle: Angle = .degrees(0)
    
    var body: some View {
        ZStack {
            Color.brown
                .opacity(0.02)
                .edgesIgnoringSafeArea(.all)
            Color.black
                .opacity(0.05)
                .edgesIgnoringSafeArea(.all)
            
            Circle()
                .fill(
                    RadialGradient(colors: [
                        color.adjustedHue(by: 24),
                        color,
                        color.adjustedHue(by: -32),
                        .white
                    ], center: .center, startRadius: 50, endRadius: shrink ? 240 : 480)
                )
                .padding(-1000)
//                .padding(.top, UIScreen.main.bounds.height/2)
                .blur(radius: 60)
                .opacity(0.12)
            
                LinearGradient(colors: [Color(UIColor.systemBackground), Color(UIColor.systemBackground).opacity(0), Color(UIColor.systemBackground).opacity(0), Color(UIColor.systemBackground)], startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
        }
    }
}

extension Color {
    func adjustedHue(by degrees: Double) -> Color {
        let uiColor = UIColor(self)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        let newHue = (hue + CGFloat(degrees / 360)).truncatingRemainder(dividingBy: 1)
        return Color(hue: newHue, saturation: Double(saturation), brightness: Double(brightness), opacity: Double(alpha))
    }
}

#Preview {
    vcuauh()
}
