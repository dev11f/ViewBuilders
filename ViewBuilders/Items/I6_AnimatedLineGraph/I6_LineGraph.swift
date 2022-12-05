//
//  I6_LineGraph.swift
//  ViewBuilders
//
//  Created by kook on 2022/12/05.
//

import SwiftUI

struct I6_LineGraph: View {
    var data: [Double]
    var profit: Bool = false
    
    @State private var currentPlot = ""
    @State private var offset: CGSize = .zero
    @State private var showPlot = false
    @State private var transition: CGFloat = 0
    
    @GestureState var isDrag: Bool = false
    
    // Animating Graph
    @State private var graphProgress: CGFloat = 0
    
    var body: some View {
        GeometryReader { proxy in
            let height = proxy.size.height
            let width = (proxy.size.width) / CGFloat(data.count - 1)
            
            let maxPoint = (data.max() ?? 0)
            let minPoint = data.min() ?? 0
            
            let points = data.enumerated().compactMap { item -> CGPoint in
                let progress = (item.element - minPoint) / (maxPoint - minPoint)
                 
                let pathHeight = progress * (height - 50)
                let pathWidth = width * CGFloat(item.offset)
                
                // Since we need peak to top not bottom
                return CGPoint(x: pathWidth, y: -pathHeight + height)
            }
            
            ZStack {
                AnimatedGraphPath(progress: graphProgress, points: points)
                .fill(
                    // Gradient
                    LinearGradient(colors: [
                        profit ? Color("I6_Profit") : Color("I6_Loss"),
                        profit ? Color("I6_Profit") : Color("I6_Loss")
                    ], startPoint: .leading, endPoint: .trailing)
                )
                
                // Path Background Coloring
                FillBG()
                    .clipShape(
                        Path { path in
                            path.move(to: .zero)
                            path.addLines(points)
                            path.addLine(to: .init(x: proxy.size.width, y: height))
                            path.addLine(to: .init(x: 0, y: height))
                        }
                    )
                    .opacity(graphProgress)
                    //.padding(.top, 15)
            }
            .overlay(
                // Drag Indicator
                VStack(spacing: 0) {
                    Text(currentPlot)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.vertical, 6)
                        .frame(width: 100)
                        .background(Color("I6_Gradient1"), in: Capsule())
                        .offset(x: transition < 10 ? 30 : 0)
                        .offset(x: transition > (proxy.size.width - 60) ? -30 : 0)
                    
                    Rectangle()
                        .fill(Color("I6_Gradient1"))
                        .frame(width: 1, height: 45)
                        .padding(.top)
                    
                    Circle()
                        .fill(Color("I6_Gradient1"))
                        .frame(width: 22, height: 22)
                        .overlay {
                            Circle()
                                .fill(.white)
                                .frame(width: 10, height: 10)
                        }
                    
                    Rectangle()
                        .fill(Color("I6_Gradient1"))
                        .frame(width: 1, height: 55)
                }
                    // Fixed Frame for Gesture Calculation
                    .frame(width: 80, height: 170)
                    // 170 / 2 = 85 - 15 => circle ring size
                    .offset(y: 70)
                    .offset(offset)
                    .opacity(showPlot ? 1 : 0),
                alignment: .bottomLeading
            )
            .contentShape(Rectangle())
            .gesture(DragGesture().onChanged({ value in
                withAnimation { showPlot = true }
                
                let translation = value.location.x
                
                let index = max(min(Int((translation / width).rounded() +  1), data.count - 1), 0)
                currentPlot = data[index].convertToCurrency()
                self.transition = translation
                
                // removing half width
                offset = CGSize(width: points[index].x - 40, height: points[index].y - height)
            }).onEnded({ value in
                withAnimation { showPlot = false }
            }).updating($isDrag, body: { value, out, _ in
                out = true
            }))
        }
        .background(
            VStack(alignment: .leading) {
                let max = data.max() ?? 0
                let min = data.min() ?? 0
                
                Text(max.convertToCurrency())
                    .font(.caption.bold())
                    .foregroundColor(.white)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(min.convertToCurrency())
                        .font(.caption.bold())
                        .foregroundColor(.white)
                    
                    Text("Last 7 Days")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .offset(y: 25)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        )
        .padding(.horizontal, 10)
        .onChange(of: isDrag) { newValue in
            if !isDrag { showPlot = false }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 1.2)) {
                    graphProgress = 1
                }
            }
        }
        .onChange(of: data) { newValue in
            // MARK: ReAnimating When ever Plot Data Updates
            graphProgress = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 1.2)) {
                    graphProgress = 1
                }
            }
        }
    }
    
    @ViewBuilder
    func FillBG() -> some View {
        let color = profit ? Color("I6_Profit") : Color("I6_Loss")
        LinearGradient(colors:
                        [color.opacity(0.3),
                         color.opacity(0.2),
                         color.opacity(0.1)]
                       + Array(repeating: color.opacity(0.1), count: 4)
                       + Array(repeating: Color.clear, count: 2),
                       startPoint: .top, endPoint: .bottom)
    }
}

struct I6_LineGraph_Previews: PreviewProvider {
    static var previews: some View {
        I6_LineGraph(data: [13, 24, 12, 15.0, 72, 38, 64])
    }
}

// MARK: Animated Path
fileprivate struct AnimatedGraphPath: Shape {
    var progress: CGFloat
    var points: [CGPoint]
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: .zero)
            path.addLines(points)
        }
        .trimmedPath(from: 0, to: progress)
        .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
    }
}


// MARK: Converting Double to Currency
fileprivate extension Double {
    func convertToCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(from: .init(value: self)) ?? ""
    }
}
