//
//  LoadingView.swift
//  currency
//
//  Created by pc on 02.12.24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            ProgressView()
            Text("Loading rates...")
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
}
