//
//  PreviewEntriesData.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 02.07.2024.
//

import SwiftData
import Foundation

let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: JournalEntry.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        Task { @MainActor in
            let context = container.mainContext
            for journalEntry in JournalEntry.sampleEntries {
                context.insert(journalEntry)
            }
        }
        return container
        
    } catch {
        fatalError("Failed to create container: \(error.localizedDescription)")
    }
}()
