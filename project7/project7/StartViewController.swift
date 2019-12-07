//
//  StartViewController.swift
//  project5
//
//  Created by Joseph Daniel Ramli on 11/4/19.
//  Copyright © 2019 Joseph Daniel Ramli. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class StartViewController: UIViewController {
    var speed_label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view!.backgroundColor = UIColor( patternImage: UIImage(named: "spikeball.png")!)
        // Do any additional setup after loading the view.
        
        speed_label.center = CGPoint(x: 200, y: 600)
        speed_label.textColor = UIColor.blue
        speed_label.textAlignment = NSTextAlignment.center
        speed_label.text = "Hero Speed: 50"
        self.view.addSubview(speed_label)
       
        
    }
    
    @IBAction func increaseHeroSpeed(_ sender: Any) {
        Singleton.shared.hero_speed += 5
        speed_label.text = "Speed is now: " + String(Singleton.shared.hero_speed)
        
    }
    
    
    @IBAction func decreaseHeroSpeed(_ sender: Any) {
        Singleton.shared.hero_speed -= 5
       speed_label.text = ("Speed is now: " + String(Singleton.shared.hero_speed) )
    }
    
    
    @IBAction func unwindToStartViewController(segue: UIStoryboardSegue){
         //Nothing is needed here
         //These comments are just instructions on how to edit the "Main.storyboard" file after adding this function action to the code here.  Adding this function action makes seeing this possible when doing "control" click-and-drag to the "EXIT" button on the top of any viewcontroller in the storyboard
         //After this function is added, drage the segue from your button up to the little orange "EXIT" icon at the top right of your sourceview of the viewcontroller in the Main.storyboard, and you should see the option to "unwindTo[ViewControllerName]WithSegue" i.e. "unwindToStartViewControllerWithSegue"
    }
}
