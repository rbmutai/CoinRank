//
//  DetailViewModelTests.swift
//  CoinRankTests
//
//  Created by Robert Mutai on 28/04/2025.
//

import XCTest
@testable import CoinRank
final class DetailViewModelTests: XCTestCase {

    func testGetPrices() async {
        
        let coins = Coins(uuid: "Qwsogvtv82FCd", symbol: "BTC", name: "Bitcoin", iconUrl: "https://cdn.coinranking.com/bOabBYkcX/bitcoin_btc.svg", marketCap: "1882386065131", price: "94800.19141134917", rank: 1, sparkline: [ "93657.98062553426","93733.70098948105",], volume24h: "30879790744")
        
        let viewModel = DetailViewModel(apiService: MockAPIService(), coin: coins)
        
        await viewModel.getCoinPrices()
        
        XCTAssertTrue(viewModel.coinPrices.count > 0)
        XCTAssertEqual(viewModel.coinPrices[0].price, "94626.27231814706")
        XCTAssertEqual(viewModel.coinPrices[0].timeStamp, 1745849880)
        
    }

}
