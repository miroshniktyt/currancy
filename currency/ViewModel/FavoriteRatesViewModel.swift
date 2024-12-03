//
//  FavoriteRatesViewModel.swift
//  currency
//
//  Created by pc on 02.12.24.
//

import Foundation
import Combine

class FavoriteRatesViewModel: ObservableObject {
    struct FavoriteRateWithValue {
        let pair: FavoriteCurrencyPair
        let rate: Double?
    }
    
    @Published private(set) var favoriteRates: [FavoriteRateWithValue] = []
    private let favoritesStorage: FavoritesStorage
    private let ratesStore: RatesRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(
        ratesStore: RatesRepository,
        favoritesStorage: FavoritesStorage
    ) {
        self.ratesStore = ratesStore
        self.favoritesStorage = favoritesStorage
        setupBindings()
    }
    
    private func setupBindings() {
        Publishers.CombineLatest(
            favoritesStorage.favorites,
            ratesStore.$state
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] favorites, ratesState in
            self?.updateFavoriteRates(favorites: favorites, ratesState: ratesState)
        }
        .store(in: &cancellables)
    }
    
    private func updateFavoriteRates(
        favorites: Set<FavoriteCurrencyPair>,
        ratesState: RatesRepository.LoadingState
    ) {
        let rates: [String: Double]
        if case .loaded(let response) = ratesState {
            rates = response.rates
        } else {
            rates = [:]
        }
        
        favoriteRates = Array(favorites)
            .map { pair in
                let rate = rates[pair.targetCurrency].map { targetRate in
                    let baseRate = rates[pair.baseCurrency] ?? 1
                    return targetRate / baseRate
                }
                return FavoriteRateWithValue(pair: pair, rate: rate)
            }
            .sorted { $0.pair.baseCurrency < $1.pair.baseCurrency }
    }
    
    func fetchRates() {
        ratesStore.fetchRates()
    }
    
    func removeFavorite(_ pair: FavoriteCurrencyPair) {
        favoritesStorage.toggleFavorite(base: pair.baseCurrency, target: pair.targetCurrency)
    }
}
