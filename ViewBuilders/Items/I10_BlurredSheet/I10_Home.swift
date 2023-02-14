//
//  I10_Home.swift
//  ViewBuilders
//
//  Created by kook on 2022/12/14.
//

import SwiftUI
import MapKit

struct I10_Home: View {
  @State private var showSheet = false
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      // MARK: Sample Map Region
      let region = MKCoordinateRegion(center: .init(latitude: 37.496486063, longitude: 127.028361548),
                                      latitudinalMeters: 10000, longitudinalMeters: 10000)
      Map(coordinateRegion: .constant(region))
        .ignoresSafeArea()
      // 백스와이프를 위해서 disabled
        .disabled(true)
      
      // MARK: Sheet Button
      Button {
        showSheet.toggle()
      } label: {
        Image(systemName: "dock.rectangle")
          .font(.title2)
          .fontWeight(.semibold)
      }
      .padding(15)
      .blurredSheet(.init(.ultraThinMaterial), show: $showSheet) {
        
      } content: {
        Text("Hello World!!")
          .presentationDetents([.large, .medium, .height(150)])
      }
      
    }
  }
}

struct I10_Home_Previews: PreviewProvider {
  static var previews: some View {
    I10_Home()
  }
}

fileprivate extension View {
  // MARK: Custom View Modifier
  func blurredSheet<Content: View>(_ style: AnyShapeStyle, show: Binding<Bool>, onDismiss: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) -> some View {
    self
    //.fullScreenCover(isPresented: show, onDismiss: onDismiss) {
      .sheet(isPresented: show, onDismiss: onDismiss) {
        content()
          .background(RemovebackgroundColor())
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background {
            Rectangle()
              .fill(style)
              .ignoresSafeArea(.container, edges: .all)
          }
      }
  }
}

// MARK: Helper View
fileprivate struct RemovebackgroundColor: UIViewRepresentable {
  func makeUIView(context: Context) -> UIView {
    return UIView()
  }
  
  func updateUIView(_ uiView: UIView, context: Context) {
    DispatchQueue.main.async {
      uiView.superview?.superview?.backgroundColor = .clear
    }
  }
}
