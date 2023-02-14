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
            .onAppear {
              vibrate()
            }
        } label: {
          ItemRowView(item: item)
        }
      }
      .listStyle(.plain)
      .background(Color(.systemGroupedBackground))
      .scrollContentBackground(.hidden)
      .navigationTitle("View Builders")

    }
  }

  private func vibrate() {
    let feedback = UIImpactFeedbackGenerator(style: .soft)
    feedback.prepare()
    feedback.impactOccurred()
  }
}

struct ItemRowView: View {
  let item: ItemData

  var body: some View {
    HStack {
      Text("\(item.id)")
        .frame(width: 40, height: 40)
        .background {
          RoundedRectangle(cornerRadius: 13, style: .continuous)
            .fill(Color(.systemGroupedBackground))
        }

      VStack(alignment: .leading, spacing: 8) {
        Text(item.title)

        Text(item.desc)
          .font(.caption)
          .foregroundColor(.gray)
        Text(item.createdDate)
          .font(.caption2)
          .foregroundColor(.gray)
      }
      .padding(.horizontal)
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
