//
//  SetView.swift
//  Set
//
//  Created by Rocca on 7/9/21.
//

import SwiftUI

struct SetView: View {
    let card: ClassicSetGame.ClassicCard
    
    var cardShapeView: some Shape {
        switch card.shape {
        case .diamond:
            return AnyShape(Diamond())
        case .oval:
            return AnyShape(Oval())
        case .squiggle:
            return AnyShape(Squiggle().scale(x: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/, y: 0.75, anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/))
        }
    }
    
    var body: some View {
        VStack {
            ForEach(0..<card.number.rawValue+2, id: \.self) {_ in
                GeometryReader { geometry in
                    ZStack {
                        switch card.shading {
                        case .open:
                            cardShapeView
                                .stroke(card.color.getColor(), lineWidth: DrawingConstants.shapeStrokeWidth)
                        case .solid:
                            cardShapeView
                                .stroke(card.color.getColor(), lineWidth: DrawingConstants.shapeStrokeWidth)
                                .background(cardShapeView.fill(card.color.getColor()))
                        case .striped:
                            Line()
                                .stroke(
                                    card.color.getColor(),
                                    style:
                                        StrokeStyle(
                                            lineWidth: max(geometry.size.width, geometry.size.height),
                                            dash: [DrawingConstants.stripedWidth, DrawingConstants.stripedGapWidth]))
                                .clipShape(cardShapeView)
                            cardShapeView
                                .stroke(card.color.getColor(), lineWidth: DrawingConstants.shapeStrokeWidth)
                        }
                    }
                }.aspectRatio(2, contentMode: .fit)
            }
        }
    }
}

struct AnyShape: Shape {
    init<S: Shape>(_ wrapped: S) {
        _path = { rect in
            let path = wrapped.path(in: rect)
            return path
        }
    }
    
    func path(in rect: CGRect) -> Path {
        return _path(rect)
    }
    
    private let _path: (CGRect) -> Path
}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        let currentCard = ClassicSetGame.ClassicCard(
            color: setColor.purple,
            shape: setShape.squiggle,
            shading: setShading.striped,
            number: setNumber.three,
            isSelected: true,
            isDisplayed: true)
        SetView(card: currentCard)
    }
}
