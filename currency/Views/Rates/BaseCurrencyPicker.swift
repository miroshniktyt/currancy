//
//  BaseCurrencyPicker.swift
//  currency
//
//  Created by pc on 03.12.24.
//

import SwiftUI

struct BaseCurrencyPicker: View {
    @Binding var selectedCurrency: String
    let availableCurrencies: [String]
    
    var body: some View {
        HStack {
            Text("Base Currency:")
                .font(.headline)
            Spacer()
            Picker("Base Currency", selection: $selectedCurrency) {
                ForEach(availableCurrencies, id: \.self) { currency in
                    Text(currency)
                        .tag(currency)
                }
            }
            .pickerStyle(.menu)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
    }
}
