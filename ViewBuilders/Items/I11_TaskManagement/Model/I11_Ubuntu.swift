//
//  I11_Ubuntu.swift
//  ViewBuilders
//
//  Created by kook on 2023/01/10.
//

import SwiftUI

// MARK: Custom Font Extension
enum I11_Ubuntu {
  case light
  case bold
  case medium
  case regular
  
  var weight: Font.Weight {
    switch self {
    case .light: return .light
    case .bold: return .bold
    case .medium: return .medium
    case .regular: return .regular
    }
  }
}

extension View {
  
  func ubuntu(_ size: CGFloat, _ weight: I11_Ubuntu) -> some View {
    self
      .font(.custom("Ubuntu", size: size))
      .fontWeight(weight.weight)
  }
  
}
