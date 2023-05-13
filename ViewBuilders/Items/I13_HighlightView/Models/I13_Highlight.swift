//
//  I13_Highlight.swift
//  ViewBuilders
//
//  Created by kook on 2023/05/13.
//

import SwiftUI

struct I13_Highlight: Identifiable, Equatable {
  var id: UUID = .init()
  var anchor: Anchor<CGRect>
  var title: String
  var cornerRadius: CGFloat
  var style: RoundedCornerStyle = .continuous
  var scale: CGFloat = 1
}
