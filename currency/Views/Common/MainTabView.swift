//
//  MainTabView.swift
//  currency
//
//  Created by pc on 02.12.24.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var favoritesStorage: FavoritesStorage
    private let ratesStore = RatesRepository()
    
    var body: some View {
        TabView {
            FavoriteRatesView(
                viewModel: FavoriteRatesViewModel(
                    ratesStore: ratesStore,
                    favoritesStorage: favoritesStorage
                )
            )
            .tabItem {
                Label("Favorites", systemImage: "star.fill")
            }
            
            ExchangeRatesView(
                viewModel: ExchangeRatesViewModel(
                    ratesStore: ratesStore,
                    favoritesStorage: favoritesStorage
                )
            )
            .tabItem {
                Label("Rates", systemImage: "chart.line.uptrend.xyaxis")
            }
        }
    }
}
