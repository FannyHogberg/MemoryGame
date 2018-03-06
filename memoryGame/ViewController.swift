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
    let allCardsInBank = CardBank()
    var timer : Timer?
    var endOfGameTimer : Timer?
    var blinkTimer : Timer?
    var countUptimer = CountUpTimer()
    var gameLevel = Level()
    let containerForNextLevelAnimation = UIView()
    var pointCounter = 0            //one point for each pair shown
    
    var pipeAnimationArray = [UIImage]()
    var flushAnimationArray = [UIImage]()
    var cardBackBlinkArray = [UIImage]()
    
    @IBOutlet weak var toiletLid: UIView!
    @IBOutlet weak var toiletView: UIView!
    @IBOutlet weak var pipe: UIImageView!
    @IBOutlet weak var toiletBottom: UIImageView!
    
    
    @IBOutlet weak var level1: UIView!
    @IBOutlet weak var level2: UIView!
    @IBOutlet weak var level3: UIView!
    
    
    @IBOutlet weak var endOfGameView: UIView!
    
    @IBOutlet weak var timerResults: UILabel!
    @IBOutlet weak var endOfGameLevel1Label: UILabel!
    @IBOutlet weak var endOfGameLevel2Label: UILabel!
    @IBOutlet weak var endOfGameLevel3Label: UILabel!
    
    @IBOutlet weak var youDidItLabel: UILabel!
    
    @IBOutlet weak var scoreLevel1Stack: UIStackView!
    var level1ScoreImages = [UIImageView]()
    @IBOutlet weak var scoreLevel2Stack: UIStackView!
    var level2ScoreImages = [UIImageView]()
    @IBOutlet weak var scoreLevel3Stack: UIStackView!
    var level3ScoreImages = [UIImageView]()
    
    var allGoldenImages = [UIImageView]()
    
    
    @IBOutlet weak var quitGameVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var quitViewWithText: UIView!
    
    @IBOutlet weak var quitEndOfGameViewGameAnswerYes: UILabel!
    @IBOutlet weak var quitGameAnswerNo: UILabel!
    
    
    @IBOutlet weak var resetButton: UIImageView!
    
    @IBOutlet weak var nextLevelText: UILabel!
    
    @IBOutlet weak var dripping: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        initCardBackBlink()
        
        allViewsHoldingBtn = [level1, level2, level3]
        
        
        initMask()
        
        
        fixContainerForAnimationFirstTime()
        
        initPipeAnimationArray()
        initFlushAnimation()
        self.resetNextLevelText()
        
        createArrayOfScorePresentation()

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
    
    
    func createArrayOfScorePresentation(){
        
        for subview in scoreLevel1Stack.subviews
        {
            if let item = subview as? UIImageView
            {
                level1ScoreImages.append(item)
            }
        }
        for subview in scoreLevel2Stack.subviews
        {
            if let item = subview as? UIImageView
            {
                level2ScoreImages.append(item)
            }
        }
        for subview in scoreLevel3Stack.subviews
        {
            if let item = subview as? UIImageView
            {
                level3ScoreImages.append(item)
            }
        }
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
        
        self.resetCardsAndButtonsThisLevel()
        self.gameLevel.setNextLevel()
        self.createCardsAndBtnForThisLevel()
        
    }
    
    
    
    
    @IBAction func btnClicked(_ sender: UIButton) {
        
        sender.imageView?.stopAnimating()   //The card cant blink when you flip cards.
        
//        cardsInThisLevel[sender.tag-1].playSound()
        playSoundEffect(list: cardsInThisLevel, index: sender.tag-1)
        
        
        if allCardsInBank.countDisplayedCards() < 2{
            flipToShowImage(index: sender.tag-1)
            
        }
        if allCardsInBank.countDisplayedCards() == 2
        {
            if allCardsInBank.checkIfDisplayedCardsAreEqual(){
                
                removePairOfCards()
//                removePairOfCards(arrayOfCards: cardsInThisLevel, indexOfCardInArray: sender.tag-1)
            }
            else{
                flipAllCardBack()
            }
            
            pointCounter += 1
        }
    }
    
    
    
    
    
    @IBAction func flushToilet(_ sender: UITapGestureRecognizer) {
        
       // playFlushToiletAudio()
        playThisSound(named: .flushToilet)
        self.toiletBottom.startAnimating()
        
    }
    
    
    
    
    
    @IBAction func resetButtonClicked(_ sender: UITapGestureRecognizer) {
        resetButton.isUserInteractionEnabled = false
        fadeBackgroundMusic(seconds: 3)
        playThisSound(named: .FlushToiletLong)
        
        resetToLevel1()

    }
    
    
    
    
    @IBAction func homeBtnClicked(_ sender: UITapGestureRecognizer) {
        quitGameVisualEffectView.effect = nil
        UIView.animate(withDuration: 5) {
            self.quitGameVisualEffectView.isHidden = false
            self.view.bringSubview(toFront: self.quitGameVisualEffectView)
            
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
        stopBlinkTimer()
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
        startBlinkAnimation()
        
        thisLevel.isHidden = false
        
        let timeInterval = gameLevel.pipeTimeInterval
        var index = cardsInThisLevel.count-1
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { _ in
            
            self.animateToFinalDestination(index: index)
            index -= 1
        }
    }
    
    
    
    
    
    func startBlinkAnimation(){
        
        var btnArray = [UIButton]()
        
        blinkTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in      // Start timer for blinking images
            
            for btn in self.btnInThisLevel{         //create array with btn that are not hidden
                if btn.isHidden == false{
                    btnArray.append(btn)
                }
            }
            
            let randomNumber =  Int(arc4random_uniform(UInt32(btnArray.count)))
            
            if self.btnInThisLevel[randomNumber].currentImage == UIImage(named: "cardBack1"){
                self.btnInThisLevel[randomNumber].imageView?.startAnimating()
            }
            
            btnArray.removeAll()
        }
    }
    
    
    
    
    func stopBlinkTimer(){
        if let timer = blinkTimer{
            timer.invalidate()
        }
    }
    
    
    
    
    func setSettingsForBtnThisLevel(){
        
        for btn in btnInThisLevel{
            btn.adjustsImageWhenDisabled = false
            btn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            btn.isEnabled = true
            btn.imageView?.animationImages = cardBackBlinkArray
            btn.imageView?.animationRepeatCount = 1
            btn.imageView?.animationDuration = 0.5
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
        let animator = UIViewPropertyAnimator(duration: 1.5, dampingRatio: 0.45) {
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
        if counter == btnInThisLevel.count{         //if all cards are hidden
            
            savePointsThisLevel()
            stopBlinkTimer()
            playAnimation()
        }
    }
    
    
    
    
    func savePointsThisLevel(){
        if !allCardsInBank.didAnyCardFlippedMoreThanTwoTimes(){
            gameLevel.savePointsThisLevel(points: 0)        //MAX POINTS
        }
        else {
            gameLevel.savePointsThisLevel(points: pointCounter)
        }
        pointCounter = 0
    }
    
    
    
    
    
    func flipToShowImage(index: Int) {
        
        let cardImage = cardsInThisLevel[index].image
        let isFlipped : Bool = cardsInThisLevel[index].isFlipped
        let btn = btnInThisLevel[index]
        
        if !isFlipped{
            btn.setImage(cardImage, for: .normal)
            UIView.transition(with: btn, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            
            
            cardsInThisLevel[index].flipCard()
        }
    }
    
    
    
    
    func flipToShowBackImage(index: Int) {
        
        let cardImage = cardsInThisLevel[index].backImage
        let isflipped : Bool = cardsInThisLevel[index].isFlipped
        let btn = btnInThisLevel[index]
        
        if isflipped{
            btn.setImage(cardImage, for: .normal)
            UIView.transition(with: btn, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
            cardsInThisLevel[index].flipCard()
            //          cardsInThisLevel[index].setIsFlipped(status: false)
            
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
    
    
    
//Removes flipped cards to toilet.
    func removePairOfCards(){

        var indexList = [Int]()
        
        for i in 0...cardsInThisLevel.count-1{
            
            if cardsInThisLevel[i].isFlipped{
                indexList.append(i)
            }
            
        }
        
        let btn1 = btnInThisLevel[indexList[0]]
        let btn2 = btnInThisLevel[indexList[1]]
        
        openToiletLid()

        animatePairOfBtnToToilet(btn1: btn1, btn2: btn2)
        
        allCardsInBank.setAllCardToBeNotFlipped()          //VARFÖR?

        
        
        
        //BLIR KALLAD PÅ FLERA GÅNER!!!!!! VARFÖR TITTAR MA INTE BARA PÅ DE SOM INTE ÄR GÖMDA?
        
        
//        self.allCardsInBank.setAllCardToBeNotFlipped()          //VARFÖR?
//
//        let card1ID = arrayOfCards[indexOfCard].id
//        let card1 = arrayOfCards[indexOfCard]
//
//        for number in 0..<arrayOfCards.count{
//            if arrayOfCards[number].id == card1ID && cardIdClickedCard !=== arrayOfCards[number].id {
//                self.animatePairOfBtnToToilet(btn1: self.btnInThisLevel[number], btn2: self.btnInThisLevel[indexOfCardInArray])
////                self.animateBtnToToilet(btn: self.btnInThisLevel[number])
//                self.btnInThisLevel[number].isEnabled = false               //cant click at the card
////                self.animateBtnToToilet(btn: self.btnInThisLevel[indexOfCardInArray])
//                self.btnInThisLevel[indexOfCard].isEnabled = false   //Cant click at the card
//
//            }
//        }
        
//        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
//
//            self.checkAndRunNextLevel()
//        }
    }
    
    
    
    //animateBtnToToilet
    func animatePairOfBtnToToilet(btn1: UIButton, btn2: UIButton){
        
        let btnList = [btn1, btn2]
        
        let transform1 = CGAffineTransform.identity
        let transform2 = CGAffineTransform.identity
        
        var transformList = [transform1, transform2]
        
        //Calculate value of Y...
        let thisLevelContainer = allViewsHoldingBtn[gameLevel.levelNumber-1]
        let containerHeight = thisLevelContainer.frame.height
        let containerMaxY = thisLevelContainer.frame.maxY
        let toiletY = toiletView.frame.midY
        let distansBetweenContainerAndToilet = toiletY - containerMaxY

        for i in 0...btnList.count-1{
            
        let distansFromBtnToContainerBottom = containerHeight - btnList[i].frame.midY

        let newPositionY = distansFromBtnToContainerBottom + distansBetweenContainerAndToilet
        
        //calculate value of X
        let btnX = btnList[i].frame.midX
        let newPositionX = (self.toiletView.frame.width * 0.4) - btnX
        
        transformList[i] = transformList[i].translatedBy(x: newPositionX , y: newPositionY)
        transformList[i]  = transformList[i].scaledBy(x: 0.04, y: 0.04)
        
  
        }
        
        UIView.animate(withDuration: 0.55, delay: 0.8, options: .curveEaseIn, animations: {
            btn1.transform = transformList[0]
            btn2.transform = transformList[1]
        }) { (finished) in

            btn1.isHidden = true
            btn2.isHidden = true

                playThisSound(named: .plop)
                self.checkAndRunNextLevel()
            }
            

        
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
        
        playThisSound(named: .jippie)

        
        
        
        let stacksHoldningScore = [scoreLevel1Stack, scoreLevel2Stack, scoreLevel3Stack]
        let viewsHoldingImages = [level1ScoreImages, level2ScoreImages, level3ScoreImages]
        let scoreLabels = [endOfGameLevel1Label, endOfGameLevel2Label, endOfGameLevel3Label]
        
        
        setScoreLabelsPositionBeforeAnimate()
        fadeInEndOfGameView()
        showYouDidItLabel()
        
        
        
        
        var i = 0
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            
            let points = self.gameLevel.getPointThisLevel(levelNumber: i + 1)
            let numberOfPairs = self.countNumberOfPairsInLevel(levelNumber: i + 1)
            
            let numberOfImages = self.calculateScoreToValueOfGoldenImages(score: points, pairOfCardsThisLevel: numberOfPairs)
            
            
            
            self.showScoreLabelAndGoldenImages(labelToShow: scoreLabels[i]!, arrayOfScoreImages: viewsHoldingImages[i], stackToPutTheImage: stacksHoldningScore[i]!, numberOfImages: numberOfImages)
            
            i += 1
            if i == self.allViewsHoldingBtn.count {         //When all points are shown
                self.stopTimer()
                self.showTimerResults()
                

                
                
            }
            
        }
  
    }
    
    
    
    //Returns true if highest score in all levels
    func highestScore() -> Bool{
        
        for i in gameLevel.pointsList{
            
            if i != 0{
                return false
            }
        }
        return true
    }
    
    
    
    
    func highestScoreAnimation(){
        
        self.changeBackgroundColor()    //Change background color
        
        let image = UIImage(named: "golden")
        let goldenImage = UIImageView(image: image )
        goldenImage.contentMode = .scaleAspectFit
        
        moveImageView(imgView: goldenImage)         //Move image in square
        scaleAndRotateImage(imgView: goldenImage)   //Scale and rotate
        
        }
    
    
    
    func scaleAndRotateImage(imgView: UIImageView){
        
        var transform = CGAffineTransform.identity
        transform = transform.rotated(by: CGFloat.pi)
        transform = transform.scaledBy(x: 4, y: 4)
        imgView.transform = transform
        
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            
            imgView.transform = CGAffineTransform.identity
            
        }, completion: nil)
        
    }
    
    
    
    func moveImageView(imgView: UIImageView){
        
        let path = UIBezierPath()
        
        let size = view.frame.width * 0.05
        
        let xMin = endOfGameView.frame.minX
        let yMin = endOfGameView.frame.minY
        let xMax = endOfGameView.frame.maxX
        let yMax = endOfGameView.frame.maxY
        
        
        imgView.frame = CGRect(x: xMin, y: yMin, width: size, height: size)
        self.containerForNextLevelAnimation.addSubview(imgView)             //Put it in that view so it will be removed when reset game.
        
        path.move(to: CGPoint(x: xMin,y: yMin))
        
        //Corner of view
        path.addLine(to: CGPoint(x: xMax, y: yMin))
        path.addLine(to: CGPoint(x: xMax, y: yMax))
        path.addLine(to: CGPoint(x: xMin, y: yMax))
        path.addLine(to: CGPoint(x: xMin, y: yMin))
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        
        animation.repeatCount = Float.infinity
        animation.duration = 6.0
        
        imgView.layer.add(animation, forKey: "animate position along path")
        
    }
    
    
    
    
    func changeBackgroundColor(){
        
        
        UIView.animate(withDuration: 0.5, delay: 0, options:[.autoreverse, .repeat, .curveLinear, .allowUserInteraction] , animations: {
            
            self.endOfGameView.backgroundColor = UIColor(red: 0.8784, green: 0.8353, blue: 0, alpha: 1.0)
            self.endOfGameView.backgroundColor = UIColor(red: 0.9686, green: 0.9686, blue: 0.251, alpha: 1.0)

        }, completion: nil)
        
    }
    
    
    
    func showYouDidItLabel(){
        youDidItLabel.isHidden = true
        youDidItLabel.transform = CGAffineTransform.identity.scaledBy(x: 0, y: 0)
        youDidItLabel.isHidden = false
        
        let animator = UIViewPropertyAnimator(duration: 2, dampingRatio: 0.2) {
            self.youDidItLabel.transform = CGAffineTransform.identity
        }
        
        animator.startAnimation(afterDelay: 1)
  
    }
    
    
    
    func showTimerResults(){
        
        timerResults.text = "\(NSLocalizedString ("TIMER_RESULTS", comment: "")) \(String(format:"%.02f", countUptimer.time))"
        resetButton.isUserInteractionEnabled = true
        UIView.animate(withDuration: 1, delay: 2, options: .curveEaseIn, animations: {
            self.timerResults.alpha = 1
            self.resetButton.alpha = 1
        }, completion: nil)
        
        
    }
    
    
    func showScoreLabelAndGoldenImages(labelToShow : UILabel, arrayOfScoreImages: [UIImageView], stackToPutTheImage : UIStackView, numberOfImages : Int){
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            
            labelToShow.center.x += self.view.bounds.width
            
        }, completion: { (finished) in
            
            self.showGoldenScoreImages(arrayOfScoreImages: arrayOfScoreImages, inToThisStackView: stackToPutTheImage, numberOfImagesToShow: numberOfImages)
            
        })
        
        
        
    }
    
    //returns 0 if level does not exist
    func countNumberOfPairsInLevel(levelNumber : Int) -> Int{
        
        var counter = 0.0
        
        if levelNumber >= 1 && levelNumber <= allViewsHoldingBtn.count{
            
            let checkThisLevel = allViewsHoldingBtn[levelNumber-1]
            
            for subview in checkThisLevel.subviews{
                if subview is UIButton{
                    counter += 1
                }
            }
            
            counter *= 0.5
        }
        
        return Int(counter)
        
    }
    
    func setScoreLabelsPositionBeforeAnimate(){
        endOfGameLevel1Label.center.x -= view.bounds.width
        endOfGameLevel2Label.center.x -= view.bounds.width
        endOfGameLevel3Label.center.x -= view.bounds.width
        timerResults.alpha = 0
        resetButton.alpha = 0
        resetButton.isUserInteractionEnabled = false
        
    }
    
    func fadeInEndOfGameView(){
        containerForNextLevelAnimation.addSubview(endOfGameView)    //So the view disappears with the mask when reset.
        endOfGameView.alpha = 0
        
        
        UIView.animate(withDuration: 2, animations: {
            
            self.endOfGameView.isHidden = false
            self.endOfGameView.alpha = 1
  
        }) { (_) in
            playBackgroundMusic()
        }
        
        UIView.animate(withDuration: 2) {

        }
        
        
        
        
        if self.highestScore(){

            self.highestScoreAnimation()
            
        }
        
        
        
    }
    
    func calculateScoreToValueOfGoldenImages(score : Int, pairOfCardsThisLevel : Int) -> Int{
        if Double(score) == 0 {
            
            return 3            //MAX
        }
        else if Double(score) <= Double(pairOfCardsThisLevel) * 2{
            
            return 2
        }
        else{
            
            return 1
        }
        
    }
    
    
    
    
    func showGoldenScoreImages(arrayOfScoreImages : [UIImageView], inToThisStackView : UIStackView, numberOfImagesToShow : Int){
        
        
        var imageNumber = 0
        
        var transform = CGAffineTransform.identity
        transform = transform.scaledBy(x: 0, y: 0)
        
        if imageNumber >= 0 {
            
            endOfGameTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
                let scoreImage = UIImageView(image: UIImage(named: "golden"))
                scoreImage.frame = arrayOfScoreImages[imageNumber].frame
                scoreImage.isHidden = true
                inToThisStackView.addSubview(scoreImage)
                self.allGoldenImages.append(scoreImage)
                scoreImage.contentMode = .scaleAspectFit
                imageNumber += 1
                
                scoreImage.transform = transform
                scoreImage.isHidden = false
                
                let animator = UIViewPropertyAnimator(duration: 1.5, dampingRatio: 0.6) {
                    scoreImage.transform = CGAffineTransform.identity
                    
                    
                    playThisSound(named: .fart)
                }
                
                animator.startAnimation()
                
                if imageNumber == numberOfImagesToShow{
                    self.stopTimerEndOfGame()
                }
            }
        }
        
    }
    
    
    func deleteAllGoldenImages(){
        for image in allGoldenImages{
            
            image.removeFromSuperview()
        }
    }
    
    
    
    func playNextLevel(){
        
        
        if gameLevel.levelNumber < allViewsHoldingBtn.count {               //Check level is not the last
            
            //Display the "next level text"
            nextLevelText.text = "\(NSLocalizedString ("LEVEL", comment: "")) \(gameLevel.levelNumber+1) 👏🏽"
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
        playThisSound(named: .nextLevel)
        fadeBackgroundMusic(seconds: 6)
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
    
    func stopTimerEndOfGame(){
        
        if let timer = self.endOfGameTimer{
            
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
        
        //For delay in beginning
        for _ in 1...6{
            flushAnimationArray.append(UIImage(named: "toiletBottom1")!)
        }
        
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
        toiletBottom.animationDuration = 2
        toiletBottom.animationRepeatCount = 1
    }
    
    
    
    
    
    func resetToLevel1(){
        
        
        let image = UIImage(named: "dripping")
        let drippingImage1 = UIImageView(image: image )
        drippingImage1.frame = CGRect(x: 0, y: -view.bounds.height * 2, width: view.bounds.width, height: view.bounds.height * 2)
        
        self.view.addSubview(drippingImage1);
        
        //Animate drip image so the screen will be all brown
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseIn, animations: {
            
            drippingImage1.center.y += self.view.bounds.height * 1.5
            
        }, completion: {_ in
            
            //Clear View behind image... when screen are all brown
            
            self.clearViewAnimation()
            self.deleteAllGoldenImages()
            
            
            //            self.resetButton.isUserInteractionEnabled = true
            
            
            //AND THEN Animate to below screen.
            UIView.animate(withDuration: 2.5, delay: 0, options: .curveEaseOut, animations: {
                drippingImage1.center.y += self.view.bounds.height * 1.5
            }, completion: {_ in
                
                //AND REMOVE IMAGE
                drippingImage1.removeFromSuperview()
                
                //AND RESET TO LEVEL1
                playBackgroundMusic()
                
                self.endOfGameView.layer.removeAllAnimations()
                self.endOfGameView.backgroundColor = UIColor(red: 0.902, green: 0.902, blue: 0.902, alpha: 1.0)
                self.resetCardsAndButtonsThisLevel()
                self.gameLevel.resetLevel()
                self.createCardsAndBtnForThisLevel()
                self.countUptimer.reset()
                self.countUptimer.start()
            })
            
        })
        
        
        
    }
    
    
    
    
    func initCardBackBlink(){
        
        for i in 1...6{
            
            let image : UIImage!
            image = UIImage(named: "cardBack\(i)")
            cardBackBlinkArray.append(image)
        }
        for i in (1...6).reversed(){
            let image : UIImage!
            image = UIImage(named: "cardBack\(i)")
            cardBackBlinkArray.append(image)
        }
        
    }
    
    
}

