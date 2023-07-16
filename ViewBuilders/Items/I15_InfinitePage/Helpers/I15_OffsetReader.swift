//
//  I15_OffsetReader.swift
//  ViewBuilders
//
//  Created by kook on 2023/07/16.
//

import SwiftUI

struct I15_OffsetKey: PreferenceKey {
  static var defaultValue: CGRect = .zero
  
  static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
    value = nextValue()
  }
}

extension View {
  @ViewBuilder
  func offsetX(_ addObserver: Bool, completion: @escaping ((CGRect) -> ())) -> some View {
    self
      .frame(maxWidth: .infinity)
      .overlay {
        if addObserver {
          GeometryReader {
            let rect = $0.frame(in: .global)
            
            Color.clear
              .preference(key: I15_OffsetKey.self, value: rect)
              .onPreferenceChange(I15_OffsetKey.self, perform: completion)
          }
        }
      }
  }
}
