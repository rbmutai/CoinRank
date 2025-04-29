//
//  CoinPrice.swift
//  CoinRank
//
//  Created by Robert Mutai on 28/04/2025.
//

import Foundation

struct CoinPrice: Decodable, Hashable {
  
    let price: String
    let timeStamp: Int
  
    enum CodingKeys: String, CodingKey {
        case price
        case timeStamp = "timestamp"
    }
 }

 struct CoinPriceHistory: Decodable {
     let history: [CoinPrice]
 }

 struct CoinPriceData: Decodable {
     let data: CoinPriceHistory
 }
