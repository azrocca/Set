//
//  DifficultyButton.swift
//  Set
//
//  Created by Rocca on 7/16/21.
//

// Code written with Daniel!  His first Swift code!

import SwiftUI

struct DifficultyButton: View {
    let buttonText: String
    let textColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                Text(buttonText)
                    .foregroundColor(textColor)
                    .bold()
                    .font(calculateFontSize(in: geometry.size))
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(DifficultyButtonBackground())
                Spacer()
            }
        }
    }
    
    private func calculateFontSize(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * 0.4)
    }
}

struct DifficultyButton_Previews: PreviewProvider {
    static var previews: some View {
        let buttonText = "Easy"
        let textColor = Color.green
        DifficultyButton(buttonText: buttonText, textColor: textColor)
    }
}
