//
//  GameManager.swift
//  Flush The Toilet
//
//  Created by Fanny Högberg on 2022-01-24.
//  Copyright © 2022 Fanny Högberg. All rights reserved.
//

import Foundation

class GameManager {
    var currentLevel: Level { levels[currentLevelIndex] }
    var levels: [Level] = [.level1, .level2, .level3]
    
    let cardBank = CardBank() //MAKEPRIVATE
    private var currentLevelIndex = 0
    
    func fetchNewCards() -> [Card] {
        cardBank.createCards(amountOfPairs: currentLevel.pairOfCardsCount)
    }
    
    func didFlipPair() {
        levels[currentLevelIndex].didFlipPairCount += 1
    }
    
    var flippedCardsAreEqual: Bool {
        cardBank.allFlippedCardsAreEqual
    }
    
    var shouldFlipOneMoreCard: Bool {
        let shouldFLip = cardBank.flippedCardsCount < 2
        print("FANNY: shouldFlip \(shouldFLip)")
        return shouldFLip
    }
    
    var onePairOfCardsIsFlipped: Bool {
        let test = cardBank.flippedCardsCount == 2
        print("FANNY: Flipped cards \(cardBank.list.filter { $0.isFlipped }).count in onPariOf cards is flipped")
        print("FANNY:onePairOfCardsIsFlipped \(test) ")
        return test
//        cardBank.flippedCardsCount == 2
    }
    
    func resetAllCards() {
        cardBank.resetAllCards()
    }
    
    func resetLevels() {
        levels = [.level1, .level2, .level3]
        currentLevelIndex = 0
    }
    
    func setFlippedPairCount(_ count: Int) {
        levels[currentLevelIndex].didFlipPairCount = count
    }
    
    func setNextLevel() {
        currentLevelIndex += 1
    }
    
    func saveScoreForCurrentLevel() {
        if cardBank.list.didNotFlipAnyCardMoreThanTwoTimes {
            setFlippedPairCount(0)
        }
    }
    
    func unflipAllCards() {
        cardBank.unflipAllCards()
    }
}


private extension Array where Element == Card {
    
    var didNotFlipAnyCardMoreThanTwoTimes: Bool {
        first { $0.flippedCounter >= 3 } == nil
    }
}
