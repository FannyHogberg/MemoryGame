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
    var allViewsHoldingBtn = [UIView]()
    var cardsInThisLevel = [Card]()
    var coordinatesThisLevel = [Int]()
    let allCardsInBank = CardBank()
    var timer : Timer?
    var countUptimer = CountUpTimer()
    var timeInterval : Double = 0
    var audioPlayer : AVAudioPlayer!
    var gameLevel = Level()
    let containerForNextLevelAnimation = UIView()
    
    var toiletAnimationArray = [UIImage]()
    
    @IBOutlet weak var nextLevelText: UILabel!
 //   @IBOutlet weak var toiletAnimate: UIImageView!
//    @IBOutlet weak var toiletLid: UIImageView!
    @IBOutlet weak var toiletLid: UIView!
    
    @IBOutlet weak var toiletView: UIView!
    
    @IBOutlet weak var pipe: UIImageView!
    
    @IBOutlet weak var level1: UIView!
    @IBOutlet weak var level2: UIView!
    @IBOutlet weak var level3: UIView!
    
    
    @IBOutlet weak var endOfGameView: UIVisualEffectView!
    
    
    @IBOutlet weak var endOfGameLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pipe.center.x -= view.bounds.width
        
//       let oldFrame = toiletLid.frame
//
      //  var anchorPoint = CGPoint(x: 0.4, y: 1)
//        toiletLid.layer.anchorPoint = CGPoint(x: 0.4, y: 1)
//       toiletLid.frame = oldFrame
        
        
//        let oldCenter = toiletLid.center
//        toiletLid.layer.anchorPoint = CGPoint(x: 0.4, y: 1)
//        toiletLid.center = oldCenter
//
    
        
//        let centerXConstraint = toiletLid.bounds.midX
//            toiletLid.layer.anchorPoint = CGPoint(x: 0.4, y: 1)
//            centerXConstraint.constant = centerXConstraint.constant + toiletLid.bounds.size.width/2
//
//
//        var old = toiletLid.layer.position.x
//        toiletLid.layer.anchorPoint = CGPoint(x: 0.4, y: 1)
//        toiletLid.layer.position.x = old
//
        
        
        
        
//
        allViewsHoldingBtn = [level1, level2, level3]
        

        
        
        fixContainerForAnimationFirstTime()
        
   //     initToiletAnimationArray()
        
        nextLevelText.center.x -= view.bounds.width
        
        
        
    }
    

    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createCardsAndBtnForThisLevel()
        countUptimer.start()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func btnClicked(_ sender: UIButton) {
        
        playSoundEffect(list: cardsInThisLevel, index: sender.tag-1)

 //       playSoundCardInThisLevel(index: sender.tag-1)
        
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
    
    

    
    
    @IBAction func goToStartScreen(_ sender: UITapGestureRecognizer) {
        
        countUptimer.reset()
        stopTimer()
       performSegue(withIdentifier: "goToStart", sender: self)
    }
    
    
    
    
    
    
    func createCardsAndBtnForThisLevel(){
        
        //Creating card for this level.
        cardsInThisLevel = allCardsInBank.createCardsToPlay(levelInGame: gameLevel)
        
        //the view holding btns...
        let thisLevel = allViewsHoldingBtn[gameLevel.levelNumber-1]
        
        //Add to list
        for subview in thisLevel.subviews{
            if subview is UIButton{
                btnInThisLevel.append(subview as! UIButton)
                
            }
        }
        print("BTN IN THIS LEVEL COUNT \(btnInThisLevel.count)")
        print("CARDIN THIS LEVEL \(cardsInThisLevel.count)")
        setSettingsForBtnThisLevel()
        setPositionForBtnBeforeAnimate()
        
        
        thisLevel.isHidden = false
//        view.bringSubview(toFront: thisLevel)
        
        var index = cardsInThisLevel.count-1
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            
            self.animateToFinalDestination(index: index)
            index -= 1
            
        }
        
    }
    
    
    func setSettingsForBtnThisLevel(){
        
        for btn in btnInThisLevel{
            btn.adjustsImageWhenDisabled = false
            btn.imageView?.contentMode = UIViewContentMode.scaleAspectFit

        }
        
        
    }
    
    
    func setPositionForBtnBeforeAnimate(){
        
        let thisLevelContainerY = allViewsHoldingBtn[gameLevel.levelNumber-1].frame.minY
        print(thisLevelContainerY)
        let pipeYValue = pipe.frame.midY
        let fromContainerTopToPipe = thisLevelContainerY - pipeYValue
        print(fromContainerTopToPipe)
        
        
        for btn in btnInThisLevel{
        
        let newPositionY = -btn.frame.midY - fromContainerTopToPipe
 
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: 0 , y: newPositionY)
        transform = transform.scaledBy(x: 0.1, y: 0.1)
        
            
            
            
        btn.transform = transform

        }

    }
    
    
    

    func hidePipe(){
        
        UIView.animate(withDuration: 1.5, delay: 0.0, options: [.curveEaseInOut], animations: {
            
            self.pipe.center.x -= self.view.bounds.width
            
        }, completion: nil)
    }
    
    
    func animatePipeToDestination(index: Int){
        
        let pipeOpeningPointInImage = pipe.frame.width * 0.3            //Where the pipe opening are.
        let newPositionX = btnInThisLevel[index].frame.midX - pipeOpeningPointInImage
        
        UIView.animate(withDuration: 0.8, delay: 0.0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            
            self.pipe.center.x = newPositionX
            
        }, completion: { finished in
             self.animateButtonToDestination(index: index)
        })
        
        
    }
    
    
    func animateButtonToDestination(index: Int){
        
        //          self.toiletAnimate.startAnimating()
        btnInThisLevel[index].isHidden = false
        let animator = UIViewPropertyAnimator(duration: 1.5, dampingRatio: 0.4) {
            self.btnInThisLevel[index].transform = CGAffineTransform.identity
        }
        
        animator.startAnimation()
        
        
    }
    
    
    func animateToFinalDestination(index: Int){
        
        if index >= 0{
            
            self.animatePipeToDestination(index: index)
            
        }
        else{
            hidePipe()
            stopTimer()
        }
    }
    
    
    
    func fixContainerForAnimationFirstTime(){
        containerForNextLevelAnimation.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(containerForNextLevelAnimation)
        self.containerForNextLevelAnimation.alpha = 0
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
        for btn in btnInThisLevel{
            btn.isEnabled = false
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.shakeButtons()
        }
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
            for number in 0..<self.btnInThisLevel.count{
                self.flipToShowBackImage(index: number)
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
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
                    self.animateBtnToToilet(btn: self.btnInThisLevel[number])
                    self.animateBtnToToilet(btn: self.btnInThisLevel[indexOfCardInArray])
                    
                }
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            self.checkAndRunNextLevel()
        }
    }
    
    
    func animateBtnToToilet(btn: UIButton){
        
        //Calculate value of Y...
        let thisLevelContainer = allViewsHoldingBtn[gameLevel.levelNumber-1]
        let containerHeight = thisLevelContainer.frame.height
        let containerMaxY = thisLevelContainer.frame.maxY
    
        let distansFromBtnToContainerBottom = containerHeight - btn.frame.midY
        let toiletY = toiletView.frame.midY
        let distansBetweenContainerAndToilet = toiletY - containerMaxY
        
        let newPositionY = distansFromBtnToContainerBottom + distansBetweenContainerAndToilet
        
        //calculate value of X
        let btnX = btn.frame.midX
        let newPositionX = (self.toiletView.frame.width * 0.4) - btnX
        
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: newPositionX , y: newPositionY)
        transform = transform.scaledBy(x: 0.1, y: 0.1)
        
        
        UIView.animate(withDuration: 0.5, animations: {
            btn.transform = transform
        }, completion: { finished in
            btn.isHidden = true
            
        })
    }
    
    
    func removeButtonsAndResetCards(){
        for button in btnInThisLevel{
            button.removeFromSuperview()
        }
        btnInThisLevel.removeAll()
        
    }
    
    
    func resetAndPlayNextLevel(){
        
        gameLevel.setNextLevel()
        
        if gameLevel.noMoreLevel{
            
            
            endOfGameView.isHidden = false
            endOfGameLabel.text = """
            HURRA!
            Du klarade spelet på:
            \(String(format:"%.02f", countUptimer.time)) sekunder.
            """
            countUptimer.reset()
            
        }
        else{
            removeButtonsAndResetCards()
            createCardsAndBtnForThisLevel()
            
        }       
        
    }
    
    
    
    
    
    func newLevelShowText(){
        
        nextLevelText.text = gameLevel.nextLevelText
        self.view.bringSubview(toFront: nextLevelText)
        
        UIView.animate(withDuration: 1, delay: 1, options: [], animations: {
            self.nextLevelText.center.x += self.view.bounds.width
        }, completion: { finish in
            
            self.clearViewAnimation()
        })
        
        
        
        
    }
    
    func clearViewAnimation(){
        
        UIView.animate(withDuration: 1, delay: 1, options: .curveEaseInOut, animations: {
            self.containerForNextLevelAnimation.alpha = 0
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
        
        self.containerForNextLevelAnimation.alpha = 1
        
        
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
        
        if imageYEndPosition <= -20{
            stopTimer()
            newLevelShowText()
        }
        
        
    }
    
    func playNextLevelAudio(){
        if soundEffectIsOn {
        let audio = Bundle.main.url(forResource: "nextLevel", withExtension: "mp3")!
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
        }
        catch{
            print(error)
        }
        audioPlayer.play()
        }
    }
    
    
//    func playSoundCardInThisLevel(index: Int){
//
//        
    
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: cardsInThisLevel[index].sound)
//        }
//        catch{
//            print(error)
//        }
//        audioPlayer.play()
//
        
        
//    }
    
    
    
    
    
    func stopTimer(){
        if let timer = self.timer{
            timer.invalidate()
        }
    }
    

    
    func openToiletLid() {
        
                    let animationKey = "rotation"
        
                        let animateOne = CABasicAnimation(keyPath: "transform.rotation")
                        animateOne.duration = 1
                        animateOne.repeatCount = 1
                        animateOne.fromValue = toiletLid.layer.presentation()?.value(forKeyPath: "transform.rotation")
                        animateOne.toValue = (Float(Double.pi) * (-0.5))
                        animateOne.autoreverses = true

                    self.toiletLid.layer.add(animateOne, forKey: animationKey)
    
                }
    
    
        
        
        
        
//            func initToiletAnimationArray(){
//                for i in 1...10{
//                    let image : UIImage!
//                    image = UIImage(named: "toiletAnimate\(i)")
//                    toiletAnimationArray.append(image)
//                }
//                for i in (1...10).reversed(){
//                    let image : UIImage!
//                    image = UIImage(named: "toiletAnimate\(i)")
//                    toiletAnimationArray.append(image)
//                }
//
//                toiletAnimate.animationImages = toiletAnimationArray
//                toiletAnimate.animationDuration = 0.5
//                toiletAnimate.animationRepeatCount = 1
//
//
//            }
    
            
}

