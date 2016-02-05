//
//  GameScene.swift
//  FlappyClone
//
//  Created by Lin Wei on 2/4/16.
//  Copyright (c) 2016 Lin Wei. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  
    var ground:SKSpriteNode?
    var ghost: SKSpriteNode?
    
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        ground = SKSpriteNode(imageNamed: "Ground")
       
        ground?.setScale(0.5)
        ground?.position = CGPoint(x: self.frame.width/2, y: 0 + ground!.frame.height/2)
        
        self.addChild(ground!)
        
        
      ghost = SKSpriteNode(imageNamed: "Ghost")
        ghost?.size = CGSize (width: 60, height: 70)
        
        ghost?.position = CGPoint(x: self.frame.width/2 - ghost!.frame.width, y: self.frame.height/2)
        
        self.addChild(ghost!)
        
       createWall()
    }
    
    
    func createWall (){
        
        let wallPair:SKNode = SKNode()
        
        let topWall: SKSpriteNode = SKSpriteNode(imageNamed: "Wall")
        topWall.setScale(0.5)
        topWall.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        wallPair.addChild(topWall)
        
        
        let buttomWall: SKSpriteNode = SKSpriteNode(imageNamed: "Wall")
        buttomWall.setScale(0.5)
        buttomWall.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        wallPair.addChild(buttomWall)
        
        self.addChild(wallPair)
        
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
    
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
