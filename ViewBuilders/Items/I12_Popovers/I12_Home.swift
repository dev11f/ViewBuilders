//
//  I12_Home.swift
//  ViewBuilders
//
//  Created by kook on 2023/02/14.
//

import SwiftUI

struct I12_Home: View {
  @State private var showPopover: Bool = false
  @State private var updateText: Bool = false
  
  var body: some View {
    Button("Show Popover") {
      showPopover.toggle()
    }
    .iOSPopover(isPresented: $showPopover, arrowDirection: .up) {
      VStack(spacing: 12) {
        Text("Hello, it's me, \(updateText ? "Updated Popover" : "Popover").")
        Button("Update Text") {
          updateText.toggle()
        }
        Button("Close Popover") {
          showPopover.toggle()
        }
      }
      .padding(15)
      // You can give the width
      .frame(width: 250)
      // You can give color
      .background {
        Rectangle()
          .fill(.yellow.gradient)
          .padding(-20)
      }
    }
  }
}

struct I12_Home_Previews: PreviewProvider {
  static var previews: some View {
    I12_Home()
  }
}

/// 기본적으로 popover는 macOS와 iPadOS에만 있다.
/// 그래서 iOS는 별도로 만들어줘야 한다.
fileprivate extension View {
  
  @ViewBuilder
  func iOSPopover<Content: View>(isPresented: Binding<Bool>, arrowDirection: UIPopoverArrowDirection, @ViewBuilder content: @escaping () -> Content) -> some View {
    self
      .background {
        PopOverController(isPresented: isPresented, arrowDirection: arrowDirection, content: content())
      }
  }
  
}

/// - Popover Helper
fileprivate struct PopOverController<Content: View>: UIViewControllerRepresentable {
  @Binding var isPresented: Bool
  var arrowDirection: UIPopoverArrowDirection
  var content: Content
  
  @State private var alreadyPresented: Bool = false
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(parent: self)
  }
  
  func makeUIViewController(context: Context) -> UIViewController {
    let controller = UIViewController()
    controller.view.backgroundColor = .clear
    return controller
  }
  
  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    if alreadyPresented {
      // Updating SwiftUI View, when it's changed
      if let hostingController = uiViewController.presentedViewController as? CustomHostingView<Content> {
        hostingController.rootView = content
        // Updating View Size when it's Update
        // Or You can define your own size in SwiftUI View
        hostingController.preferredContentSize = hostingController.view.intrinsicContentSize
      }
      
      // Close View, if it's toggled Back
      if !isPresented {
        uiViewController.dismiss(animated: true) {
          alreadyPresented = false
        }
      }
    } else {
      if isPresented {
        let controller = CustomHostingView(rootView: content)
        controller.view.backgroundColor = .clear
        controller.modalPresentationStyle = .popover
        controller.popoverPresentationController?.permittedArrowDirections = arrowDirection
        controller.presentationController?.delegate = context.coordinator
        // attach the source view so that it will show arrow at correct position
        controller.popoverPresentationController?.sourceView = uiViewController.view
        uiViewController.present(controller, animated: true)
      }
    }
  }
  
  // Forcing it to show Popover using PresentationDelegate
  class Coordinator: NSObject, UIPopoverPresentationControllerDelegate {
    var parent: PopOverController
    
    init(parent: PopOverController) {
      self.parent = parent
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
      return .none
    }
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
      parent.isPresented = false
    }
    
    func presentationController(_ presentationController: UIPresentationController, willPresentWithAdaptiveStyle style: UIModalPresentationStyle, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
      DispatchQueue.main.async {
        self.parent.alreadyPresented = true
      }
    }
  }
}

// Custom Hosting Controller for Wrapping to it's SwiftUI View Size
// 이거 안하면 Popover 창이 엄청 크게 나옴
class CustomHostingView<Content: View>: UIHostingController<Content> {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    preferredContentSize = view.intrinsicContentSize
  }
}
