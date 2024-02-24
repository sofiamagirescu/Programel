//
//  InfoEducatieApp.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 14.02.2024.
//

import SwiftUI
import Firebase

//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(
//        _ application: UIApplication,
//        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
//    ) -> Bool {
//        FirebaseApp.configure()
//        return true
//    }
//}

@main
struct InfoEducatieApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ActivitiesView()
        }
    }
}
