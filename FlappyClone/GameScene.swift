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
}



class GameScene: SKScene {
  
    var ground:SKSpriteNode?
    var dragon: SKSpriteNode?
    var wallPair = SKNode()
 
    
    var imageArrayB = [SKTexture]()
    var animAction = SKAction()
    
    var  moveAndRemove =  SKAction ()
    var gameStarted = Bool()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        
    
        let bg = SKSpriteNode(imageNamed: "BG")
        bg.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        bg.setScale(0.5)
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
        dragon?.physicsBody = SKPhysicsBody(circleOfRadius: ((dragon?.frame.height)!/3))
        
        dragon?.physicsBody?.categoryBitMask = PhysicsCatagory.dragon
        dragon?.physicsBody?.collisionBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall
        dragon?.physicsBody?.contactTestBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall
        dragon?.physicsBody?.affectedByGravity = true
        dragon?.physicsBody?.allowsRotation = false
        dragon?.physicsBody?.dynamic = true
        
        dragon?.zPosition = 2
        self.addChild(dragon!)
        
        
        
        
        
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
       
        
        
        
    }
    
    
    func createWall (){
        
         wallPair = SKNode()
        
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
        
        wallPair.runAction(moveAndRemove)
        
        self.addChild(wallPair)
        
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */

        
        dragon?.physicsBody?.velocity = CGVectorMake(0, 0)
        dragon?.physicsBody?.applyImpulse(CGVectorMake(0, 90))
        
    
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
