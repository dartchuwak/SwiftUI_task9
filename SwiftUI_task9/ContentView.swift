//
//  ContentView.swift
//  SwiftUI_task9
//
//  Created by Evgenii Mikhailov on 24.12.2023.
//

import SwiftUI

struct ContentView: View {
    @State var drag: CGSize = .zero

    var body: some View {
        VStack {
            ZStack {
                MetaBall(color: .cyan)
                Image(systemName: "cloud.sun.rain.fill")
                    .foregroundStyle(Color.white)
                    .symbolRenderingMode(.hierarchical)
                    .font(.system(size: 24))
                    .frame(width: 80, height: 80)
                    .offset(drag)
            }
            .background(.black)

        }
        .ignoresSafeArea(.all)
    }

    @ViewBuilder
    func MetaBall(color: Color) -> some View {

        Rectangle().fill(.radialGradient(colors: [.yellow, .red], center: .center, startRadius: 50, endRadius: 100))
            .mask {
                Canvas { contex, size in
                    contex.addFilter(.alphaThreshold(min: 0.5, color: color))
                    contex.addFilter(.blur(radius: 30))
                    contex.drawLayer { ctx in
                        for index in [1,2] {
                            if let resolvedView = contex.resolveSymbol(id: index) {
                                ctx.draw(resolvedView, at: CGPoint(x: size.width/2, y: size.height/2))
                            }
                        }
                    }
                } symbols: {
                    Ball()
                        .tag(1)
                    Ball(offset: drag)
                        .tag(2)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        drag = value.translation
                    })
                    .onEnded({ value in
                        withAnimation {
                            drag = .zero
                        }

                    })
            )
    }

    @ViewBuilder
    func Ball(offset: CGSize = .zero) -> some View {
        Circle()
            .frame(width: 100, height: 100)
            .offset(offset)
    }
    @ViewBuilder
    func BallWithImage(offset: CGSize = .zero) -> some View {

        Circle()
            .frame(width: 100, height: 100)

            .offset(offset)
    }
}




#Preview {
    ContentView()
}
