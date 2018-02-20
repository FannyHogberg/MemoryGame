//
//  ViewController.swift
//  memoryGame
//
//  Created by Fanny Högberg on 2018-01-09.
//  Copyright © 2018 Fanny Högberg. All rights reserved.
//

import UIKit

//import AVFoundation



class ViewController: UIViewController, CAAnimationDelegate{
    
    var mask : CALayer?
    var btnInThisLevel = [UIButton]()
    var allViewsHoldingBtn = [UIView]()
    var cardsInThisLevel = [Card]()
    var coordinatesThisLevel = [Int]()
    let allCardsInBank = CardBank()
    var timer : Timer?
    var countUptimer = CountUpTimer()
    var gameLevel = Level()
    let containerForNextLevelAnimation = UIView()
    
    var pipeAnimationArray = [UIImage]()
    var flushAnimationArray = [UIImage]()
    
    @IBOutlet weak var toiletLid: UIView!
    @IBOutlet weak var toiletView: UIView!
    @IBOutlet weak var pipe: UIImageView!
    @IBOutlet weak var toiletBottom: UIImageView!
    
    
    @IBOutlet weak var level1: UIView!
    @IBOutlet weak var level2: UIView!
    @IBOutlet weak var level3: UIView!
    
    
    @IBOutlet weak var endOfGameView: UIVisualEffectView!
    @IBOutlet weak var endOfGameLabel: UILabel!
    
    @IBOutlet weak var quitGameVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var quitViewWithText: UIView!
    
    @IBOutlet weak var quitGameAnswerYes: UILabel!
    @IBOutlet weak var quitGameAnswerNo: UILabel!
    
    
    @IBOutlet weak var resetButton: UIImageView!
    
    @IBOutlet weak var nextLevelText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allViewsHoldingBtn = [level1, level2, level3]
        
        
        initMask()
        
        
        
        fixContainerForAnimationFirstTime()
        
        initPipeAnimationArray()
        initFlushAnimation()
        self.resetNextLevelText()
        
        endOfGameView.alpha = 0
        
        
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
    
    
    
    
    func initMask(){
        let sizeOfMask = self.view.frame.height * 4
        
        self.mask = CALayer()
        self.mask!.contents = UIImage(named: "toMask")!.cgImage
        self.mask!.contentsGravity = kCAGravityResizeAspect
        self.mask!.bounds = CGRect(x: 0, y: 0, width: sizeOfMask, height: sizeOfMask)
        self.mask!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.mask!.position = CGPoint(x: view.frame.width * 0.5, y: view.frame.height * 0.47)
        
        
    }
    
    
    
    func animateMask(){
        
        let maskSizeMiddle = view.frame.size.width * 0.5
        let maskSizeMiddle2 = maskSizeMiddle * 2.5

        let animation = CAKeyframeAnimation(keyPath: "bounds")
        animation.delegate = self

 //       animation.beginTime = CACurrentMediaTime() + 0.7      // delay

        let start = self.mask!.bounds
        let middle = CGRect(x: 0, y: 0, width: maskSizeMiddle, height: maskSizeMiddle)
        let middle2 = CGRect(x: 0, y: 0, width: maskSizeMiddle2, height: maskSizeMiddle2)
        let final = CGRect(x: 0, y: 0, width: 1, height: 1)

        animation.values = [start, middle, middle2, final]
        animation.keyTimes = [0, 0.4,0.6, 1.0]
        animation.duration = 2.5
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards

        animation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)]

        self.mask?.add(animation, forKey: "bounds")
        
    }
    
    
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        clearViewAnimation()
        self.containerForNextLevelAnimation.layer.mask = nil
        playBackgroundMusic()
        
        
        if gameLevel.levelNumber != allViewsHoldingBtn.count{       //If not last Level
        self.resetCardsAndButtonsThisLevel()
        self.gameLevel.setNextLevel()
        self.createCardsAndBtnForThisLevel()
        }
        else{                                                       //check for last level.. reset from beginning.
            resetButton.isUserInteractionEnabled = true
            self.resetCardsAndButtonsThisLevel()
            gameLevel.resetLevel()
            self.createCardsAndBtnForThisLevel()
            countUptimer.start()
            
        }
    }
    
    
    
    
    @IBAction func btnClicked(_ sender: UIButton) {
        

        
        playSoundEffect(list: cardsInThisLevel, index: sender.tag-1)
        
        
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
    
    
    
    @IBAction func flushToilet(_ sender: UITapGestureRecognizer) {
        playFlushToiletAudio()
        
        
    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
    self.toiletBottom.startAnimating()
        }
    }
    

    
    
    
    @IBAction func resetButtonClicked(_ sender: UITapGestureRecognizer) {
        resetButton.isUserInteractionEnabled = false
        
        self.containerForNextLevelAnimation.layer.mask = self.mask
        animateMask()
        
        


        
        
        
    }
    
    
    
    @IBAction func homeBtnClicked(_ sender: UITapGestureRecognizer) {
        quitGameVisualEffectView.effect = nil
        UIView.animate(withDuration: 5) {
            self.quitGameVisualEffectView.isHidden = false
            self.quitGameVisualEffectView.effect = UIBlurEffect(style: UIBlurEffectStyle.prominent)
        }
        
        quitViewWithText.alpha = 0
        self.quitViewWithText.isHidden = false
        
        UIView.animate(withDuration: 1) {
            self.quitViewWithText.alpha = 1
        }

    }
    
 
    @IBAction func goToHomeScreenClicked(_ sender: UITapGestureRecognizer) {
        countUptimer.reset()
        stopTimer()
        performSegue(withIdentifier: "goToStart", sender: self)
    }
    
    
    @IBAction func keepPlayingClicked(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.quitGameVisualEffectView.effect = nil
            self.quitViewWithText.alpha = 0
            
        }) { (finished) in
            self.quitGameVisualEffectView.isHidden = true
            self.quitViewWithText.isHidden = false
        }
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
            setSettingsForBtnThisLevel()
            setPositionForBtnBeforeAnimate()
            
            
            thisLevel.isHidden = false
        
            let timeInterval = gameLevel.pipeTimeInterval
            var index = cardsInThisLevel.count-1
            timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { _ in
                
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
        let pipeYValue = pipe.frame.height * 0.8
        let fromContainerTopToPipe = thisLevelContainerY - pipeYValue
        
        
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
        
        let duration = gameLevel.pipeAnimationDuration
        
        let pipeOpeningPointInImage = pipe.frame.width * 0.3            //Where the pipe opening are.
        let newPositionX = btnInThisLevel[index].frame.midX - pipeOpeningPointInImage
          
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            
            self.pipe.center.x = newPositionX
            
        }, completion: { finished in
            self.pipe.startAnimating()
            playPipeSound()
            
            self.animateButtonToDestination(index: index)
        })
        
        
    }
    
    
    
    
    func animateButtonToDestination(index: Int){
        
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
            playPlopInToilet()
            
        })
    }
    
    
    func resetCardsAndButtonsThisLevel(){

        
        allViewsHoldingBtn[gameLevel.levelNumber-1].isHidden = true
        
        for i in 0..<self.btnInThisLevel.count{
            let buttonImage = cardsInThisLevel[i].backImage
            btnInThisLevel[i].setImage(buttonImage, for: .normal)
            btnInThisLevel[i].transform = CGAffineTransform.identity
        }
        
        btnInThisLevel.removeAll()
        allCardsInBank.resetAllCards()

        

        
    }
    
    

    
    
    func endOfGame(){
                endOfGameView.alpha = 0
                containerForNextLevelAnimation.addSubview(endOfGameView)
                endOfGameView.isHidden = false
                endOfGameLabel.text = """
                \(gameLevel.nextLevelText)
                \(String(format:"%.02f", countUptimer.time)) \(NSLocalizedString ("SECONDS", comment: ""))
                """
                countUptimer.reset()
        
        UIView.animate(withDuration: 1.5) {
            self.endOfGameView.alpha = 1
        }
        
        
    }
    
    func playNextLevel(){
        
        if gameLevel.levelNumber < allViewsHoldingBtn.count {               //Check level is not the last
            
            //Display the "next level text"
            nextLevelText.text = gameLevel.nextLevelText
            containerForNextLevelAnimation.addSubview(nextLevelText)
            
            UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                
                self.nextLevelText.center.x += self.view.frame.width
                
            }, completion: { finish in
                
                self.containerForNextLevelAnimation.layer.mask = self.mask
                self.animateMask()      //When ended animate mask.
            })
            
        }
        else{
            endOfGame()
        }
        
        
    }
    
    

    
    func clearViewAnimation(){
        self.containerForNextLevelAnimation.alpha = 0
        self.resetNextLevelText()
        self.removeImagesFromContainerForNextLevelAnimation()
        
        
        self.endOfGameView.isHidden = true
     
    }
    
    
    func resetNextLevelText(){
    self.nextLevelText.center.x = self.view.frame.width * 0.5
    self.nextLevelText.center.y = self.view.frame.height * 0.5
    self.nextLevelText.center.x -= self.view.frame.width
    }
    
    
    func removeImagesFromContainerForNextLevelAnimation(){
        for subview in self.containerForNextLevelAnimation.subviews {
            if subview is UIImageView {
                subview.removeFromSuperview()
            }
        }
    }
    
    
    
    
    
    func playAnimation() {
        
        self.containerForNextLevelAnimation.alpha = 1
        
        let imageSize = Int(view.frame.width * 0.33)
        let halfImageSize = Int((Double(imageSize) * 0.5))
        var imageXValue = -50
        let widthOfScreen = Int(view.frame.width)
        var imageEndPosition = Int(view.frame.height) + Int(Double(halfImageSize) * 0.5)
        var animateLeftToRight = true
        var counter = 0
        
        let distanceBetweenImages = Int(view.frame.width * 0.13)
        
        nextLevelAnimation(imageXValue: imageXValue, imageYEndPosition: imageEndPosition, imageSize: imageSize)
        playNextLevelAudio()
        stopBackgroundMusic()
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            counter += 1
            if counter % 8 == 0 || counter > 50 && counter % 4 == 0 || counter > 80{
                if animateLeftToRight == true{
                    imageXValue += distanceBetweenImages
                }
                else{
                    imageXValue -= distanceBetweenImages
                }
                
                if imageXValue > widthOfScreen - halfImageSize{
                    imageEndPosition -= distanceBetweenImages
                    animateLeftToRight = false
                    
                }
                
                if imageXValue <= -halfImageSize {
                    imageEndPosition -= distanceBetweenImages
                    animateLeftToRight = true
                }
                
                self.nextLevelAnimation(imageXValue: imageXValue, imageYEndPosition: imageEndPosition, imageSize: imageSize)
                
            }
        }
    }
    
    
    @objc func nextLevelAnimation(imageXValue: Int, imageYEndPosition: Int, imageSize: Int){
        
        
        let imageStartPositionY = -imageSize
        let randomCardNumber = Int(arc4random_uniform(UInt32(allCardsInBank.list.count)))
        let randomImage = allCardsInBank.list[randomCardNumber].image
        let randomNumber = drand48()-0.5
        
        let endPosition = imageYEndPosition
        let imageView = UIImageView(image: randomImage)
        
        
        
        imageView.frame = CGRect(x: imageXValue, y: imageStartPositionY, width: imageSize, height: imageSize)
        containerForNextLevelAnimation.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.transform = imageView.transform.rotated(by: CGFloat(randomNumber))
        
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveLinear, animations: {
            imageView.frame.origin.y += CGFloat(endPosition)
        }, completion: nil)
        
        if imageYEndPosition <= -Int((Double(imageSize) * 0.5)){ //Half of image size
            stopTimer()
            playNextLevel()
        }
        
        
    }
    
    
    
    
    
    
    
    func stopTimer(){
        if let timer = self.timer{
            timer.invalidate()
        }
    }
    
    
    
    func openToiletLid() {
        
        let duration = 1.0
        
        
        let animationKey = "rotation"
        
        let animateOne = CABasicAnimation(keyPath: "transform.rotation")
        animateOne.duration = duration
        animateOne.repeatCount = 1
        animateOne.fromValue = toiletLid.layer.presentation()?.value(forKeyPath: "transform.rotation")
        animateOne.toValue = (Float(Double.pi) * (-0.5))
        animateOne.autoreverses = true
        
        
        self.toiletLid.layer.add(animateOne, forKey: animationKey)
        
    }
    
    

    
    
                func initPipeAnimationArray(){
                    for i in 1...4{
                        let image : UIImage!
                        image = UIImage(named: "pipe\(i)")
                        pipeAnimationArray.append(image)
                    }
                    for i in (1...4).reversed(){
                        let image : UIImage!
                        image = UIImage(named: "pipe\(i)")
                        pipeAnimationArray.append(image)
                    }
    
                    pipe.animationImages = pipeAnimationArray
                    pipe.animationDuration = 0.3
                    pipe.animationRepeatCount = 1
    
                }
    
    func initFlushAnimation(){
        for i in 1...3{
            let image : UIImage!
            image = UIImage(named: "toiletBottom\(i)")
            flushAnimationArray.append(image)
        }
        
        for i in (1...3).reversed(){
            let image : UIImage!
            image = UIImage(named: "toiletBottom\(i)")
            flushAnimationArray.append(image)
        }
        flushAnimationArray.append(UIImage(named: "toiletBottom4")!)
        flushAnimationArray.append(UIImage(named: "toiletBottom5")!)
        flushAnimationArray.append(UIImage(named: "toiletBottom4")!)
        
        for i in 6...8{
            let image : UIImage!
            image = UIImage(named: "toiletBottom\(i)")
            flushAnimationArray.append(image)
        }
        
        for i in (6...8).reversed(){
            let image : UIImage!
            image = UIImage(named: "toiletBottom\(i)")
            flushAnimationArray.append(image)
        }
        toiletBottom.animationImages = flushAnimationArray
        toiletBottom.animationDuration = 1.6
        toiletBottom.animationRepeatCount = 1
    }
    
    
}

