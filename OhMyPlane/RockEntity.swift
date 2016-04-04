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

class RockEntityTexture {
    static var topTextures: [String: SKTexture] = [:]
    static var bottomTextures: [String: SKTexture] = [:]
    static var physicsTextures: [RockType: SKTexture] = [:]

    class func loadAllTextures() {
        for type in BackgroundType.allTypes {
            getTexture(.Top, backgroundType: type)
            getTexture(.Bottom, backgroundType: type)
        }

        getPhysicsTexture(.Top)
        getPhysicsTexture(.Bottom)
    }
    
    class func getTexture(rockType: RockType, backgroundType: BackgroundType) -> SKTexture {
        switch rockType {
        case .Top:
            return getTopTexture(backgroundType)
            
        case .Bottom:
            return getBottomTexture(backgroundType)
        }
    }
    
    class func getPhysicsTexture(rockType: RockType) -> SKTexture {
        if let texture = physicsTextures[rockType] {
            return texture
        }
        
        switch rockType {
        case .Top:
            physicsTextures[.Top] = SKTexture(imageNamed: "obstacle_top_physics")
            
        case .Bottom:
            physicsTextures[.Bottom] = SKTexture(imageNamed: "obstacle_bottom_physics")
        }
        
        return physicsTextures[rockType]!
    }

    private class func getTopTexture(backgroundType: BackgroundType) -> SKTexture {
        if let texture = topTextures[backgroundType.rawValue] {
            return texture
        }
        
        let spriteName = "obstacle_\(backgroundType.rawValue)_top"
        let texture = SKTexture(imageNamed: spriteName)
        
        topTextures[backgroundType.rawValue] = texture
        
        return texture
    }
    
    private class func getBottomTexture(backgroundType: BackgroundType) -> SKTexture {
        if let texture = bottomTextures[backgroundType.rawValue] {
            return texture
        }
        
        let spriteName = "obstacle_\(backgroundType.rawValue)_bottom"
        let texture = SKTexture(imageNamed: spriteName)
        
        bottomTextures[backgroundType.rawValue] = texture
        
        return texture
    }
}

class RockEntity: GKEntity {
    var rockType: RockType
    
    var spriteComponent: SpriteComponent!
    let backgroundType: BackgroundType

    /*
     * position is left, bottom point.
     */
    init(backgroundType: BackgroundType, rockType: RockType, atPosition position: CGPoint) {
        self.backgroundType = backgroundType
        self.rockType = rockType
        
        super.init()

        let texture = RockEntityTexture.getTexture(rockType, backgroundType: backgroundType)
        
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)

        loadSprite(position)
    }
    
    private func loadSprite(position: CGPoint) {
        let sprite = spriteComponent.node as SKSpriteNode
        sprite.zPosition = SpriteZPosition.RockObstacle
        sprite.name = SpriteName.rockObstacle
        sprite.position = CGPoint(x: position.x + sprite.size.width / 2, y: position.y + sprite.size.height / 2)
        
        let physicsBodyTexture = RockEntityTexture.getPhysicsTexture(rockType)
        sprite.physicsBody = SKPhysicsBody(texture: physicsBodyTexture, size: physicsBodyTexture.size())
        sprite.physicsBody?.dynamic = false
        sprite.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        sprite.physicsBody?.collisionBitMask = PhysicsCategory.Plane
        sprite.physicsBody?.contactTestBitMask = PhysicsCategory.Plane
    }
    
    func reset(backgroundType: BackgroundType, rockType: RockType, atPosition position: CGPoint) {
        let sprite = spriteComponent.node as SKSpriteNode
        sprite.texture = RockEntityTexture.getTexture(rockType, backgroundType: backgroundType)
        sprite.position = CGPoint(x: position.x + sprite.size.width / 2, y: position.y + sprite.size.height / 2)
        
        if self.rockType != rockType {
            let physicsBodyTexture = RockEntityTexture.getPhysicsTexture(rockType)
            sprite.physicsBody = SKPhysicsBody(texture: physicsBodyTexture, size: physicsBodyTexture.size())
            sprite.physicsBody?.dynamic = false
            sprite.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
            sprite.physicsBody?.collisionBitMask = PhysicsCategory.Plane
            sprite.physicsBody?.contactTestBitMask = PhysicsCategory.Plane
        }
        
        self.rockType = rockType
    }
}