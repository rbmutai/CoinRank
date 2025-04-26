//
//  CoinRankCellView.swift
//  CoinRank
//
//  Created by Robert Mutai on 26/04/2025.
//

import SwiftUI

struct CoinRankCellView: View {
    @State var name: String
    @State var iconURL: String
    @State var currentPrice: String
    @State var performance24h: String
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                AsyncImage(url: URL(string: iconURL)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Image(systemName: "photo")
                    }
                }
                .frame(width: 50, height: 50)
                
                Text(name)
                    .fontWeight(.bold)
                    .padding([.leading],8)
                
                Spacer()
            }
            
            VStack(alignment: .leading) {
                Text("Current Price")
                Text(currentPrice)
                    .fontWeight(.bold)
            }.padding([.top],4)
            
            VStack(alignment: .leading) {
                Text("24h Performance")
                Text(performance24h)
                    .fontWeight(.bold)
            }.padding([.top],4)
            
           
        }.padding()
       
    }
}

#Preview {
    CoinRankCellView(name: "Bitcoin", iconURL: "", currentPrice: "$200", performance24h: "$78888")
}
