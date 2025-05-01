//
//  ViewController.swift
//  CoinRank
//
//  Created by Robert Mutai on 24/04/2025.
//

import UIKit
import Combine
import SwiftUI
class CoinRankViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pageNumberLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortButton: UIButton!
    var viewModel: CoinRankViewModel?
    private var subscribers = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        tableView.refreshControl = refreshControl
            
        bind()
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
        
        viewModel.$coins
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] value in
                tableView.reloadData()
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
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
        
        viewModel.$currentPage
            .receive(on: DispatchQueue.main)
            .assign(to: \.text!, on: pageNumberLabel)
            .store(in: &subscribers)
        
        viewModel.$title
            .receive(on: DispatchQueue.main)
            .assign(to: \.text!, on: titleLabel)
            .store(in: &subscribers)
        
        setUpSortMenu()
        
        fetchCoinRank()
    }
    @objc func updateData(refreshControl: UIRefreshControl) {
        fetchCoinRank()
        refreshControl.endRefreshing()
    }
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        viewModel?.setPageNumber(isNext: true)
        fetchCoinRank()
    }
    @IBAction func previousButtonPressed(_ sender: UIButton) {
        viewModel?.setPageNumber(isNext: false)
        fetchCoinRank()
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
        let saveAction = UIContextualAction(style: .normal, title: "Save") {
            (action, sourceView, completionHandler) in
            
            if let coin = self.viewModel?.coins[indexPath.row] {
                self.viewModel?.saveFavouriteCoin(uuid: coin.uuid)
                self.showAlert(message: "Saved to favourites")
            }
           
           completionHandler(true)
            
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [saveAction])
        
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let coin = self.viewModel?.coins[indexPath.row]{
            viewModel?.goToDetail(coin: coin)
        }
    }
    
    func setUpSortMenu() {
        let price = UIAction(title: "Highest Price", image: UIImage(systemName: "arrow.up")) { _ in
            self.sortCoinRank(order: .price)
        }
        
        let performance = UIAction(title: "Best 24h Performance", image: UIImage(systemName: "clock")) { _ in
            self.sortCoinRank(order: .performance)
        }
        
        let marketCap = UIAction(title: "Market Cap", image: UIImage(systemName: "dollarsign")) { _ in
            self.sortCoinRank(order: .marketCap)
        }
        
        let menu = UIMenu(title: "Filter By", children: [price, performance, marketCap])
        sortButton.menu = menu
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func sortCoinRank(order: SortOrder) {
        viewModel?.filterBy(order: order)
        viewModel?.resetPageNumber()
        fetchCoinRank()
    }
    
    func fetchCoinRank() {
        Task {
            await viewModel?.getCoinsInfo()
        }
    }


}

