//
//  ObstacleEntity.swift
//  BrokenPlane
//
//  Created by HS Song on 2016. 3. 24..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import SpriteKit
import GameplayKit

enum RockType {
    case Top
    case Bottom
    case Both
}

class RockEntity: GKEntity {
    var spriteComponent: SpriteComponent!
    let backgroundType: BackgroundType
    
    init(backgroundType: BackgroundType) {
        self.backgroundType = backgroundType
        
        super.init()

        spriteComponent = SpriteComponent(entity: self, texture: SKTexture(), size: CGSizeZero)
        addComponent(spriteComponent)
        
        loadSprite()
    }
    
    private func loadSprite() {
        let spriteNode = spriteComponent.node as SKSpriteNode
        
        let topSprite = SKSpriteNode(imageNamed: "background_\(backgroundType.rawValue)_top")
        
        let bodyTexture = SKTexture(imageNamed: "obstacle_top_physics")
        topSprite.physicsBody = SKPhysicsBody(texture: bodyTexture, size: bodyTexture.size())
        topSprite.physicsBody?.dynamic = false
        topSprite.physicsBody?.categoryBitMask = PhysicsCategory.Obstabcle
        topSprite.physicsBody?.collisionBitMask = PhysicsCategory.Plane
        topSprite.physicsBody?.contactTestBitMask = PhysicsCategory.Plane
        
        spriteNode.addChild(topSprite)
        
        let bottomSprite = SKSpriteNode(imageNamed: "obstacle_\(backgroundType.rawValue)_bottom")

        let bottomPhysicsTexture = SKTexture(imageNamed: "obstacle_bottom_physics")
        bottomSprite.physicsBody = SKPhysicsBody(texture: bottomPhysicsTexture, size: bottomPhysicsTexture.size())
        bottomSprite.physicsBody?.dynamic = false
        bottomSprite.physicsBody?.categoryBitMask = PhysicsCategory.Obstabcle
        bottomSprite.physicsBody?.collisionBitMask = PhysicsCategory.Plane
        bottomSprite.physicsBody?.contactTestBitMask = PhysicsCategory.Plane

        spriteNode.addChild(bottomSprite)
    }
}