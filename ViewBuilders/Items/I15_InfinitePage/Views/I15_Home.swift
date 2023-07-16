//
//  I15_Home.swift
//  ViewBuilders
//
//  Created by kook on 2023/07/16.
//

import SwiftUI

struct I15_Home: View {
  
  /// View Properties
  @State private var currentPage: String = ""
  @State private var listOfPages: [I15_Page] = []
  /// Infinite Carousel Properties
  @State private var fakedPages: [I15_Page] = []
  
  var body: some View {
    NavigationStack {
      Home()
        .navigationTitle("Infinite Carousel")
    }
  }
  
  private func Home() -> some View {
    GeometryReader {
      let size = $0.size
      
      TabView(selection: $currentPage, content: {
        ForEach(fakedPages) { page in
          RoundedRectangle(cornerRadius: 25, style: .continuous)
            .fill(page.color.gradient)
            .frame(width: 300, height: size.height)
            .tag(page.id.uuidString)
          /// Calculating Entire Page Scroll Offset
            .offsetX(currentPage == page.id.uuidString) { rect in
              let minX = rect.minX
              let pageOffset = minX - (size.width * CGFloat(fakeIndex(page)))
              /// Converting Page Offset into Progress
              let pageProgress = pageOffset / size.width
              
              /// Infinite Carousel Logic
              if -pageProgress < 1.0 {
                /// Moving to the Last Page
                /// Which is Actually the First Duplicated Page
                /// Safe Check
                if fakedPages.indices.contains(fakedPages.count - 1) {
                  currentPage = fakedPages[fakedPages.count - 1].id.uuidString
                }
              }
              
              if -pageProgress > CGFloat(fakedPages.count - 1) {
                /// Moving to the First Page
                /// Which is Actually the Last Duplicated Page
                /// Safe Check
                if fakedPages.indices.contains(1) {
                  currentPage = fakedPages[1].id.uuidString
                }
              }
            }
        }
      })
      .tabViewStyle(.page(indexDisplayMode: .never))
      .overlay(alignment: .bottom) {
        I15_PageControl(totalPages: listOfPages.count, currentPage: originIndex(currentPage))
          .offset(y: -15)
      }
    }
    .frame(height: 400)
    .onAppear {
      guard fakedPages.isEmpty else { return }
      
      for color in [Color.red, Color.blue, Color.yellow, Color.black, Color.brown] {
        listOfPages.append(.init(color: color))
      }
      
      fakedPages.append(contentsOf: listOfPages)
      
      if var firstPage = listOfPages.first, var lastPage = listOfPages.last {
        currentPage = firstPage.id.uuidString
        
        // 중복된 page를 array에 넣으면 SwiftUI가 제대로 동작하지 않을 것이기 때문에, ID를 변경해주고 array에 집어넣는다.
        firstPage.id = .init()
        lastPage.id = .init()
        
        fakedPages.append(firstPage)
        fakedPages.insert(lastPage, at: 0)
      }
    }
  }
  
  func fakeIndex(_ of: I15_Page) -> Int {
    fakedPages.firstIndex(of: of) ?? 0
  }
  
  func originIndex(_ id: String) -> Int {
    listOfPages.firstIndex { page in
      page.id.uuidString == id
    } ?? 0
  }
}

struct I15_Home_Previews: PreviewProvider {
  static var previews: some View {
    I15_Home()
  }
}
