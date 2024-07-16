//
//  TipHelpers.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 02.07.2024.
//

import Foundation

// Function to extract and parse tips
func extractTips(from input: String) -> [Tip] {
    var tips = [Tip]()
    
    // Separate the sections using @LIST@
    let sections = input.components(separatedBy: "@LIST@")
    
    // Ensure there is at least one section with list items
    if sections.count > 1 {
        let listSection = sections[1]
        
        // Regular expression to match lines with bold text
        let regex = try! NSRegularExpression(pattern: "(\\d+)\\.\\s*\\*\\*([^*]+)\\*\\*", options: [])
        let matches = regex.matches(in: listSection, options: [], range: NSRange(location: 0, length: listSection.utf16.count))
        
        var currentIndex: Int?
        var currentTitle: String?
        var previousMatchEnd = listSection.startIndex
        
        for match in matches {
            if let range = Range(match.range, in: listSection) {
                // Capture the index number and title without bold markers
                let indexString = String(listSection[Range(match.range(at: 1), in: listSection)!])
                let index = Int(indexString) ?? 0
                let title = String(listSection[Range(match.range(at: 2), in: listSection)!]).trimmingCharacters(in: .whitespacesAndNewlines)
                
                // Capture the body text before the current title
                if let currentIndex = currentIndex, let currentTitle = currentTitle {
                    let body = String(listSection[previousMatchEnd..<range.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
                    tips.append(Tip(index: currentIndex, title: currentTitle, body: body))
                }
                
                // Update currentIndex, currentTitle, and previousMatchEnd
                currentIndex = index
                currentTitle = title
                previousMatchEnd = range.upperBound
            }
        }
        
        // Capture the last title and body
        if let currentIndex = currentIndex, let currentTitle = currentTitle {
            let body = String(listSection[previousMatchEnd..<listSection.endIndex]).trimmingCharacters(in: .whitespacesAndNewlines)
            tips.append(Tip(index: currentIndex, title: currentTitle, body: body))
        }
    }
    
    // Remove '-' from the beginning of each body
    tips = tips.map { tip in
        var body = tip.body
        if body.hasPrefix("-") {
            body.removeFirst()
        }
        return Tip(index: tip.index, title: tip.title, body: body.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    return tips
}

func extractTitle(from text: String) -> String {
    if let titleRangeStart = text.range(of: "@TITLE@"),
       let titleRangeEnd = text.range(of: "@LIST@", range: titleRangeStart.upperBound..<text.endIndex) {
        var title = String(text[titleRangeStart.upperBound..<titleRangeEnd.lowerBound])
        title = title.replacingOccurrences(of: "***", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        return title
    }
    return ""
}

func trimExtraNewlines(from text: String) -> String {
    return text
        .components(separatedBy: .newlines)
        .filter { !$0.isEmpty }
        .joined(separator: "\n")
}
