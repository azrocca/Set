//
//  CardAnimation.swift
//  Set
//
//  Created by Rocca on 7/20/21.
//

import SwiftUI

struct CardAnimation: AnimatableModifier {
    init(isSelected: Bool, isDisplayed: Bool, opacity: Double = 1, isMatchFound: Bool, isNotTrueMatch: Bool) {
        self.isSelected = isSelected
        self.isDisplayed = isDisplayed
        self.opacity = opacity
        self.isMatchFound = isMatchFound
        self.isNotTrueMatch = isNotTrueMatch
        self.rotation = isDisplayed ? 0 : 180
    }
    
    let shape = RoundedRectangle(cornerRadius: DrawingConstants.cardCornerRadius, style: .continuous)
    
    var isSelected: Bool
    var isDisplayed: Bool
    
    var isMatchFound: Bool
    var isNotTrueMatch: Bool
    
    var rotation: Double
    var opacity: Double
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
//    var offset: Double {
//        (rotation - 90) / 90 * 5
//    }
    
    func body(content: Content) -> some View {
        Group {
            if rotation < 90 {
                content
//                    .offset(x: (isNotTrueMatch && isSelected) ? CGFloat(offset) : 0)
            } else {
                ZStack {
                    shape
                        .fill()
                        .foregroundColor(DrawingConstants.cardBackColor)
                    shape
                        .strokeBorder(lineWidth: DrawingConstants.cardLineWidth, antialiased: true)
                        .foregroundColor(.white)
                }
            }
        }
        .opacity(opacity)
//        .rotationEffect(Angle.degrees(rotation))
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
}

extension AnyTransition {
    static func spinCard(_ card: ClassicSetGame.ClassicCard) -> AnyTransition {
        return AnyTransition.modifier(
            active: CardAnimation(isSelected: card.isSelected, isDisplayed: false, opacity: 0, isMatchFound: false, isNotTrueMatch: false),
            identity: CardAnimation(isSelected: card.isSelected, isDisplayed: true, opacity: 1, isMatchFound: false, isNotTrueMatch: false))
    }
}
