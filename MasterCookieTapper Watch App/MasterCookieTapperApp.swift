//
//  MasterCookieTapperApp.swift
//  MasterCookieTapper Watch App
//
//  Created by Shicheng Huang on 2/22/25.
//

import SwiftUI
import AVFoundation

@main
struct CookieClickerApp: App {
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            print("Successfully configured audio session")
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
