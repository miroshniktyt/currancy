//
//  FavoritePairRow.swift
//  currency
//
//  Created by pc on 03.12.24.
//

import SwiftUI

struct FavoritePairRow: View {
    let pair: FavoriteRatesViewModel.FavoriteRateWithValue
    
    var body: some View {
        HStack {
            Text(pair.pair.baseCurrency)
                .font(.headline)
            Image(systemName: "arrow.right")
                .foregroundStyle(.secondary)
            Text(pair.pair.targetCurrency)
                .font(.headline)
            Spacer()
            if let rate = pair.rate {
                Text(String(format: "%.4f", rate))
                    .font(.body)
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
