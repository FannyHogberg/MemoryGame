//
//  CardBank.swift
//  bajsMemory
//
//  Created by Fanny Högberg on 2018-01-09.
//  Copyright © 2018 Fanny Högberg. All rights reserved.
//

import Foundation



class CardBank{
    
    var list = [Card]()

    init() {
        for number in 1...12{
            list.append(Card(cardId: number, imageName: "card\(number)", soundName: "fart\(number)"))
            list.append(Card(cardId: number, imageName: "card\(number)", soundName: "fart\(number)"))
        }
    }
    
    //returns an Array of Cards in pairs in random order...
    func createCards(amountOfPairs: Int) -> [Card] {
        var listOfCardPair = getRandomDifferentCardPairs(numberOfPairs: amountOfPairs)
        listOfCardPair = shuffleCardsInArray(arrayToShuffle: listOfCardPair)
        return listOfCardPair
    }
    
    //Returns an array of different Card Objects. min: 1, max: cards in cardbank / 2
    func getRandomDifferentCardPairs(numberOfPairs: Int) -> [Card]{
        
        var listOfRandomNumbers = [Int]()
        let randomMaxNumber = list.count
        var listOfCards = [Card]()
        
        if numberOfPairs > 0 && numberOfPairs <= list.count / 2{
            
            for _ in 1...numberOfPairs{
                
                var randomNumber = Int(arc4random_uniform(UInt32(randomMaxNumber)))
                while (randomNumber % 2 != 0) || listOfRandomNumbers.contains(randomNumber){ // we want an even number.
                    randomNumber = Int(arc4random_uniform(UInt32(randomMaxNumber)))
                }
                listOfRandomNumbers.append(randomNumber)
                listOfCards.append(list[randomNumber])      //The first card.
                listOfCards.append(list[randomNumber+1])    //The other equal card.
            }
        }
        return listOfCards
    }
        
    //Shuffles the Cards in an array.
    func shuffleCardsInArray(arrayToShuffle: [Card]) -> [Card] {
        var cards = arrayToShuffle
        let i = 4 //Mixing ratio
        for _ in 0..<cards.count * i{
            let card = cards.remove(at: Int(arc4random_uniform(UInt32(cards.count))))
            cards.insert(card, at: Int(arc4random_uniform(UInt32(cards.count))))
        }
        return cards
    }

    var allFlippedCardsAreEqual: Bool {
        let flippedCards = list.filter { $0.isFlipped }
        guard flippedCards.count > 1 else { fatalError() }
        guard let id = flippedCards.first?.id else { fatalError() }
        return flippedCards.allSatisfy { $0.id == id }
    }

    var flippedCardsCount: Int {
        list.filter { $0.isFlipped }.count
    }
    
    func unflipAllCards() {
        list.forEach { $0.setIsFlippedToFalse() }
    }
    
    func resetAllCards() {
        list.forEach { $0.resetCard() }
    }
}

