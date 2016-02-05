//
//  GameScene.swift
//  FlappyClone
//
//  Created by Lin Wei on 2/4/16.
//  Copyright (c) 2016 Lin Wei. All rights reserved.
//

import SpriteKit


struct PhysicsCatagory {
    
    // bitwise left shift operator (<<). so "<< 1" shifts to the right one unit in bitwise
    static let dragon : UInt32 = 0x1 << 1
    static let Ground : UInt32 = 0x1 << 2
    static let Wall : UInt32 = 0x1 << 3
    static let Score : UInt32 = 0x1 << 4
}



class GameScene: SKScene, SKPhysicsContactDelegate {
  
    var ground:SKSpriteNode?
    var dragon: SKSpriteNode?
    var wallPair = SKNode()
 
    
    var imageArrayB = [SKTexture]()
    var animAction = SKAction()
    
    var  moveAndRemove =  SKAction ()
    var gameStarted = Bool()
    
    let scoreLabel = SKLabelNode()
    var score = Int()
    
    var touchCount =  Int()
    
    var dieState = Bool()
    
    var restartButton = SKSpriteNode()
    
    
    func restartGame(){
   
        self.removeAllActions()
        self.removeAllChildren()
        dieState = false
        gameStarted = false
        score = 0
        touchCount = 0
   
        createScene()
        
    }
    
    func createScene (){
        
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
        
        //load dragon sequence
        for i in 1...9 {
            
            let imageName = "dragon\(i)"
            
            imageArrayB += [SKTexture(imageNamed: imageName)]
            animAction = SKAction.animateWithTextures(imageArrayB, timePerFrame: 0.1)
            
        }
        
        
        dragon = SKSpriteNode(imageNamed:"dragon1")
        
        let action = SKAction.repeatActionForever(animAction)
        
        dragon?.runAction(action)
        
        
        dragon?.size = CGSize (width: 100, height: 100)
        dragon?.position = CGPoint(x: self.frame.width/2 , y: self.frame.height/2)
        
        //adding physicsBody to dragon
        dragon?.physicsBody = SKPhysicsBody(circleOfRadius: ((dragon?.frame.height)!/4))
        
        dragon?.physicsBody?.categoryBitMask = PhysicsCatagory.dragon
        dragon?.physicsBody?.collisionBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall
        dragon?.physicsBody?.contactTestBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall | PhysicsCatagory.Score
        dragon?.physicsBody?.affectedByGravity = false
        dragon?.physicsBody?.allowsRotation = false
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
     
        if contactBodyA.categoryBitMask == PhysicsCatagory.Wall && contactBodyB.categoryBitMask == PhysicsCatagory.dragon || contactBodyA.categoryBitMask == PhysicsCatagory.dragon && contactBodyB.categoryBitMask == PhysicsCatagory.Wall {
    
            dieState = true
            
            
            touchCount++
            if touchCount == 1 {
                print("touched")
         
//          dragon?.physicsBody?.collisionBitMask = PhysicsCatagory.Ground
            createButton()
//
                
            }
            print(touchCount)
//            enumerateChildNodesWithName("wallPair", usingBlock: { (node, error ) -> Void in
//                node.speed = 0
//            })
            
            
        }
        
    }
    
    func createWall (){
        
        //add score node
        let scoreNode = SKSpriteNode()
        scoreNode.size = CGSize(width: 1, height: 200)
        scoreNode.position = CGPoint(x: self.frame.width, y: self.frame.height/2)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOfSize: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.dynamic = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsCatagory.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCatagory.dragon
        scoreNode.color = SKColor.blueColor()
        
        
        
        //----
         wallPair = SKNode()
        wallPair.addChild(scoreNode)
        wallPair.name = "wallPair"
        
        let topWall: SKSpriteNode = SKSpriteNode(imageNamed: "Wall")
        topWall.setScale(0.5)
        topWall.position = CGPoint(x: self.frame.width, y: self.frame.height/2 + 350)
        //rotate the the topWall in z 180 degree radian
        topWall.zRotation = CGFloat(M_PI)
        
        //adding physics to topWall
        topWall.physicsBody = SKPhysicsBody(rectangleOfSize: topWall.size)
        topWall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        topWall.physicsBody?.collisionBitMask = PhysicsCatagory.dragon
        topWall.physicsBody?.contactTestBitMask = PhysicsCatagory.dragon
        topWall.physicsBody?.affectedByGravity = false
        topWall.physicsBody?.dynamic = false

        
        wallPair.addChild(topWall)
        
        

        
        let buttomWall: SKSpriteNode = SKSpriteNode(imageNamed: "Wall")
        buttomWall.setScale(0.5)
        buttomWall.position = CGPoint(x: self.frame.width, y: self.frame.height/2 - 350)
        wallPair.addChild(buttomWall)
        
        //adding physics to buttomWall
        buttomWall.physicsBody = SKPhysicsBody(rectangleOfSize: buttomWall.size)
        buttomWall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        buttomWall.physicsBody?.collisionBitMask = PhysicsCatagory.dragon
        buttomWall.physicsBody?.contactTestBitMask = PhysicsCatagory.dragon
        buttomWall.physicsBody?.affectedByGravity = false
        buttomWall.physicsBody?.dynamic = false
        
        wallPair.zPosition = 1
        
        let randomPosition = CGFloat.random(-200, max: 200)
        
        wallPair.position.y += randomPosition
        
        
        wallPair.runAction(moveAndRemove)
        
        
        
        self.addChild(wallPair)
        
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */

        if gameStarted == false {
            
            gameStarted = true
            
            dragon?.physicsBody?.affectedByGravity = true
            //create wall
            
            let wallSpawn =  SKAction.runBlock { () -> Void in
                self.createWall()
            }
            
            let delay = SKAction.waitForDuration(2.0)
            let wallSpawnDelay = SKAction.sequence([wallSpawn, delay])
            let spawnActionForever = SKAction.repeatActionForever(wallSpawnDelay)
            self.runAction(spawnActionForever)
            
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            
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
            dragon?.physicsBody?.applyImpulse(CGVectorMake(0, 50))
            
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
