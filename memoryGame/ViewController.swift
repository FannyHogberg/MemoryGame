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
    let containerForNextLevelAnimation = UIView()
    
    var toiletAnimationArray = [UIImage]()
    
    @IBOutlet weak var nextLevelText: UILabel!
    @IBOutlet weak var toiletAnimate: UIImageView!
    @IBOutlet weak var toiletLid: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerForNextLevelAnimation.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(containerForNextLevelAnimation)
        
        initToiletAnimationArray()

        
        toiletAnimate.startAnimating()


        gameLevel = Level(heightOfView: Double(view.frame.height), widthOfView: Double(view.frame.width))
        
        
        nextLevelText.center.x -= view.bounds.width
        createButtonsWithCards()
        

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func btnClicked(sender:UIButton!) {

        playSoundCardInThisLevel(index: sender.tag-1)

        if allCardsInBank.countDisplayedCards() < 2{
            flipToShowImage(index: sender.tag-1)
  
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
    
    
    func flipToShowImage(index: Int) {
        
        let cardImage = cardsInThisLevel[index].image
        let isFlipped : Bool = cardsInThisLevel[index].isFlipped
        let btn = btnInThisLevel[index]
        
        if !isFlipped{
            btn.setImage(cardImage, for: .normal)
            UIView.transition(with: btn, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            cardsInThisLevel[index].setIsFlipped(status: true)
            
        }
        
        
    }
    
    
    func flipToShowBackImage(index: Int) {
        
        let cardImage = cardsInThisLevel[index].backImage
        let isflipped : Bool = cardsInThisLevel[index].isFlipped
        let btn = btnInThisLevel[index]
        
        if isflipped{
            btn.setImage(cardImage, for: .normal)
            UIView.transition(with: btn, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
            cardsInThisLevel[index].setIsFlipped(status: false)
            
        }
        
    }
    
    
    func flipAllCardBack(){
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.shakeButtons()
        }
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            for number in 0..<self.btnInThisLevel.count{
                self.flipToShowBackImage(index: number)
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
    
    func shakeButtons(){
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
   
        
        for index in 0...btnInThisLevel.count-1{
            
            if cardsInThisLevel[index].isFlipped{
                
                let btn = btnInThisLevel[index]
                
                let fromPoint = CGPoint(x: btn.center.x - 5, y: btn.center.y - 5)
                let fromValue = NSValue(cgPoint: fromPoint)
                
                let toPoint = CGPoint(x: btn.center.x + 5, y: btn.center.y + 5)
                let toValue = NSValue(cgPoint: toPoint)
                
                shake.fromValue = fromValue
                shake.toValue = toValue
                
                btn.layer.add(shake, forKey: nil)
                
                
                
            }
            
            
            
        }

        
        
    }
    

    func removePairOfCards(arrayOfCards: [Card], indexOfCardInArray: Int){
        
        openToiletLid()
        
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
            
            
            let randomNumber = arc4random_uniform(100)
            
           
            let btn = UIButton(type: .custom) as UIButton
            btn.setImage(cardsInThisLevel[i].backImage, for: .normal)
            btn.transform = CGAffineTransform(rotationAngle: CGFloat(4))
            btn.transform = CGAffineTransform(scaleX: 10, y: 10);
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
            
         let animator = UIViewPropertyAnimator(duration: 5, dampingRatio: 0.4) {
            let x = CGFloat(self.cardsInThisLevel[i].xCoordinate)
            let y = CGFloat(self.cardsInThisLevel[i].yCoordinate)
            let width = CGFloat(self.cardsInThisLevel[i].width)
            let height = CGFloat(self.cardsInThisLevel[i].height)
            
            self.btnInThisLevel[i].isHidden = false
            self.btnInThisLevel[i].frame = CGRect(x: x, y: y, width: width, height: height)
            
            
        }
            animator.startAnimation()
            
            
            
        }

    }
    

    
    @objc func nextLevelAnimation(imageXValue: Int, imageYEndPosition: Int){
        
        let randomCardNumber = Int(arc4random_uniform(UInt32(allCardsInBank.list.count)))
        let randomImage = allCardsInBank.list[randomCardNumber].image
        let randomNumber = drand48()-0.5
        
        let endPosition = imageYEndPosition
        let imageView = UIImageView(image: randomImage)
        
        
        
        imageView.frame = CGRect(x: imageXValue, y: -129, width: 162, height: 129)
        containerForNextLevelAnimation.addSubview(imageView)
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
            for subview in self.containerForNextLevelAnimation.subviews{
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
        for subview in self.containerForNextLevelAnimation.subviews {
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
    
    
    func playSoundCardInThisLevel(index: Int){
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: cardsInThisLevel[index].sound)
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
    
    
    
    func openToiletLid() {
        
        UIView.animate(withDuration: 1, delay: 0, options: [.autoreverse, .allowUserInteraction], animations: {
            self.toiletLid.layer.anchorPoint = CGPoint(x: 0.32, y: 1 )
            
            self.toiletLid.transform = CGAffineTransform(rotationAngle: 5.0)
            
        }, completion: { finished in
            self.toiletLid.transform = CGAffineTransform.identity
            self.toiletLid.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        })
    }
    
    func initToiletAnimationArray(){
        
        for i in 1...9{
            let image : UIImage!
            image = UIImage(named: "toiletimage\(i)")
            toiletAnimationArray.append(image)
        }
        for i in (1...9).reversed(){
            let image : UIImage!
            image = UIImage(named: "toiletimage\(i)")
            toiletAnimationArray.append(image)
        }
        
        toiletAnimate.animationImages = toiletAnimationArray
        toiletAnimate.animationDuration = 1
     //   toiletAnimate.animationRepeatCount = 1
        
        
    }
    
    
}

