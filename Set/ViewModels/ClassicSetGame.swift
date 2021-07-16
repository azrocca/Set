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
    @Published var noCardsLeft: Bool
    @Published var totalSetsFound: Int = 0
    @Published var matchFound = false
    @Published var notRealMatch = false
    @Published var winner = false
    @Published var gameOver = false
    
    let numberOfFeatures = 4
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
        
        var isSelected = false
        var isDisplayed = false
        
    }
    
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
    
    init?() {
        self.noCardsLeft = false
        
        classicCardList = []
        for color in setColor.allCases {
            for shape in setShape.allCases {
                for shading in setShading.allCases {
                    for number in setNumber.allCases {
                        classicCardList.append(ClassicCard(color: color, shape: shape, shading: shading, number: number))
                    }
                }
            }
        }
        
        let numberOfCards = classicCardList.count
        self.model = ClassicSetGame.createSetGame(numberOfCards: numberOfCards, cardList: classicCardList)
        // shuffle the deck so a new game doesn't always produce the same organized cards
        
        shuffleCards()
        
        // pick out which cards should be displayed initially
        displayInitialCards()
        
        noCardsLeft = allCardsDisplayed()
        
    }
    
    private static func createSetGame(numberOfCards: Int, cardList: [ClassicCard]) -> SetGame<ClassicCard> {
        let shuffledCardList = cardList //.shuffled()
        return SetGame<ClassicCard>(numberOfCards: numberOfCards) { cardIndex in
            shuffledCardList[cardIndex]
        }
    }
    
    //MARK: - Intent(s)
    
    var cards: Array<Card> {
        model.cards
    }
    
    func choose(_ card: Card) {
        toggleIsSelected(cardID: card.id)
        (matchedCardIDs, resetSelectedCards) = model.choose(card, numberOfCardsPerMatch: numberOfCardsPerMatch) {selectedCardIDs in
            // implement assessMatch()
            // for reference: four options are color, shape, shading, & number
            var featureCount = Array(repeating: 0, count: numberOfFeatures)
            // featureCount[0] represents colorCount
            // featureCount[1] represents shapeCount
            // featureCount[2] represents shadingCount
            // featureCount[3] represents numberCount
            
            // need to get the 3 cards to do an assessment
            let selectedCards = cards.filter({ card in
                var isFiltered = false
                for cardID in selectedCardIDs {
                    if card.id == cardID { isFiltered = true }
                }
                return isFiltered
            })
            
            // since the enums are all assigned numbers -1, 0, & +1,
            // can sum for the numberOfCardsPerMatch cards and
            // they are either all same or all different if the sum
            // is -numberOfCardsPerMatch, 0, or +numberOfCardsPerMatch
            for card in selectedCards {
                featureCount[0] += card.content.color.rawValue
                featureCount[1] += card.content.shape.rawValue
                featureCount[2] += card.content.shading.rawValue
                featureCount[3] += card.content.number.rawValue
            }
            
            for count in featureCount {
                if !(count == -numberOfCardsPerMatch || count == 0 || count == +numberOfCardsPerMatch) {
                    // if count does not equal -numberOfCardsPerMatch, 0, or +numberOfCardsPerMatch,
                    // then these cards don't match, regardless of if other features match
                    return false
//                    return true // only used for debugging of game over
                }
            }
            return true
        }
        
        if !matchedCardIDs.isEmpty {
            matchFound = true
            for cardID in matchedCardIDs {
                toggleIsSelected(cardID: cardID)
                toggleIsDisplayed(cardID: cardID)
            }
            totalSetsFound += 1
            if numberOfCurrentlyDisplayedCards < numberOfInitiallyDisplayedCards {
                drawCards()
            }
            if numberOfCurrentlyDisplayedCards == 0 {
                // winner!
                winner = true
            }
        } else {
            matchFound = false
            notRealMatch = false
        }
        
        if resetSelectedCards {
            resetCards()
            notRealMatch = !matchFound
        }
        
        checkForGameOver()
        
//        print("--- selected card after all processing ---")
//        printCard(card.content, terminator: "")
//        print(", id: \(card.id)", terminator: "")
//        print(", matched?: \(card.isMatched)")
    }
    
    func newGame() {
        let numberOfCards = classicCardList.count
        model = ClassicSetGame.createSetGame(numberOfCards: numberOfCards, cardList: classicCardList)
        shuffleCards()
        displayInitialCards()
        noCardsLeft = false
        matchFound = false
        notRealMatch = false
        gameOver = false
        winner = false
        totalSetsFound = 0
    }
    
    func shuffleCards() {
        model.shuffleCards()
    }
    
    func toggleIsDisplayed(cardID: Int) {
        if var newCardContent = cards.first(where: { $0.id == cardID })?.content {
            newCardContent.isDisplayed.toggle()
            model.changeCardContent(cardID: cardID, newContent: newCardContent)
        }
    }
    
    func displayInitialCards() {
        var maxIndex = numberOfInitiallyDisplayedCards
        if maxIndex > cards.count { maxIndex = cards.count }
        for cardIndex in 0..<maxIndex {
            toggleIsDisplayed(cardID: cards[cardIndex].id)
        }
    }
    
    func toggleIsSelected(cardID: Int) {
        if var newCardContent = cards.first(where: { $0.id == cardID })?.content {
            newCardContent.isSelected.toggle()
            model.changeCardContent(cardID: cardID, newContent: newCardContent)
        }
    }
    
    func resetCards() {
        for card in cards {
            var newContent = card.content
            newContent.isSelected = false
            model.changeCardContent(cardID: card.id, newContent: newContent)
        }
    }
    
    func checkForGameOver() {
        var checkBool = Array(repeating: Array(repeating: false, count: numberOfCardsPerMatch), count: numberOfFeatures)
        
        let remainingCards = cards.filter({ !($0.isMatched) })
        for card in remainingCards {
            switch card.content.color {
            case .green:
                checkBool[0][0] = true
            case .purple:
                checkBool[0][1] = true
            case .red:
                checkBool[0][2] = true
            }
            switch card.content.shape {
            case .diamond:
                checkBool[1][0] = true
            case .oval:
                checkBool[1][1] = true
            case .squiggle:
                checkBool[1][2] = true
            }
            switch card.content.shading {
            case .open:
                checkBool[2][0] = true
            case .solid:
                checkBool[2][1] = true
            case .striped:
                checkBool[2][2] = true
            }
            switch card.content.number {
            case .one:
                checkBool[3][0] = true
            case .two:
                checkBool[3][1] = true
            case .three:
                checkBool[3][2] = true
            }
        }
        
        var checkFeatureBool = Array(repeating: false, count: numberOfFeatures)
        for index in 0..<numberOfFeatures {
            let check0 = checkBool[index][0]
            let check1 = checkBool[index][1]
            let check2 = checkBool[index][2]
            checkFeatureBool[index] = (check0 && check1 && check2) || (!check0 && !check1 && !check2)
        }
        
        gameOver = !(checkFeatureBool[0] && checkFeatureBool[1] && checkFeatureBool[2] && checkFeatureBool[3])
        
        print("--- checkBool ---")
        print(checkBool)
        print("--- tempArray ---")
        print(checkFeatureBool)
        print("--- gameOver ---")
        print(gameOver)
        
    }
    
    func allCardsDisplayed() -> Bool {
        if cards.contains(where: { !($0.content.isDisplayed) && !($0.isMatched) }) {
            return false
        } else {
            return true
        }
    }
    
    func drawCards() {
        // for loop over numberOfCards where each time it finds the first card,
        // that isDisplayed == false and isMatched == false, it will toggle isDisplayed
        for _ in 1...numberOfCardsPerDraw {
            if let cardID = cards.first(where: { !($0.content.isDisplayed) && !($0.isMatched) })?.id {
                toggleIsDisplayed(cardID: cardID)
            } else { // no cards left to draw
                noCardsLeft = true
            }
        }
    }
}
