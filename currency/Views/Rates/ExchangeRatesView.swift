//
//  FixerAPIResponse.swift
//  currency
//
//  Created by pc on 02.12.24.
//

import SwiftUI

struct ExchangeRatesView: View {
    @StateObject var viewModel: ExchangeRatesViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                switch viewModel.state {
                case .loading:
                    LoadingView()
                    
                case .error(let message):
                    ErrorView(
                        error: message,
                        retryAction: viewModel.fetchRates
                    )
                    
                case .loaded(let base, let rates):
                    VStack(spacing: 0) {
                        BaseCurrencyPicker(
                            selectedCurrency: $viewModel.selectedBaseCurrency,
                            availableCurrencies: viewModel.availableCurrencies
                        )
                        .padding(.horizontal)
                        
                        Divider()
                            .padding(.top)
                        
                        RatesList(
                            rates: viewModel.ratesWithStatus,
                            onFavoriteToggle: viewModel.toggleFavorite
                        )
                        .refreshable {
                            viewModel.fetchRates()
                        }
                    }
                }
            }
            .navigationTitle("Exchange Rates")
        }
    }
}

private struct RatesList: View {
    let rates: [ExchangeRatesViewModel.RateWithFavoriteStatus]
    let onFavoriteToggle: (String) -> Void
    
    var body: some View {
        List {
            ForEach(rates, id: \.currency) { rateInfo in
                RateRow(
                    currency: rateInfo.currency,
                    rate: rateInfo.rate,
                    isFavorite: rateInfo.isFavorite,
                    onFavoriteToggle: { onFavoriteToggle(rateInfo.currency) }
                )
            }
        }
        .listStyle(.plain)
    }
}
