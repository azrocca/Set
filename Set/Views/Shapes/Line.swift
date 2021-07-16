//
//  Line.swift
//  Set
//
//  Created by Rocca on 7/9/21.
//

import SwiftUI

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width, y: rect.midY))
        return path
    }
}

struct Line_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            Line()
                .stroke(
                    Color.blue,
                    style: StrokeStyle(
                        lineWidth: geometry.size.height,
                        dash: [DrawingConstants.stripedWidth, DrawingConstants.stripedGapWidth]))
        }
    }
}
