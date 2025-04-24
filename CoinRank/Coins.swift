//
//  Coins.swift
//  CoinRank
//
//  Created by Robert Mutai on 24/04/2025.
//

import Foundation
      
struct Coins: Decodable {
   let uuid: String
   let symbol: String
   let name: String
   let iconUrl: String
   let marketCap: String
   let price: String
   let rank: Int
   let sparkline: [String]
   let volume24h: String
 
   enum CodingKeys: String, CodingKey {
       case uuid
       case symbol
       case name
       case iconUrl
       case marketCap
       case price
       case rank
       case sparkline
       case volume24h = "24hVolume"
   }
}

struct CoinData: Decodable {
    let coins: [Coins]
}


