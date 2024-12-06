//
//  currencyApp.swift
//  currency
//
//  Created by pc on 02.12.24.
//

import SwiftUI

@main
struct currencyApp: App {
    private let favoritesStorage = DefaultsFavoritesStorage()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(favoritesStorage)
        }
    }
}
