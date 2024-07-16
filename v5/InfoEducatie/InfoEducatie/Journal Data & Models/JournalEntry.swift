//
//  JournalEntry.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 22.06.2024.
//

import SwiftData
import SwiftUI

@Model
class JournalEntry: Identifiable {
    var id = UUID()
    var summary: String
    var date: Date
    var emotion: CurrentEmotion?
    @Relationship(deleteRule: .cascade) var causes: [Cause]
    @Relationship(deleteRule: .cascade) var selectedTips: [String: [Tip]]?
    
    init(
        summary: String = "",
        date: Date = .now,
        emotion: CurrentEmotion? = nil,
        causes: [Cause] = [],
        selectedTips: [String: [Tip]]? = nil
    ) {
        self.summary = summary
        self.date = date
        self.emotion = emotion
        self.causes = causes
        self.selectedTips = selectedTips
    }
    
    static func addEntry(
        modelContext: ModelContext,
        summary: String,
        date: Date,
        emotion: CurrentEmotion,
        causes: [Cause],
        selectedTips: [String: [Tip]]
    ) {
        let newEntry = JournalEntry(
            summary: summary,
            date: date,
            causes: causes,
            selectedTips: selectedTips
        )
        modelContext.insert(newEntry)
        newEntry.emotion = emotion
    }
}
