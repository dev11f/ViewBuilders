//
//  I8_Home.swift
//  ViewBuilders
//
//  Created by kook on 2022/12/07.
//

import SwiftUI

struct I8_Home: View {
    
    var body: some View {
        ZStack {
            Color.black
            
            MatrixRainView()
        }
        .ignoresSafeArea()
    }
    
    // MARK: Matrix Rain View
    @ViewBuilder
    func MatrixRainView() -> some View {
        GeometryReader {
            let size = $0.size
            
            HStack(spacing: 15) {
                // Repeating the effects until it occupied the full screen
                // With the help of ForEach
                // For Count since our font size is 25 so width/fontSize will the give the count
                ForEach(1...Int(size.width / 25), id: \.self) { _ in
                   MatrixRainCharacters(size: size)
                }
            }
            .padding(.horizontal)
        }
    }
}

fileprivate struct MatrixRainCharacters: View {
    var size: CGSize
    // MARK: Animation Properteis
    @State private var startAnimation: Bool = false
    
    @State private var random: Int = 0
    
    var body: some View {
        
        // Random Height
        let randomHeight: CGFloat = .random(in: (size.height/2)...size.height)
        
        VStack {
            // MARK: Iterating String
            ForEach(0..<constant.count, id: \.self) { index in
                let character = Array(constant)[getRandomIndex(index: index)]
                
                Text(String(character))
                    .font(.custom("matrix code nfi", size: 25))
                    .foregroundColor(Color("I8_Green"))
            }
        }
        // Fade like Animation Using Mask
        .mask(alignment: .top) {
            Rectangle()
                .fill(
                    LinearGradient(colors: [
                        .clear,
                        .black.opacity(0.1),
                        .black.opacity(0.2),
                        .black.opacity(0.3),
                        .black.opacity(0.5),
                        .black.opacity(0.7),
                        .black
                    ], startPoint: .top, endPoint: .bottom)
                )
                .frame(height: size.height / 2)
                // Animating To Look like coming from Top
                .offset(y: startAnimation ? size.height : -randomHeight)
        }
        .onAppear {
            // Moving Slowly down with linear Animation
            // Endless loop without reversing
            // Random delay for more fluent Effect
            withAnimation(.linear(duration: 12).delay(.random(in: 0...2)).repeatForever(autoreverses: false)) {
                startAnimation = true
            }
        }
        // Timer
        .onReceive(Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()) { _ in
            random = Int.random(in: 0..<constant.count)
        }
    }
    
    // Changing Characters randomly with the help of Timer
    func getRandomIndex(index: Int) -> Int {
        // To avoid index out bound range
        let max = constant.count - 1
        
        if (index + random) > max {
            if (index - random) < 0 {
                return index
            }
            return index - random
        } else {
            return index + random
        }
    }
}

struct I8_Home_Previews: PreviewProvider {
    static var previews: some View {
        I8_Home()
    }
}

// MARK: Random Characters
fileprivate let constant = "abcdefghijklmnopqrstuvwxyzabcquepaje123jdj09"
