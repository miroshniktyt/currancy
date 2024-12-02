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
    
    @Published private(set) var state: ViewState = .loading
    @Published var selectedBaseCurrency: String = "EUR" {
        didSet {
            recalculateRates()
        }
    }
    
    private var rates: [String: Double] = [:]
    private var cancellables = Set<AnyCancellable>()
    
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
} 
