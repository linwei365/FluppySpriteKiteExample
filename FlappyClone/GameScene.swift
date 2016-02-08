//
//  GameScene.swift
//  FlappyClone
//
//  Created by Lin Wei on 2/4/16.
//  Copyright (c) 2016 Lin Wei. All rights reserved.
//

import SpriteKit
import AVFoundation


struct PhysicsCatagory {
    
    // bitwise left shift operator (<<). so "<< 1" shifts to the right one unit in bitwise
    static let dragon : UInt32 = 0x1 << 1
    static let Ground : UInt32 = 0x1 << 2
    static let Cloud : UInt32 = 0x1 << 3
    static let Score : UInt32 = 0x1 << 4
}



class GameScene: SKScene, SKPhysicsContactDelegate {
  
    var ground:SKSpriteNode?
    var dragon: SKSpriteNode?
    var CloudPair = SKNode()
 
    
    var imageName = String()
    var imageNameB = String ()
    
    var imageArrayB = [SKTexture]()
    var animAction = SKAction()
    
    var  moveAndRemove =  SKAction ()
    var gameStarted = Bool()
    
    let scoreLabel = SKLabelNode()
    var score = Int()
    
    var touchCount =  Int()
    var touchGestureCount = Int()
    var dieState = Bool()
    
    var restartButton = SKSpriteNode()
    var dragonPhyscialbody = SKPhysicsBody()
    
   
    
    // Grab the path, make sure to add it to your project!
    var windSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("WindSoundEffectLoop", ofType: "mp3")!)
    var flappingWingSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("FlappyingWings", ofType: "mp3")!)
    var dragonDyingSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("dragonDying", ofType: "mp3")!)

    
    var audioPlayer = AVAudioPlayer()
    var aduioPlayerB = AVAudioPlayer()
    var audioPlayerC = AVAudioPlayer()
  
    
    func restartGame(){
   
        self.removeAllActions()
        self.removeAllChildren()
        dieState = false
        gameStarted = false
        score = 0
        touchCount = 0
        touchGestureCount = 0
        createScene()
        
    }
    func loadDragonSequence() {
        
        //load dragon sequence
        for i in 1...9 {
            
            imageName = "dragon\(i)"
            imageNameB = "dragonFlame\(i)"
            
            if touchGestureCount%4 == 1 {
                imageArrayB += [SKTexture(imageNamed: imageNameB)]
            }
            else {
                imageArrayB += [SKTexture(imageNamed: imageName)]
            }
            
            
            animAction = SKAction.animateWithTextures(imageArrayB, timePerFrame: 0.1)
            
            /* unused physicsBody on alpha Channel
            dragonPhyscialbody =  SKPhysicsBody(texture: SKTexture(imageNamed: "dragon1"), alphaThreshold: 1, size: (dragon?.size)!)
            */
        }
    }
    
    func createScene (){
        
   
       // audio player
        do {
            try        audioPlayer = AVAudioPlayer(contentsOfURL: windSound, fileTypeHint: nil)
            try aduioPlayerB =  AVAudioPlayer(contentsOfURL: flappingWingSound, fileTypeHint: nil)
            try audioPlayerC = AVAudioPlayer(contentsOfURL: dragonDyingSound, fileTypeHint: nil)
         }
        catch{
            
            print("audio error")
        }

        audioPlayer.prepareToPlay()
         audioPlayer.numberOfLoops = -1
        audioPlayer.play()
        
       
        
        
        
        //score label
        scoreLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + self.frame.height / 2.5)
        scoreLabel.text = "Score: \(score)"
        scoreLabel.zPosition = 3
        self.addChild(scoreLabel)
        //--
        
        self.physicsWorld.contactDelegate = self
        
        //----
        
        let bg = SKSpriteNode(imageNamed: "BG")
        bg.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        bg.setScale(0.5)
        bg.zPosition = 0
        
        self.addChild(bg)
        
        ground = SKSpriteNode(imageNamed: "Ground")
        ground?.setScale(0.5)
        ground?.position = CGPoint(x: self.frame.width/2, y: 0 + ground!.frame.height/2)
        
        //adding dynamic
        ground?.physicsBody = SKPhysicsBody(rectangleOfSize: (ground?.size)!)
        ground?.physicsBody?.categoryBitMask = PhysicsCatagory.Ground
        ground?.physicsBody?.collisionBitMask = PhysicsCatagory.dragon
        ground?.physicsBody?.contactTestBitMask = PhysicsCatagory.dragon
        ground?.physicsBody?.affectedByGravity = false
        ground?.physicsBody?.dynamic = false
        ground?.zPosition = 3
        
        self.addChild(ground!)
        
 
        //load image sequence
        loadDragonSequence()
        
        
        dragon = SKSpriteNode(imageNamed:"dragon1")
        
        let action = SKAction.repeatActionForever(animAction)
        
        dragon?.runAction(action)
        
       
        dragon?.size = CGSize (width: 100, height: 100)
        
      
        dragon?.position = CGPoint(x: self.frame.width/2 , y: self.frame.height/2)
        
        //adding physicsBody to dragon
    /*
        dragon?.physicsBody = dragonPhyscialbody
    */
       dragon?.physicsBody = SKPhysicsBody(circleOfRadius: ((dragon?.frame.height)!/4))
        
        dragon?.physicsBody?.categoryBitMask = PhysicsCatagory.dragon
        dragon?.physicsBody?.collisionBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Cloud
        dragon?.physicsBody?.contactTestBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Cloud | PhysicsCatagory.Score
        dragon?.physicsBody?.affectedByGravity = false
//        dragon?.physicsBody?.allowsRotation = false
        dragon?.physicsBody?.dynamic = true
        
        dragon?.zPosition = 2
        self.addChild(dragon!)
        

        
    }
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        createScene()
      
    }
    
    func createButton (){
        
        restartButton = SKSpriteNode(imageNamed: "restart-button")
        
        restartButton.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        restartButton.setScale(0)
        restartButton.zPosition = 4
        self.addChild(restartButton)
        restartButton.runAction(SKAction.scaleTo(0.4, duration: 0.5))
        
    }
    func didBeginContact(contact: SKPhysicsContact) {
        
        
        
        let contactBodyA = contact.bodyA
        let contactBodyB = contact.bodyB
        
        
        
        if contactBodyA.categoryBitMask == PhysicsCatagory.Score && contactBodyB.categoryBitMask == PhysicsCatagory.dragon || contactBodyA.categoryBitMask == PhysicsCatagory.dragon && contactBodyB.categoryBitMask == PhysicsCatagory.Score {
            
           score++
            
            
               scoreLabel.text = "Score: \(score)"
           
            
        }
     
        if contactBodyA.categoryBitMask == PhysicsCatagory.Cloud && contactBodyB.categoryBitMask == PhysicsCatagory.dragon || contactBodyA.categoryBitMask == PhysicsCatagory.dragon && contactBodyB.categoryBitMask == PhysicsCatagory.Cloud {
    
            dieState = true
            
        
            
            touchCount++
            if touchCount == 1 {
                print("touched")
         
          //if dragon got hit make sound
                audioPlayerC.prepareToPlay()
                audioPlayerC.play()
                
            createButton()
                
            }
            print(touchCount)
            enumerateChildNodesWithName("CloudPair", usingBlock: { (node, error ) -> Void in
                node.speed = 0
                self.removeAllActions()
            })
            
            
        }
        
    }
    
    func createCloud (){
        
        //add score node
        let scoreNode = SKSpriteNode()
        scoreNode.size = CGSize(width: 1, height: 220)
        scoreNode.position = CGPoint(x: self.frame.width, y: self.frame.height/2)
        
        scoreNode.physicsBody = SKPhysicsBody(rectangleOfSize: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.dynamic = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsCatagory.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCatagory.dragon
        scoreNode.color = SKColor.blueColor()
        
        
        
        //----
         CloudPair = SKNode()
        CloudPair.addChild(scoreNode)
        CloudPair.name = "CloudPair"
        
        
        let topCloud: SKSpriteNode = SKSpriteNode(imageNamed: "Cloud")
        topCloud.setScale(0.5)
        topCloud.position = CGPoint(x: self.frame.width, y: self.frame.height/2 + 360)
        //rotate the the topCloud in z 180 degree radian
        topCloud.zRotation = CGFloat(M_PI)
        
        //adding physics to topCloud
        topCloud.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Cloud"), alphaThreshold: 0.5, size: (topCloud.size))
        
//        topCloud.physicsBody = SKPhysicsBody(rectangleOfSize: topCloud.size)
        topCloud.physicsBody?.categoryBitMask = PhysicsCatagory.Cloud
        topCloud.physicsBody?.collisionBitMask = PhysicsCatagory.dragon
        topCloud.physicsBody?.contactTestBitMask = PhysicsCatagory.dragon
        topCloud.physicsBody?.affectedByGravity = false
        topCloud.physicsBody?.dynamic = false

        
        CloudPair.addChild(topCloud)
        
        

        
        let buttomCloud: SKSpriteNode = SKSpriteNode(imageNamed: "Cloud")
        buttomCloud.setScale(0.5)
        buttomCloud.position = CGPoint(x: self.frame.width, y: self.frame.height/2 - 360)
        CloudPair.addChild(buttomCloud)
        
        //adding physics to buttomCloud
        buttomCloud.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Cloud"), alphaThreshold: 0.5, size: (buttomCloud.size))
//        buttomCloud.physicsBody = SKPhysicsBody(rectangleOfSize: buttomCloud.size)
        buttomCloud.physicsBody?.categoryBitMask = PhysicsCatagory.Cloud
        buttomCloud.physicsBody?.collisionBitMask = PhysicsCatagory.dragon
        buttomCloud.physicsBody?.contactTestBitMask = PhysicsCatagory.dragon
        buttomCloud.physicsBody?.affectedByGravity = false
        buttomCloud.physicsBody?.dynamic = false
        
        CloudPair.zPosition = 1
        
        let randomPosition = CGFloat.random(-200, max: 200)
        
        CloudPair.position.y += randomPosition
        
        
        CloudPair.runAction(moveAndRemove)
        
        
        
        self.addChild(CloudPair)
        
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
         touchGestureCount++
         aduioPlayerB.prepareToPlay()
        aduioPlayerB.play() 
        
        print(touchGestureCount)
        /* Called when a touch begins */

        if gameStarted == false {
            
            gameStarted = true
            
            dragon?.physicsBody?.affectedByGravity = true
            //create Cloud
            
            let CloudSpawn =  SKAction.runBlock { () -> Void in
                self.createCloud()
            }
            
            let delay = SKAction.waitForDuration(2.0)
            let CloudSpawnDelay = SKAction.sequence([CloudSpawn, delay])
            let spawnActionForever = SKAction.repeatActionForever(CloudSpawnDelay)
            self.runAction(spawnActionForever)
            
            let distance = CGFloat(self.frame.width + CloudPair.frame.width )
           
            
            let movePipes = SKAction.moveByX(-distance, y: 0, duration: NSTimeInterval(0.01 * distance))
            let removePipes = SKAction.removeFromParent()
            
            moveAndRemove = SKAction.sequence([movePipes,removePipes])
            
            
            dragon?.physicsBody?.velocity = CGVectorMake(0, 0)
            dragon?.physicsBody?.applyImpulse(CGVectorMake(0, 80))

            
        }
        else {
            
            
        }
        
        if dieState == true {
        
        }
        else{
        
            dragon?.physicsBody?.velocity = CGVectorMake(0, 0)
            dragon?.physicsBody?.applyImpulse(CGVectorMake(0, 44))
            
        }
        
        for touch in touches {
            let touchLocation =  touch.locationInNode(self)
            
            if dieState == true{
                
                
                if restartButton.containsPoint(touchLocation){
                    restartGame()
                }
                
            }
            
           
        }
        
  
    
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
