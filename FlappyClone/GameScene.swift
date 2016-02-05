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
    static let Ghost : UInt32 = 0x1 << 1
    static let Ground : UInt32 = 0x1 << 2
    static let Wall : UInt32 = 0x1 << 3
}



class GameScene: SKScene {
  
    var ground:SKSpriteNode?
    var ghost: SKSpriteNode?
    
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
           createWall()
        
        
       
        ground = SKSpriteNode(imageNamed: "Ground")
        ground?.setScale(0.5)
        ground?.position = CGPoint(x: self.frame.width/2, y: 0 + ground!.frame.height/2)
        
        //adding dynamic
        ground?.physicsBody = SKPhysicsBody(rectangleOfSize: (ground?.size)!)
        ground?.physicsBody?.categoryBitMask = PhysicsCatagory.Ground
        ground?.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
        ground?.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        ground?.physicsBody?.affectedByGravity = false
        ground?.physicsBody?.dynamic = false
        
        self.addChild(ground!)
        
        
        
        ghost = SKSpriteNode(imageNamed: "Ghost")
        ghost?.size = CGSize (width: 60, height: 70)
        ghost?.position = CGPoint(x: self.frame.width/2 - ghost!.frame.width, y: self.frame.height/2)
        
        //adding physicsBody to ghost
        ghost?.physicsBody = SKPhysicsBody(circleOfRadius: ((ghost?.frame.height)!/2))
        ghost?.physicsBody?.categoryBitMask = PhysicsCatagory.Ghost
        ghost?.physicsBody?.collisionBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall
        ghost?.physicsBody?.contactTestBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall
        ghost?.physicsBody?.affectedByGravity = true
        ghost?.physicsBody?.dynamic = true
        
        
        self.addChild(ghost!)
        
    
    }
    
    
    func createWall (){
        
        let wallPair:SKNode = SKNode()
        
        let topWall: SKSpriteNode = SKSpriteNode(imageNamed: "Wall")
        topWall.setScale(0.5)
        topWall.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 - 380)
        wallPair.addChild(topWall)
        
        
        
        
        
        let buttomWall: SKSpriteNode = SKSpriteNode(imageNamed: "Wall")
        buttomWall.setScale(0.5)
        buttomWall.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 380)
        wallPair.addChild(buttomWall)
        
        self.addChild(wallPair)
        
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
 
        ghost?.physicsBody?.velocity = CGVectorMake(0, 0)
        ghost?.physicsBody?.applyImpulse(CGVectorMake(0, 80))
        
    
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
