//
//  I5_ContentView.swift
//  ViewBuilders
//
//  Created by kook on 2022/12/05.
//

import SwiftUI

struct I5_ContentView: View {
    var body: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            let size = $0.size
            I5_Home(safeArea: safeArea, size: size)
                .ignoresSafeArea(.container, edges: .top)
                .background(Color.black)
        }
    }
}

struct I5_ContentView_Previews: PreviewProvider {
    static var previews: some View {
        I5_ContentView()
    }
}
