//
//  I14_ContentView.swift
//  ViewBuilders
//
//  Created by kook on 2023/06/12.
//

import SwiftUI

struct I14_ContentView: View {
  
  var body: some View {
    NavigationStack {
      I14_Home()
        .navigationTitle("To-Do")
        .environment(\.managedObjectContext, I14_PersistenceController.shared.container.viewContext)
    }
  }
}
