//
//  JournalViewSections.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 22.06.2024.
//

import SwiftUI

struct JournalViewSection {
    var header: String
    var title: String
    var content: (String) -> AnyView
}
