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
            if let error = error {
                print("Error fetching links: \(error)")
                return
            }

            guard let snapshot = snapshot else { return }
            DispatchQueue.main.async {
                self.links = snapshot.documents.compactMap { document in
                    let id = document.documentID
                    let name = document.get("name") as? String ?? ""
                    return LinkType(id: id, name: name)
                }
            }
        }
    }
}
