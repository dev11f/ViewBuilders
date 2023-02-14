//
//  I7_Home.swift
//  ViewBuilders
//
//  Created by kook on 2022/12/07.
//

import SwiftUI

struct I7_Home: View {
  // MARK: GlassMorphism Properties
  @State private var blurView: UIVisualEffectView = .init()
  @State private var defaultBlurRadius: CGFloat = 0
  @State private var defaultSaturationAmount: CGFloat = 0

  @State private var activateGlassMorphism: Bool = false

  var body: some View {
    ZStack {
      Color("I7_BG")
        .ignoresSafeArea()

      Circle()
        .fill(LinearGradient(colors: [.pink, .purple, .indigo],
                             startPoint: .bottomLeading, endPoint: .topTrailing))
        .frame(width: 200, height: 200)
        .offset(x: 150, y: -90)

      Circle()
        .fill(LinearGradient(colors: [.red, .pink, .pink],
                             startPoint: .bottomLeading, endPoint: .topTrailing))
        .frame(width: 130, height: 130)
        .offset(x: -150, y: 90)

      Circle()
        .fill(LinearGradient(colors: [.red, .pink],
                             startPoint: .bottomLeading, endPoint: .topTrailing))
        .frame(width: 60, height: 60)
        .offset(x: -40, y: -100)

      GlassMorphicCard()

      // MARK: Toggle To Apply
      Toggle("Activate Glass Morphism", isOn: $activateGlassMorphism)
        .font(.title3)
        .foregroundColor(.white)
        .fontWeight(.semibold)
        .onChange(of: activateGlassMorphism) { newValue in
          // Changing Blur Radius And Saturation
          blurView.gaussianBlurRadius = (activateGlassMorphism ? 10 : defaultBlurRadius)
          blurView.saturationAmount = (activateGlassMorphism ? 1.8 : defaultSaturationAmount)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(15)

    }
  }

  // MARK: GlassMorphism Card
  @ViewBuilder
  func GlassMorphicCard() -> some View {
    ZStack {
      CustomBlurView(effect: .systemUltraThinMaterialDark) { view in
        blurView = view
        if defaultBlurRadius == 0 {
          defaultBlurRadius = view.gaussianBlurRadius
        }
        if defaultSaturationAmount == 0 {
          defaultSaturationAmount = view.saturationAmount
        }
      }
      .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))

      // MARK: Building Glassmorphic Card
      RoundedRectangle(cornerRadius: 25, style: .continuous)
        .fill(
          .linearGradient(colors: [
            .white.opacity(0.25),
            .white.opacity(0.05),
            .clear
          ], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .blur(radius: 5)

      // MARK: Borders
      RoundedRectangle(cornerRadius: 25, style: .continuous)
        .stroke(
          .linearGradient(colors: [
            .white.opacity(0.6),
            .clear,
            .purple.opacity(0.2),
            .purple.opacity(0.5)
          ], startPoint: .topLeading, endPoint: .bottomTrailing),
          lineWidth: 2
        )
    }
    // MARK: Shadows
    .shadow(color: .black.opacity(0.15), radius: 5, x: -10, y: 10)
    .shadow(color: .black.opacity(0.15), radius: 5, x: 10, y: -10)
    .overlay(content: {
      // MARK: Card Content
      CardContent()
        .opacity(activateGlassMorphism ? 1 : 0)
        .animation(.easeIn(duration: 0.5), value: activateGlassMorphism)
    })
    .padding(.horizontal, 25)
    .frame(height: 220)
  }

  @ViewBuilder
  func CardContent() -> some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Text("MEMBERSHIP")
          .modifier(CustomModifier(font: .callout))

        Image("I7_Logo")
          .resizable()
          .renderingMode(.template)
          .foregroundColor(.white)
          .aspectRatio(contentMode: .fit)
          .frame(width: 40, height: 40)
      }

      Spacer()

      Text("Kook Hyoungbin")
        .modifier(CustomModifier(font: .title3))

      Text("KAVSOFT")
        .modifier(CustomModifier(font: .callout))
    }
    .padding(20)
    .padding(.vertical, 10)
    .blendMode(.overlay )
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  }
}

// MARK: Custom Modifier Since Most of the Text Shares same Modifiers
fileprivate struct CustomModifier: ViewModifier {
  var font: Font

  func body(content: Content) -> some View {
    content
      .font(font)
      .fontWeight(.semibold)
      .foregroundColor(.white)
      .kerning(1.2)
      .shadow(radius: 15)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
}

struct I7_Home_Previews: PreviewProvider {
  static var previews: some View {
    I7_Home()
  }
}

// MARK: Custom Blur View
// With The Help of UIVisualEffect View
fileprivate struct CustomBlurView: UIViewRepresentable {
  var effect: UIBlurEffect.Style
  var onChange: (UIVisualEffectView) -> Void

  func makeUIView(context: Context) -> UIVisualEffectView {
    UIVisualEffectView(effect: UIBlurEffect(style: effect))
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {
    DispatchQueue.main.async {
      onChange(uiView)
    }
  }
}

// MARK: Adjusting Blur Radius in UIVisualEffectView
fileprivate extension UIVisualEffectView {
  // MARK: Steps
  // Extracting Private Class BackDropView Class
  // Then From that View Extracting ViewEffects like Gaussian Blur & Saturation
  // With the Help of this we can Achieve Glass Morphism
  var backDrop: UIView? {
    // PRIVATE CLASS
    subView(forClass: NSClassFromString("_UIVisualEffectBackdropView"))
  }

  // MARK: Extracting Gaussian Blur From BackDropView
  var gaussianBlur: NSObject? {
    backDrop?.value(key: "filters", filter: "gaussianBlur")
  }

  // MARK: Extracting Saturation Blur From BackDropView
  var saturation: NSObject? {
    backDrop?.value(key: "filters", filter: "colorSaturate")
  }

  // MARK: Updating Blur Radius And Saturation
  var gaussianBlurRadius: CGFloat {
    get {
      // MARK: We Know The Key for Gaussian Blur = "inputRadius"
      return gaussianBlur?.values?["inputRadius"] as? CGFloat ?? 0
    }
    set {
      gaussianBlur?.values?["inputRadius"] = newValue
      applyNewEffects()
    }
  }

  var saturationAmount: CGFloat {
    get {
      // MARK: We Know The Key for Gaussian Blur = "inputAmount"
      return saturation?.values?["inputAmount"] as? CGFloat ?? 0
    }
    set {
      saturation?.values?["inputAmount"] = newValue
      applyNewEffects()
    }
  }

  func applyNewEffects() {
    // Updating the Backdrop View with the New Filter Updates
    UIVisualEffectView.animate(withDuration: 0.5) {
      self.backDrop?.perform(Selector(("applyRequestedFilterEffects")))
    }
  }
}

// MARK: Finding Subview for Class
fileprivate extension UIView {
  func subView(forClass: AnyClass?) -> UIView? {
    subviews.first { view in
      type(of: view) == forClass
    }
  }
}

// MARK: Custom Key Filtering
fileprivate extension NSObject {
  // MARK: Key Values From NSObject
  var values: [String: Any]? {
    get {
      value(forKeyPath: "requestedValues") as? [String: Any]
    }
    set {
      setValue(newValue, forKeyPath: "requestedValues")
    }
  }


  func value(key: String, filter: String) -> NSObject? {
    (value(forKey: key) as? [NSObject])?.first(where: { obj in
      return obj.value(forKeyPath: "filterType") as? String == filter
    })
  }
}
