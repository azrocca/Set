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
        self.shakeRotation = isNotTrueMatch && isSelected ? DrawingConstants.notMatchShakeRotationDegrees : 0
    }
    
    let shape = RoundedRectangle(cornerRadius: DrawingConstants.cardCornerRadius, style: .continuous)
    
    var isSelected: Bool
    var isDisplayed: Bool
    
    var isMatchFound: Bool
    var isNotTrueMatch: Bool
    
    var rotation: Double
    var opacity: Double
    var shakeRotation: Double
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var offset: CGFloat {
        // normalize rotation between -1 & 1 and then scale by factor
        CGFloat((rotation - 90) / 90 * 5)
    }
    
    var modifiedSetImage: some View {
        Image("LaunchIcon")
        .resizable()
        .scaledToFit()
        .rotationEffect(.degrees(-90))
        .rotation3DEffect(
            .degrees(180),
            axis: (0, 1, 0)
        )
    }
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            Group {
                if rotation < 90 {
                    content
                        // TODO: get both shimmer and shake to take effect when 3 cards are selected
                        .shimmer(control: isSelected, color: Color.gray, width: geometry.size.height)
//                        .shake(shake: isNotTrueMatch, offset: isSelected ? offset : 0)
                        .shake(shake: isNotTrueMatch, rotation: shakeRotation)
                } else {
                    ZStack {
                        shape
                            .fill()
                            .foregroundColor(DrawingConstants.cardBackColor)
                            .overlay(modifiedSetImage)
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
}

extension View {
    func cardAnimation(isSelected: Bool, isDisplayed: Bool, opacity: Double = 1, isMatchFound: Bool, isNotTrueMatch: Bool) -> some View {
        self.modifier(
            CardAnimation(isSelected: isSelected,
                          isDisplayed: isDisplayed,
                          opacity: opacity,
                          isMatchFound: isMatchFound,
                          isNotTrueMatch: isNotTrueMatch)
        )
    }
}
