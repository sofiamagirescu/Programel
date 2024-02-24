//
//  ActivitiesView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 24.02.2024.
//

import SwiftUI
import Firebase

struct ActivitiesView: View {
    @ObservedObject var model = ViewModel()
    
    var body: some View {
        NavigationView {
            List(model.links) { item in
                NavigationLink(destination: 
                                WebView(url: URL(string: item.name)!)
                        .edgesIgnoringSafeArea(.bottom)
                ) {
                    Text(item.name)
                        .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Link-uri")
            .refreshable { model.getData() }
        }
    }
    
    init() {
        model.getData()
    }
}

#Preview {
    ActivitiesView()
}
