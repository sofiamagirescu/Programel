//
//  ChatMessageStyle.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 12.07.2024.
//

import SwiftUI

struct ChatMessageStyle: ViewModifier {
    var accentColor: Color
    var isUser: Bool

    func body(content: Content) -> some View {
        content
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .foregroundColor(isUser ? .white : .primary)
            .background(
                isUser ?
                AnyView(
                    ZStack {
                        Color.black.opacity(1)
                        Color(accentColor)
                            .opacity(0.72)
                            .saturation(2.4)
                    }
                )
                : AnyView(Color(.systemBackground))
            )
            .cornerRadius(12)
            .frame(maxWidth: MaxWidths().maxChatMessageWidth, alignment: isUser ? .trailing : .leading)
    }
}

extension View {
    func chatMessageStyle(accentColor: Color, isUser: Bool) -> some View {
        self.modifier(ChatMessageStyle(accentColor: accentColor, isUser: isUser))
    }
}
