//
//  SetGame.swift
//  Set
//
//  Created by Rocca on 7/11/21.
//

import Foundation

struct SetGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    private var selectedCardIDs: Array<Int>
    
    struct Card: Identifiable, Hashable {
        var content: CardContent
        var isMatched = false
        var id: Int
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
    
    init(numberOfCards: Int, createCardContent: (Int) -> CardContent) {
        selectedCardIDs = []
        
        cards = []
        for cardIndex in 0..<numberOfCards {
            let content = createCardContent(cardIndex)
            cards.append(Card(content: content, id: cardIndex))
        }
    }
    
    mutating func choose(_ card:Card, numberOfCardsPerMatch: Int, assessMatch: (Array<Int>) -> Bool) -> ([Int], Bool) {
        var matchedCardIDs: [Int] = []
        var resetSelectedCards = false
        
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }), !cards[chosenIndex].isMatched {
            // only add card ID if it is a new card, if it's not, remove from list
            if !selectedCardIDs.contains(card.id) {
                selectedCardIDs.append(card.id)
            } else {
                selectedCardIDs.removeAll(where: {$0 == card.id} )
            }
            if selectedCardIDs.count >= numberOfCardsPerMatch { // once you have enough cards
                // assess match, if matched change isMatched property for each card
                if assessMatch(selectedCardIDs) {
                    for selectedID in selectedCardIDs {
                        if let cardIndex = cards.firstIndex(where: { $0.id == selectedID }) {
                            cards[cardIndex].isMatched = true
                        }
                    }
                    matchedCardIDs = selectedCardIDs
                }
                
                // reset selectedCardIDs array
                selectedCardIDs = []
                resetSelectedCards = true
            }
        }
        return (matchedCardIDs, resetSelectedCards)
    }
    
    mutating func shuffleCards() {
        cards.shuffle()
    }
    
    mutating func changeCardContent(cardID: Int, newContent: CardContent) {
        if let cardIndex = cards.firstIndex(where: { $0.id == cardID }) {
            cards[cardIndex].content = newContent
        }
    }
    
}
