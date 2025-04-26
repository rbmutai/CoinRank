//
//  CoinRankViewModel.swift
//  CoinRank
//
//  Created by Robert Mutai on 26/04/2025.
//

import Foundation
import Combine

enum SortOrder: String {
    case marketCap
    case price
    case performance
}

class CoinRankViewModel {
    @Published var  orderBy = "marketCap"
    @Published var  orderDirection = "desc"
    @Published var  limit = 20
    @Published var  offset = 0
    @Published var  total = 100
    @Published var errorMessage = ""
    @Published var currentPage = "1"
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
    
    func setPageNumber(isNext: Bool) {
        if isNext {
            if offset < (total/limit)-1 {
                offset += 1
            }
        } else {
            if offset > 0 {
                offset -= 1
            }
        }
        currentPage = "\(offset+1)"
    }
    
    func resetPageNumber() {
        offset = 0
        currentPage = "\(offset+1)"
    }
    
    func filterBy(order: SortOrder){
        switch order {
        case .price:
            orderBy = "price"
        case .marketCap:
            orderBy = "marketCap"
        case .performance:
            orderBy = "24hVolume"
        }
    }
    
}
