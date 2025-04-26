//
//  MockAPIService.swift
//  CoinRank
//
//  Created by Robert Mutai on 26/04/2025.
//

import Foundation

class MockAPIService: APIServiceProtocol {
    
    func fetchCoins(orderBy: String, orderDirection: String, limit: Int, offset: Int) async throws -> [Coins] {
        
        guard let bundleUrl = Bundle.main.url(forResource: "Coins", withExtension: "json") else {
            throw ResultError.data }
        
        do {
            let data = try Data(contentsOf: bundleUrl)
            
            let decoder = JSONDecoder()
            
            let coinRankData = try decoder.decode(CoinRankData.self, from: data)
            
            return coinRankData.data.coins
            
        } catch {
            throw ResultError.parsing
        }
    }
    
    
     
}
