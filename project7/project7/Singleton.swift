//
//  Singleton.swift
//  project5
//
//  Created by Joseph Daniel Ramli on 11/7/19.
//  Copyright © 2019 Joseph Daniel Ramli. All rights reserved.
//

import Foundation
import UIKit
//import SpriteKit

class Singleton{
    
    static let shared = Singleton()
    var int_highscores : [Int] = [0,0,0,0,0,0,0,0,0,0,
                              0,0,0,0,0,0,0,0,0,0,]
    
    var highscores : [String] = ["0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0",]
    var bugs_busted = 0
    var background_color : UIColor = UIColor.orange
    var recent_bugs_busted = 0
    
    var downloaded_contents = ""
    
    private init(){
        
    }

}
