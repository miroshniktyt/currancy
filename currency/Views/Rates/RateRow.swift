//
//  RateRow.swift
//  currency
//
//  Created by pc on 03.12.24.
//

import SwiftUI

struct RateRow: View {
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
