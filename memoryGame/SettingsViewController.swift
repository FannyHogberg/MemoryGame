//
//  SettingsViewController.swift
//  memoryGame
//
//  Created by Fanny Högberg on 2018-02-04.
//  Copyright © 2018 Fanny Högberg. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    
    
    let offImage = UIImage(named: "noSound")
    let onImage = UIImage(named: "sound")
    
    @IBOutlet weak var musicButton: UIImageView!
    @IBOutlet weak var audioButton: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateImages()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateImages(){
        
        if !backgroundMusicIsOn{
            musicButton.image = offImage
        }
        
        if !soundEffectIsOn{
            audioButton.image = offImage
        }
        
    }
    
    
    
    @IBAction func settingsForMusic(_ sender: UITapGestureRecognizer) {
        
        
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
    
    
    @IBAction func settingsForAudio(_ sender: UITapGestureRecognizer) {
        
        if soundEffectIsOn{
            
            changeImage(imageview: audioButton, toImage: offImage)
            soundEffectIsOn = false
            saveSettingsFor(SoundEffects: soundEffectIsOn)

        }
        else{
            
            
            changeImage(imageview: audioButton, toImage: onImage)
            soundEffectIsOn = true
            saveSettingsFor(SoundEffects: soundEffectIsOn)
            
        }
        
    }
    

    func changeImage(imageview: UIImageView, toImage : UIImage?){
        
        UIView.transition(with: imageview, duration: 0.5, options: .transitionCrossDissolve , animations: {
            imageview.image = toImage
        }, completion: nil)
        
    }
    
    
    
    
    @IBAction func goToHomeScreen(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
