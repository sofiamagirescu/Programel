//
//  Emotions.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 22.06.2024.
//

import SwiftData
import SwiftUI

@Model
class CurrentEmotion: Identifiable {
    var id = UUID()
    var name: String
    var color: String
    
    init(name: String = "", color: String = "") {
        self.name = name
        self.color = color
    }
}

let emotions = [
    CurrentEmotion(name: "Foate prost", color: "Foarte Prost"),
    CurrentEmotion(name: "Prost", color: "Prost"),
    CurrentEmotion(name: "Bine", color: "Bine"),
    CurrentEmotion(name: "Fericit", color: "Fericit"),
    CurrentEmotion(name: "Foarte fericit", color: "Foarte Fericit")
]
