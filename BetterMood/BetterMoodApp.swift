//
//  BetterMoodApp.swift
//  BetterMood
//
//  Created by Yosri on 5/9/2021.
//

import SwiftUI
import Firebase

// Main Structure
@main
struct BetterMoodApp: App {
    // Firebase Init
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// Firebase AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
