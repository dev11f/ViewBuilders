//
//  I4_Home.swift
//  ViewBuilders
//
//  Created by kook on 2022/11/30.
//

import SwiftUI
import RealityKit
import ARKit

struct I4_Home: View {
  var body: some View {
    I4_ARViewContainer()
      .edgesIgnoringSafeArea(.all)
  }
}

fileprivate struct I4_ARViewContainer: UIViewRepresentable {
  
  func makeUIView(context: Context) -> ARView {
    
    let arView = ARView(frame: .zero)
    
    let config = ARFaceTrackingConfiguration()
    config.frameSemantics.insert(.personSegmentation)
    arView.session.run(config)
    
    let textAnchor = AnchorEntity(.camera)
    textAnchor.addChild(textGen(textString: getTime()))
    arView.scene.addAnchor(textAnchor)
    
    return arView
  }
  
  func updateUIView(_ uiView: ARView, context: Context) {
    
  }
  
  private func textGen(textString: String) -> ModelEntity {
    
    var meterial = UnlitMaterial(color: .black)
    meterial.blending = .transparent(opacity: 0.8)
    
    let depth: Float = 0.005
    let font = UIFont.systemFont(ofSize: 0.15, weight: .bold, width: .standard)
    let frame = CGRect(x: -0.4, y: 0.0, width: 0.8, height: 0.4)
    
    let textMeshResource = MeshResource.generateText(textString,
                                                     extrusionDepth: depth,
                                                     font: font,
                                                     containerFrame: frame,
                                                     alignment: .center,
                                                     lineBreakMode: .byCharWrapping)
    let textEntity = ModelEntity(mesh: textMeshResource, materials: [meterial])
    textEntity.transform.translation = [0, 0.1, -0.9]
    
    return textEntity
  }
  
  private func getTime() -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    
    var dateString = formatter.string(from: Date())
    dateString.removeLast(3)
    
    return dateString
  }
}

struct I4_Home_Previews: PreviewProvider {
  static var previews: some View {
    I4_Home()
  }
}
