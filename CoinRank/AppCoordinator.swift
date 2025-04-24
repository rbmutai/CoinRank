//
//  AppCoordinator.swift
//  CoinRank
//
//  Created by Robert Mutai on 24/04/2025.
//

import Foundation
import UIKit
class AppCoordinator : Coordinator {
    let storyboard = UIStoryboard(name: "Main", bundle: .main)
    
    func start() {
        guard let homeTabBarController = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController") as? HomeTabBarController else { return }
        
        guard let favourites = storyboard.instantiateViewController(withIdentifier: "FavouritesViewController") as? FavouritesViewController else { return }

        guard let coinRank = storyboard.instantiateViewController(withIdentifier: "CoinRankViewController") as? CoinRankViewController else { return }
       

        homeTabBarController.viewControllers = [coinRank, favourites]
        
        navigationController?.pushViewController(homeTabBarController, animated: true)
    }
}
