//
//  CoinRankTests.swift
//  CoinRankTests
//
//  Created by Robert Mutai on 24/04/2025.
//

import XCTest
@testable import CoinRank

final class CoinRankTests: XCTestCase {

    func testGetCoins() async {
        let viewModel = CoinRankViewModel(apiService: MockAPIService(), delegate: .none)
       
        await viewModel.getCoinsInfo()
        
        XCTAssertTrue(viewModel.coins.count>0)
        XCTAssertEqual(viewModel.coins[0].uuid, "Qwsogvtv82FCd")
        XCTAssertEqual(viewModel.coins[0].name, "Bitcoin")
        XCTAssertEqual(viewModel.coins[0].price, "94800.19141134917")
        XCTAssertEqual(viewModel.coins[0].volume24h, "30879790744")
        XCTAssertEqual(viewModel.coins[0].iconUrl, "https://cdn.coinranking.com/bOabBYkcX/bitcoin_btc.svg")
        XCTAssertEqual(viewModel.coins[0].symbol, "BTC")
    }

}
