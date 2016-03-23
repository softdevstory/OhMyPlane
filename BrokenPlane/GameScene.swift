//
//  GameScene.swift
//  BrokenPlane
//
//  Created by HS Song on 2016. 3. 23..
//  Copyright (c) 2016년 softdevstory. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    let backgroundLayer = SKNode()
    let spriteLayer = SKNode()
    
    override func didMoveToView(view: SKView) {

        addChild(backgroundLayer)
        addChild(spriteLayer)

        let background = SKSpriteNode(imageNamed: "background")
        background.anchorPoint = CGPoint.zero
        backgroundLayer.addChild(background)
        
        addPlane(.Blue)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    // MARK: plane entity
    
    func addPlane(planeType: PlaneType) {
        let plane = PlaneEntity(planeType: planeType)
        let planeNode = plane.spriteComponent.node
        planeNode.position = CGPoint(x: 500, y: 500)
        planeNode.zPosition = 100
        
        let textures: [SKTexture] = [SKTexture(imageNamed: "plane_\(planeType.rawValue)_01"),
                                     SKTexture(imageNamed: "plane_\(planeType.rawValue)_02"),
                                     SKTexture(imageNamed: "plane_\(planeType.rawValue)_03"),
                                     SKTexture(imageNamed: "plane_\(planeType.rawValue)_02")]
        let animation = SKAction.animateWithTextures(textures, timePerFrame: 0.1)
        planeNode.runAction(SKAction.repeatActionForever(animation))
        
        planeNode.runAction(SKAction.moveByX(900, y: 0, duration: 3))
        
        addEntity(plane)
    }
    
    // MARK: entity management
    
    var entities = Set<GKEntity>()
    
    func addEntity(entity: GKEntity) {
        entities.insert(entity)
        
        if let spriteNode = entity.componentForClass(SpriteComponent.self)?.node {
            spriteLayer.addChild(spriteNode)
        }
    }
    
}
