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
                            height = 0 // last item
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
    @State private var index = 0
    
    @State var selectedState = ""
    let states = ["Fericit", "Trist", "Entuziasmat", "Stresat", "Recunoscator", "Confuz", "Calm", "Inspirat"]
    
    var body: some View {
        
        let sections: [EmotionLogSection] = [
            EmotionLogSection(
                header: "Mai intai, o intrebare simpla:",
                title: "Cum te simti in acest moment?",
                content: { _ in
                    AnyView(
                        Text("AICI VINE SLIDER-UL AAA")
                    )
                }
            ),
            EmotionLogSection(
                header: "Apoi, o intrebare si mai simpla:",
                title: "Mai precis, cum te simti?",
                content: { _ in
                    AnyView(
                        FlowLayout(items: states, spacing: 8, content: { text in
                            Button(action: {
                                selectedState = text
                            }) {
                                Text(text)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 20)
                                    .background(selectedState == text ? Color.orange : Color.white.opacity(0.6))
                                    .foregroundColor(selectedState == text ? Color.white : Color.black)
                                    .clipShape(Capsule())
                            }
                        })
                    )
                }
            ),
            EmotionLogSection(
                header: "In sfarsit, dezvolta!",
                title: "De unde vine aceasta stare?",
                content: { _ in
                    AnyView(
                        TextEditor(text: .constant("Exemplu: Ma simt bine pentru ca am mancat o prajitura CrisCakes. CrisCakes este viata mea. Sunt fericit atunci cand mananc CrisCakes si cand mananc CrisCakes doar atunci sunt fericit."))
                            .foregroundColor(.white)
                            .scrollContentBackground(.hidden)
                            .padding(18)
                            .frame(height: 320)
                            .background(.black.blendMode(.overlay))
                            .cornerRadius(8)
                            .padding(.bottom, 32)
                    )
                }
            )
        ]
        
        ZStack {
            Color.brown
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            Color.gray
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
            Circle()
                .fill(
                    RadialGradient(colors: [.indigo, .blue, .cyan, .white], center: .center, startRadius: 50, endRadius: shrink ? 200 : 480)
                )
                .padding(-400)
                .padding(.top, UIScreen.main.bounds.height/2)
                .blur(radius: 60)
                .opacity(0.12)
            
                LinearGradient(colors: [Color(UIColor.systemBackground), Color(UIColor.systemBackground), Color(UIColor.systemBackground).opacity(0), Color(UIColor.systemBackground).opacity(0), Color(UIColor.systemBackground)], startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 12) {
                
                Spacer()
                
                Text(sections[index].header)
                    .staggeredAppear(isVisible: visible, index: 1)
                
                Text(sections[index].title)
                    .foregroundColor(.black)
                    .opacity(0.9)
                    .font(.custom("DMSerifDisplay-Regular", size: 36))
                    .staggeredAppear(isVisible: visible, index: 2)
                
                Divider()
                    .padding(.vertical, 20)
                    .staggeredAppear(isVisible: visible, index: 3)
                
                sections[index].content("")
                    .staggeredAppear(isVisible: visible, index: 3)
//                FlowLayout(items: states, spacing: 8, content: { text in
//                    Button(action: {
//                        selectedState = text
//                    }) {
//                        Text(text)
//                            .padding(.vertical, 8)
//                            .padding(.horizontal, 20)
//                            .background(selectedState == text ? Color.orange : Color.white.opacity(0.6))
//                            .foregroundColor(selectedState == text ? Color.white : Color.black)
//                            .clipShape(Capsule())
//                    }
//                })
                
                Spacer()
                
//                Divider()
                Button(action: {
                    visible = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        index += 1
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                        visible = true
                    }
                }) {
                    HStack {
                        Spacer()
                        Text("Urmatorul")
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.vertical, 16)
                    .background(Color.black.opacity(0.9))
                    .cornerRadius(8)
                }
                .disabled(disableButton)
                .foregroundColor(.white)
                .padding(.top, 18)
            }
            .padding(32)
        }
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
    }
}

#Preview {
    vcuauh()
}
