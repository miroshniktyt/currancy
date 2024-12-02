//
//  FixerAPIError.swift
//  currency
//
//  Created by pc on 02.12.24.
//

import Foundation

enum FixerAPIError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case apiError(code: Int, message: String)
    case decodingError(Error)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return error.localizedDescription
        case .invalidURL:
            return "Invalid response from the server."
        case .apiError(_, let message):
            return message
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
