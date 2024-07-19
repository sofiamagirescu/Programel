//
//  LogFeelingsView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 17.07.2024.
//

import SwiftUI

struct LogFeelingsView: View {
    
    @State private var colors: [Color] = []
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    let emotions: [String: Color] = [
        "Fericit": Color(hex: "F94144"),
        "Trist": Color(hex: "F3722C"),
        "Furios": Color(hex: "F8961E"),
        "Frustrat": Color(hex: "F9844A"),
        "Anxios": Color(hex: "F9C74F"),
        "Uimit": Color(hex: "90BE6D"),
        "Recunoscător": Color(hex: "43AA8B"),
        "Calm": Color(hex: "4D908E"),
        "Entuziasmat": Color(hex: "577590"),
        "Îngrijorat": Color(hex: "277DA1"),
        "Iubitor": .indigo, // System color
        "Plin de Speranță": .purple // System color
    ]
    
    var body: some View {
        ZStack {
            BlurryBackgroundView(colors: $colors)
                .animation(.smooth(duration: 1), value: colors)
                .animation(.smooth(duration: 1), value: colors.count)
                .opacity(0.4)
            ScrollView {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                    ForEach(emotions.keys.sorted(), id: \.self) { emotion in
                        Button(action: {
                            toggleColor(for: emotion)
                        }) {
                            VStack {
                                ZStack {
                                    Circle()
                                        .foregroundColor(emotions[emotion])
                                        .blur(radius: 8)
                                        .saturation(1.4)
                                    Circle()
                                        .stroke(emotions[emotion] ?? Color(.systemBackground), lineWidth: 2)
                                        .brightness(0.32)
                                        .padding(12)
                                }
                                .padding(.horizontal, 32)
                                .padding(.vertical, 42)
                                
                                Text(emotion)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.primary)
                                    .padding(.horizontal, 20)
                                Spacer(minLength: 0)
                            }
                            .padding(.vertical, 24)
                            .background(Color(.systemBackground).opacity(colors == [] ? 1 : 0.8))
                            .cornerRadius(12)
                            .shadow(color: 
                                colors == [] ?
                                Color.primary.opacity(0.03)
                                    : Color(emotions[emotion] ?? Color(.systemBackground)).opacity(0.1),
                                radius: 16
                            )
                            .overlay(
                                Group {
                                    if colors.contains(emotions[emotion] ?? Color(.systemBackground)) {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(emotions[emotion] ?? Color(.systemBackground), lineWidth: 3)
                                    } else if colors == [] {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(
                                                .gray,
                                                lineWidth: 0.2
                                            )
                                    }
                                }
                            )
                        }
                        .padding(.trailing, 12)
                    }
                }
                .animation(.smooth, value: colors == [])
                .padding([.leading, .vertical], 32)
                .padding(.trailing, 20)
            }
        }
    }
    
    private func toggleColor(for emotion: String) {
        guard let color = emotions[emotion] else { return }
        if let index = colors.firstIndex(of: color) {
            colors.remove(at: index)
        } else {
            colors.append(color)
        }
    }
}

#Preview {
    LogFeelingsView()
}
