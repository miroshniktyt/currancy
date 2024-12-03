//
//  FixerAPIErrorResponse.swift
//  currency
//
//  Created by pc on 02.12.24.
//

import Foundation

struct FixerAPIErrorResponse: Decodable {
    let success: Bool
    let error: FixerApiErrorDetail
}

struct FixerApiErrorDetail: Decodable {
    let code: Int
    let type: String?
    let info: String?
    
    var message: String {
        info ?? type ?? "Unknown error occurred"
    }
}
