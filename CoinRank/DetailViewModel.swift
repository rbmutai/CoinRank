//
//  DetailViewModel.swift
//  CoinRank
//
//  Created by Robert Mutai on 28/04/2025.
//

import Foundation
import Combine

enum TimePeriod: String, CaseIterable, Hashable {
    case OneHour = "1h"
    case ThreeHours = "3h"
    case TwelveHours = "12h"
    case TwentyFourHours = "24h"
    case SevenDays = "7d"
    case ThirtyDays = "30d"
    case ThreeMonths = "3m"
    case OneYear = "1y"
    case ThreeYears = "3y"
    case FiveYears = "5y"
}

class DetailViewModel: ObservableObject {
    @Published var coinPrices: [CoinPrice] = []
    @Published var errorMessage = ""
    @Published var showLoading = false
    @Published var timePeriod: TimePeriod = .TwentyFourHours
    let coin: Coins
    let apiService: APIServiceProtocol
    init(apiService: APIServiceProtocol, coin: Coins) {
        self.apiService = apiService
        self.coin = coin
    }
    
    func getCoinPrices(timePeriod: TimePeriod = .TwentyFourHours) async {
        self.timePeriod  = timePeriod
        do {
            showLoading = true
            
            coinPrices = try await apiService.fetchPriceHistory(uuid: coin.uuid, timePeriod: timePeriod.rawValue)
            
            showLoading = false
            
        } catch {
            showLoading = false
            processError(error: error)
        }
    }
    
    func processError(error: Error) {
        switch error {
            case ResultError.network:
                errorMessage = "Network error"
            case ResultError.parsing:
                errorMessage = "Parsing error"
            case ResultError.data:
                errorMessage = "Data error"
            default:
                errorMessage = "Error: \(error.localizedDescription)"
        }
    }
    
    func formatAmount(amount: String) -> String {
        let amount = Double(amount)?.formatted(.currency(code: "USD").presentation(.narrow))
        return amount ?? "Unavailable"
    }
    
    func chartYScale() -> [Double] {
       
        var priceScale = coinPrices.compactMap({ coinPrice in
             Double(coinPrice.price) ?? 0.0
        })
        
        priceScale.sort(by: >)
        
        return [priceScale.first ?? 0.0, priceScale.last ?? 0.0]
    }
}
