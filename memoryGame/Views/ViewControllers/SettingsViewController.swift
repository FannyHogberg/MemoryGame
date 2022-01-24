//
//  SettingsViewController.swift
//  memoryGame
//
//  Created by Fanny Högberg on 2018-02-04.
//  Copyright © 2018 Fanny Högberg. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let offImage = UIImage(named: "noSound")
    private let onImage = UIImage(named: "sound")
    
    @IBOutlet private weak var musicButton: UIImageView! {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didPressMusicSetting))
            musicButton.isUserInteractionEnabled = true
            musicButton.addGestureRecognizer(tapGesture)
            musicButton.image = backgroundMusicIsOn ? onImage : offImage
        }
    }
    
    @IBOutlet private weak var audioButton: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateImages()
    }
    
    func updateImages(){

        
        if !soundEffectIsOn {
            audioButton.image = offImage
        }
        
    }
    
    @objc
    func didPressMusicSetting() {
        
    }
    
    @IBAction func didPressMusicSettingsButton(_ sender: UITapGestureRecognizer) {
        
        
        if  backgroundMusicIsOn
        {
            changeImage(imageview: musicButton, toImage: offImage)
            stopBackgroundMusic()
            backgroundMusicIsOn = false
            saveSettingFor(music: backgroundMusicIsOn)
            
        }
        else{
            
            changeImage(imageview: musicButton, toImage: onImage)
            backgroundMusicIsOn = true
            playBackgroundMusic()
            saveSettingFor(music: backgroundMusicIsOn)
            
        }
        
    }
    
    
    @IBAction func didPressAudioSettingsButton(_ sender: UITapGestureRecognizer) {
        if soundEffectIsOn {
            changeImage(imageview: audioButton, toImage: offImage)
            soundEffectIsOn = false
            saveSettingsFor(SoundEffects: soundEffectIsOn)
        }
        else {
            changeImage(imageview: audioButton, toImage: onImage)
            soundEffectIsOn = true
            saveSettingsFor(SoundEffects: soundEffectIsOn)
        }
    }
    

    func changeImage(imageview: UIImageView, toImage : UIImage?) {
        
        UIView.transition(with: imageview, duration: 0.5, options: .transitionCrossDissolve , animations: {
            imageview.image = toImage
        })
        
    }

    @IBAction func goToHomeScreen(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
