//
//  Shimmer.swift
//  Set
//
//  Created by Rocca on 8/11/21.
//

import SwiftUI

struct Shimmer: AnimatableModifier {
    
    var control: Bool
    
    init(control: Bool, color shimmerColor: Color, width offset: CGFloat) {
        self.control = control
        self.shimmerColor = shimmerColor
        self.position = control ? offset : -offset
    }
    
    var position: CGFloat
    var shimmerColor: Color
    
    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            content
            if control {
                shimmerColor
                    .mask(
                        Rectangle()
                            .fill(gradient)
                            .scaleEffect(CGSize(width: DrawingConstants.scale, height: 1.0))
                            .rotationEffect(.init(degrees: DrawingConstants.rotation))
                            .offset(x: position)
                    )
            } else {
                Color.clear
            }
        }
    }
    
    // shimmer view parameters
    
    let colors = [Color.clear, Color.white.opacity(DrawingConstants.colorOpacity), Color.white.opacity(DrawingConstants.colorOpacity), Color.clear]
    
    var gradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
    }
    
    struct DrawingConstants {
        static let rotation = 110.0
        static let colorOpacity = 0.6
        static let scale: CGFloat = 3
    }
}

extension View {
    func shimmer(control: Bool, color: Color, width: CGFloat) -> some View {
        self.modifier(Shimmer(control: control, color: color, width: width))
    }
}

