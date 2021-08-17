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
        ZStack {
            SetView(card: card)
                .scaleEffect(DrawingConstants.shapeScaleFactor)
                .cardify(cardBackgroundColor: card.background.getColor(), isSelected: card.isSelected, isDisplayed: card.isDisplayed)
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
            background: setBackground.white,
            isSelected: false,
            isDisplayed: false)
        CardView(card: currentCard)
    }
}
