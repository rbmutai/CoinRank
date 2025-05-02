//
//  FavouritesViewController.swift
//  CoinRank
//
//  Created by Robert Mutai on 24/04/2025.
//

import UIKit
import Combine
import SwiftUI
class FavouritesViewController: UIViewController, UITabBarControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var viewModel: FavouritesViewModel?
    private var subscribers = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        self.tabBarController?.delegate = self
        bind()
        // Do any additional setup after loading the view.
    }
    func bind(){
        guard let viewModel = viewModel else { return }
        
        viewModel.$showActivityIndicator
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] value in
                if value {
                    activityIndicator.startAnimating()
                } else {
                    activityIndicator.stopAnimating()
                }
            })
            .store(in: &subscribers)
        
        viewModel.$hasFavourites
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] value in
                tableView.isHidden = !value
            })
            .store(in: &subscribers)
        
        viewModel.$coins
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] value in
                tableView.reloadData()
            })
            .store(in: &subscribers)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] value in
                if value != "" {
                    showAlert(message: value)
                }
            })
            .store(in: &subscribers)
        
        fetchFavouriteCoins()
        
    }
    @objc func updateData(refreshControl: UIRefreshControl) {
        fetchFavouriteCoins()
        refreshControl.endRefreshing()
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 1 {
            fetchFavouriteCoins()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.coins.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        
        guard let viewModel = viewModel else { return cell }
        
         let coin = viewModel.coins[indexPath.row]
            
         cell.contentConfiguration = UIHostingConfiguration(content: {
             CoinRankCellView(name: coin.name, iconURL: coin.iconUrl, currentPrice: viewModel.formatAmount(amount: coin.price), performance24h: viewModel.formatAmount(amount: coin.volume24h))
         })
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, sourceView, completionHandler) in
            
            if let coin = self.viewModel?.coins[indexPath.row] {
                self.viewModel?.deleteFavouriteCoin(uuid: coin.uuid)
            }
           
           completionHandler(true)
            
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let coin = self.viewModel?.coins[indexPath.row]{
            viewModel?.goToDetail(coin: coin)
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
   
    
    func fetchFavouriteCoins() {
        Task {
            await viewModel?.getFavouriteCoins()
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
