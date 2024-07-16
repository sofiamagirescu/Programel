//
//  ActivitiesView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 24.02.2024.
//

import SwiftUI
import Firebase

struct ActivitiesView: View {
    @StateObject var model = ViewModel()
    
    @State private var isLoading = true
    @State private var url = URL(string: "https://www.google.com")
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 32) {
                if !isLoading {
                    WebView(url: url!)
                        .frame(height: 500)
                        .cornerRadius(16)
                } else {
                    ProgressView()
                }
                
                NavigationLink(destination:
                    JournalView()
                ) {
                    Text("Urmatorul")
                }
            }
            .padding(32)
        }
        .onAppear { model.getData() }
        .refreshable { model.getData() }
        .onChange(of: model.links) {
            DispatchQueue.main.async {
                url = URL(string: model.links[2].name)!
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    withAnimation {
                        isLoading = false
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        ActivitiesView()
    }
}
