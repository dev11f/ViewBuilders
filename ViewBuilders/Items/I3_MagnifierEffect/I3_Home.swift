//
//  I3_Home.swift
//  ViewBuilders
//
//  Created by kook on 2022/11/30.
//

import SwiftUI

struct I3_Home: View {
    // MARK: Magnification Properties
    @State private var scale: CGFloat = 0
    @State private var rotation: CGFloat = 0
    @State private var size: CGFloat = 0
    @State private var hideGlass: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader {
                let size = $0.size
                
                Image("I3_wallpaper")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.width, height: size.height)
                    /// Adding Magnification Modifier
                    .magnificationEffect(scale, rotation, self.size, .black, hideGlass)
            }
            .padding(50)
            .contentShape(Rectangle())
            
            // MARK: Customization Options
            VStack(alignment: .leading, spacing: 0) {
                Text("Customizations")
                    .fontWeight(.medium)
                    .foregroundColor(.black.opacity(0.5))
                    .padding(.bottom, 20)
                
                HStack(spacing: 14) {
                    Text("Scale")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(width: 35, alignment: .leading)
                    
                    Slider(value: $scale)
                    
                    Text("Rotation")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Slider(value: $rotation)
                }
                .tint(.black)
                
                HStack(spacing: 14) {
                    Text("Size")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(width: 35, alignment: .leading)
                    
                    Slider(value: $size, in: -20...100)
                }
                .tint(.black)
                .padding(.top)
                
                HStack(spacing: 14) {
                    Text("Hide Glass")
                        .font(.caption)
                        .foregroundColor(.black.opacity(0.5))
                    
                    Toggle("", isOn: $hideGlass)
                }
                .padding(.top)
            }
            .padding(15)
            .background {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.white)
                    .ignoresSafeArea()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.black
                .opacity(0.08)
                .ignoresSafeArea()
        }
    }
}

struct I3_Home_Previews: PreviewProvider {
    static var previews: some View {
        I3_Home()
    }
}

// MARK: Custom View Modifier
fileprivate extension View {

    @ViewBuilder
    func magnificationEffect(_ scale: CGFloat, _ rotation: CGFloat, _ size: CGFloat = 0,
                             _ tint: Color = .white, _ hideGlass: Bool = false) -> some View {
        MagnificationEffectHelper(scale: scale, rotation: rotation, size: size,
                                  tint: tint, hideGlass: hideGlass) {
            self
        }
    }
}

// MARK: Magnification Effect Helper
fileprivate struct MagnificationEffectHelper<Content: View>: View {
    var scale: CGFloat
    var rotation: CGFloat
    var size: CGFloat
    var tint: Color
    var hideGlass: Bool
    var content: Content
    
    init(scale: CGFloat, rotation: CGFloat, size: CGFloat,
         tint: Color = .white,
         hideGlass: Bool = false,
         @ViewBuilder content: @escaping () -> Content) {
        self.scale = scale
        self.rotation = rotation
        self.size = size
        self.tint = tint
        self.hideGlass = hideGlass
        self.content = content()
    }
    
    // MARK: Gesture Properties
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    
    var body: some View {
        content
            // MARK: Applying Reverse Mask For Clipping the Current Highlighting Spot
            .reverseMask(content: {
                let newCircleSize = 150 + size
                Circle()
                    .frame(width: newCircleSize, height: newCircleSize)
                    .offset(offset)
            })
            .overlay {
                GeometryReader {
                    let newCircleSize = 150 + size
                    let size = $0.size
                    
                    content
                        // Clipping it into Circle Form
                        // Moving Content Inside (Reversing)
                        .offset(x: -offset.width, y: -offset.height)
                        .frame(width: newCircleSize, height: newCircleSize)
                        // Apply Scaling Here
                        .scaleEffect(1 + scale)
                        .clipShape(Circle())
                        // Applying Offset
                        .offset(offset)
                        // Making it Center
                        .frame(width: size.width, height: size.height)
                    
                    // MARK: Optional Magnifyingglass Image Overlay
                    if !hideGlass {
                        Circle()
                            .fill(.clear)
                            .frame(width: newCircleSize, height: newCircleSize)
                            .overlay(alignment: .topLeading) {
                                Image(systemName: "magnifyingglass")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(1.4, anchor: .topLeading)
                                    .offset(x: -10, y: -5)
                                    .foregroundColor(tint)
                            }
                            .rotationEffect(.init(degrees: rotation * 360.0))
                            .offset(offset)
                            .frame(width: size.width, height: size.height)
                    }
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        offset = CGSize(width: value.translation.width + lastStoredOffset.width,
                                        height: value.translation.height + lastStoredOffset.height)
                    }).onEnded({ _ in
                        lastStoredOffset = offset
                    })
            )
    }
}

fileprivate extension View {
    
    // MARK: ReverseMask Modifier
    @ViewBuilder
    func reverseMask<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .mask {
                Rectangle()
                    .overlay {
                        content()
                            .blendMode(.destinationOut)
                    }
            }
    }
}
