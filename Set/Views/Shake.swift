//
//  Shake.swift
//  Set
//
//  Created by Rocca on 8/11/21.
//

import SwiftUI

struct Shake: AnimatableModifier {
    var shake: Bool
    var rotation: Double
    var angle: Double = 0
    
    init(shake: Bool, rotation: Double) {
        self.shake = shake
        self.rotation = rotation
        self.angle = shake ? 1 : 0
    }
    
    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(rotation * sin(2 * .pi * angle)))
    }
}

extension View {
    func shake(shake: Bool, rotation: Double) -> some View {
        self.modifier(Shake(shake: shake, rotation: rotation))
    }
}
