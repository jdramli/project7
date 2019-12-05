//
//  GameScene.swift
//  project5
//
//  Created by Joseph Daniel Ramli on 10/30/19.
//  Copyright © 2019 Joseph Daniel Ramli. All rights reserved.
//
//MyNotes: The MyNotes: sections create a way to search and find helpful structural tidbits that I discovered while building this code, and may help in future projects.
import CoreGraphics
import SpriteKit
import GameplayKit
import SceneKit

//This enum type is to create a quick unique collision bitmask by increasing by power of 2.
enum CollisionType: UInt32{
    case player = 1
    case bullet = 2
    case enemy = 4
    case upgrade = 8
    case melee_upgrade = 16
}

class GameScene: SKScene, SKPhysicsContactDelegate { //Added SKPhysicsContactDelegate to make sure the physics contact functions can be written.
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    //variables added from default
    private var picbullet : SKSpriteNode? //Opted not to use this for now as of 11/3/19
    private var hero : SKShapeNode? //Opted not to use this for now as of 11/3/19
    
    private var bullet : SKShapeNode?
    private var upgrade : SKShapeNode? //creating a power_up node
    private var player : SKSpriteNode?
    private var enemy : SKSpriteNode?
    private var melee_upgrade: SKShapeNode?
    private var gameTimer: Timer? //Timer object to be called regularly
    private var upgradeTimer: Timer? // Separate timer for the upgrade node
    private var meleeupgradeTimer: Timer?
    private var count_label : SKLabelNode?
    private var upgrade_label : SKLabelNode?
    private var kill_count = 0;
    
    private var bullet_power_up = 1.0
    private var melee_power_up = 1
    private var barrier : SCNShape
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        //Can this Section be shifted to a class file? This might help segregate out modifying hero parameters and interactions
        /*
        //This section of code is broken, I think because of improperly moving a CGRect via setting the position to a CGPoint.  I think it should be somethine instead like: "let moveRect = SKAction.moveTo(x:100, y:100)"; hero.runAction(moveRect)
        self.hero = SKShapeNode.init(rect: (CGRect(x: frame.minX+100, y:frame.minY+100, width: 70, height: 20)))
        self.hero?.strokeColor = SKColor.yellow
        self.hero?.fillColor = SKColor.yellow
        self.addChild(hero!)
        hero!.position = CGPoint(x:100, y: 100)
         */
        
        //Can this Section be shifted to a class file? This might help segregate out modifying bullet parameters and interactions
        //self.picbullet = self.childNode(withName: "//bullet") as? SKSpriteNode
        //Adding the option of a shape bullet or a sprite bullet by building both for now
        //self.bullet = SKShapeNode.init(circleOfRadius: 10)
        self.bullet = SKShapeNode.init(circleOfRadius:CGFloat(Double(10) * bullet_power_up))
        self.bullet?.name = "bullet" //MyNotes: Added name here for Collision detection
        self.bullet?.position = CGPoint(x: frame.midX, y: frame.midY)
        self.bullet?.strokeColor = SKColor.white
        self.bullet?.fillColor = SKColor.white
        self.addChild(bullet!)
      
        self.upgrade = SKShapeNode.init(circleOfRadius: 20)
        self.upgrade?.name = "upgrade" //MyNotes: Added name here for Collision detection
        self.upgrade?.position = CGPoint(x: frame.midX + 40, y: frame.midY + 100)
        self.upgrade?.strokeColor = SKColor.red
        self.upgrade?.fillColor = SKColor.red
        self.addChild(upgrade!)
        
        self.melee_upgrade = SKShapeNode.init(circleOfRadius: 30.0)
        self.melee_upgrade?.name = "melee_upgrade" //MyNotes: Added name here for Collisions
        self.melee_upgrade?.position = CGPoint(x: 700, y: 700)
        self.melee_upgrade?.strokeColor = SKColor.green
        self.melee_upgrade?.fillColor   = SKColor.green
        self.addChild(melee_upgrade!)
        
        self.player = self.childNode(withName: "//player") as? SKSpriteNode
        self.enemy = self.childNode(withName: "//enemy") as? SKSpriteNode
        self.count_label = self.childNode(withName: "//count_label") as? SKLabelNode
        self.upgrade_label = self.childNode(withName: "//upgrade_label") as? SKLabelNode
        //let moveRect = SKAction.moveTo(x: 74.0, duration: 0) //This was just a test line
        //player!.run(moveRect) //This was just a test line
        
        //Set Physics bodies
        //player
        //self.player?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 74, height: 97)) //This was a physics body of the player rectangle
        self.player?.physicsBody = SKPhysicsBody(texture: (player?.texture!)!, size: (player?.texture!.size())!) //This sets the physics body to the actual texture size and shape.
        self.player?.physicsBody?.affectedByGravity = false
        //enemy
        self.enemy?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 109, height: 82))
        self.enemy?.physicsBody?.affectedByGravity = false
        //self.enemy?.physicsBody?.mass = 200
        
        self.bullet?.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        //self.bullet?.physicsBody = SKPhysicsBody(rectangleOf: CGSize (width: 100, height: 100))
        self.bullet?.physicsBody?.affectedByGravity = false
        //self.bullet?.physicsBody?.mass = 20
        self.bullet?.position = CGPoint(x: 800, y: 300) //Moves initial bullet image offscreen out of play at 800x so that it doesn't interfere with gameplay.
        self.upgrade?.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        self.upgrade?.position = CGPoint(x: 800, y: -300) //Moves initial upgrade image offscreen out of play at 800x so that it doesn't interfere with gameplay.
        self.upgrade?.physicsBody?.affectedByGravity = false
        //self.upgrade?.physicsBody?.mass = 40
        
        self.melee_upgrade?.physicsBody = SKPhysicsBody(circleOfRadius: 30.0)
        self.melee_upgrade?.physicsBody?.affectedByGravity = false
        
        //self.enemy?.isHidden = true
        //self.enemy?.removeFromParent() // this creates a funny glitch where enemies spawn from the center.
        //MyNotes; Create a timer cycle to generate the enemy objects every few seconds
        //Timers:
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        
        upgradeTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(runUpgrades), userInfo: nil, repeats: true)
        
        meleeupgradeTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(runmeleeUpgrades), userInfo: nil, repeats: true)
        //MyNotes: Create physics interactions using the enum UInt32 bitmasks above
        player!.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        enemy!.physicsBody?.categoryBitMask = CollisionType.enemy.rawValue
        bullet!.physicsBody?.categoryBitMask = CollisionType.bullet.rawValue
        upgrade!.physicsBody?.categoryBitMask = CollisionType.upgrade.rawValue
        melee_upgrade!.physicsBody?.categoryBitMask = CollisionType.melee_upgrade.rawValue
        
        player!.physicsBody?.collisionBitMask = CollisionType.enemy.rawValue | CollisionType.upgrade.rawValue | CollisionType.melee_upgrade.rawValue //This line creates player to enemy collision detection ability, and uses a single bitwise "or" (|) operator to add possible interaction with "upgrade" nodes
        enemy!.physicsBody?.collisionBitMask = CollisionType.bullet.rawValue | CollisionType.player.rawValue
        bullet!.physicsBody?.collisionBitMask = CollisionType.enemy.rawValue
        upgrade!.physicsBody?.collisionBitMask = CollisionType.player.rawValue
        melee_upgrade!.physicsBody?.collisionBitMask = CollisionType.player.rawValue
        
        player!.physicsBody?.contactTestBitMask = CollisionType.enemy.rawValue | CollisionType.player.rawValue
        enemy!.physicsBody?.contactTestBitMask = CollisionType.bullet.rawValue //This line creates bullet to enemy contact detection
        upgrade!.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
        melee_upgrade!.physicsBody?.contactTestBitMask =  CollisionType.player.rawValue
        
       

       
    }
    @objc func runmeleeUpgrades(){
           //print("upgrading")
        //Insert meleeUpgrade code here
        if let m = self.melee_upgrade?.copy() as! SKShapeNode?{
            
            m.position = player!.position
            
            self.addChild(m)
            m.strokeColor = SKColor.green
            m.fillColor = SKColor.green
            let upgrade_path = UIBezierPath()
             upgrade_path.move(to: CGPoint(x: Double.random(in:-300...300), y: 590))
             upgrade_path.addLine(to: CGPoint( x: Double.random(in:-300...300), y: 300))
             for i in 1...10{
                 let temp = Float(Double(m.position.y) - (100.0*Double(i)))
                 upgrade_path.addLine(to: CGPoint( x: Double.random(in:-300...300), y: Double(temp)))
             }
            
             let move = SKAction.follow(upgrade_path.cgPath, asOffset: true, orientToPath: true, speed: 300)
             let upgrade_sequence = SKAction.sequence([move, .removeFromParent()])
             m.run(upgrade_sequence)
            
            
        }
        
    }
    @objc func runUpgrades(){
        //create  upgrade power-up nodes and set their path.
        if let u = self.upgrade?.copy() as! SKShapeNode?{
            u.position = player!.anchorPoint // Could probably just use 0,0
            self.addChild(u)
            u.strokeColor = SKColor.red
            u.fillColor = SKColor.red
            let upgrade_path = UIBezierPath()
            upgrade_path.move(to: CGPoint(x: Double.random(in:-300...300), y: 590))
            upgrade_path.addLine(to: CGPoint( x: Double.random(in:-300...300), y: 300))
            for i in 1...10{
                let temp = Float(Double(u.position.y) - (100.0*Double(i)))
                upgrade_path.addLine(to: CGPoint( x: Double.random(in:-300...300), y: Double(temp)))
            }
           
            let move = SKAction.follow(upgrade_path.cgPath, asOffset: true, orientToPath: true, speed: 300)
            let upgrade_sequence = SKAction.sequence([move, .removeFromParent()])
            u.run(upgrade_sequence)
        }
    }
    @objc func runTimedCode(){
        //create enemy nodes
        let multiplier = 1
        //let multiplier = (kill_count / 10) + 1 //MyNotes: This can varied in equation style to vary bug speed a lot
        for _ in 0...multiplier{
            
        
        if let e = self.enemy?.copy() as! SKSpriteNode?{
            //e.position = player!.anchorPoint
            e.position = CGPoint( x: Double.random(in:-300...300), y: Double.random(in: -200...590)  )   
            self.addChild(e)
            let enemy_path = UIBezierPath()
            //adding a speed multiplier based on kill_count
            
            let spawn_pos = Int.random(in:1...4)
            switch spawn_pos{
            case 1:enemy_path.move(to: CGPoint(x: Double.random(in:-350...(-300)), y: 480))
            //path.addLine(to: CGPoint(x:0,y:200)) //bullet shoots toward center.
            enemy_path.addLine(to: CGPoint(x:player!.position.x,y:player!.position.y) )
            enemy_path.addLine(to: CGPoint(x:player!.position.x,y:player!.position.y-1500) ) //Added 1500 because that is a significant offscreen distance for the bullet to travel.
            let move = SKAction.follow(enemy_path.cgPath, asOffset: true, orientToPath: true, speed: CGFloat(200*multiplier)) //MyNotes: remove 'multiplier' to go back to basic launch
            let enemy_sequence = SKAction.sequence([move, .removeFromParent()]) //This "sequence" is critical because it removes the bullet from parent with the function ".removeFromParent()" once the "move" function is complete
            e.run(enemy_sequence)
            
            case 2:enemy_path.move(to: CGPoint(x: Double.random(in:-300...300), y: -590))
            //path.addLine(to: CGPoint(x:0,y:200)) //bullet shoots toward center.
            enemy_path.addLine(to: CGPoint(x:player!.position.x,y:player!.position.y+1500) ) //Added 1500 because that is a significant offscreen distance for the bullet to travel.
            let move = SKAction.follow(enemy_path.cgPath, asOffset: true, orientToPath: true, speed: CGFloat(200*multiplier)) //MyNotes: remove 'multiplier' to go back to basic launch
            let enemy_sequence = SKAction.sequence([move, .removeFromParent()]) //This "sequence" is critical because it removes the bullet from parent with the function ".removeFromParent()" once the "move" function is complete
            e.run(enemy_sequence)
            
            default:enemy_path.move(to: CGPoint(x: Double.random(in:-300...300), y: 0))
            //path.addLine(to: CGPoint(x:0,y:200)) //bullet shoots toward center.
            enemy_path.addLine(to: CGPoint(x:player!.position.x,y:player!.position.y-1500) ) //Added 1500 because that is a significant offscreen distance for the bullet to travel.
            let move = SKAction.follow(enemy_path.cgPath, asOffset: true, orientToPath: true, speed: CGFloat(200*multiplier)) //MyNotes: remove 'multiplier' to go back to basic launch
            let enemy_sequence = SKAction.sequence([move, .removeFromParent()]) //This "sequence" is critical because it removes the bullet from parent with the function ".removeFromParent()" once the "move" function is complete
            e.run(enemy_sequence)
            }
            
            /*
            if(e.position.y < -600){
                let lose : SKLabelNode?
                print("Bug Escaped!")
                
            } */
        }
        }
        
        
        
    }
    
    //This function is necessary for physics contact body interactions.
    override func didMove(to view: SKView){
        physicsWorld.contactDelegate = self
    }
    func didBegin(_ contact: SKPhysicsContact){ //This function determines when contact happens
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        //This creates the contact nodes, but we don't know which nodes correspond to which contact yet, so the next lines are to sort the nodes and make sure they can be organized into a trackable way.
        let sortedNodes = [nodeA, nodeB].sorted { $0.name ?? "" < $1.name ?? "" } //This just sorts them in alphabetical order by name i.e. bullet, enemy, player.
        
        //This setup makes it so that if there is ANY contact of the 3 contacts now, then "player" will be nodeB because it is last.  Bullet would be nodeA, and enemy could be either (node B if colliding with bullet and node A if colliding with player).
        let firstNode = sortedNodes[0]
        let secondNode = sortedNodes[1]
        
        if (firstNode.name == "bullet" && secondNode.name == "enemy") { //shortcut here would be just "if(secondNode == "enemy") because if enemy is the second node then we know that the first can only be "bullet" because of the names of the classes "bullet, enemy, player, upgrade" are sorted in that order above.
            firstNode.removeFromParent()
            secondNode.removeFromParent()
            kill_count += 1
            count_label!.text = "Bugs Busted: " + String(kill_count)
        }
            // MyNotes: Contact Collision detection is not working here for some reason --FIXED --  have to make sure the contact bitmask is set above! -- "player!.physicsBody?.contactTestBitMask = CollisionType.enemy.rawValue"
        else if( ((firstNode.name == "enemy") && (secondNode.name == "player")) ){
            //print("hero has been hit!")
            firstNode.removeFromParent()
            //player?.removeFromParent()
            Singleton.shared.recent_bugs_busted = kill_count
            Singleton.shared.int_highscores.append(kill_count)
            kill_count = 0;
            count_label!.text = "Bugs Busted: " + String(kill_count)
            Singleton.shared.int_highscores.sort(by: >)
            Singleton.shared.int_highscores.remove(at: Singleton.shared.int_highscores.count-1)
            for i in 0...Singleton.shared.int_highscores.count-1{
                Singleton.shared.highscores[i] = String(Singleton.shared.int_highscores[i])
            }
            bullet_power_up = 1
            upgrade_label!.text = "Upgrade level: " + String(bullet_power_up)
            
        }
        else if( ((firstNode.name == "player") && (secondNode.name == "upgrade"))  ){
            if(bullet_power_up > 9){
                //do nothing
            }
            else{
                bullet_power_up += 1 //increase bullet size!
                upgrade_label!.text = "Upgrade level: " + String(Int(bullet_power_up))
            }
            
            //print("Upgrade contact!" + String(bullet_power_up))
            secondNode.removeFromParent()
        }
            /* //used this to test that bullet would make upgrade disappear
        else if( ((firstNode.name == "bullet") && (secondNode.name == "upgrade"))  ){
            bullet_power_up += 1
            print("Upgrade contact!" + String(bullet_power_up))
        }*/
        else if( ((firstNode.name == "melee_upgrade") && (secondNode.name == "player"))){
           if(melee_power_up > 5){
                //spawn a kinematic physics body near the player!
                
            
            }
            else{
                melee_power_up += 1 //increase bullet size!
                //upgrade_label!.text = "Upgrade level: " + String(Int(bullet_power_up))
            }
            
            //print("Upgrade contact!" + String(bullet_power_up))
            firstNode.removeFromParent()
            print("melee_upgrade count: ", melee_power_up)
        }
    }
    func touchDown(atPoint pos : CGPoint) {
        
        //The aim for project 7 is to implement a move toward touchdown style of character control
        print("player x and y are: ", player!.position.x," ", player!.position.y)
        print("position x,y are: ", pos.x, ",",pos.y)
        //This series of conditions replaced the old commit because the multiple "if" conditions were buggy and seemed to be updating slower than the next command was calculating the position and the ship would not always move in the cursor direction.
        self.bullet = SKShapeNode.init(circleOfRadius:CGFloat(Double(10) * bullet_power_up))
        self.bullet?.name = "bullet" //MyNotes: Added name here for Collision detection
        self.bullet?.position = CGPoint(x: frame.midX, y: frame.midY)
        self.bullet?.strokeColor = SKColor.white
        self.bullet?.fillColor = SKColor.white
        self.bullet?.physicsBody = SKPhysicsBody(circleOfRadius:CGFloat(Double(10) * bullet_power_up))
        self.bullet?.physicsBody?.affectedByGravity = false
        bullet!.physicsBody?.categoryBitMask = CollisionType.bullet.rawValue
        bullet!.physicsBody?.collisionBitMask = CollisionType.enemy.rawValue
        self.addChild(bullet!)
        let bulletpath = UIBezierPath() //beginning of bullet path will vary based on conditionals
        
        if(pos.x > player!.position.x && pos.y > player!.position.y+50){
            player!.position = CGPoint(x: player!.position.x + 50, y: player!.position.y+50)
            bulletpath.move(to: CGPoint( x: player!.position.x+50, y: player!.position.y + 50) )
            bulletpath.addLine(to: CGPoint(x:player!.position.x+1500,y:player!.position.y+1500) ) //Added 1500 because that is a significant offscreen distance for the bullet to travel.
                         let move = SKAction.follow(bulletpath.cgPath, asOffset: true, orientToPath: true, speed: 500)
                         let sequence = SKAction.sequence([move, .removeFromParent()]) //This "sequence" is critical because it removes the bullet from parent with the function ".removeFromParent()" once the "move" function is complete
                         bullet!.run(sequence)
        }
        else if(pos.x < player!.position.x && pos.y < player!.position.y+50){
            player!.position = CGPoint(x: player!.position.x - 50, y: player!.position.y-50)
             bulletpath.move(to: CGPoint( x: player!.position.x-50, y: player!.position.y - 50) )
            bulletpath.addLine(to: CGPoint(x:player!.position.x-1500,y:player!.position.y-1500) ) //Added 1500 because that is a significant offscreen distance for the bullet to travel.
                         let move = SKAction.follow(bulletpath.cgPath, asOffset: true, orientToPath: true, speed: 500)
                         let sequence = SKAction.sequence([move, .removeFromParent()]) //This "sequence" is critical because it removes the bullet from parent with the function ".removeFromParent()" once the "move" function is complete
                         bullet!.run(sequence)
        }
        else if(pos.x < player!.position.x && pos.y > player!.position.y+50){
            player!.position = CGPoint(x: player!.position.x - 50, y: player!.position.y+50)
             bulletpath.move(to: CGPoint( x: player!.position.x-50, y: player!.position.y + 50) )
            bulletpath.addLine(to: CGPoint(x:player!.position.x-1500,y:player!.position.y+1500) ) //Added 1500 because that is a significant offscreen distance for the bullet to travel.
                         let move = SKAction.follow(bulletpath.cgPath, asOffset: true, orientToPath: true, speed: 500)
                         let sequence = SKAction.sequence([move, .removeFromParent()]) //This "sequence" is critical because it removes the bullet from parent with the function ".removeFromParent()" once the "move" function is complete
                         bullet!.run(sequence)
        }
        else if(pos.x > player!.position.x && pos.y < player!.position.y+50){
            player!.position = CGPoint(x: player!.position.x + 50, y: player!.position.y-50)
             bulletpath.move(to: CGPoint( x: player!.position.x+50, y: player!.position.y - 50) )
            bulletpath.addLine(to: CGPoint(x:player!.position.x+1500,y:player!.position.y-1500) ) //Added 1500 because that is a significant offscreen distance for the bullet to travel.
                         let move = SKAction.follow(bulletpath.cgPath, asOffset: true, orientToPath: true, speed: 500)
                         let sequence = SKAction.sequence([move, .removeFromParent()]) //This "sequence" is critical because it removes the bullet from parent with the function ".removeFromParent()" once the "move" function is complete
                         bullet!.run(sequence)
        }
        else if(pos.x < player!.position.x){
            player!.position = CGPoint(x: player!.position.x - 50, y: player!.position.y)
             bulletpath.move(to: CGPoint( x: player!.position.x-50, y: player!.position.y) )
            bulletpath.addLine(to: CGPoint(x:player!.position.x-1500,y:player!.position.y) ) //Added 1500 because that is a significant offscreen distance for the bullet to travel.
                         let move = SKAction.follow(bulletpath.cgPath, asOffset: true, orientToPath: true, speed: 500)
                         let sequence = SKAction.sequence([move, .removeFromParent()]) //This "sequence" is critical because it removes the bullet from parent with the function ".removeFromParent()" once the "move" function is complete
                         bullet!.run(sequence)
        }
        else if(pos.x > player!.position.x){
            player!.position = CGPoint(x: player!.position.x + 50, y: player!.position.y)
             bulletpath.move(to: CGPoint( x: player!.position.x+50, y: player!.position.y) )
            bulletpath.addLine(to: CGPoint(x:player!.position.x+1500,y:player!.position.y) ) //Added 1500 because that is a significant offscreen distance for the bullet to travel.
                         let move = SKAction.follow(bulletpath.cgPath, asOffset: true, orientToPath: true, speed: 500)
                         let sequence = SKAction.sequence([move, .removeFromParent()]) //This "sequence" is critical because it removes the bullet from parent with the function ".removeFromParent()" once the "move" function is complete
                         bullet!.run(sequence)
        }
        
        
           
              
            
             
    
        
       
        
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
        //Singleton.shared.bugs_busted = kill_count
       
    }
    
    
}
