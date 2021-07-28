//
//  ClassicSetGame.swift
//  Set
//
//  Created by Rocca on 7/12/21.
//

import Foundation
import SwiftUI

class ClassicSetGame: ObservableObject {
    typealias Card = SetGame<ClassicCard>.Card
    
    @Published private var model: SetGame<ClassicCard>
    @Published var totalSetsFound: Int = 0
    @Published var userMessage = ""
    @Published var isMatchFound = false
    @Published var isNotTrueMatch = false
    
    @Published var dealt = Set<Int>()
    
    var isGameWon = false
    var isGameOver = false
    
    let numberOfFeatures: Int
    let numberOfCardsPerMatch = 3
    var numberOfPossibleSets: Int {
        numberOfCardsPerMatch ^ (numberOfFeatures - 1)
    }
    let numberOfInitiallyDisplayedCards = 12
    var numberOfCurrentlyDisplayedCards: Int {
        cards.filter({ ($0.content.isDisplayed) && !($0.isMatched) }).count
    }
    
    let numberOfCardsPerDraw = 3
    var matchedCardIDs: [Int] = []
    var resetSelectedCards = false
    
    struct ClassicCard: Equatable {
        var color: setColor
        var shape: setShape
        var shading: setShading
        var number: setNumber
        var background: setBackground
        
        var isSelected = false
        var isDisplayed = false
    }
    
    private let defaultClassicCard = ClassicCard(color: .red, shape: .oval, shading: .solid, number: .one, background: .white)
    private var classicCardList: [ClassicCard]
    
    //MARK: Debugger(s)
    
    func printCard(_ card: ClassicCard, terminator: String = "\n") {
        print("color: \(card.color), shape: \(card.shape), shading: \(card.shading), number: \(card.number), selected?: \(card.isSelected), displayed?: \(card.isDisplayed)", terminator: terminator)
    }
    
    func printCards() {
        cards.indices.forEach {
            printCard(cards[$0].content, terminator: "")
            print(", id: \(cards[$0].id)", terminator: "")
            print(", matched?: \(cards[$0].isMatched)")
        }
    }
    
    func printCardList(_ cardList: [ClassicCard]) {
        cardList.indices.forEach { printCard(cardList[$0]) }
    }
    
    //MARK: Initializer(s)
    
    init?(numberOfFeatures: Int) {
        if numberOfFeatures > 2 && numberOfFeatures < 6 {
            self.numberOfFeatures = numberOfFeatures
        } else { // default to medium difficulty
            self.numberOfFeatures = 4
        }
        // number of features must be defined first
        // NEEDS TO BE UPDATED TO SUPPORT MULTIPLE NUMBER OF FEATURES!
        
        classicCardList = [] // ClassicSetGame.buildDeck()
        
        for shape in setShape.allCases {
            for number in setNumber.allCases {
                for color in setColor.allCases {
                    if numberOfFeatures > 3 {
                        for shading in setShading.allCases {
                            if numberOfFeatures > 4 {
                                for background in setBackground.allCases {
                                    classicCardList.append(ClassicCard(color: color, shape: shape, shading: shading, number: number, background: background))
                                }
                            } else {
                                classicCardList.append(ClassicCard(color: color, shape: shape, shading: shading, number: number, background: defaultClassicCard.background))
                            }
                        }
                    } else {
                        classicCardList.append(ClassicCard(color: color, shape: shape, shading: defaultClassicCard.shading, number: number, background: defaultClassicCard.background))
                    }
                }
            }
        }
        
        self.dealt = []
        let numberOfCards = classicCardList.count
        self.model = ClassicSetGame.createSetGame(numberOfCards: numberOfCards, cardList: classicCardList)
        // shuffle the deck so a new game doesn't always produce the same organized cards
        
        shuffleCards()
        
        // pick out which cards should be displayed initially
        displayInitialCards()
        flipCardsFaceUp()
    }
    
    private static func createSetGame(numberOfCards: Int, cardList: [ClassicCard]) -> SetGame<ClassicCard> {
        let shuffledCardList = cardList //.shuffled()
        return SetGame<ClassicCard>(numberOfCards: numberOfCards) { cardIndex in
            shuffledCardList[cardIndex]
        }
    }
    
//    private static func buildDeck() -> [ClassicCard] {
//        var cardList: [ClassicCard] = []
//
//
//        return cardList
//    }
    
    //MARK: - Method(s)
    
    private func shuffleCards() {
        model.shuffleCards()
    }
    
    private func toggleIsDisplayed(cardID: Int) {
        if var newCardContent = cards.first(where: { $0.id == cardID })?.content {
            newCardContent.isDisplayed.toggle()
            model.changeCardContent(cardID: cardID, newContent: newCardContent)
        }
    }
    
    func displayInitialCards() {
        var maxIndex = numberOfInitiallyDisplayedCards
        if maxIndex > cards.count { maxIndex = cards.count }
        dealt = []
        for cardIndex in 0..<maxIndex {
            deal(cards[cardIndex])
        }
    }
    
    private func toggleIsSelected(cardID: Int) {
        if var newCardContent = cards.first(where: { $0.id == cardID })?.content {
            newCardContent.isSelected.toggle()
            model.changeCardContent(cardID: cardID, newContent: newCardContent)
        }
    }
    
    private func resetCards() {
        for card in cards {
            var newContent = card.content
            newContent.isSelected = false
            model.changeCardContent(cardID: card.id, newContent: newContent)
        }
    }
    
    private func deal(_ card: ClassicSetGame.Card) {
        dealt.insert(card.id)
    }
    
    private func undeal(cardID: Int) {
        if dealt.contains(cardID) {
            dealt.remove(cardID)
        }
    }
    
    func isUndealt(_ card: ClassicSetGame.Card) -> Bool {
        !dealt.contains(card.id) && !card.isMatched
    }
    
    func isDealt(_ card: ClassicSetGame.Card) -> Bool {
        dealt.contains(card.id) && !card.isMatched
    }
    
    func isMatched(_ card: ClassicSetGame.Card) -> Bool {
        card.isMatched
    }
    
    func isDisplayed(_ card: ClassicSetGame.Card) -> Bool {
        card.content.isDisplayed
    }
    
    private func doCardsMatch(_ cardsToAssess: [Card]) -> Bool {
        
        // NEEDS TO BE UPDATED TO SUPPORT MULTIPLE NUMBER OF FEATURES!
        
        var featureCount = Array(repeating: 0, count: numberOfFeatures)
        // featureCount[0] represents shapeCount
        // featureCount[1] represents numberCount
        // featureCount[2] represents colorCount
        // featureCount[3] represents shadingCount
        
        // since the enums are all assigned numbers -1, 0, & +1,
        // can sum for the numberOfCardsPerMatch cards and
        // they are either all same or all different if the sum
        // is -numberOfCardsPerMatch, 0, or +numberOfCardsPerMatch
        for card in cardsToAssess {
            featureCount[0] += card.content.shape.rawValue
            featureCount[1] += card.content.number.rawValue
            if numberOfFeatures > 2 {
                featureCount[2] += card.content.color.rawValue
                if numberOfFeatures > 3 {
                    featureCount[3] += card.content.shading.rawValue
                }
                if numberOfFeatures > 4 {
                    featureCount[4] += card.content.background.rawValue
                }
            }
        }
        
        for count in featureCount {
            if !(count == -numberOfCardsPerMatch || count == 0 || count == +numberOfCardsPerMatch) {
                // if count does not equal -numberOfCardsPerMatch, 0, or +numberOfCardsPerMatch,
                // then these cards don't match, regardless of if other features match
                return false
            }
        }
        return true
    }
    
    private func checkForGameOver() {
        // not at all generic, breaks if the number of cards per set is not 3!!!
        // need to convert to generic by recursion
        var setFound = false
        
        var cardsForCheck: [Card] = []
        let remainingCards = cards.filter({ !($0.isMatched) }).sorted(by: { $0.id < $1.id })
        cardMatchLooper(cardList: remainingCards)
        isGameOver = !setFound
        
        func cardMatchLooper(cardList: [Card]) {
            if !setFound {
                if cardsForCheck.count < numberOfCardsPerMatch {
                    for card in cardList {
                        if !setFound {
                            cardsForCheck.append(card)
                            let remainingCardList = cardList.filter({$0.id > card.id})
                            cardMatchLooper(cardList: remainingCardList)
                        }
                    }
                } else {
                    if doCardsMatch(cardsForCheck) {
                        setFound = true
                        cardsForCheck = []
                    } else {
                        cardsForCheck.removeLast()
                        if cardList.isEmpty {
                            cardsForCheck.removeLast()
                        }
                    }
                }
            }
        }
        
    }
    
    private func updateUserMessage() {
        if isGameWon {
            userMessage = "You win! 🥳"
        } else if isGameOver {
            userMessage = "Game over 😭"
        } else if isMatchFound {
            userMessage = "A match 🤗"
        } else if isNotTrueMatch {
            userMessage = "Not a match 😢"
        } else {
            userMessage = ""
        }
    }
    
    private func areAllCardsDisplayed() -> Bool {
        !cards.filter(isUndealt).isEmpty
    }
    
    //MARK: - Intent(s)
    
    var cards: Array<Card> {
        model.cards
    }
    
    func choose(_ card: Card) {
        toggleIsSelected(cardID: card.id)
        (matchedCardIDs, resetSelectedCards) = model.choose(card, numberOfCardsPerMatch: numberOfCardsPerMatch) {selectedCardIDs in
            // implement assessMatch()
            
            // need to get the 3 cards to do an assessment
            let selectedCards = cards.filter({card in !selectedCardIDs.filter({$0 == card.id}).isEmpty })
            
            return doCardsMatch(selectedCards)
//            return true // just for debug purposes!
        }
        
        if !matchedCardIDs.isEmpty {
            isMatchFound = true
            for cardID in matchedCardIDs {
                toggleIsSelected(cardID: cardID)
                toggleIsDisplayed(cardID: cardID)
                undeal(cardID: cardID)
            }
            totalSetsFound += 1
//            if numberOfCurrentlyDisplayedCards < numberOfInitiallyDisplayedCards {
//                drawCards()
//                flipCardsFaceUp()
//            }
            if numberOfCurrentlyDisplayedCards == 0 {
                // winner!
                isGameWon = true
            }
        } else {
            isMatchFound = false
            isNotTrueMatch = false
        }
        
        if resetSelectedCards {
            resetCards()
            isNotTrueMatch = !isMatchFound
            checkForGameOver()
        }
        
        updateUserMessage()
    }
    
    func newGame() {
        let numberOfCards = classicCardList.count
        model = ClassicSetGame.createSetGame(numberOfCards: numberOfCards, cardList: classicCardList)
        shuffleCards()
        flipCardsFaceUp(false)
        isMatchFound = false
        isNotTrueMatch = false
        isGameOver = false
        isGameWon = false
        updateUserMessage()
        totalSetsFound = 0
//        dealt = []
        displayInitialCards()
    }
    
    func drawCards() {
        // for loop over numberOfCards where each time it finds the first card,
        // that isDisplayed == false and isMatched == false, it will toggle isDisplayed
        for _ in 1...numberOfCardsPerDraw {
            drawNextCard()
        }
    }
    
    func drawNextCard() {
        if let card = cards.first(where: { !isDealt($0) && !$0.isMatched }) {
            deal(card)
        }
    }
    
    func flipCardsFaceUp(_ isUp: Bool = true) {
        for card in cards.filter(isDealt) {
            if card.content.isDisplayed == !isUp {
                toggleIsDisplayed(cardID: card.id)
            }
        }
    }
    
}
