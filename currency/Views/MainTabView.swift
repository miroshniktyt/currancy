//
//  MainTabView.swift
//  currency
//
//  Created by pc on 02.12.24.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var favoritesStorage: FavoritesStorageManager
    
    var body: some View {
        TabView {
            FavoriteRatesView(
                viewModel: FavoriteRatesViewModel(favoritesStorage: favoritesStorage)
            )
            .tabItem {
                Label("Favorites", systemImage: "star.fill")
            }
            
            RatesView(
                viewModel: ExchangeRatesViewModel(favoritesStorage: favoritesStorage)
            )
            .tabItem {
                Label("Rates", systemImage: "chart.line.uptrend.xyaxis")
            }
        }
    }
}
