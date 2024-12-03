//
//  FixerAPIResponse.swift
//  currency
//
//  Created by pc on 02.12.24.
//

import Foundation

enum FixerAPIResponse: Decodable {
    case success(FixerAPISuccessResponse)
    case failure(FixerAPIErrorResponse)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let success = try container.decode(Bool.self, forKey: .success)
        
        if success {
            self = .success(try FixerAPISuccessResponse(from: decoder))
        } else {
            self = .failure(try FixerAPIErrorResponse(from: decoder))
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case success
    }
}
