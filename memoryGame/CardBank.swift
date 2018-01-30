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
        
        for number in 1...5{
            list.append(Card(cardId: "card\(number)", imageName: "card\(number)", soundName: "fart\(number)"))
            list.append(Card(cardId: "card\(number)", imageName: "card\(number)", soundName: "fart\(number)"))
        }
        
        
    }
    
    
    func setSizeToAllCards(width: Int, height: Int) {
        for card in list{
            
            card.setSize(imagewidth: width, imageHeight: height)
            
        }
    }
    
    
    //returns an Array of Cards in pairs in random order...
    func createCardsToPlay(levelInGame: Level, viewvWidth: Int, viewHeight: Int) -> [Card]{
        
        var listOfCardPair = getRandomDifferentCardPairs(numberOfPairs: levelInGame.pairOfCards)
        
        listOfCardPair = shuffleCardsInArray(arrayToShuffle: listOfCardPair)
        
        findRandomCoordinatesToAllCardsIn(listOfCards: listOfCardPair, levelInGame: levelInGame, viewWidth: viewvWidth, viewHeight: viewHeight)
        
        setSizeToAllCards(width: levelInGame.cardWidth, height: levelInGame.cardHeight)
        
        
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
    
    
    
    
    
    func findRandomCoordinatesToAllCardsIn(listOfCards: [Card], levelInGame: Level, viewWidth: Int, viewHeight: Int){
        
        let cardWidth = levelInGame.cardWidth
        let cardHeight = levelInGame.cardHeight

        var counter = 30
        var newCoordinates : (x : Int, y: Int)
        var coordinatesArray = [(x : Int, y: Int)]()
        
        while counter == 30 {
            counter = 0
            coordinatesArray.removeAll()
            
            coordinatesArray.append(randomCoordinates(level: levelInGame, widthOfView: viewWidth, heightOfView: viewHeight))
            
            for _ in 1...listOfCards.count{
                
                newCoordinates = randomCoordinates(level: levelInGame, widthOfView: viewWidth, heightOfView: viewHeight)
                
                while checkCollisionInArray(coordinates: newCoordinates, arrayOfCardCoordinates: coordinatesArray, imageWidth: cardWidth, imageHeight: cardHeight) && counter != 30{
                    counter += 1
                    print("counter ================ \(counter)")
                    
                    newCoordinates = randomCoordinates(level: levelInGame, widthOfView: viewWidth, heightOfView: viewHeight)
                }
                
                coordinatesArray.append(newCoordinates)
                
            }
        }
        
        setCoordinatesToCardsInThis(listOfCards: listOfCards, arrayOfCoordinates: coordinatesArray)
    }
    
    
    
    func setCoordinatesToCardsInThis(listOfCards: [Card], arrayOfCoordinates: [(x : Int, y : Int)]) {
        for i in 0...listOfCards.count-1{
            
            listOfCards[i].xCoordinate = arrayOfCoordinates[i].x
            listOfCards[i].yCoordinate = arrayOfCoordinates[i].y

        }
        
    }
    
    
    
    func randomXcoordinate(imageWidth: Int, viewWidth : Int) -> Int {
        
        let xMaxValue = viewWidth - Int((Double(viewWidth) * 0.10)) - Int(imageWidth)
        let randomNumber = Int(arc4random_uniform(UInt32(Int(xMaxValue)))) + Int((Double(viewWidth) * 0.10))
        return randomNumber
        
    }
    
    func randomYcoordinate(imageHeight: Int, viewHeight : Int) -> Int {
        
        let yMaxValue = viewHeight - Int((Double(viewHeight) * 0.35)) - imageHeight
        let randomNumber = Int(arc4random_uniform(UInt32(Int(yMaxValue)))) + Int((Double(viewHeight) * 0.15))
        return randomNumber
        
    }
    
    
    func randomCoordinates (level: Level, widthOfView: Int, heightOfView: Int) -> (Int, Int){

        let width = level.cardWidth
        let height = level.cardHeight
        
        let randomX = randomXcoordinate(imageWidth: width, viewWidth: widthOfView)
        
        let randomY = randomYcoordinate(imageHeight: height, viewHeight: heightOfView)
        
        return (x : randomX, y : randomY)
        
        
    }
    
    
    
    
    //Check collision of two buttons.
    func checkCollision (cardOne: (x : Int, y : Int), cardTwo: (x : Int, y : Int), imageWidth: Int, imageHeight: Int) -> Bool{
      
        let xOne = cardOne.x
        let yOne = cardOne.y
        let xTwo = cardTwo.x
        let yTwo = cardTwo.y
        
        return !(xOne > xTwo + imageWidth || xOne + imageWidth < xTwo || yOne>yTwo+imageHeight || yOne+imageHeight<yTwo )
        
    }
    
    //  check for collision with other cards.
    func checkCollisionInArray(coordinates: (x:Int, y:Int), arrayOfCardCoordinates: [(x: Int, y: Int)], imageWidth: Int, imageHeight: Int) -> Bool {
        
        for i in 0...arrayOfCardCoordinates.count-1{
            
            if checkCollision(cardOne: coordinates, cardTwo: arrayOfCardCoordinates[i], imageWidth: imageWidth, imageHeight: imageHeight){
                return true
            }
            
            
        }
        
        return false
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
    
    
//    func checkIfTwoCardsAreDisplayed() -> Bool{
//        var counter = 0
//        for card in list{
//            if card.isFlipped{
//                counter += 1
//            }
//        }
//        if counter == 2{
//            return true
//        }
//        return false
//    }
    
    func countDisplayedCards() -> Int{
        var counter = 0
        for card in list{
            if card.isFlipped{
                counter += 1
            }
        }
        return counter
        
    }
    
    
    
    func resetAllCards(){
        for card in list{
            card.isFlipped = false
        }
        
        
    }
    
    

    }
    
    
    


