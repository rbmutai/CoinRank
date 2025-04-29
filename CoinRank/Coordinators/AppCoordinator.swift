//
//  AppCoordinator.swift
//  CoinRank
//
//  Created by Robert Mutai on 24/04/2025.
//

import Foundation
import UIKit
class AppCoordinator : Coordinator, ViewModelDelegate {
    let storyboard = UIStoryboard(name: "Main", bundle: .main)
    
    func start() {
        guard let homeTabBarController = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController") as? HomeTabBarController else { return }
        
        guard let favourites = storyboard.instantiateViewController(withIdentifier: "FavouritesViewController") as? FavouritesViewController else { return }
        let favouritesViewModel = FavouritesViewModel(apiService: APIService(), delegate: self)
        favourites.viewModel = favouritesViewModel

        guard let coinRank = storyboard.instantiateViewController(withIdentifier: "CoinRankViewController") as? CoinRankViewController else { return }
        let coinRankViewModel = CoinRankViewModel(apiService: APIService(), delegate: self)
        coinRank.viewModel = coinRankViewModel

        homeTabBarController.viewControllers = [coinRank, favourites]
        
        navigationController?.pushViewController(homeTabBarController, animated: true)
    }
    
    func showDetail(coin: Coins) {
        
        guard let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        let detailViewModel = DetailViewModel(apiService: APIService(), coin: coin)
        detailViewController.viewModel = detailViewModel
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

