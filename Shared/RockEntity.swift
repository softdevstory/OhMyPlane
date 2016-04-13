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
    
    static var all: [RockType] {
        return [.Top, .Bottom]
    }
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

    var rockPhysicsBody: [RockType: SKPhysicsBody] = [:]
    
    /*
     * position is left, bottom point.
     */
    init(backgroundType: BackgroundType, rockType: RockType, atPosition position: CGPoint) {
        self.backgroundType = backgroundType
        self.rockType = rockType
        
        super.init()

        initializeRockPhysicsBody()
        
        let texture = RockEntityTexture.getTexture(rockType, backgroundType: backgroundType)
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
        
        reset(backgroundType, rockType: rockType, atPosition: position)
    }
    
    private func initializeRockPhysicsBody() {
        for rockType in RockType.all {
            let physicsBodyTexture = RockEntityTexture.getPhysicsTexture(rockType)
            let physicsBody = SKPhysicsBody(texture: physicsBodyTexture, size: physicsBodyTexture.size())
            physicsBody.dynamic = false
            physicsBody.categoryBitMask = PhysicsCategory.Obstacle
            physicsBody.collisionBitMask = PhysicsCategory.Plane
            physicsBody.contactTestBitMask = PhysicsCategory.Plane

            rockPhysicsBody[rockType] = physicsBody
        }
    }
    
    func reset(backgroundType: BackgroundType, rockType: RockType, atPosition position: CGPoint) {
        let sprite = spriteComponent.node as SKSpriteNode
        
        sprite.zPosition = SpriteZPosition.RockObstacle
        sprite.name = SpriteName.rockObstacle
        
        sprite.texture = RockEntityTexture.getTexture(rockType, backgroundType: backgroundType)
        sprite.position = CGPoint(x: position.x + sprite.size.width / 2, y: position.y + sprite.size.height / 2)
        
        sprite.physicsBody = rockPhysicsBody[rockType]
        
        self.rockType = rockType
    }
}