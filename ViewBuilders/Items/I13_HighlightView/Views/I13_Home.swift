//
//  I13_Home.swift
//  ViewBuilders
//
//  Created by kook on 2023/05/13.
//

import SwiftUI
import MapKit

struct I13_Home: View {
  /// Apple Park Region
  @State private var region = MKCoordinateRegion(
    center: .init(latitude: 37.3346, longitude: -122.0090),
    latitudinalMeters: 1000,
    longitudinalMeters: 1000)
  
  var body: some View {
    TabView {
      GeometryReader {
        let safeArea = $0.safeAreaInsets
        
        Map(coordinateRegion: $region)
          /// Top Safe Area Material View
          .overlay(alignment: .top, content: {
            Rectangle()
              .fill(.ultraThinMaterial)
              .frame(height: safeArea.top)
          })
          .ignoresSafeArea()
          .overlay(alignment: .topTrailing) {
            /// Sample Button
            VStack {
              Button {
                
              } label: {
                Image(systemName: "location.fill")
                  .foregroundColor(.white)
                  .padding(10)
                  .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                      .fill(.black)
                  }
              }
              .I13_showCase(
                order: 0,
                title: "My Current Location",
                cornerRadius: 10
              )
              
              Spacer()
              
              Button {
                
              } label: {
                Image(systemName: "suit.heart.fill")
                  .foregroundColor(.white)
                  .padding(10)
                  .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                      .fill(.red)
                  }
              }
              .I13_showCase(
                order: 1,
                title: "Favorite Location's",
                cornerRadius: 10
              )
            }
            .padding(15)
          }
      }
      .tabItem {
        Image(systemName: "macbook.and.iphone")
        Text("Devices")
      }
      .toolbarBackground(.visible, for: .tabBar)
      .toolbarBackground(.ultraThinMaterial, for: .tabBar)
      
      Text("")
        .tabItem {
          Image(systemName: "square.grid.2x2.fill")
          Text("Items")
        }
      
      Text("")
        .tabItem {
          Image(systemName: "person.circle.fill")
          Text("Me")
        }
    }
    /// Tab Item 위치를 바로 가져올 수 없어서 따로 만듦
    .overlay(alignment: .bottom, content: {
      HStack(spacing: 0) {
        Circle()
          .foregroundColor(.clear)
          .frame(width: 45, height: 45)
          .I13_showCase(
            order: 2,
            title: "My Devices",
            cornerRadius: 10
          )
          .frame(maxWidth: .infinity)
        
        Circle()
          .foregroundColor(.clear)
          .frame(width: 45, height: 45)
          .I13_showCase(
            order: 4,
            title: "Location Enabled Tag's",
            cornerRadius: 10
          )
          .frame(maxWidth: .infinity)
        
        Circle()
          .foregroundColor(.clear)
          .frame(width: 45, height: 45)
          .I13_showCase(
            order: 3,
            title: "Personal Info",
            cornerRadius: 10
          )
          .frame(maxWidth: .infinity)
      }
      /// Disabling User Interactions
      .allowsHitTesting(false)
    })
    /// Call this Modifier on the top of the current view, also it must be called once.
    .modifier(I13_ShowCaseRoot(showHighlights: true, onFinished: {
      print("Finished OnBoarding")
    }))
  }
}

struct I13_Home_Previews: PreviewProvider {
  static var previews: some View {
    I13_Home()
  }
}
