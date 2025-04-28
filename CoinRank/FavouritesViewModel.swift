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
    @Published var  errorMessage = ""
    @Published var  showActivityIndicator = false
    @Published var  hasFavourites = true
    let persistence = PersistenceController.shared
    let apiService: APIServiceProtocol
    weak var delegate : ViewModelDelegate?
    init(apiService: APIServiceProtocol, delegate: ViewModelDelegate?) {
        self.apiService = apiService
        self.delegate = delegate
    }
    
    func getFavouriteCoins() async {
        
        let favourites =  persistence.getFavouriteCoins()
        
        if favourites.count > 0 {
            hasFavourites = true
            do {
                showActivityIndicator = true
                
                coins = try await apiService.fetchCoins(orderBy: "", orderDirection: "", limit: 0, offset: 0, uuids: favourites, isFavourites: true)
                
                showActivityIndicator = false
                
            } catch {
                showActivityIndicator = false
                processError(error: error)
            }
            
        } else {
            hasFavourites = false
        }
    }
    
    func deleteFavouriteCoin(uuid:String){
        persistence.deleteFavouriteCoin(uuid: uuid)
        coins.removeAll { $0.uuid == uuid }
        if coins.count == 0 {
            hasFavourites = false
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
    
    func goToDetail(coin: Coins){
        delegate?.showDetail(coin: coin)
    }
}
