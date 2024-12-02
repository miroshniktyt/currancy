//
//  FavoriteRatesView.swift
//  currency
//
//  Created by pc on 02.12.24.
//

import Foundation
import SwiftUI

struct FavoriteRatesView: View {
    @StateObject var viewModel: FavoriteRatesViewModel
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.favoritePairs.isEmpty {
                    VStack {
                        Text("No Favorites Yet")
                        Text("Your favorite currency pairs will appear here when you add some in Rates tab :)")
                    }
                } else {
                    List {
                        ForEach(viewModel.favoritePairs, id: \.id) { pair in
                            FavoritePairRow(pair: pair)
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                viewModel.removeFavorite(viewModel.favoritePairs[index])
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

private struct FavoritePairRow: View {
    let pair: FavoriteCurrencyPair
    
    var body: some View {
        HStack {
            Text(pair.baseCurrency)
                .font(.headline)
            Image(systemName: "arrow.right")
                .foregroundStyle(.secondary)
            Text(pair.targetCurrency)
                .font(.headline)
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
