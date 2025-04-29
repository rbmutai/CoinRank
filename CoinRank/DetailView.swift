//
//  DetailView.swift
//  CoinRank
//
//  Created by Robert Mutai on 29/04/2025.
//

import SwiftUI
import Charts
struct DetailView: View {
    @ObservedObject var viewModel: DetailViewModel
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                AsyncImage(url: URL(string: viewModel.coin.iconUrl)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Image(systemName: "photo")
                    }
                }
                .frame(width: 50, height: 50)
                
                Text(viewModel.coin.name)
                    .fontWeight(.bold)
                    .padding([.leading],8)
                
                Spacer()
            }
            
            Divider()
            
            HStack {
                Text("Rank: ")
                Text("\(viewModel.coin.rank)")
                    .fontWeight(.bold)
            }.padding([.top],4)
            
            HStack {
                Text("Current Price: ")
                Text(viewModel.formatAmount(amount: viewModel.coin.price))
                    .fontWeight(.bold)
            }.padding([.top],4)
            
            HStack {
                Text("24h Performance: ")
                Text(viewModel.formatAmount(amount: viewModel.coin.volume24h))
                    .fontWeight(.bold)
            }.padding([.top],4)
            
            HStack {
                Text("Market Cap: ")
                Text(viewModel.formatAmount(amount: viewModel.coin.marketCap))
                    .fontWeight(.bold)
            }.padding([.top],4)
            
            Text("Price Chart")
                .fontWeight(.bold)
                .padding([.top], 24)
            
            if viewModel.coinPrices.count > 0 && !viewModel.showLoading {
                   Chart(viewModel.coinPrices, id: \.self) { coinPrice in
                    LineMark(
                        x: .value("Time", Date(timeIntervalSince1970: Double(coinPrice.timeStamp))),
                        y: .value("Price", Double(coinPrice.price) ?? 0.0)
                    )
                    
                }
                .frame(height: 220)
                .padding([.top], 4)
                .chartYScale(domain: viewModel.chartYScale())
                
                HStack {
                    ForEach(TimePeriod.allCases, id: \.self) { item in
                        Button(item.rawValue, role: .none) {
                            Task {
                                await viewModel.getCoinPrices( timePeriod: item)
                            }
                        }.border(item == viewModel.timePeriod ? Color.gray : Color.clear)
                        .foregroundStyle(item == viewModel.timePeriod ? Color.black : Color.gray)
                        .padding(2)
        
                    }
                }
                
            } else {
                HStack {
                    Spacer()
                    ProgressView()
                        .padding([.top], 24)
                        .scaleEffect(1.5)
                        .ignoresSafeArea(.all)
                    Spacer()
                }
            }
            Spacer()
        }.padding()
          .onAppear {
                Task {
                    await viewModel.getCoinPrices()
                }
            }
          .alert("Alert", isPresented: $viewModel.showAlert) {
              Button("OK", role: .cancel, action: {})
          } message: {
              Text(viewModel.errorMessage)
          }
    }
}

#Preview {
    let coin = Coins(uuid: "Qwsogvtv82FCd", symbol: "BTC", name: "Bitcoin", iconUrl: "https://cdn.coinranking.com/bOabBYkcX/bitcoin_btc.svg", marketCap: "1882386065131", price: "94800.19141134917", rank: 1, sparkline: [ "93657.98062553426","93733.70098948105",], volume24h: "30879790744")
    
    DetailView(viewModel: DetailViewModel(apiService: MockAPIService(), coin: coin))
}
