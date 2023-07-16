//
//  I15_PageControl.swift
//  ViewBuilders
//
//  Created by kook on 2023/07/16.
//

import SwiftUI

struct I15_PageControl: UIViewRepresentable {
  var totalPages: Int
  var currentPage: Int
  
  func makeUIView(context: Context) -> UIPageControl {
    let control = UIPageControl()
    control.numberOfPages = totalPages
    control.currentPage = currentPage
    control.backgroundStyle = .prominent
    control.allowsContinuousInteraction = false
    
    return control
  }
  
  func updateUIView(_ uiView: UIPageControl, context: Context) {
    uiView.numberOfPages = totalPages
    uiView.currentPage = currentPage
  }
}
