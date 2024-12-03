//
//  ExchangeRatesStore.swift
//  currency
//
//  Created by pc on 03.12.24.
//

import Foundation
import Combine

class ExchangeRatesStore: ObservableObject {
    enum LoadingState {
        case loading
        case loaded(FixerAPISuccessResponse)
        case error(FixerAPIError)
    }
    
    @Published private(set) var state: LoadingState = .loading
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchRates()
    }
    func fetchRates() {
        state = .loading
        
        ExchangeRateService.fetchLatestRates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .error(error)
                }
            } receiveValue: { [weak self] response in
                self?.state = .loaded(response)
            }
            .store(in: &cancellables)
    }
    
    func recalculateRates(for newBase: String) -> [String: Double]? {
        guard case .loaded(let state) = self.state,
              let baseRate = state.rates[newBase] else {
            return nil
        }
        
        return state.rates.mapValues { rate in
            rate / baseRate
        }
    }
}
