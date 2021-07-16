//
//  Squiggle.swift
//  Set
//
//  Created by Rocca on 7/8/21.
//

import SwiftUI

struct Squiggle: Shape {
    var aspectRatio: Double = 2/1
    
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = width / CGFloat(aspectRatio)
        
        let yOffset: CGFloat = height / 2
        let xOffset: CGFloat = 0
        
//        let firstSquiggleWidthPercentage: CGFloat = 22 / 172
//        let secondSquiggleWidthPercentage: CGFloat = 64 / 172
//        let thirdSquiggleWidthPercentage: CGFloat = 120 / 172
//
//        let secondSquiggleHeightPercentage: CGFloat = 1 - 68 / 88
//        let thirdSquiggleHeightPercentage: CGFloat = 1 - 82 / 88
//        let furthestSquiggleHeightPercentage: CGFloat = 25 / 88

        let center = CGPoint(x: rect.midX, y: rect.midY)
        let start = CGPoint(
            x: width * 13 / 100 + xOffset, // 22 / 172
            y: center.y + 1*height - yOffset) // max
        
        var path = Path()
        path.move(to: start)
                
        SquiggleParameters.segments.forEach { segment in
            path.addCurve(
                to: CGPoint(
                    x: width * segment.line.x + xOffset,
                    y: center.y + height * segment.line.y - yOffset
                ),
                control1: CGPoint(
                    x: width * segment.control1.x + xOffset,
                    y: center.y + height * segment.control1.y - yOffset
                ),
                control2: CGPoint(
                    x: width * segment.control2.x + xOffset,
                    y: center.y + height * segment.control2.y - yOffset)
            )
        }
        
        return path
    }
}

struct Squiggle_Previews: PreviewProvider {
    static var previews: some View {
        Squiggle().stroke(Color.blue, style: StrokeStyle(lineWidth: 3))
    }
}
