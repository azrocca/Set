//
//  DrawingConstants.swift
//  Set
//
//  Created by Rocca on 7/11/21.
//

import SwiftUI

struct DrawingConstants {
    // shape constants
    static let stripedWidth: CGFloat = 1
    static let stripedGapWidth: CGFloat = 3
    static let shapeScaleFactor: CGFloat = 0.75
    static let shapeStrokeWidth: CGFloat = 3
    // card constants
    static let cardAspectRatio: CGFloat = 2/3
    static let cardCornerRadius: CGFloat = 8
    static let paddingBetweenCards: CGFloat = 3
    static let cardLineWidth: CGFloat = 2
    static let selectedCardLineWidth: CGFloat = 2
    static let cardBackColor = Color(#colorLiteral(red: 0.7797397131, green: 0.8400355774, blue: 0.9244036118, alpha: 1))
    static let cardBorderColor = Color.gray
    static let selectedCardBorderColor = Color.black
    static let selectedCardBorderColorBlackCard = Color.white
    static let selectedCardDarkModeBorderColor = Color(#colorLiteral(red: 0, green: 0.920794487, blue: 0.9735403657, alpha: 1))
    static let selectedCardShadowColor = Color.gray
    static let selectedCardShadowRadius: CGFloat = 2
    static let selectedCardShadowOffsetX: CGFloat = 1.5
    static let selectedCardShadowOffsetY: CGFloat = 1.5
    static let minCardWidth: CGFloat = 40
    static let undealtHeight: CGFloat = 80
    static let undealtWidth = undealtHeight * cardAspectRatio
    static let totalDeckOffset: CGFloat = 10
    static let maxDeckRotationAngle: Double = 10.0
    // text constants
    static let messageFontColor = Color.orange
    // annimation constants
    static let defaultAnimationDuration: Double = 2
    static let dealDuration: Double = 0.25
    static let flipDuration: Double = 0.5
    static let totalDealDelayDuration: Double = 0.75
    static let notMatchShakeRotationDegrees: Double = 5
}
