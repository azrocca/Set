//
//  AnimationTester.swift
//  Set
//
//  Created by Rocca on 7/17/21.
//

import SwiftUI

struct AnimationTester: View {
    @State var card = ClassicSetGame.ClassicCard(color: setColor.green,
                                          shape: setShape.squiggle,
                                          shading: setShading.striped,
                                          number: setNumber.three,
                                          background: setBackground.white,
                                          isSelected: false,
                                          isDisplayed: false)
    let boxSize: CGFloat = 150
    let aspectRatio: CGFloat = 2/3
    
    @State private var show = true
    @State private var move = false
    @State private var rotation: Double = 0
    @Namespace private var cardNamespace
    
    var cardView: some View {
        CardView(card: card)
            .modifier(CardAnimation(isSelected: card.isSelected, isDisplayed: card.isDisplayed, isMatchFound: false, isNotTrueMatch: false))
            .aspectRatio(aspectRatio, contentMode: .fit)
            .frame(width: boxSize, height: boxSize, alignment: .center)
            .padding(DrawingConstants.paddingBetweenCards)
            .matchedGeometryEffect(id: card.number, in: cardNamespace)
    }
    
    var body: some View {
        VStack {
            Spacer()
            if show {
                if move { // card on left
                    HStack {
                        CardView(card: card)
                            .modifier(CardAnimation(isSelected: card.isSelected, isDisplayed: card.isDisplayed, isMatchFound: false, isNotTrueMatch: false))
                            .aspectRatio(aspectRatio, contentMode: .fit)
                            .frame(width: boxSize, height: boxSize, alignment: .center)
                            .padding(DrawingConstants.paddingBetweenCards)
                            .zIndex(Double(card.number.rawValue))
                            .matchedGeometryEffect(id: card.number, in: cardNamespace)
//                            .transition(.asymmetric(insertion: .identity, removal: .scale))
                            .animation(.easeOut(duration: 2))
                        Spacer()
                    }
                } else { // card on right
                    HStack {
                        Spacer()
                        CardView(card: card)
                            .modifier(CardAnimation(isSelected: card.isSelected, isDisplayed: card.isDisplayed, isMatchFound: false, isNotTrueMatch: false))
                            .aspectRatio(aspectRatio, contentMode: .fit)
                            .frame(width: boxSize, height: boxSize, alignment: .center)
                            .padding(DrawingConstants.paddingBetweenCards)
                            .zIndex(Double(card.number.rawValue))
                            .matchedGeometryEffect(id: card.number, in: cardNamespace)
//                            .transition(.asymmetric(insertion: .identity, removal: .scale))
                            .animation(.easeOut(duration: 2))
//                            .transition(.asymmetric(insertion: .identity, removal: AnyTransition.spinCard(card)))
//                            .transition(AnyTransition.spinCard(card))
                    }
                }
            }
            Spacer()
            HStack {
                Button("Show") {
                    withAnimation(.easeOut(duration: 2)) {
                        show.toggle()
                    }
                }.padding(.horizontal)
                Button("Spin") {
                    withAnimation(.easeOut(duration: 2)) {
                        card.isDisplayed.toggle()
                    }
                }.padding(.horizontal)
                Button("Move") {
                    withAnimation(.easeOut(duration: 2)) {
                        move.toggle()
                    }
                }.padding(.horizontal)
                Button("Both") {
                    move.toggle()
                    withAnimation(.easeOut(duration: 2)) {
                        card.isDisplayed.toggle()
                    }
                }.padding(.horizontal)
            }
            .padding()
        }
    }
}

//struct FlipEffect: GeometryEffect {
//
//    var animatableData: Double {
//        get { angle }
//        set { angle = newValue }
//    }
//
//    @Binding var flipped: Bool
//    var angle: Double
//    let axis: (x: CGFloat, y: CGFloat)
//
//    func effectValue(size: CGSize) -> ProjectionTransform {
//
//        // We schedule the change to be done after the view has finished drawing,
//        // otherwise, we would receive a runtime error, indicating we are changing
//        // the state while the view is being drawn.
//        DispatchQueue.main.async {
//            self.flipped = self.angle >= 90 && self.angle < 270
//        }
//
//        let a = CGFloat(Angle(degrees: angle).radians)
//
//        var transform3d = CATransform3DIdentity;
//        transform3d.m34 = -1/max(size.width, size.height)
//
//        transform3d = CATransform3DRotate(transform3d, a, axis.x, axis.y, 0)
//        transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)
//
//        let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))
//
//        return ProjectionTransform(transform3d).concatenating(affineTransform)
//    }
//}

struct AnimationTester_Previews: PreviewProvider {
    static var previews: some View {
        AnimationTester()
    }
}
