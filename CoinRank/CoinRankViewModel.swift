//
//  CoinRankViewModel.swift
//  CoinRank
//
//  Created by Robert Mutai on 26/04/2025.
//

import Foundation
import Combine
class CoinRankViewModel {
    @Published var  orderBy = "marketCap"
    @Published var  orderDirection = "desc"
    @Published var  limit = 20
    @Published var  offset = 0
    @Published var errorMessage = ""
    @Published var showActivityIndicator = false
    @Published var  coins: [Coins] = []
    let apiService: APIServiceProtocol
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func getCoinsInfo() async {
        
        do {
            showActivityIndicator = true
            
            coins = try await apiService.fetchCoins(orderBy: orderBy, orderDirection: orderDirection, limit: limit, offset: offset)
            
            showActivityIndicator = false
            
        } catch {
            showActivityIndicator = false
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
    
}
