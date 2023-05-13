//
//  I13_ShowCaseHelper.swift
//  ViewBuilders
//
//  Created by kook on 2023/05/13.
//

import SwiftUI

/// Custom Show Case View Extensions
extension View {
  @ViewBuilder
  func I13_showCase(order: Int, title: String, cornerRadius: CGFloat, style: RoundedCornerStyle = .continuous, scale: CGFloat = 1) -> some View {
    self
      /// Storing it in Anchor Preference
      .anchorPreference(key: HighlightAnchorKey.self, value: .bounds) { anchor in
        let highlight = I13_Highlight(anchor: anchor, title: title, cornerRadius: cornerRadius, style: style, scale: scale)
        return [order: highlight]
      }
  }
}

/// ShowCase Root View Modifier
struct I13_ShowCaseRoot: ViewModifier {
  var showHighlights: Bool
  var onFinished: () -> ()
  
  /// View Properties
  @State private var highlightOrder: [Int] = []
  @State private var currentHighlight: Int = 0
  @State private var showView: Bool = true
  @State private var showTitle: Bool = false
  /// Namespace ID, for smooth Shape Transitions
  @Namespace private var animation
  
  /// So the logic is that we're collecting all the highlight keys and storing them in an array,
  /// and every time the user taps the screen, we will move to the next highlight (this order will be in ascending order),
  /// and eventually at the final highlight, we will close the entire highlight view.
  func body(content: Content) -> some View {
    content
      .onPreferenceChange(HighlightAnchorKey.self) { value in
        highlightOrder = Array(value.keys).sorted()
      }
      .overlayPreferenceValue(HighlightAnchorKey.self) { preferences in
        if highlightOrder.indices.contains(currentHighlight), showHighlights, showView {
          if let highlight = preferences[highlightOrder[currentHighlight]] {
            HighlightView(highlight)
          }
        }
      }
  }
  
  /// Highlight View
  @ViewBuilder
  func HighlightView(_ highlight: I13_Highlight) -> some View {
    /// Gemoetry Reader for Extracting Highlight Frame Rects
    GeometryReader { proxy in
      let highlightRect = proxy[highlight.anchor]
      let safeArea = proxy.safeAreaInsets
      
      Rectangle()
        .fill(.black.opacity(0.5))
        .reverseMask {
          Rectangle()
            .matchedGeometryEffect(id: "HIGHLIGHTSHAPE", in: animation)
            /// Adding Border, Simply Extend it's Size
            .frame(width: highlightRect.width + 5, height: highlightRect.height + 5)
            .clipShape(RoundedRectangle(cornerRadius: highlight.cornerRadius, style: highlight.style))
            .scaleEffect(highlight.scale)
            .offset(x: highlightRect.minX - 2.5, y: highlightRect.minY + safeArea.top - 2.5)
        }
        .ignoresSafeArea()
        .onTapGesture {
          if currentHighlight >= highlightOrder.count - 1 {
            /// Hiding the Highlight View, beacuse it's the Last Highlight
            withAnimation(.easeIn(duration: 0.25)) {
              showView = false
            }
            onFinished()
          } else {
            /// Moving to next Highlight
            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.7)) {
              showTitle = false
              currentHighlight += 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
              showTitle = true
            }
          }
        }
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            showTitle = true
          }
        }
      
      Rectangle()
        .foregroundColor(.clear)
        /// Adding Border, Simply Extend it's Size
        .frame(width: highlightRect.width + 20, height: highlightRect.height + 20)
        .clipShape(RoundedRectangle(cornerRadius: highlight.cornerRadius, style: highlight.style))
//        .popover(isPresented: $showTitle) {
//          Text(highlight.title)
//            .padding(.horizontal, 10)
//            /// iOS 16.4+ Modifier
//            .presentationCompactAdaptation(.popover)
//        }
        .scaleEffect(highlight.scale)
        .offset(x: highlightRect.minX - 10, y: highlightRect.minY - 10)
    }
  }
}

/// Custom View Modifier for Inner/Reverse Mask
fileprivate extension View {
  @ViewBuilder
  func reverseMask<Content: View>(alignment: Alignment = .topLeading, @ViewBuilder content: @escaping () -> Content) -> some View {
    self
      .mask {
        Rectangle()
          .overlay(alignment: .topLeading) {
            content()
              .blendMode(.destinationOut)
          }
      }
  }
}

/// Anchor Key
fileprivate struct HighlightAnchorKey: PreferenceKey {
  static var defaultValue: [Int: I13_Highlight] = [:]
  
  static func reduce(value: inout [Int : I13_Highlight], nextValue: () -> [Int : I13_Highlight]) {
    value.merge(nextValue()) { $1 }
  }
}

struct I13_ShowCaseHelper_Previews: PreviewProvider {
  static var previews: some View {
    I13_Home()
  }
}
