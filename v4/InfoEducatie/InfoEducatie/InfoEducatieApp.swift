//
//  InfoEducatieApp.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 14.02.2024.
//

import SwiftUI
import Firebase

@main
struct InfoEducatieApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
//            GreetingsView()
//            vcuauh()
            
            ChatView(
                chatMessages: [],
//                chatMessages: ChatMessage.sampleMessages,
                emotion: .constant(CurrentEmotion(name: "Prost", color: Color.white)),
                causes: .constant(["Identitatii", "Scolii"])
            )
            .environmentObject(OpenAIService())
            .padding(32)
            .background(Color(.systemGray5))
            
            
            
//            ActivitiesView()
        }
    }
}
