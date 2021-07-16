//
//  SetEnums.swift
//  Set
//
//  Created by Rocca on 7/9/21.
//

import SwiftUI

enum setColor: Int, CaseIterable {
    case red = -1, green, purple
    
    func getColor() -> Color {
        switch self {
        case .red:
            return Color.red
        case .green:
            return Color.green
        case .purple:
            return Color.purple
        }
    }
}

enum setNumber: Int, CaseIterable {
    case one = -1, two, three
}

enum setShape: Int, CaseIterable {
    case diamond = -1, oval, squiggle
}

enum setShading: Int, CaseIterable {
    case open = -1, solid, striped
}

//struct Trool: Hashable {
//    var storedValue: Int?
//    var value: Int?
//    {
//        set {
//            storedValue = newValue?.signum()
//        }
//        get { storedValue }
//    }
//    init(_ value: Int?) {
//        self.value = value
//    }
//}
