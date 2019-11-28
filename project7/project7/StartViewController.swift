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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view!.backgroundColor = UIColor( patternImage: UIImage(named: "bugs.jpg")!)
        // Do any additional setup after loading the view.
    }
    
   @IBAction func unwindToStartViewController(segue: UIStoryboardSegue){
         //Nothing is needed here
         //These comments are just instructions on how to edit the "Main.storyboard" file after adding this function action to the code here.  Adding this function action makes seeing this possible when doing "control" click-and-drag to the "EXIT" button on the top of any viewcontroller in the storyboard
         //After this function is added, drage the segue from your button up to the little orange "EXIT" icon at the top right of your sourceview of the viewcontroller in the Main.storyboard, and you should see the option to "unwindTo[ViewControllerName]WithSegue" i.e. "unwindToStartViewControllerWithSegue"
    }
}
