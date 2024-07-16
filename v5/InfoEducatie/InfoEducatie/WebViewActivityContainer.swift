//
//  WebViewActivityContainer.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 04.07.2024.
//

import SwiftUI

struct WebViewActivityContainer: View {
    var body: some View {
        VStack {
            HStack {
                Text("Scor: 15")
                Spacer()
                Divider()
                    .frame(height: 20)
                Spacer()
                Text("Scor maxim atins: 15")
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(.systemGray6))
            
            Color.white
        }
        .cornerRadius(12)
        .shadow(color: .purple.opacity(0.05), radius: 24, x: 2, y: 12)
        .shadow(color: .blue.opacity(0.1), radius: 24, x: 2, y: 12)
        .shadow(color: .primary.opacity(0.1), radius: 24, x: 2, y: 12)
    }
}

#Preview {
    ZStack {
//        Color(.systemGray6)
//            .edgesIgnoringSafeArea(.all)
        WebViewActivityContainer()
            .padding(.horizontal, 32)
            .padding(.vertical, 96)
    }
}
