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
            List {
                Section {
                    ForEach(model.links) { item in
                        NavigationLink(destination: WebView(url: URL(string: item.name)!)
                            .edgesIgnoringSafeArea(.bottom)
                        ) {
                            Text(item.name)
                                .listStyle(PlainListStyle())
                        }
                    }
                }
                Section {
                    NavigationLink(destination: vcuauh()) {
                        Text("Test - Mindulness")
                    }
                }
            }
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
