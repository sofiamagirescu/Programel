//
//  GameView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 30.04.2024.
//

import SwiftUI

struct GameView: View {
    var body: some View {
        VStack {
            Text("JOC AICI TRALALA")
            NavigationLink(destination: vcuauh()) {
                Text("Urmatorul")
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    GameView()
}
