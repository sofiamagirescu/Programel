//
//  LogEmotionView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 30.04.2024.
//

import SwiftUI

struct CurrentEmotion: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
}

struct LogEmotionView: View {
    @State var index: Double = 1
    var parteIntreagaIndex: Double {
        index - floor(index)
    }
    @Binding var selectedEmotion: CurrentEmotion
    var emotions: [CurrentEmotion]
    
    var body: some View {
        VStack(spacing: 42) {
            ZStack {
                ZStack {
                    Circle()
                        .foregroundColor(emotions[Int(index)].color)
                    
                    Circle()
                        .foregroundColor(emotions[Int(index - 1)].color)
                        .opacity(parteIntreagaIndex < 0.5 ?
                                 (0.5 - parteIntreagaIndex) : 0
                        )
                    
                    if Int(index) != emotions.count - 1 {
                        Circle()
                            .foregroundColor(emotions[Int(index + 1)].color)
                            .opacity(parteIntreagaIndex > 0.5 ?
                                     (parteIntreagaIndex - 0.5) : 0
                            )
                    }
                }
                .blur(radius: 24)
                .shadow(color: Color.black.opacity(0.6), radius: 12, x: 12, y: 2)
                .padding(.bottom, 4)
                .padding(.trailing, 14)
                .rotationEffect(.degrees(200 - (Double(360 / emotions.count) * index)))
                
                Circle()
                    .stroke(emotions[Int(index)].color, lineWidth: 2)
                    .brightness(0.1)
                    .padding(24)
            }
            
            Text(emotions[Int(index)].name)
                .font(.title)
                .fontWeight(.semibold)
            
            Slider(
                value: $index,
                in: 0.1...Double(Double(emotions.count) - 0.1)
            )
            .tint(emotions[Int(index)].color)
        }
        .onAppear {
            withAnimation(.none) {
                index = Double(emotions.count / 2) + 0.5
                selectedEmotion = emotions[Int(index)]
            }
        }
        .onChange(of: index) {
            selectedEmotion = emotions[Int(index)]
        }
    }
}

//struct LogEmotionView: View {
//    @State var number = 0
//    var states: [CurrentState]
//    
//    var body: some View {
//        ScrollViewReader { value in
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack {
//                    ForEach(states) { state in
//                        VStack(spacing: 32) {
//                            Circle()
//                                .blur(radius: 20)
//                                .foregroundColor(state.color)
//                            Text(state.name)
//                                .font(.title)
//                                .fontWeight(.semibold)
//                        }
//                        .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
//                        .scrollTransition(topLeading: .interactive, bottomTrailing: .interactive, axis: .horizontal) { effect, phase in
//                            effect
//                                .scaleEffect(1 - (abs(phase.value)/2))
//                        }
////                        .padding(.horizontal, -18)
//                        .id(state.id)
//                    }
//                }
////                .padding(.horizontal, 18)
//                .scrollTargetLayout()
//            }
//            .scrollClipDisabled()
//            .contentMargins(.horizontal, 72, for: .scrollContent)
//            .scrollTargetBehavior(.viewAligned)
//            .onAppear {
//                DispatchQueue.main.async {
//                    if let middleState = states[safe: states.count / 2] {
//                        withAnimation {
//                            value.scrollTo(middleState.id, anchor: .center)
//                        }
//                    }
//                }
//            }
//        }
//    }
//}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    LogEmotionView(selectedEmotion: .constant(CurrentEmotion(name: "", color: .accentColor)), emotions: [
        CurrentEmotion(name: "Foate prost", color: .indigo),
        CurrentEmotion(name: "Prost", color: .blue),
        CurrentEmotion(name: "Bine", color: .green),
        CurrentEmotion(name: "Fericit", color: .orange),
        CurrentEmotion(name: "Foarte fericit", color: .red)
    ])
    .previewLayout(.sizeThatFits)
}
