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
                if viewModel.favoriteRates.isEmpty {
                    VStack {
                        Text("No Favorites Yet")
                        Text("Your favorite currency pairs will appear here when you add some in Rates tab :)")
                    }
                } else {
                    List {
                        ForEach(viewModel.favoriteRates, id: \.pair.id) { favoriteRate in
                            FavoritePairRow(pair: favoriteRate)
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                viewModel.removeFavorite(viewModel.favoriteRates[index].pair)
                            }
                        }
                    }
                    .refreshable {
                        viewModel.fetchRates()
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}
