//
//  CardView.swift
//  Set
//
//  Created by Rocca on 7/11/21.
//

import SwiftUI

struct CardView: View {
    let card: ClassicSetGame.ClassicCard
    
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: DrawingConstants.cardCornerRadius, style: .continuous)
        let cardBorderWidth = card.isSelected ? DrawingConstants.selectedCardLineWidth : DrawingConstants.cardLineWidth
        let cardBorderColor = card.isSelected ? DrawingConstants.selectedCardBorderColor : DrawingConstants.cardBorderColor
            ZStack {
                shape
                    .fill()
                    .foregroundColor(.white)
                if card.isSelected { // apply shadow if selected
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
                SetView(card: card).scaleEffect(DrawingConstants.shapeScaleFactor)
            }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let currentCard = ClassicSetGame.ClassicCard(
            color: setColor.purple,
            shape: setShape.squiggle,
            shading: setShading.striped,
            number: setNumber.three,
            isSelected: true,
            isDisplayed: true)
        CardView(card: currentCard)
    }
}
