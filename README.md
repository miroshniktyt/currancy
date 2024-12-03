# Currency Exchange App

A SwiftUI iOS app for real-time currency exchange rates using the Fixer.io API.

## Features

- Real-time currency exchange rates
- Favorite currency pairs
- Base currency selection
- Offline data persistence

## Quick Start

1. Clone the repository
2. Open `CurrencyExchange.xcodeproj` in Xcode
3. Replace `your_key` in `Services/ExchangeRatesAPI.swift` with your [Fixer.io](https://fixer.io) API key
4. Build and run

## Technical Overview

### Architecture
- MVVM pattern with SwiftUI
- Combine for reactive data flow
- UserDefaults for local storage

### Key Components
- `RatesRepository`: API communication & caching
- `ExchangeRatesViewModel`: Exchange rates logic
- `FavoriteRatesViewModel`: Favorites management

## Requirements
- iOS 15.0+
- Xcode 13.0+
