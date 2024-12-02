//
//  FixerAPIResponse.swift
//  currency
//
//  Created by pc on 02.12.24.
//

import SwiftUI

struct RatesView: View {
    @StateObject private var viewModel = ExchangeRatesViewModel()
    
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
                        
                        RatesList(rates: rates)
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
    let rates: [String: Double]
    
    var body: some View {
        List {
            ForEach(Array(rates.keys.sorted()), id: \.self) { currency in
                if let rate = rates[currency] {
                    RateRow(currency: currency, rate: rate)
                }
            }
        }
        .listStyle(.plain)
        .listRowInsets(EdgeInsets())
    }
}

private struct RateRow: View {
    let currency: String
    let rate: Double
    
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
        }
    }
}


#Preview {
    RatesView()
}
