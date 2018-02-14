//
//  StartViewController.swift
//  memoryGame
//
//  Created by Fanny Högberg on 2018-01-22.
//  Copyright © 2018 Fanny Högberg. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    


    
    @IBOutlet weak var textTitle: UILabel!
    @IBOutlet weak var text: UILabel!
    
    @IBOutlet weak var arrow: UIButton!
    
    @IBOutlet weak var startImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if firstTime{
            playBackgroundMusic()

        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textTitle.center.y -= view.bounds.height
        text.alpha = 0
        startImage.alpha = 0
        arrow.alpha = 0
        arrow.center.x -= 20
        
      //  self.view.backgroundColor = UIColor.brown
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            
            self.textTitle.center.y += self.view.bounds.height
        //    self.view.backgroundColor = UIColor.white
            
            
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0, options: [.allowUserInteraction], animations: {
            
            self.text.alpha = 1
            self.startImage.alpha = 1
            self.arrow.alpha = 1
            
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0.7, options: [.repeat, .autoreverse, .allowUserInteraction], animations: {
            
            self.arrow.center.x += 20
            
            
        }, completion: nil)
        
        
        
    }
    
    
    @IBAction func goToGame(_ sender: UIButton) {
        performSegue(withIdentifier: "startGame", sender: self)
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
