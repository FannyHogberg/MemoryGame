//
//  ViewController.swift
//  memoryGame
//
//  Created by Fanny Högberg on 2018-01-09.
//  Copyright © 2018 Fanny Högberg. All rights reserved.
//
import AVFoundation
import UIKit

class ViewController: UIViewController {
    
    var allViewsHoldingBtn = [UIView]()
    var newCardsTimer : Timer?
    var blinkTimer : Timer?
    var timeTimer = TimeTimer()
    
    var audioFlush : AudioEffectPlayer?
    var audioFlushLong : AudioEffectPlayer?
    var audioPlop : AudioEffectPlayer?
    var audioJippie : AudioEffectPlayer?
    var audioNextLevel : AudioEffectPlayer?
    var audioScore : AudioEffectPlayer?
        
    private let gameManager = GameManager()
    private let nextLevelTransitionView = NextLevelTransitionView()
    private let scoreResultView = ScoreResultView()
    
    @IBOutlet weak var toiletLid: ToiletLidView!
    @IBOutlet weak var toiletView: UIView!
    @IBOutlet weak var pipe: UIImageView!
    @IBOutlet weak var toiletBottom: UIImageView!
    
    @IBOutlet weak var level1: UIView!
    @IBOutlet weak var level2: UIView!
    @IBOutlet weak var level3: UIView!
    
    @IBOutlet weak var quitGameVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var quitViewWithText: UIView!
    
    @IBOutlet weak var quitEndOfGameViewGameAnswerYes: UILabel!
    @IBOutlet weak var quitGameAnswerNo: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(nextLevelTransitionView, fill: true)
        nextLevelTransitionView.isHidden = true
        view.addSubview(scoreResultView, margins: UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20))
        scoreResultView.isHidden = true
        scoreResultView.setupButtonAction(didPressPlayAgainButton)
        
        initAudioPlayers()
        allViewsHoldingBtn = [level1, level2, level3]
        setupFlushAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupButtonsForCurrentLevel()
        timeTimer.start()
    }
    

    // MARK:- PREPARE AND PLAY
    // TODO: - 
    func setupButtonsForCurrentLevel() {
        let currentLevelContainer = allViewsHoldingBtn[gameManager.currentLevel.levelNumber]
        currentLevelContainer.isHidden = true
        
        buttonsForCurrentLevel.forEach { $0.reset() }
        gameManager.resetAllCards()
        
        let newCards = gameManager.fetchNewCards()
        allViewsHoldingBtn.forEach { $0.isHidden = $0 != currentLevelContainer }

        for (index, button) in buttonsForCurrentLevel.enumerated() {
            let card = newCards[index]
            button.setupWith(card)
        }
        
        setPositionForBtnBeforeAnimate()
        startBlinkAnimation()
        
        currentLevelContainer.isHidden = false
        
        var index = buttonsForCurrentLevel.count-1
        newCardsTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let button = self.buttonsForCurrentLevel[index]
            self.animatePipeTo(button: button)

            index -= 1
            if index < 0 {
                self.hidePipe()
                self.newCardsTimer?.invalidate()
                self.newCardsTimer = nil
            }
        }
    }
    
    func playNextLevel() {
        let didFinish = gameManager.currentLevel.levelNumber >= allViewsHoldingBtn.count - 1
        if didFinish {
            return didFinishGame()
        } else {
            self.gameManager.setNextLevel()
            let text = "\(NSLocalizedString ("Level", comment: "")) \(gameManager.currentLevel.levelNumber + 1) ❤️"
            nextLevelTransitionView.showTextAndHide(text: text) { [weak self] in
                playBackgroundMusic()
                self?.setupButtonsForCurrentLevel()
            }
        }
    }
    
    func checkAndRunNextLevel() { // Rename and save found pairs in gamemanager instead?
        let allHidden = buttonsForCurrentLevel.first { !$0.isHidden }  == nil
        guard allHidden else { return }
        
        gameManager.saveScoreForCurrentLevel()
        stopBlinkTimer()
        playNextLevelAnimation()
    }
    
    func transitionToFirstLevel() {
        let drippingImage = UIImageView(image: UIImage(named: "dripping"))
        drippingImage.frame = CGRect(x: 0, y: -view.bounds.height * 2, width: view.bounds.width, height: view.bounds.height * 2)
        view.addSubview(drippingImage)
        
        UIView.animate(withDuration: 2, delay: 0, options: .curveLinear) {
            drippingImage.center.y = self.view.center.y
        } completion: { _ in
            self.nextLevelTransitionView.clear()
            self.nextLevelTransitionView.isHidden = true
            self.scoreResultView.isHidden = true
            
            UIView.animate(withDuration: 2, delay: 0, options: .curveLinear) {
                drippingImage.frame.origin.y = self.view.bounds.height
            } completion: { _ in
                drippingImage.removeFromSuperview()
                self.resetToPlayAgain()
            }
        }
    }

    
    
    // MARK: - All BTN Clicked functions...
    @IBAction func btnClicked(_ sender: UIButton) {
        guard let button = sender as? CardButton else { return }
        guard let card = button.card else { return }
        print("FANNY: flipped count: \(gameManager.cardBank.list.filter {$0.isFlipped}.count)")
        button.stopEyeAnimation()
        playCardSoundEffect(card: card)
        
        if gameManager.shouldFlipOneMoreCard {
            button.flipToFront()
        }
        if gameManager.onePairOfCardsIsFlipped {
            if gameManager.flippedCardsAreEqual {
                removePairOfCards()
                gameManager.unflipAllCards()
            }
            else { flipAllCardBack() }
            gameManager.didFlipPair()
        }
    }
    
    @IBAction func flushToilet(_ sender: UITapGestureRecognizer) {
        audioFlush?.playSound()
        toiletBottom.startAnimating()
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
        stopBlinkTimer()
        performSegue(withIdentifier: "goToStart", sender: self)
    }
    
    // TODO: Refactor this view
    @IBAction func keepPlayingClicked(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5, animations: {
            self.quitGameVisualEffectView.effect = nil
            self.quitViewWithText.alpha = 0
        }) { _ in
            self.quitGameVisualEffectView.isHidden = true
            self.quitViewWithText.isHidden = false
        }
    }
    
    

    
    
    //MARK:- BTN ANIMATION AND FLIP CARD
    
    func shakeFlippedButtons() {
        let flippedButtons = buttonsForCurrentLevel.filter { $0.isFlipped }
        flippedButtons.forEach { $0.shake() }
    }
    
    //Removes flipped cards to toilet.
    func removePairOfCards() {
        let pair = buttonsForCurrentLevel.filter {
            $0.card?.isFlipped ?? false && !$0.isHidden
        }
        //Man hittar ett par, man hittar ett annat som inte är lika, sen när man trycker på en till, då smäller det

        let btn1 = pair[0]
        let btn2 = pair[1]
        
        toiletLid.openLid()
        animatePairOfBtnToToilet(btn1: btn1, btn2: btn2)
    }
    
    
    //MARK: ANIMATE BTN TO DESTINATION FROM PIPE
    
    func setPositionForBtnBeforeAnimate(){
        let thisLevelContainerY = allViewsHoldingBtn[gameManager.currentLevel.levelNumber].frame.minY
        let pipeYValue = pipe.frame.height * 0.8
        let fromContainerTopToPipe = thisLevelContainerY - pipeYValue
        
        for btn in buttonsForCurrentLevel {
            let newPositionY = -btn.frame.midY - fromContainerTopToPipe
            
            var transform = CGAffineTransform.identity
            transform = transform.translatedBy(x: 0 , y: newPositionY)
            transform = transform.scaledBy(x: 0.1, y: 0.1)
            btn.transform = transform
        }
    }
    
    
    //MARK: ANIMATE BTN TO TOILET
    
    //animateBtnToToilet //TODO: refactor this one
    func animatePairOfBtnToToilet(btn1: UIButton, btn2: UIButton){
        
        let btnList = [btn1, btn2]
        
        let transform1 = CGAffineTransform.identity
        let transform2 = CGAffineTransform.identity
        
        var transformList = [transform1, transform2]
        
        //Calculate value of Y...
        let thisLevelContainer = allViewsHoldingBtn[gameManager.currentLevel.levelNumber]
        let containerHeight = thisLevelContainer.frame.height
        let containerMaxY = thisLevelContainer.frame.maxY
        let toiletY = toiletView.frame.midY
        let distansBetweenContainerAndToilet = toiletY - containerMaxY
        
        for i in 0...btnList.count-1 {
            
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
        }) { _ in
            
            btn1.isHidden = true
            btn2.isHidden = true
            
            self.audioPlop?.playSound()
            self.checkAndRunNextLevel()
        }
    }

    
    // MARK: - INIT AND SETTINGS
    
    func initAudioPlayers(){
        audioFlush = AudioEffectPlayer(soundName: .flushToilet, volume: 1)
        audioFlushLong = AudioEffectPlayer(soundName: .FlushToiletLong, volume: 1)
        audioPlop = AudioEffectPlayer(soundName: .plop, volume: 1)
        audioJippie = AudioEffectPlayer(soundName: .jippie, volume: 0.8)
        audioNextLevel = AudioEffectPlayer(soundName: .nextLevel, volume: 1)
        audioScore = AudioEffectPlayer(soundName: .fart, volume: 1)
    }
}

private extension ViewController {
    
    func animateButtonToDestination(button: UIButton) {
        button.isHidden = false
        let animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.45) {
            button.transform = CGAffineTransform.identity
        }
        animator.startAnimation()
    }
    
    func animatePipeTo(button: UIButton) { //TODO: Put som of this stuff in the pipe view
        //Where the pipe opening is.
        let pipeOpeningPointInImage = pipe.frame.width * 0.3
        let newPositionX = button.frame.midX - pipeOpeningPointInImage
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            self.pipe.center.x = newPositionX
        }, completion: { _ in
            self.pipe.startAnimating()
            playPipeSound()
            self.animateButtonToDestination(button: button)
        })
    }
    
    var buttonsForCurrentLevel: [CardButton] {
        let currentView = allViewsHoldingBtn[gameManager.currentLevel.levelNumber]
        return currentView.subviews.compactMap { $0 as? CardButton }
    }
    
    func didFinishGame() {
        audioJippie?.playSound()
        scoreResultView.isHidden = false
        scoreResultView.showScores(title: "You did it!", levels: gameManager.levels, time: timeTimer.time)
    }
    
    func didPressPlayAgainButton() {
        fadeBackgroundMusic(seconds: 3)
        audioFlushLong?.playSound()
        transitionToFirstLevel()
    }
    
    func hidePipe(){
        UIView.animate(withDuration: 1.5, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.pipe.center.x -= self.view.bounds.width
        })
    }
    
    func flipAllCardBack() {
        buttonsForCurrentLevel.forEach { $0.isEnabled = false }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.shakeFlippedButtons()
        }
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
            self.buttonsForCurrentLevel.forEach { $0.flipToBack() }
        }
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
            self.gameManager.unflipAllCards()
            self.buttonsForCurrentLevel.forEach { $0.isEnabled = true }
        }
    }
    
    func playNextLevelAnimation() {
        nextLevelTransitionView.isHidden = false
        nextLevelTransitionView.animateFallingImages { [weak self] in
            self?.playNextLevel()
        }
        audioNextLevel?.playSound()
        fadeBackgroundMusic(seconds: 6)
    }
    
    func resetToPlayAgain() {
        playBackgroundMusic()
        gameManager.resetLevels()
        setupButtonsForCurrentLevel()
        timeTimer.start()
    }
    
    func setupFlushAnimation(){
        toiletBottom.animationImages = .flushAnimation
        toiletBottom.animationDuration = 2
        toiletBottom.animationRepeatCount = 1
    }
}


// MARK: - BLINKING ANIMATION

private extension ViewController {
        
    func startBlinkAnimation() {
        blinkTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            let notHiddenButtons = self.buttonsForCurrentLevel.filter { !$0.isHidden }
            let randomButton = notHiddenButtons.randomElement()
            randomButton?.startEyeAnimation()
        }
    }

    func stopBlinkTimer() {
        blinkTimer?.invalidate()
        blinkTimer = nil
    }
}
