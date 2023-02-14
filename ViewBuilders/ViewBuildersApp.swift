//
//  ViewBuildersApp.swift
//  ViewBuilders
//
//  Created by kook on 2022/11/29.
//

import SwiftUI

@main
struct ViewBuildersApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}

struct Test_Previews: PreviewProvider {
  
  static var previews: some View {
    TestView()
  }
  
  struct TestView: View {
    
    var body: some View {
      Circle()
        .fill(.blue)
        .frame(width: 200, height: 300)
        .frame(width: .infinity)
        .border(.green)
    }
  }
  
}
