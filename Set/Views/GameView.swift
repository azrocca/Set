//
//  GameView.swift
//  Set
//
//  Created by Rocca on 7/8/21.
//

import SwiftUI

struct GameView: View {
    let numberOfFeatures: Int
    @ObservedObject var game: ClassicSetGame
    @Namespace private var dealingNamespace
//    @Namespace private var discardNamespace
    
    init(numberOfFeatures: Int) {
        self.numberOfFeatures = numberOfFeatures
        _game = ObservedObject(initialValue: ClassicSetGame(numberOfFeatures: numberOfFeatures)!)
    }
    
    private var gridItemLayout = [GridItem(.adaptive(minimum: DrawingConstants.minCardWidth), spacing: 0)]
    
    private func zIndex(of card: ClassicSetGame.Card) -> Double {
        Double((game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)-game.cards.count)
    }
    
    private func flipAnimation(_ card: ClassicSetGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (DrawingConstants.totalDealDelayDuration / Double(game.cards.count))
        }
        delay += DrawingConstants.totalDealDelayDuration

        return Animation.easeInOut(duration: DrawingConstants.flipDuration).delay(delay)
    }
    
    private func dealDrawAnimation(_ cardNumber: Int) -> Animation {
        let delay = Double(cardNumber) * (DrawingConstants.totalDealDelayDuration / Double(game.numberOfCardsPerDraw))
        
        return Animation.easeInOut(duration: DrawingConstants.dealDuration).delay(delay)
    }
    
    private func cardOffset(_ card: ClassicSetGame.Card) -> CGSize {
        var offset: CGFloat = 0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            offset = CGFloat(index) * (DrawingConstants.totalDeckOffset / CGFloat(game.cards.count))
        }
        return CGSize(width: -offset, height: -offset)
    }
    
    private func cardRotation(_ card: ClassicSetGame.Card) -> Angle {
        var rotation: Double = 0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            let range = 2 * DrawingConstants.maxDeckRotationAngle
            rotation = Double(index) * (range / Double(game.cards.count)) - DrawingConstants.maxDeckRotationAngle
        }
        return Angle.degrees(rotation)
    }
    
    var body: some View {
        VStack {
            userBody
            let dealtCards = game.cards.filter(game.isDealt)
            AspectVGrid(items: dealtCards, aspectRatio: DrawingConstants.cardAspectRatio, minWidth: DrawingConstants.minCardWidth) { card in
                CardView(card: card.content)
                    .modifier(CardAnimation(isSelected: card.content.isSelected, isDisplayed: card.content.isDisplayed, isMatchFound: game.isMatchFound, isNotTrueMatch: game.isNotTrueMatch))
                    .padding(DrawingConstants.paddingBetweenCards)
                    .zIndex(zIndex(of: card))
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace, isSource: true)
                    .onAppear {
                        withAnimation(flipAnimation(card)) {
                            game.flipCardsFaceUp()
                        }
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: DrawingConstants.totalDealDelayDuration)) {
                            game.choose(card)
                        }
                    }
            }
            cardStackBody
//                .padding(.horizontal)
                .padding(.top)
        }
        .navigationBarHidden(true)
        //        .navigationBarBackButtonHidden(true)
        //        .navigationBarTitle("", displayMode: .inline)
    }
    
    var deckBody: some View {
        ZStack(alignment: .center) {
            ForEach(game.cards.filter(game.isUndealt)) { card in
                CardView(card: card.content)
                    .modifier(CardAnimation(isSelected: false, isDisplayed: false, isMatchFound: false, isNotTrueMatch: false))
                    .frame(width: DrawingConstants.undealtWidth, height: DrawingConstants.undealtHeight)
                    .offset(cardOffset(card))
                    .rotationEffect(cardRotation(card))
                    .zIndex(zIndex(of: card))
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace, isSource: true)
            }
            Text("All cards\ndealt")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .opacity(game.cards.filter(game.isUndealt).isEmpty ? 1 : 0)
        }
        .onTapGesture {
            for index in 1...game.numberOfCardsPerDraw {
                withAnimation(dealDrawAnimation(index)) {
                    game.drawNextCard()
                }
            }
        }
    }
    
    var matchedBody: some View {
        ZStack(alignment: .center) {
            ForEach(game.cards.filter(game.isMatched)) { card in
                CardView(card: card.content)
                    .modifier(CardAnimation(isSelected: false, isDisplayed: true, isMatchFound: false, isNotTrueMatch: false))
                    .frame(width: DrawingConstants.undealtWidth, height: DrawingConstants.undealtHeight)
                    .offset(cardOffset(card))
                    .rotationEffect(cardRotation(card))
                    .zIndex(zIndex(of: card))
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace, isSource: true)
            }
        }
    }
    
    var newGame: some View {
        Button("New game") {
            game.newGame()
            game.flipCardsFaceUp()
        }
    }
    
    var userBody: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .center) {
                HStack(alignment: .center, spacing: 0) {
                    newGame
                    Spacer()
                    Text("Sets: \(game.totalSetsFound)")
                }.padding(.horizontal)
                Text(game.userMessage)
                    .foregroundColor(DrawingConstants.messageFontColor)
                    .bold()
                    .animation(nil)
            }
        }
    }
    
    var cardStackBody: some View {
        HStack(alignment: .center, spacing: 0) {
            Spacer()
            deckBody
                .frame(width: 2*DrawingConstants.undealtWidth)
            Spacer()
            matchedBody
                .frame(width: 2*DrawingConstants.undealtWidth)
            Spacer()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let numberOfFeatures = 3
        GameView(numberOfFeatures: numberOfFeatures)
    }
}
