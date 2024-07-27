//
//  TabBarButton.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 25.07.2024.
//

import SwiftUI

struct TabBarButton: View {
    
    @EnvironmentObject var userInfo: UserInfo
    
    let index: Int
    let name: String
    let imageName: String
    var action: (() -> Void)
    
    @Binding var selectedIndex: Int
    
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                Text(name)
                    .font(.caption)
            }
            .padding(.horizontal, selectedIndex == index ? 14 : 0)
            .padding(.vertical, selectedIndex == index ? 8 : 0)
            .padding(.bottom, -2)
        }
        .foregroundColor(selectedIndex == index ? .white : .secondary)
        .background(selectedIndex == index ? Color(userInfo.favoriteColor) : Color.clear)
        .cornerRadius(6)
        .shadow(color: userInfo.favoriteColor.opacity(selectedIndex == index ? 0.12 : 0), radius: 4, x: 2, y: 1)
        .shadow(color: userInfo.favoriteColor.opacity(selectedIndex == index ? 0.36 : 0), radius: 8, x: 2, y: 1)
        .padding(.horizontal, selectedIndex == index ? -6 : 0)
    }
}
