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
        
        if !backgroundMusicIsOn{
            musicButton.image = offImage
        }
        
        if !soundEffectIsOn{
            audioButton.image = offImage
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func settingsForMusic(_ sender: UITapGestureRecognizer) {
        
        
        if  backgroundMusicIsOn
        {
            UIView.transition(with: self.musicButton, duration: 0.5, options: .transitionCrossDissolve , animations: {
                self.musicButton.image = self.offImage
            }, completion: nil)
            stopBackgroundMusic()
            backgroundMusicIsOn = false
        }
        else{
            UIView.transition(with: self.musicButton, duration: 0.5, options: .transitionCrossDissolve , animations: {
                self.musicButton.image = self.onImage
            }, completion: nil)
            
            backgroundMusicIsOn = true
            playBackgroundMusic()
            
        }
        
    }
    
    
    @IBAction func settingsForAudio(_ sender: UITapGestureRecognizer) {
        
        if soundEffectIsOn{
            
            UIView.transition(with: self.audioButton, duration: 0.5, options: .transitionCrossDissolve , animations: {
                self.audioButton.image = self.offImage
            }, completion: nil)
            
            soundEffectIsOn = false
        }
        else{
            
            UIView.transition(with: self.audioButton, duration: 0.5, options: .transitionCrossDissolve , animations: {
                self.audioButton.image = self.onImage
            }, completion: nil)
            
            soundEffectIsOn = true
            
        }
        
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
