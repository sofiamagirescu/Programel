//
//  InfoEducatieApp.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 14.02.2024.
//

import Firebase
import SwiftUI

@main
struct InfoEducatieApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                GreetingsView()
                    .environmentObject(UserInfo())
                    .environmentObject(FirebaseViewModel())
                    .environmentObject(JournalEntryViewModel())
                
//                QuizViewPreviewContainer()
            }
            
//            EntriesListView()
//            FirebaseTestList()
//            VideoCardView()
        }
//        .modelContainer(for: JournalEntry.self)
        .modelContainer(previewContainer)
    }
}
