//
//  RadialBackgroundView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 22.06.2024.
//

import SwiftUI

struct RadialGradientBackgroundView: View {
    @Binding var shrink: Bool
    var color: Color
    
    @State private var hueRotationAngle: Angle = .degrees(0)
    
    var body: some View {
        ZStack {
            Color.brown
                .opacity(0.02)
                .edgesIgnoringSafeArea(.all)
            Color.black
                .opacity(0.04)
                .edgesIgnoringSafeArea(.all)
            
            Circle()
                .fill(
                    RadialGradient(colors: [
                        color.adjustedHue(by: 32),
                        color,
                        color.adjustedHue(by: -48),
                        .white
//                    ], center: .center, startRadius: 50, endRadius: shrink ? 280 : 480)
                    ], center: .center, startRadius: 50, endRadius: 400)
                )
                .saturation(1.8)
                .padding(-1000)
                .blur(radius: 60)
                .opacity(0.1)
            
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
    RadialGradientBackgroundView(shrink: .constant(false), color: Color("Foarte Prost"))
}
#Preview {
    RadialGradientBackgroundView(shrink: .constant(false), color: Color("Prost"))
}
#Preview {
    RadialGradientBackgroundView(shrink: .constant(false), color: Color("Bine"))
}
#Preview {
    RadialGradientBackgroundView(shrink: .constant(false), color: Color("Fericit"))
}
#Preview {
    RadialGradientBackgroundView(shrink: .constant(false), color: Color("Foarte Fericit"))
}

