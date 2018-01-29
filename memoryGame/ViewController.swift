//
//  ViewController.swift
//  memoryGame
//
//  Created by Fanny Högberg on 2018-01-09.
//  Copyright © 2018 Fanny Högberg. All rights reserved.
//

import UIKit

import AVFoundation



class ViewController: UIViewController{
    
    
    
    var btnInThisLevel = [UIButton]()
    var cardsInThisLevel = [Card]()
    var coordinatesThisLevel = [Int]()
    let allCardsInBank = CardBank()
    var timer : Timer?
    var timeInterval : Double = 0
    var audioPlayer : AVAudioPlayer!
    var gameLevel : Level?
    
    @IBOutlet weak var nextLevelText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var image1 = UIImage(named: "toalett1")
        
        
        gameLevel = Level(heightOfView: Double(view.frame.height), widthOfView: Double(view.frame.width))
        
        
        nextLevelText.center.x -= view.bounds.width
        createButtonsWithCards()
        

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func btnClicked(sender:UIButton!) {

        
        cardsInThisLevel[sender.tag-1].playSound()
        
        
        if allCardsInBank.countDisplayedCards() < 2{
            cardsInThisLevel[sender.tag-1].flipToShowImage(cardButton: btnInThisLevel[sender.tag-1])
            
        }
        if allCardsInBank.countDisplayedCards() == 2
        {
            if allCardsInBank.checkIfDisplayedCardsAreEqual(){
                removePairOfCards(arrayOfCards: cardsInThisLevel, indexOfCardInArray: sender.tag-1)
            }
            else{
                flipAllCardBack()
            }
            
            
        }
 
        
    }
    
    
    
    
    
    func checkAndRunNextLevel() {
        var counter = 0
        
        for btn in btnInThisLevel{
            if btn.isHidden == true{
                counter += 1
            }
        }
        if counter == btnInThisLevel.count{
            playAnimation()
        }
        
    }
    
    
    
    
    
    func flipAllCardBack(){
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            
            for number in 0..<self.btnInThisLevel.count{
                self.cardsInThisLevel[number].flipToHide(cardButton: self.btnInThisLevel[number])
            }
        }
        for btn in btnInThisLevel{
            btn.isEnabled = false
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            for btn in self.btnInThisLevel{
                btn.isEnabled = true
            }
        }
        
        
        
    }
    

    func removePairOfCards(arrayOfCards: [Card], indexOfCardInArray: Int){
        self.allCardsInBank.resetAllCards()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            let cardId = arrayOfCards[indexOfCardInArray].id
            for number in 0..<arrayOfCards.count{
                if arrayOfCards[number].id == cardId{
                    self.btnInThisLevel[number].isHidden = true
                    self.btnInThisLevel[indexOfCardInArray].isHidden = true
                }
            }
           self.checkAndRunNextLevel()
        }
        
    }
    
    func removeButtonsAndResetCards(){
        for button in btnInThisLevel{
            button.removeFromSuperview()
        }
        btnInThisLevel.removeAll()
    
    }
    
    
    func resetAndPlayNextLevel(){
        
        gameLevel?.setNextLevel()
        
        if (gameLevel?.noMoreLevel)!{
            
            print("SPELET SLUT")    ///HÄNDA NÅT HÄR
            
        }
        
//        if gameLevel == 2{
//            gameLevel = 3
//        }
//        else if gameLevel == 3{
//            gameLevel = 5
//        }
//        else{
//            print("SPELET SLUT")//GÖRA NÅT HÄÄÄÄÄÄR
//        }
        
        removeButtonsAndResetCards()
        createButtonsWithCards()
        
        
    }
    
    
    
    
    
    func createButtonsWithCards(){
        //Creating Cards with stored x and y positions.
        cardsInThisLevel = allCardsInBank.createCardsToPlay(levelInGame: gameLevel!, viewvWidth:
        Int(view.frame.width), viewHeight: Int(view.frame.height))
        
        
        //Create btn...
        for i in 0...cardsInThisLevel.count-1{
            
       //     let randomNumber = drand48()-0.5                      FÅ DET HÄR ATT FUNGERA
                  //      btn.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(randomNumber))
            let btn = UIButton(type: .custom) as UIButton
            btn.setImage(cardsInThisLevel[i].backImage, for: .normal)
            btn.adjustsImageWhenDisabled = false
            btn.tag = i+1
            btn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
            btn.frame = CGRect(x: 385, y: 75, width: 10, height: 10)
            btn.isHidden = true

            self.view.addSubview(btn)
            btnInThisLevel.append(btn)


    }
        
        animateCardsToFinalDestination()

        
    }
    
    
    func animateCardsToFinalDestination(){
        
        for i in 0...cardsInThisLevel.count-1{
            
         let animator = UIViewPropertyAnimator(duration: 4, dampingRatio: 0.5) {
            let x = CGFloat(self.cardsInThisLevel[i].xCoordinate)
            let y = CGFloat(self.cardsInThisLevel[i].yCoordinate)
            let width = CGFloat(self.cardsInThisLevel[i].width)
            let height = CGFloat(self.cardsInThisLevel[i].height)
            
            self.btnInThisLevel[i].isHidden = false
            self.btnInThisLevel[i].frame = CGRect(x: x, y: y, width: width, height: height)
            
            
            //        self.squareView.frame = finalPosition
        }
            animator.startAnimation()
            
            
//            UIView.animate(withDuration: 0.6, delay: 0, options: .curveLinear, animations: {
//                let x = CGFloat(self.cardsInThisLevel[i].xCoordinate)
//                let y = CGFloat(self.cardsInThisLevel[i].yCoordinate)
//                let width = CGFloat(self.cardsInThisLevel[i].width)
//                let height = CGFloat(self.cardsInThisLevel[i].height)
//
//                self.btnInThisLevel[i].isHidden = false
//                self.btnInThisLevel[i].frame = CGRect(x: x, y: y, width: width, height: height)
//            }, completion: nil)
            
        }

    }

    
    @objc func nextLevelAnimation(imageXValue: Int, imageYEndPosition: Int){
        
        let randomCardNumber = Int(arc4random_uniform(UInt32(allCardsInBank.list.count)))
        let randomImage = allCardsInBank.list[randomCardNumber].image
        let randomNumber = drand48()-0.5
        
        let endPosition = imageYEndPosition
        let imageView = UIImageView(image: randomImage)
        
        
        
        imageView.frame = CGRect(x: imageXValue, y: -129, width: 162, height: 129)
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.transform = imageView.transform.rotated(by: CGFloat(randomNumber))
        
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveLinear, animations: {
            imageView.frame.origin.y += CGFloat(endPosition)
        }, completion: nil)
        
        print("SKA STOPPA VID -20::::::::   \(imageYEndPosition)")
        if imageYEndPosition <= -20{
            stopTimer()
            newLevelShowText()
        }
        
        
    }
    
    func newLevelShowText(){
        
        nextLevelText.text = gameLevel?.nextLevelText
        self.view.bringSubview(toFront: nextLevelText)
        
        UIView.animate(withDuration: 1, delay: 1, options: [], animations: {
            self.nextLevelText.center.x += self.view.bounds.width
        }, completion: { finish in
            
            self.clearViewAnimation()
        })
        
        
        
        
    }
    
    func clearViewAnimation(){
        
        UIView.animate(withDuration: 1, delay: 1, options: .curveEaseInOut, animations: {
            for subview in self.view.subviews{
                if subview is UIImageView{
                    subview.alpha = 0
                }
            }
            self.nextLevelText.center.x += self.view.bounds.width
        }, completion: { _ in
            self.nextLevelText.center.x -= self.view.bounds.width * 2
            self.removeFromSuperview()
            self.resetAndPlayNextLevel()
        
        })
        
        
            }
    
    
    
    func removeFromSuperview(){
        for subview in self.view.subviews {
            if subview is UIImageView {
                subview.removeFromSuperview()
            }
    }
    
    }
    
    
    func playAnimation() {
        
        
        
        var imageXValue = -50
        let widthOfScreen = Int(view.frame.width)
        var imageEndPosition = Int(view.frame.height)+30
        timeInterval = 2.0
        var animateLeftToRight = true
        var counter = 0
        
        
        
        nextLevelAnimation(imageXValue: imageXValue, imageYEndPosition: imageEndPosition)
        playNextLevelAudio()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            counter += 1
            if counter % 8 == 0 || counter > 50 && counter % 4 == 0 || counter > 80{
            print(counter)
            if animateLeftToRight == true{
                imageXValue += 70
            }
            else{
                imageXValue -= 70
            }
            
            if imageXValue > widthOfScreen - 100 {
                imageEndPosition -= 70
                animateLeftToRight = false
                
            }
            
            if imageXValue <= -100{
                imageEndPosition -= 70
                animateLeftToRight = true
            }
            
            self.nextLevelAnimation(imageXValue: imageXValue, imageYEndPosition: imageEndPosition)
            
        }
        }
    }
    
    func playNextLevelAudio(){
        let audio = Bundle.main.url(forResource: "nextLevel", withExtension: "mp3")!
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
        }
        catch{
            print(error)
        }
        audioPlayer.play()
        
    }
    

    
    
    func stopTimer(){
        if let timer = self.timer{
            timer.invalidate()
        }
    }
    
    
    
}

