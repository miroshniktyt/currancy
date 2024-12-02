//
//  FavoritesStorageManager.swift
//  currency
//
//  Created by pc on 02.12.24.
//

import Foundation
import Combine

protocol FavoritesStorage {
    var favorites: AnyPublisher<Set<FavoriteCurrencyPair>, Never> { get }
    func toggleFavorite(base: String, target: String)
    func isFavorite(base: String, target: String) -> Bool
}

class FavoritesStorageManager: FavoritesStorage {
    private let userDefaults: UserDefaults
    private let favoritesKey = "favoriteCurrencyPairs"
    private let favoritesSubject = CurrentValueSubject<Set<FavoriteCurrencyPair>, Never>([])
    
    var favorites: AnyPublisher<Set<FavoriteCurrencyPair>, Never> {
        favoritesSubject.eraseToAnyPublisher()
    }
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        loadFavorites()
    }
    
    private func loadFavorites() {
        let favorites = userDefaults.data(forKey: favoritesKey)
            .flatMap { try? JSONDecoder().decode(Set<FavoriteCurrencyPair>.self, from: $0) } ?? []
        favoritesSubject.send(favorites)
    }
    
    func toggleFavorite(base: String, target: String) {
        let pair = FavoriteCurrencyPair(baseCurrency: base, targetCurrency: target)
        var currentFavorites = favoritesSubject.value
        
        if currentFavorites.contains(pair) {
            currentFavorites.remove(pair)
        } else {
            currentFavorites.insert(pair)
        }
        
        if let encoded = try? JSONEncoder().encode(currentFavorites) {
            userDefaults.set(encoded, forKey: favoritesKey)
            favoritesSubject.send(currentFavorites)
        }
    }
    
    func isFavorite(base: String, target: String) -> Bool {
        let pair = FavoriteCurrencyPair(baseCurrency: base, targetCurrency: target)
        return favoritesSubject.value.contains(pair)
    }
}
