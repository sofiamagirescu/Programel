//
//  SettingsView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 25.07.2024.
//

import SwiftUI

struct SettingsView: View {
    
    var showTitle: Bool = true
    @EnvironmentObject var userInfo: UserInfo
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                
                if showTitle {
                    Text("Setari")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 8)
                }
                
                HStack {
                    Image(systemName: "person.circle.fill")
                    Text("Despre tine")
                }
                .font(.subheadline.smallCaps())
                .foregroundColor(.secondary)
                .padding(.top, showTitle ? 20 : 0)
                
                TextField("Prenumele tau", text: $userInfo.userFirstName)
                    .textFieldStyle()
                
                TextField("Numele de familie", text: $userInfo.userLastName)
                    .textFieldStyle()
                
                HStack {
                    Text("Pronumele tale:")
                    Spacer()
                    Picker("Pronumele tale", selection: $userInfo.userPronouns) {
                        ForEach(PronounOptions.allCases) { option in
                            Text(option.rawValue.capitalized).tag(option)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .textFieldStyle()
                
                
                HStack {
                    Image(systemName: "paintbrush.fill")
                    Text("Alte setari")
                }
                .font(.subheadline.smallCaps())
                .foregroundColor(.secondary)
                .padding(.top, 32)
                
                ColorPicker("Culoarea preferata", selection: $userInfo.favoriteColor)
                    .underline(color: userInfo.favoriteColor)
                    .textFieldStyle()
            }
            .padding(32)
        }
        .overlay(alignment: .top) {
            if showTitle {
                Capsule()
                    .foregroundColor(Color(.systemGray3))
                    .frame(width: 36, height: 6)
                    .padding(16)
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserInfo())
}
