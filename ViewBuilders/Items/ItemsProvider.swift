//
//  ItemsProvider.swift
//  ViewBuilders
//
//  Created by kook on 2022/11/29.
//

import SwiftUI

struct ItemData: Identifiable {
    let id: Int
    let title: String
    let view: AnyView
}

final class ItemsProvider {
    static let shared = ItemsProvider()
    
    private init() { }
    
    let items: [ItemData] = [
        .init(id: 3, title: "Magnifying Glass", view: AnyView(I3_Home())),
        .init(id: 2, title: "Custom Date Picker", view: AnyView(I2_Home())),
        .init(id: 1, title: "Wallet Animation", view: AnyView(I1_Home()))
    ]
}
