//
//  DifficultyButtonBackground.swift
//  Set
//
//  Created by Rocca on 7/16/21.
//

// Code written with Daniel!  His first Swift code!

import SwiftUI

struct DifficultyButtonBackground: View {
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 25.0)
        ZStack {
            shape
                .stroke(Color.black, lineWidth: 5)
            shape
                .foregroundColor(.blue)
        }
    }
}

struct DifficultyButtonBackground_Previews: PreviewProvider {
    static var previews: some View {
        DifficultyButtonBackground()
    }
}
