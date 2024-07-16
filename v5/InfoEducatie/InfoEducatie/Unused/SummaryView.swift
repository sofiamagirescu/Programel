//
//  SummaryView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 11.06.2024.
//

import SwiftUI

struct SummaryView: View {
    @EnvironmentObject var openAIService: OpenAIService
    var body: some View {
        VStack {
            if openAIService.isSummaryLoading {
                ProgressView()
            }
            ScrollView {
                Text(openAIService.summaryMessage)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            openAIService.summarizeConversation()
        }
    }
}

#Preview {
    SummaryView()
        .padding()
        .environmentObject(OpenAIService())
}
