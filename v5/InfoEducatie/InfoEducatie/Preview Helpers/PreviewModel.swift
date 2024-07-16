//
//  PreviewModel.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 03.07.2024.
//

import SwiftUI
import SwiftData

struct PreviewModel<Model: PersistentModel, Content: View>: View {
    
    var content: (Model) -> Content
    
    init(@ViewBuilder content: @escaping (Model) -> Content) {
        self.content = content
    }
    
    var body: some View {
        PreviewContentView(content: content)
            .modelContainer(previewContainer)
    }
    
    struct PreviewContentView: View {
        
        @Query private var models: [Model]
        var content: (Model) -> Content
        
        @State private var finishedWaitingToShowIssue = false
        
        var body: some View {
            if let model = models.first {
                content(model)
            } else {
                ContentUnavailableView("No data", image: "xmark.circle")
                    .opacity(finishedWaitingToShowIssue ? 1 : 0)
                    .task {
                        Task {
                            try await Task.sleep(for: .seconds(1))
                            finishedWaitingToShowIssue = true
                        }
                    }
            }
        }
    }
}
