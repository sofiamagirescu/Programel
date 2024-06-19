//
//  GreetingsView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 29.04.2024.
//

import SwiftUI

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct StaggeredAppearModifier: ViewModifier {
    var isVisible: Bool
    var index: Int
    var offset: CGFloat
    var duration: Double

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : offset)
            .animation(
                .easeInOut(duration: duration).delay(0.2 * Double(index)),
                value: isVisible
            )
    }
}
extension View {
    func staggeredAppear(isVisible: Bool, index: Int, offset: CGFloat = 8, duration: Double = 0.6) -> some View {
        self.modifier(StaggeredAppearModifier(isVisible: isVisible, index: index, offset: offset, duration: duration))
    }
}

struct GreetingsView: View {
    
    @State private var animate = false
    @State private var visible = false
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            Circle()
                .frame(height: UIScreen.main.bounds.width/1.24)
                .padding(.leading, animate ? -40 : 40)
                .padding(.bottom, 48)
                .foregroundColor(.red)
//                .grainyNoise()
                .opacity(0.8)
            Circle()
                .frame(height: UIScreen.main.bounds.width/1.24)
                .padding(.trailing, animate ? -40 : 40)
                .padding(.bottom, 48)
                .foregroundColor(.yellow)
//                .grainyNoise()
                .opacity(0.4)
            VisualEffectView(effect: UIBlurEffect(style: .light))
                .opacity(1)
                .frame(height: UIScreen.main.bounds.width/1.8)
            
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(Date().formatted(Date.FormatStyle().weekday(.wide)))")
                        .padding(.top, -16)
                    Text("\(Date.now.formatted(date: Date.FormatStyle.DateStyle.numeric, time: Date.FormatStyle.TimeStyle.omitted))")
                    HStack {
                        Image(systemName: "cloud.sun.fill")
                        Text("\(Date.now.formatted(date: Date.FormatStyle.DateStyle.omitted, time: Date.FormatStyle.TimeStyle.shortened))")
                    }
                    
                    Text("Bună dimineata,\nSofia!")
                        .font(.custom("DMSerifDisplay-Regular", size: 36))
                        .padding(.top, 18)
                        .staggeredAppear(isVisible: visible, index: 1)
                    
                    Text("Pregatita pentru doza zilnica de invatare? Haide sa incepem prin a-ti incalzi putin mintea...")
                        .padding(.top, 18)
                        .opacity(visible ? 1 : 0)
                        .offset(y: visible ? 0 : 12)
                        .staggeredAppear(isVisible: visible, index: 2, offset: 2)
                    
                    Spacer()
                }
                Spacer(minLength: 0)
            }
            .padding(32)
            
            VStack(spacing: 16) {
                Text("Etapa #1: BRAIN WORKOUT")
                    .font(.headline)
                NavigationLink(destination: ActivitiesView()) {
                    HStack {
                        Spacer()
                        Text("Incepe")
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.vertical, 16)
                    .background(Color.black.opacity(0.9))
                    .cornerRadius(8)
                }
            }
            .foregroundColor(.white)
            .padding([.horizontal, .bottom], 32)
            .frame(height: UIScreen.main.bounds.width/1.8)
            .staggeredAppear(isVisible: visible, index: 3)
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            withAnimation(.easeInOut(duration: 2).delay(0.2)) {
                animate = true
            }
            visible = true
        }
        .onChange(of: animate) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 3)) {
                    animate.toggle()
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        GreetingsView()
    }
}
