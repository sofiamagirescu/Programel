//
//  Tip.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 01.07.2024.
//

import SwiftData
import Foundation

//@Model
class Tip: Identifiable, Equatable, Codable {
    var id = UUID()
    var index: Int
    var title: String
    var body: String
    
    init(index: Int = 1, title: String = "", body: String = "") {
        self.index = index
        self.title = title
        self.body = body
    }
    
    // Equatable conformance
    static func == (lhs: Tip, rhs: Tip) -> Bool {
        return lhs.index == rhs.index &&
               lhs.title == rhs.title &&
               lhs.body == rhs.body
    }
    
    // Codable conformance
    enum CodingKeys: String, CodingKey {
        case id, index, title, body
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        index = try container.decode(Int.self, forKey: .index)
        title = try container.decode(String.self, forKey: .title)
        body = try container.decode(String.self, forKey: .body)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(index, forKey: .index)
        try container.encode(title, forKey: .title)
        try container.encode(body, forKey: .body)
    }
}
