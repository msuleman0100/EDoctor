//
//  EDOCTORApp.swift
//  EDOCTOR
//
//  Created by Maani on 10/17/21.
//

import SwiftUI
import Firebase

// for API's call......
var serverRequest = MVP()

@main
struct EDOCTORApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            if Auth.auth().currentUser == nil {
                LoginView()
            } else {
                HomeView()
            }
        }
    }
    
    
    class AppDelegate: NSObject, UIApplicationDelegate {
      func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
      }
    }
    
}
