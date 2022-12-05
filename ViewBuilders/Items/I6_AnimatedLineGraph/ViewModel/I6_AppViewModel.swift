//
//  I6_AppViewModel.swift
//  ViewBuilders
//
//  Created by kook on 2022/12/05.
//

import SwiftUI

class I6_AppViewModel: ObservableObject {
    @Published var coins: [I6_CryptoModel]?
    @Published var currentCoin: I6_CryptoModel?
    
    init() {
        Task {
            do {
                try await fetchCryptoData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: Fetching Crypto Data
    func fetchCryptoData() async throws {
        guard let url = I6_url else { return }
        let session = URLSession.shared
        
        let response = try await session.data(from: url)
        let jsonData = try JSONDecoder().decode([I6_CryptoModel].self, from: response.0)
        
        // Alternative For DispatchQueue Main
        await MainActor.run(body: {
            self.coins = jsonData
            if let firstCoin = jsonData.first {
                self.currentCoin = firstCoin
            }
        })
    }
    
}
