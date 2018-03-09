//
//  StartViewController.swift
//  memoryGame
//
//  Created by Fanny Högberg on 2018-01-22.
//  Copyright © 2018 Fanny Högberg. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var startImage: UIImageView!
    @IBOutlet weak var settingsBtn: UIImageView!
    
    var startImageArray = [UIImage]()
    var timer : Timer?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsBtn.alpha = 0           //Hide
        containerView.alpha = 0         //Hide
        
        self.initStartImageAnimation()      //prepair the blinking animation

        self.fadeInStartViewAndStartBlink()
        
        self.reloadAudioSettingsAndPlay()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateArrow()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    @IBAction func preformSegue(_ sender: UITapGestureRecognizer) {
        stopTimer()
        performSegue(withIdentifier: "playGame", sender: self)
        
        
    }
    
    
    func reloadAudioSettingsAndPlay(){
        
        backgroundMusicIsOn = initialBackgroundMusicIsOn()
        if firstTime{
            playBackgroundMusic()
        }
        
        soundEffectIsOn = initialSoundEffectIsOn()
        
    }
    
    
    
    func animateArrow(){
        UIView.animate(withDuration: 1, delay: 0.0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: {
            
            self.arrow.center.x += 40

            
        }, completion: {_ in
            self.arrow.center.x -= 40
        })
    }
    
    
    
    //Fade in and start blink animation when done.
    func fadeInStartViewAndStartBlink(){
        
        //Fade in the view
        UIView.animate(withDuration: 1.5, delay: 0, options: .allowUserInteraction, animations: {
            
            self.containerView.alpha = 1
            self.settingsBtn.alpha = 1
            
        }) { (finished) in
            
            self.startBlinkingAnimation()             //Start blink
            
        }
        
    }
    
    //MARK:- BLINKING ANIMINATION
    
    //put the images in the array...
    func initStartImageAnimation(){
        
        for i in 1...6{
            
            let image : UIImage!
            image = UIImage(named: "cardBack\(i)")
            startImageArray.append(image)
        }
        for i in (1...6).reversed(){
            let image : UIImage!
            image = UIImage(named: "cardBack\(i)")
            startImageArray.append(image)
        }
        
        startImage.animationImages = startImageArray
        startImage.animationDuration = 0.5
        startImage.animationRepeatCount = 2
    }
    
    func startBlinkingAnimation(){
        self.startImage.startAnimating()    //for first time
        timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
            
            self.startImage.startAnimating()
            
            
        }
    }

    //Timer for blinking animation
    func stopTimer(){
        
        if let timer = timer{
            timer.invalidate()
        }
        
        
    }
    
    
}
