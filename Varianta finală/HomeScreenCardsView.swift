//
//  HomeScreenCardsView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 25.07.2024.
//

import SwiftUI

struct HomeScreenCardsView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    let quote: Quote
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: -24) {
                
                VStack(spacing: 12) {
                    Text("„\(quote.quote)”")
                    Text(quote.person)
                        .bold()
                }
                .padding(20)
                .frame(width: UIScreen.main.bounds.width / 2)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .primary.opacity(0.12), radius: 16, x: 0, y: 4)
                .rotationEffect(.degrees(2))
//                .padding(.trailing, UIScreen.main.bounds.width / 2.32)
                .padding(.trailing, 64)
                .fixedSize(horizontal: false, vertical: true)
                .zIndex(2)
                
                ZStack {
                    Circle()
                        .foregroundColor(Color(userInfo.favoriteColor))
                        .blur(radius: 8)
                    Circle()
                        .stroke(Color(userInfo.favoriteColor), lineWidth: 2)
                        .brightness(0.32)
                        .padding(12)
                }
                .padding(26)
                .frame(width: UIScreen.main.bounds.width / 2.8)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .primary.opacity(0.12), radius: 16, x: 6, y: 4)
                .rotationEffect(.degrees(-2))
                .padding(.leading, 96)
                .fixedSize(horizontal: false, vertical: true)
                .zIndex(1)
                
            }
            
            Spacer()
        }
    }
}

#Preview {
    HomeScreenCardsView(quote: Quote(
        id: "",
        quote: "Suntem ceea ce facem în mod repetat. Prin urmare, excelența nu este o acțiune, ci un obicei.",
         person: "Aristotel"
    ))
    .environmentObject(UserInfo())
}
