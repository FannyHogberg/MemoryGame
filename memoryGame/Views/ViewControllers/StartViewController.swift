//
//  StartViewController.swift
//  memoryGame
//
//  Created by Fanny Högberg on 2018-01-22.
//  Copyright © 2018 Fanny Högberg. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet private weak var arrow: UIImageView!
    @IBOutlet private weak var startImage: UIImageView!
    
    private var startImageArray = [UIImage]()
    private var timer : Timer?
    
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlinkingAnimation()
        reloadAudioSettingsAndPlay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startBlinkingAnimation()
        animateArrow()
    }
    
    @IBAction func preformSegue(_ sender: UITapGestureRecognizer) {
        stopTimer()
        performSegue(withIdentifier: "playGame", sender: self)
    }
}


// MARK: - Private Functions

private extension StartViewController {
    
    func animateArrow(){
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse]) {
            self.arrow.center.x += 40
        }
    }
    
    func reloadAudioSettingsAndPlay(){
        backgroundMusicIsOn = initialBackgroundMusicIsOn()
        if firstTime {
            playBackgroundMusic()
        }
        soundEffectIsOn = initialSoundEffectIsOn()
    }
    
    func setupBlinkingAnimation(){
        for i in 1...6 {
        let image = UIImage(named: "cardBack\(i)")!
            startImageArray.append(image)
        }
        for i in (1...6).reversed(){
            let image = UIImage(named: "cardBack\(i)")!
            startImageArray.append(image)
        }
        startImage.animationImages = startImageArray
        startImage.animationDuration = 0.5
        startImage.animationRepeatCount = 2
    }
    
    func startBlinkingAnimation(){
        startImage.startAnimating()
        timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
            self.startImage.startAnimating()
        }
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
}
