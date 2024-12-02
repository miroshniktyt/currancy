//
//  FixerAPIResponse.swift
//  currency
//
//  Created by pc on 02.12.24.
//

import SwiftUI

struct RatesView: View {
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
                    }
                }
            }
            .navigationTitle("Exchange Rates")
        }
        .onAppear {
            viewModel.fetchRates()
        }
    }
}

// MARK: - Subviews
private struct BaseCurrencyPicker: View {
    @Binding var selectedCurrency: String
    let availableCurrencies: [String]
    
    var body: some View {
        HStack {
            Text("Base Currency:")
                .font(.headline)
            Spacer()
            Picker("Base Currency", selection: $selectedCurrency) {
                ForEach(availableCurrencies, id: \.self) { currency in
                    Text(currency)
                        .tag(currency)
                }
            }
            .pickerStyle(.menu)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
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

private struct RateRow: View {
    let currency: String
    let rate: Double
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Text(currency)
                .font(.headline)
                .foregroundStyle(.primary)
            Spacer()
            Text(String(format: "%.4f", rate))
                .font(.body)
                .monospacedDigit()
                .foregroundStyle(.secondary)
            Button(action: onFavoriteToggle) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundStyle(isFavorite ? .yellow : .gray)
            }
        }
        .padding(.horizontal)
    }
}
