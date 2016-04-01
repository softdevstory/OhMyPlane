//
//  ObstacleEntity.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 3. 24..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import SpriteKit
import GameplayKit

enum RockType: Int {
    case Top        = 0
    case Bottom
}

class RockEntity: GKEntity {
    var rockType: RockType
    
    var spriteComponent: SpriteComponent!
    let backgroundType: BackgroundType

    var spriteName: [String]!
    var physicsBodyFileName = ["obstacle_top_physics", "obstacle_bottom_physics"]
    
    /*
     * position is left, bottom point.
     */
    init(backgroundType: BackgroundType, rockType: RockType, atPosition position: CGPoint) {
        self.backgroundType = backgroundType
        self.rockType = rockType
        
        super.init()

        spriteName = ["obstacle_\(backgroundType.rawValue)_top", "obstacle_\(backgroundType.rawValue)_bottom"]
        let texture = SKTexture(imageNamed: spriteName![rockType.rawValue])
        
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)

        loadSprite(position)
    }
    
    private func loadSprite(position: CGPoint) {
        let sprite = spriteComponent.node as SKSpriteNode
        sprite.zPosition = SpriteZPosition.RockObstacle
        sprite.name = SpriteName.rockObstacle
        sprite.position = CGPoint(x: position.x + sprite.size.width / 2, y: position.y + sprite.size.height / 2)
        
        let physicsBodyTexture = SKTexture(imageNamed: physicsBodyFileName[rockType.rawValue])
        sprite.physicsBody = SKPhysicsBody(texture: physicsBodyTexture, size: physicsBodyTexture.size())
        sprite.physicsBody?.dynamic = false
        sprite.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        sprite.physicsBody?.collisionBitMask = PhysicsCategory.Plane
        sprite.physicsBody?.contactTestBitMask = PhysicsCategory.Plane
    }
}