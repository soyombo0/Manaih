//
//  ManaihApp.swift
//  Manaih
//
//  Created by Soyombo Mantaagiin on 17.02.2023.
//

import SwiftUI
import Firebase

@main
struct ManaihApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
