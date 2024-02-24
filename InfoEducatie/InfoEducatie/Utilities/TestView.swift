//
//  TestView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 15.02.2024.
//

import SwiftUI

struct TestView: View {
    var text: String
    var color: Color
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Text(text)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }
            Spacer()
        }
        .background(color)
    }
}
