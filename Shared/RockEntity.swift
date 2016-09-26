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
    case top        = 0
    case bottom
    
    static var all: [RockType] {
        return [.top, .bottom]
    }
}

class RockEntityTexture {
    static var topTextures: [String: SKTexture] = [:]
    static var bottomTextures: [String: SKTexture] = [:]
    static var physicsTextures: [RockType: SKTexture] = [:]

    class func loadAllTextures() {
        for type in BackgroundType.allTypes {
            getTexture(.top, backgroundType: type)
            getTexture(.bottom, backgroundType: type)
        }

        getPhysicsTexture(.top)
        getPhysicsTexture(.bottom)
    }
    
    class func getTexture(_ rockType: RockType, backgroundType: BackgroundType) -> SKTexture {
        switch rockType {
        case .top:
            return getTopTexture(backgroundType)
            
        case .bottom:
            return getBottomTexture(backgroundType)
        }
    }
    
    class func getPhysicsTexture(_ rockType: RockType) -> SKTexture {
        if let texture = physicsTextures[rockType] {
            return texture
        }
        
        switch rockType {
        case .top:
            physicsTextures[.top] = SKTexture(imageNamed: "obstacle_top_physics")
            
        case .bottom:
            physicsTextures[.bottom] = SKTexture(imageNamed: "obstacle_bottom_physics")
        }
        
        return physicsTextures[rockType]!
    }

    fileprivate class func getTopTexture(_ backgroundType: BackgroundType) -> SKTexture {
        if let texture = topTextures[backgroundType.rawValue] {
            return texture
        }
        
        let spriteName = "obstacle_\(backgroundType.rawValue)_top"
        let texture = SKTexture(imageNamed: spriteName)
        
        topTextures[backgroundType.rawValue] = texture
        
        return texture
    }
    
    fileprivate class func getBottomTexture(_ backgroundType: BackgroundType) -> SKTexture {
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initializeRockPhysicsBody() {
        for rockType in RockType.all {
            let physicsBodyTexture = RockEntityTexture.getPhysicsTexture(rockType)
            let physicsBody = SKPhysicsBody(texture: physicsBodyTexture, size: physicsBodyTexture.size())
            physicsBody.isDynamic = false
            physicsBody.categoryBitMask = PhysicsCategory.Obstacle
            physicsBody.collisionBitMask = PhysicsCategory.Plane
            physicsBody.contactTestBitMask = PhysicsCategory.Plane

            rockPhysicsBody[rockType] = physicsBody
        }
    }
    
    func reset(_ backgroundType: BackgroundType, rockType: RockType, atPosition position: CGPoint) {
        let sprite = spriteComponent.node as SKSpriteNode
        
        sprite.zPosition = SpriteZPosition.RockObstacle
        sprite.name = SpriteName.rockObstacle
        
        sprite.texture = RockEntityTexture.getTexture(rockType, backgroundType: backgroundType)
        sprite.position = CGPoint(x: position.x + sprite.size.width / 2, y: position.y + sprite.size.height / 2)
        
        sprite.physicsBody = rockPhysicsBody[rockType]
        
        self.rockType = rockType
    }
}
