//
//  FixerAPISuccessResponse.swift
//  currency
//
//  Created by pc on 02.12.24.
//

import Foundation

struct FixerAPISuccessResponse: Decodable {
    let success: Bool
    let timestamp: Int
    let base: String
    let date: String
    let rates: [String: Double]
}
