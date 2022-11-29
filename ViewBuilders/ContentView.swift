//
//  ContentView.swift
//  ViewBuilders
//
//  Created by kook on 2022/11/29.
//

import SwiftUI

struct ContentView: View {
    
    let items = ItemsProvider.shared.items
    
    var body: some View {
        NavigationView {
            List(items) { item in
                NavigationLink {
                    item.view
                        .toolbar(.hidden)
                } label: {
                    Text("\(item.id). " + item.title)
                }
            }
            .background(Color(.systemGroupedBackground))
            .scrollContentBackground(.hidden)
            .navigationTitle("View Builders")
            
        }
    }
    
}

// https://stackoverflow.com/a/68650943/8293462
// 네비게이션바 안보여도 백스와이프 되도록
extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
