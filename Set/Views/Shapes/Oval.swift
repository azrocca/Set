//
//  Oval.swift
//  Set
//
//  Created by Rocca on 7/8/21.
//

import SwiftUI

struct Oval: Shape {
    
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = width * 70/160
        
        let rectWidth = width * 90/160
        let ovalRadius = height / 2
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let bottomLeft = CGPoint(x: center.x - rectWidth / 2, y: center.y + height / 2)
        let bottomRight = CGPoint(x: center.x + rectWidth / 2, y: center.y + height / 2)
        let topLeft = CGPoint(x: center.x - rectWidth / 2, y: center.y - height / 2)
        let topRight = CGPoint(x: center.x + rectWidth / 2, y: center.y - height / 2)
        let centerRight = CGPoint(x: center.x + rectWidth / 2, y: center.y)
        let centerLeft = CGPoint(x: center.x - rectWidth / 2, y: center.y)
        
        var path = Path()
        path.move(to: topLeft)
        path.addArc(center: centerLeft, radius: ovalRadius, startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 180-90), clockwise: true)
        path.addLine(to: bottomLeft)
        path.addLine(to: bottomRight)
        path.addArc(center: centerRight, radius: ovalRadius, startAngle: Angle(degrees: 180-90), endAngle: Angle(degrees: 0-90), clockwise: true)
        path.addLine(to: topRight)
        path.addLine(to: topLeft)
        
        return path
    }
    
}

struct Oval_Previews: PreviewProvider {
    static var previews: some View {
        Oval().stroke(Color.blue, lineWidth: 3)
    }
}
