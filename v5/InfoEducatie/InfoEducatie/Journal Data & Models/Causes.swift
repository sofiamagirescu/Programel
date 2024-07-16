//
//  Causes.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 22.06.2024.
//

import SwiftData
import Foundation

@Model
class Cause: Identifiable, Equatable {
    var id = UUID()
    let name: String
    
    init(name: String = "") {
        self.name = name
    }
    
    // Equatable conformance
    static func == (lhs: Cause, rhs: Cause) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}

let causes = [
    Cause(name: "Sănătății"),
    Cause(name: "Fitnessului"),
    Cause(name: "Self-Care-ului"),
    Cause(name: "Hobby-urilor"),
    Cause(name: "Propiei Persoane"),
    Cause(name: "Conexiunii Spirituale"),
    Cause(name: "Comunității"),
    Cause(name: "Familiei"),
    Cause(name: "Prietenilor"),
    Cause(name: "Partenerului/ei"),
    Cause(name: "Responsabilităților"),
    Cause(name: "Școlii"),
    Cause(name: "Vremii"),
    Cause(name: "Evenimentelor Actuale"),
    Cause(name: "Banilor")
]
