//
//  MockAPIService.swift
//  CoinRank
//
//  Created by Robert Mutai on 26/04/2025.
//

import Foundation

class MockAPIService: APIServiceProtocol {
    
    func fetchCoins(orderBy: String, orderDirection: String, limit: Int, offset: Int, uuids: [String], isFavourites: Bool) async throws -> [Coins] {
        
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
    
    func fetchPriceHistory(uuid: String, timePeriod: String) async throws -> [CoinPrice] {
        guard let bundleUrl = Bundle.main.url(forResource: "CoinPrice", withExtension: "json") else {
            throw ResultError.data }
        
        do {
            let data = try Data(contentsOf: bundleUrl)
            
            let decoder = JSONDecoder()
            
            let coinPriceData = try decoder.decode(CoinPriceData.self, from: data)
            
            return coinPriceData.data.history
            
        } catch {
            throw ResultError.parsing
        }
    }
     
}
