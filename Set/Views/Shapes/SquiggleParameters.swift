//
//  SquiggleParameters.swift
//  Set
//
//  Created by Rocca on 7/9/21.
//

import CoreGraphics

struct SquiggleParameters {
    struct Segment {
        let line: CGPoint
        let control1: CGPoint
        let control2: CGPoint
    }
    
    static let adjustment: CGFloat = 0.0 //0.085
    static let xDenominator: CGFloat = 100
    static let yDenominator: CGFloat = 100
    
    static let segments = [
        Segment( // bottom right
            line:      CGPoint(x: 87 / xDenominator, y:  80 / yDenominator + adjustment),
            control1:  CGPoint(x: 47 / xDenominator, y:  30 / yDenominator + adjustment),
            control2:  CGPoint(x: 58 / xDenominator, y: 130 / yDenominator + adjustment)
        ),
        Segment( // top right
            line:      CGPoint(x:  87 / xDenominator, y:   0 / yDenominator - adjustment),
            control1:  CGPoint(x: 100 / xDenominator, y:  60 / yDenominator - adjustment),
            control2:  CGPoint(x: 104 / xDenominator, y: -28 / yDenominator - adjustment)
        ),
        Segment( // top left
            line:      CGPoint(x:  13 / xDenominator, y:  20 / yDenominator + adjustment),
            control1:  CGPoint(x:  53 / xDenominator, y:  70 / yDenominator + adjustment),
            control2:  CGPoint(x:  42 / xDenominator, y: -30 / yDenominator + adjustment)
        ),
        Segment( // bottom left -- start
            line:      CGPoint(x:  13 / xDenominator, y: 100 / yDenominator - adjustment),
            control1:  CGPoint(x:   0 / xDenominator, y:  40 / yDenominator - adjustment),
            control2:  CGPoint(x:  -4 / xDenominator, y: 128 / yDenominator - adjustment)
        )
    ]
}
