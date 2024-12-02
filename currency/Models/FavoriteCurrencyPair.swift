//
//  FavoriteCurrencyPair.swift
//  currency
//
//  Created by pc on 02.12.24.
//

import Foundation

struct FavoriteCurrencyPair: Codable, Equatable, Hashable {
    let baseCurrency: String
    let targetCurrency: String
    
    var id: String {
        "\(baseCurrency)-\(targetCurrency)"
    }
}
