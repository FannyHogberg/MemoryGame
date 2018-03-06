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
    func createCardsToPlay(levelInGame: Level) -> [Card]{
        
        var listOfCardPair = getRandomDifferentCardPairs(numberOfPairs: levelInGame.pairOfCards)
        
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
    
    
    
    
    //Run this function when two cards are flipped
    func checkIfDisplayedCardsAreEqual () -> Bool{
        var cardIndex = [Int]()
        
        for i in 0...list.count-1{
            if list[i].isFlipped{
                cardIndex.append(i)
            }
        }
        if list[cardIndex[0]].id == list[cardIndex[1]].id{
            return true
        }
        return false
    }
    
    
    
    
    func countDisplayedCards() -> Int{
        var counter = 0
        for card in list{
            if card.isFlipped{
                counter += 1
            }
        }
        return counter
        
    }
    
    
    
    func didAnyCardFlippedMoreThanTwoTimes() -> Bool{
        
        for card in list{
            if card.flippedCounter >= 3{
                return true
            }
        }
        return false
    }
    
    
    func setAllCardToBeNotFlipped(){
        for card in list{
            card.setIsFlippedToFalse()
        }
    }
    
    
    func resetAllCards(){
        for card in list{
            card.resetCard()
        }
        
        
    }
    
    
    
}





