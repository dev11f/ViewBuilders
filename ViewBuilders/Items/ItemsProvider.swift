//
//  ItemsProvider.swift
//  ViewBuilders
//
//  Created by kook on 2022/11/29.
//

import SwiftUI

final class ItemsProvider {
  static let shared = ItemsProvider()
  
  private init() { }
  
  let items: [ItemData] = [
    .init(id: 13,
          title: "Highight Views",
          desc: "하이라이팅 뷰 기능 구현",
          createdDate: "2023-05-13",
          view: I13_Home()),
    .init(id: 12,
          title: "Popovers",
          desc: "팝 오버 구현",
          createdDate: "2023-02-14",
          view: I12_Home()),
    .init(id: 11,
          title: "Task Management",
          desc: "일정 관리 화면 UI 구현",
          createdDate: "2023-01-14",
          view: I11_Home()),
    .init(id: 10,
          title: "Blurred Sheet",
          desc: "커스텀 Blur Sheet 구현",
          createdDate: "2022-12-14",
          view: I10_Home()),
    .init(id: 9,
          title: "Tag View",
          desc: "태그 뷰 구현",
          createdDate: "2022-12-09",
          view: I9_Home()),
    .init(id: 8,
          title: "Matrix Rain Effect",
          desc: "매트릭스 Rain 효과",
          createdDate: "2022-12-07",
          view: I8_Home()),
    .init(id: 7,
          title: "Glass Card Effect",
          desc: "Morphism 효과",
          createdDate: "2022-12-07",
          view: I7_Home()),
    .init(id: 6,
          title: "Animated Line Graph",
          desc: "애니메이션 그래프",
          createdDate: "2022-12-05",
          view: I6_Home()),
    .init(id: 5,
          title: "Animatable Sticky Header",
          desc: "스티키 헤더 효과",
          createdDate: "2022-12-05",
          view: I5_ContentView()),
    .init(id: 4,
          title: "AR Lock Screen",
          desc: "iOS 16 잠금화면 효과",
          createdDate: "2022-11-30",
          view: I4_Home()),
    .init(id: 3,
          title: "Magnifying Glass",
          desc: "돋보기 효과",
          createdDate: "2022-11-30",
          view: I3_Home()),
    .init(id: 2,
          title: "Custom Date Picker",
          desc: "커스텀 캘린더",
          createdDate: "2022-11-29",
          view: I2_Home()),
    .init(id: 1,
          title: "Wallet Animation",
          desc: "다양한 애니메이션 효과",
          createdDate: "2022-11-29",
          view: I1_Home())
  ]
}

struct ItemData: Identifiable {
  let id: Int
  let title: String
  let desc: String
  let createdDate: String
  let view: AnyView
  
  init(id: Int, title: String, desc: String, createdDate: String, view: some View) {
    self.id = id
    self.title = title
    self.desc = desc
    self.createdDate = createdDate
    self.view = AnyView(view)
  }
}
