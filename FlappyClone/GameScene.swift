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
        
        
        
     
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
    
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
