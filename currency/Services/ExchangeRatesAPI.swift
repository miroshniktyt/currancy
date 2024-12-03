//
//  currencyApp.swift
//  currency
//
//  Created by pc on 02.12.24.
//

import Foundation
import Combine

enum ExchangeRatesAPI {
    private static let baseURL = "http://data.fixer.io/api/latest"
    private static let accessKey = "your_key"
    
    static func fetchLatestRates() -> AnyPublisher<FixerAPISuccessResponse, FixerAPIError> {
        guard let url = makeURL() else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { FixerAPIError.networkError($0) }
            .map(\.data)
            .decode(type: FixerAPIResponse.self, decoder: JSONDecoder())
            .mapError { error -> FixerAPIError in
                if let error = error as? DecodingError {
                    return .decodingError(error)
                }
                return .networkError(error)
            }
            .flatMap { response -> AnyPublisher<FixerAPISuccessResponse, FixerAPIError> in
                switch response {
                case .success(let successResponse):
                    return Just(successResponse)
                        .setFailureType(to: FixerAPIError.self)
                        .eraseToAnyPublisher()
                case .failure(let errorResponse):
                    return Fail(
                        error: .apiError(
                            code: errorResponse.error.code,
                            message: errorResponse.error.message
                        )
                    ).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    private static func makeURL() -> URL? {
        guard let url = URL(string: baseURL) else {
            return nil
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [
            URLQueryItem(name: "access_key", value: accessKey)
        ]
        return components?.url
    }
}
