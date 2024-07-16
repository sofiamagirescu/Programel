//
//  AbbreviateString.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 04.07.2024.
//

import Foundation

func abbreviate(_ string: String) -> String {
    let words = string.split(separator: " ")
    let abbreviation = words.reduce("") { result, word in
        result + word.prefix(1).uppercased()
    }
    return abbreviation
}
