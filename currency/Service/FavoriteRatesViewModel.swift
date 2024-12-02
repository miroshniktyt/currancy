//
//  FavoriteRatesViewModel.swift
//  currency
//
//  Created by pc on 02.12.24.
//

import Foundation
import Combine

class FavoriteRatesViewModel: ObservableObject {
    @Published private(set) var favoritePairs: [FavoriteCurrencyPair] = []
    private let favoritesStorage: FavoritesStorage
    private var cancellables = Set<AnyCancellable>()
    
    init(favoritesStorage: FavoritesStorage) {
        self.favoritesStorage = favoritesStorage
        setupBindings()
    }
    
    private func setupBindings() {
        favoritesStorage.favorites
            .receive(on: DispatchQueue.main)
            .sink { [weak self] favorites in
                self?.favoritePairs = Array(favorites).sorted { $0.baseCurrency < $1.baseCurrency }
            }
            .store(in: &cancellables)
    }
    
    func removeFavorite(_ pair: FavoriteCurrencyPair) {
        favoritesStorage.toggleFavorite(base: pair.baseCurrency, target: pair.targetCurrency)
    }
}
