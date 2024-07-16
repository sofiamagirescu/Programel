//
//  Link.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 24.02.2024.
//

import Foundation

class LinkType: Codable, Identifiable, Equatable {
    let id: String
    let name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    static func == (lhs: LinkType, rhs: LinkType) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
