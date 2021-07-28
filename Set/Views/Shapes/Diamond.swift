//
//  Diamond.swift
//  Set
//
//  Created by Rocca on 7/8/21.
//

import SwiftUI

struct Diamond: Shape {
    var aspectRatio: Double = 2/1
    
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = width / CGFloat(aspectRatio)
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let left = CGPoint(x: center.x - width / 2, y: center.y)
        let right = CGPoint(x: center.x + width / 2, y: center.y)
        let top = CGPoint(x: center.x, y: center.y + height / 2)
        let bottom = CGPoint(x: center.x, y: center.y - height / 2)
        
        var path = Path()
        
        path.move(to: left)
        path.addLine(to: top)
        path.addLine(to: right)
        path.addLine(to: bottom)
        path.addLine(to: left)
        path.addLine(to: top)
        
        return path
    }
}

struct Diamond_Previews: PreviewProvider {
    static var previews: some View {
        Diamond().stroke(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/, lineWidth: 3)
        Diamond().stroke(Color.green, lineWidth: 3).opacity(0.5)
    }
}
