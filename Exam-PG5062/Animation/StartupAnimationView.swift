//
//  StartupAnimationView.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 27/11/2023.
//

import SwiftUI
struct StartupAnimationView: View {
    @State private var hatPosition = CGPoint(x: UIScreen.main.bounds.midX, y: -500)
    var onAnimationCompleted: (() -> Void)?
    @State private var rotationAngle: Angle = .degrees(0)
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    
    var body: some View {
        ZStack {
            Image("remy")
                .resizable()
                .scaledToFit()
                .scaleEffect(scale)
                    .opacity(opacity)
                

            Image("derpHat")
                .resizable()
                .scaledToFit()
                .position(hatPosition)
                .rotationEffect(rotationAngle)
                .scaleEffect(scale)
                    .opacity(opacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1)) {
                        hatPosition = CGPoint(x: 190, y: 14)
                        rotationAngle = .degrees(24)
                    }
                    withAnimation(.easeInOut(duration: 0.3).delay(1.5)) {
                            scale = 2.0
                            opacity = 0
                        
                    }
                }
            Text("RaTaToUiLlE")
                .position(CGPoint(x: UIScreen.main.bounds.midX, y: 490))
                .bold()
                .foregroundColor(Theme.ColoredText)
                .font(.system(size: 40))
                .opacity(opacity)
        }
        .frame(width: 300, height: 300)
        .onChange(of: hatPosition) { newPosition in
            if newPosition.y == 14 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    onAnimationCompleted?()
                    
                }
            }
        }
    }
}
