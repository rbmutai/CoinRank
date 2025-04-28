//
//  FavouritesViewModel.swift
//  CoinRank
//
//  Created by Robert Mutai on 28/04/2025.
//

import Foundation
import Combine
class FavouritesViewModel {
    @Published var coins: [Coins] = []
    let persistence = PersistenceController.shared
    let apiService: APIServiceProtocol
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
}
