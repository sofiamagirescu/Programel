//
//  HideKeyboard.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 22.06.2024.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
