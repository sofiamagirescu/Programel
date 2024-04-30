//
//  HomeView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 29.04.2024.
//

import SwiftUI

struct HomeView: View {
    @State private var showView = false
    var body: some View {
        Button("Incepe", action: {
            showView = true
        })
        .fullScreenCover(isPresented: $showView) {
            NavigationView {
                GreetingsView()
            }
        }
    }
}

#Preview {
    HomeView()
}
