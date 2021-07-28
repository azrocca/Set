//
//  Cardify.swift
//  Set
//
//  Created by Rocca on 7/17/21.
//

import SwiftUI

struct Cardify: ViewModifier {
    
    let cardBorderWidth: CGFloat
    let selectedBorderColor: Color
    let cardBorderColor: Color
    let cardBackgroundColor: Color
    
    var isSelected: Bool
    var isDisplayed: Bool
    
    init(cardBackgroundColor: Color, isSelected: Bool, isDisplayed: Bool) {
        self.cardBorderWidth = isSelected ? DrawingConstants.selectedCardLineWidth : DrawingConstants.cardLineWidth
        self.selectedBorderColor = (cardBackgroundColor == .black) ? DrawingConstants.selectedCardBorderColorBlackCard : DrawingConstants.selectedCardBorderColor
        self.cardBorderColor = isSelected ? selectedBorderColor : DrawingConstants.cardBorderColor
        self.cardBackgroundColor = cardBackgroundColor
        self.isSelected = isSelected
        self.isDisplayed = isDisplayed
    }
    
    let shape = RoundedRectangle(cornerRadius: DrawingConstants.cardCornerRadius, style: .continuous)
    
    func body(content: Content) -> some View {
        ZStack {
            shape
                .fill()
                .foregroundColor(cardBackgroundColor)
            if isSelected { // apply shadow if selected
                shape
                    .strokeBorder(lineWidth: cardBorderWidth, antialiased: true)
                    .foregroundColor(cardBorderColor)
                    .shadow(
                        color: DrawingConstants.selectedCardShadowColor,
                        radius: DrawingConstants.selectedCardShadowRadius,
                        x: DrawingConstants.selectedCardShadowOffsetX,
                        y: DrawingConstants.selectedCardShadowOffsetY)
            }
            shape
                .strokeBorder(lineWidth: cardBorderWidth, antialiased: true)
                .foregroundColor(cardBorderColor)
            content
        }
    }
}

extension View {
    func cardify(cardBackgroundColor: Color, isSelected: Bool, isDisplayed: Bool) -> some View {
        self.modifier(Cardify(cardBackgroundColor: cardBackgroundColor,
                              isSelected: isSelected,
                              isDisplayed: isDisplayed))
    }
}
