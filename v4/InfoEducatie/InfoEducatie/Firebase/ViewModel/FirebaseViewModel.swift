//
//  ViewModel.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 24.02.2024.
//

import Foundation
import Firebase

// https://www.youtube.com/watch?v=xkxGoNfpLXs

class ViewModel: ObservableObject {
    @Published var links = [LinkType]()
    func getData() {
        let db = Firestore.firestore()
        db.collection("links").getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.links = snapshot.documents.map { item in
                            return LinkType(id: item.documentID, name: item["name"] as? String ?? "")
                        }
                    }
                }
            } else {
                // eroare
            }
        }
    }
}
