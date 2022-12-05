//
//  I6_Home.swift
//  ViewBuilders
//
//  Created by kook on 2022/12/05.
//

import SwiftUI
import SDWebImageSwiftUI

struct I6_Home: View {
    @State private var currentCoin: String = "BTC"
    @Namespace var animation
    @StateObject var appModel = I6_AppViewModel()
    
    var body: some View {
        VStack {
            if let coins = appModel.coins, let coin = appModel.currentCoin {
                HStack(spacing: 15) {
                    AnimatedImage(url: URL(string: coin.image))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Bitcoin")
                            .font(.callout)
                            .foregroundColor(.white)
                        Text("BTC")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                 
                CustomControl(coins: coins)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(coin.current_price.convertToCurrency())
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    
                    // MARK: Profit/Loss
                    Text("\(coin.price_change > 0 ? "+" : "")\(String(format: "%.2f", coin.price_change))")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(coin.price_change < 0 ? .white : .black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background {
                            Capsule()
                                .fill(coin.price_change < 0 ? .red : Color("I6_LightGreen"))
                        }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                GraphView(coin: coin)
                Controls()
            } else {
                ProgressView()
                    .tint(Color("I6_LightGreen"))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
    
    // MARK: Line Graph
    @ViewBuilder
    func GraphView(coin: I6_CryptoModel) -> some View {
        GeometryReader { _ in
            I6_LineGraph(data: coin.last_7days_price.price, profit: coin.price_change > 0)
        }
        .padding(.vertical, 30)
        .padding(.bottom, 20)
    }
    
    // MARK: Custom Segmented Control
    @ViewBuilder
    func CustomControl(coins: [I6_CryptoModel]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(coins) { coin in
                    Text(coin.symbol.uppercased())
                        .foregroundColor(currentCoin == coin.symbol.uppercased() ? .white : .gray)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .contentShape(Rectangle())
                        .background {
                            if currentCoin == coin.symbol.uppercased()  {
                                Rectangle()
                                    .fill(Color("I6_Tab"))
                                    .matchedGeometryEffect(id: "SEGMENTEDTAB", in: animation)
                            }
                        }
                        .onTapGesture {
                            withAnimation {
                                appModel.currentCoin = coin
                                currentCoin = coin.symbol.uppercased()
                            }
                        }
                }
            }
        }
    }
    
    // MARK: Controls
    @ViewBuilder
    func Controls() -> some View {
        HStack(spacing: 20) {
            Button {
                
            } label: {
                Text("Sell")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.white)
                    }
            }
            
            Button {
                
            } label: {
                Text("Buy")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color("I6_LightGreen"))
                    }
            }
        }
    }
}

struct I6_Home_Previews: PreviewProvider {
    static var previews: some View {
        I6_Home()
    }
}

// MARK: Converting Double to Currency
fileprivate extension Double {
    func convertToCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(from: .init(value: self)) ?? ""
    }
}
