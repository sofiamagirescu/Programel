//
//  BackgroundView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 20.02.2024.
//

import SwiftUI

struct BackgroundView: View {
    
    @State var size: Double = 380
    @State var shrink = false
    
    var body: some View {
        ZStack {
            Color.brown
                .opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            Color.yellow
                .opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            Circle()
                .fill(
                    RadialGradient(colors: [.indigo, .blue, .cyan, .cyan, .white], center: .center, startRadius: 50, endRadius: size)
                )
                .padding(-1000)
                .blur(radius: 60)
                .opacity(0.8)
        }
        .onAppear {
            size += 1
        }
        .onChange(of: size) {
            if !shrink {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
                    size += 0.5
                }
                if size > 500 {
                    shrink = true
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
                    size -= 0.5
                }
                if size < 260 {
                    shrink = false
                }
            }
        }
    }
}

#Preview {
    BackgroundView()
}
