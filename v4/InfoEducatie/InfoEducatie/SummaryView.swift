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
            Text(openAIService.summaryMessage)
                .padding()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            openAIService.summarizeConversation()
        }
    }
}

#Preview {
    SummaryView()
        .environmentObject(OpenAIService())
}
