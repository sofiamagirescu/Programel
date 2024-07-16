//
//  StaggeredAppearModifier.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 22.06.2024.
//

import SwiftUI

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
