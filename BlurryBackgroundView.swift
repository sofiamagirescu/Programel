//
//  BlurryBackgroundView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 16.07.2024.
//

import SwiftUI

struct BlurryBackgroundView: View {
    @Binding var colors: [Color]
    @State private var positions: [CGSize] = []
    @State private var targetPositions: [CGSize] = []

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ZStack {
                    ForEach(0..<positions.count, id: \.self) { index in
                        if !colors.isEmpty {
                            Circle()
                                .fill(colors[index % colors.count])
                                .frame(width: geometry.size.width / 1.6, height: geometry.size.height / 1.6)
                                .position(x: positions[index].width, y: positions[index].height)
                        }
                    }
                }
                .onAppear {
                    if !colors.isEmpty {
                        initializePositions(for: geometry.size)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            randomizeTargetPositions(for: geometry.size)
                            animatePositions()
                        }
                    }
                }
                .onChange(of: colors) {
                    if !colors.isEmpty {
                        updatePositions(for: geometry.size)
                        randomizeTargetPositions(for: geometry.size)
                        animatePositions()
                    } else {
                        positions = []
                        targetPositions = []
                    }
                }
            }
        }
        .saturation(4.0)
        .blur(radius: 260)
        .opacity(
            colors.count > 3 ?
            0.18
            : 1 / Double((colors.count + 1))
        )
        .edgesIgnoringSafeArea(.all)
    }

    private func initializePositions(for size: CGSize) {
        positions = Array(repeating: CGSize(width: size.width / 2, height: size.height / 2), count: colors.count * 3)
        targetPositions = Array(repeating: CGSize.zero, count: colors.count * 3)
    }

    private func updatePositions(for size: CGSize) {
        let newCount = colors.count * 3
        if positions.count != newCount {
            if positions.count > newCount {
                positions.removeLast(positions.count - newCount)
                targetPositions.removeLast(targetPositions.count - newCount)
            } else {
                positions.append(contentsOf: Array(repeating: CGSize(width: size.width / 2, height: size.height / 2), count: newCount - positions.count))
                targetPositions.append(contentsOf: Array(repeating: CGSize.zero, count: newCount - targetPositions.count))
            }
        }
    }

    private func randomizeTargetPositions(for size: CGSize) {
        targetPositions = (0..<positions.count).map { _ in
            CGSize(width: CGFloat.random(in: 0...size.width), height: CGFloat.random(in: 0...size.height))
        }
    }

    private func animatePositions() {
        if !positions.isEmpty {
            withAnimation(Animation.linear(duration: 4).repeatForever(autoreverses: true)) {
                for index in positions.indices {
                    positions[index] = targetPositions[index]
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                randomizeTargetPositions(for: UIScreen.main.bounds.size)
                animatePositions()
            }
        }
    }
}

#Preview {
//    BlurryBackgroundView(colors: [.blue, .yellow, .purple, .orange, .pink])
    BlurryBackgroundView(colors: .constant([.blue, .indigo, .cyan, .pink, .green, .green, .green]))
    
//    BlurryBackgroundView(colors: [])
}
