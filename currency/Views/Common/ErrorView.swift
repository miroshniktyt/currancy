//
//  ErrorView.swift
//  currency
//
//  Created by pc on 02.12.24.
//

import SwiftUI

struct ErrorView: View {
    let error: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.red)
            Text("Error occurred")
                .font(.headline)
            Text(error)
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
            Button("Retry", action: retryAction)
                .buttonStyle(.bordered)
            Spacer()
        }
        .padding()
    }
}
