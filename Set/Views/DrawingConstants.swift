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
    static let cardBorderColor = Color.gray
    static let selectedCardBorderColor = Color.black
    static let selectedCardShadowColor = Color.gray
    static let selectedCardShadowRadius: CGFloat = 2
    static let selectedCardShadowOffsetX: CGFloat = 1.5
    static let selectedCardShadowOffsetY: CGFloat = 1.5
    static let minCardWidth: CGFloat = 40
    // text constants
    static let messageFontColor = Color.orange
}
