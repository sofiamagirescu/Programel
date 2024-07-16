//
//  LogEmotionView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 30.04.2024.
//

import SwiftData
import SwiftUI

struct LogEmotionView: View {
    @State private var index: Double = 1
    var parteIntreagaIndex: Double {
        index - floor(index)
    }
    @Binding var selectedEmotion: CurrentEmotion
    var emotions: [CurrentEmotion]
    
    @Binding var geometryHeight: CGFloat
    
    var body: some View {
        let isTooShort = geometryHeight < 720
        
        VStack(spacing: isTooShort ? 20 : 42) {
            ZStack {
                ZStack {
                    Circle()
                        .foregroundColor(Color(emotions[Int(index)].color))
                    
                    Circle()
                        .foregroundColor(Color(emotions[Int(index - 1)].color))
                        .opacity(parteIntreagaIndex < 0.5 ?
                                 (0.5 - parteIntreagaIndex) : 0
                        )
                    
                    if Int(index) != emotions.count - 1 {
                        Circle()
                            .foregroundColor(Color(emotions[Int(index + 1)].color))
                            .opacity(parteIntreagaIndex > 0.5 ?
                                     (parteIntreagaIndex - 0.5) : 0
                            )
                    }
                }
                .blur(radius: 16)
//                .shadow(color: Color.black.opacity(0.6), radius: 12, x: 12, y: 2)
//                .padding(.bottom, 4)
//                .padding(.trailing, 14)
//                .rotationEffect(.degrees(200 - (Double(360 / emotions.count) * index)))
                
                Circle()
                    .stroke(Color(emotions[Int(index)].color), lineWidth: 2)
                    .brightness(0.1)
                    .padding(isTooShort ? 24 : 32)
            }
            .frame(maxWidth: 320, maxHeight: 320)
            .padding(.top, isTooShort ? -24 : 0)
            
            Text(emotions[Int(index)].name)
                .font(.title)
                .fontWeight(.semibold)
            
            Slider(
                value: $index,
                in: 0.1...Double(Double(emotions.count) - 0.1)
            )
            .tint(Color(emotions[Int(index)].color))
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

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    LogEmotionView(selectedEmotion: .constant(emotions[2]), emotions: emotions, geometryHeight: .constant(800))
        .padding(60)
        .previewLayout(.sizeThatFits)
}
