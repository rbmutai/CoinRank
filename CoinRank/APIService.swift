//
//  APIService.swift
//  CoinRank
//
//  Created by Robert Mutai on 24/04/2025.
//

import Foundation

protocol APIServiceProtocol {
    func fetchCoins(orderBy: String, orderDirection: String, limit: Int, offset: Int) async throws -> [Coins]
}

enum ResultError: Error {
    case parsing
    case network
    case data
}

class APIService: APIServiceProtocol {
    
    let coinRankingAPI = "https://api.coinranking.com/v2"
    let coinsPath = "/coins?"
    
    
    func fetchCoins(orderBy: String = "marketCap", orderDirection: String = "desc", limit: Int = 20, offset: Int) async throws -> [Coins] {
        
        let coinRankingURL = coinRankingAPI + coinsPath + "orderBy=\(orderBy)&orderDirection=\(orderDirection)&limit=\(limit)&offset=\(offset)"
        
        guard let url = URL(string: coinRankingURL) else {
            throw ResultError.data
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) =  try await URLSession.shared.data(for: urlRequest)
        
        let decoder = JSONDecoder()
        
        let coinRankData = try decoder.decode(CoinRankData.self, from: data)
        
        return coinRankData.data.coins
    }
    
}
