//
//  FixerAPIResponse.swift
//  currency
//
//  Created by pc on 02.12.24.
//

import Foundation
import Combine

class ExchangeRatesViewModel: ObservableObject {
    
    enum ViewState {
        case loading
        case loaded(base: String, rates: [String: Double])
        case error(String)
    }
    
    struct RateWithFavoriteStatus {
        let currency: String
        let rate: Double
        let isFavorite: Bool
    }
    
    @Published private(set) var ratesWithStatus: [RateWithFavoriteStatus] = []
    @Published private(set) var state: ViewState = .loading
    @Published var selectedBaseCurrency: String = "EUR" {
        didSet {
            recalculateRates()
        }
    }
    
    private var rates: [String: Double] = [:]
    private var cancellables = Set<AnyCancellable>()
    private let favoritesStorage: FavoritesStorage
    
    init(favoritesStorage: FavoritesStorage = FavoritesStorageManager(userDefaults: .standard)) {
        self.favoritesStorage = favoritesStorage
        setupBindings()
    }
    
    var availableCurrencies: [String] {
        if case .loaded(_, let rates) = state {
            return Array(rates.keys).sorted()
        }
        return []
    }
    
    func fetchRates() {
        state = .loading
        
        ExchangeRateService.fetchLatestRates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                self?.rates = response.rates
                self?.selectedBaseCurrency = response.base
                self?.recalculateRates()
            }
            .store(in: &cancellables)
    }
    
    private func recalculateRates() {
        guard !rates.isEmpty else { return }
        
        guard let baseRate = rates[selectedBaseCurrency] else { return }
        
        let recalculatedRates = rates.mapValues { rate in
            rate / baseRate
        }
        
        state = .loaded(base: selectedBaseCurrency, rates: recalculatedRates)
    }
    
    private func setupBindings() {
        Publishers.CombineLatest3(
            $state,
            $selectedBaseCurrency,
            favoritesStorage.favorites
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] state, baseCurrency, favorites in
            self?.updateRatesWithStatus(state: state, baseCurrency: baseCurrency, favorites: favorites)
        }
        .store(in: &cancellables)
    }
    
    private func updateRatesWithStatus(state: ViewState, baseCurrency: String, favorites: Set<FavoriteCurrencyPair>) {
        guard case .loaded(_, let rates) = state else {
            ratesWithStatus = []
            return
        }
        
        ratesWithStatus = rates.map { currency, rate in
            RateWithFavoriteStatus(
                currency: currency,
                rate: rate,
                isFavorite: favoritesStorage.isFavorite(base: baseCurrency, target: currency)
            )
        }
        .sorted { $0.currency < $1.currency }
    }
    
    func toggleFavorite(for currency: String) {
        favoritesStorage.toggleFavorite(base: selectedBaseCurrency, target: currency)
    }
} 
