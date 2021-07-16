//
//  GameView.swift
//  Set
//
//  Created by Rocca on 7/8/21.
//

import SwiftUI

struct GameView: View {
//    @State var noCardsLeft = false
    @ObservedObject var game = ClassicSetGame()!
    
    private var gridItemLayout = [GridItem(.adaptive(minimum: DrawingConstants.minCardWidth), spacing: 0)]
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button(action: { game.newGame() }, label: {
                    Text("New game")
                })
                Spacer()
                if !game.noCardsLeft {
                    Button(action: { game.drawCards() }, label: {
                        Text("Draw \(game.numberOfCardsPerDraw)")
                    }).disabled(game.noCardsLeft)
                } else {
                    Text("All cards dealt")
                        .foregroundColor(.secondary)
                }
            }.padding(.horizontal).padding(.top)
            HStack {
                Text("Sets: \(game.totalSetsFound)")
                Spacer()
                if game.winner {
                    Text("You win! 🥳")
                        .foregroundColor(DrawingConstants.messageFontColor)
                        .bold()
                } else if game.gameOver {
                    Text("Game over 😭")
                        .foregroundColor(DrawingConstants.messageFontColor)
                        .bold()
                } else if game.matchFound {
                    Text("A match 🤗")
                        .foregroundColor(DrawingConstants.messageFontColor)
                        .bold()
                } else if game.notRealMatch {
                    Text("Not a match 😢")
                        .foregroundColor(DrawingConstants.messageFontColor)
                        .bold()
                }
                Spacer()
                Spacer()
            }.padding(.horizontal).padding(.top)
            AspectVGrid(items: game.cards.filter({ $0.content.isDisplayed }), aspectRatio: DrawingConstants.cardAspectRatio, minWidth: DrawingConstants.minCardWidth) { card in
//            VStack {
//                ScrollView {
//                    LazyVGrid(columns: gridItemLayout, spacing: 0) {
//                        ForEach(game.cards.filter({ $0.content.isDisplayed }), id: \.id) { card in
                            CardView(card: card.content)
                                .padding(DrawingConstants.paddingBetweenCards)
                                .onTapGesture {
                                    game.choose(card)
                                }
//                                .aspectRatio(DrawingConstants.cardAspectRatio, contentMode: .fit)
//                        }
//                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
