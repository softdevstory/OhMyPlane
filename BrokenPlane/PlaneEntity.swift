//
//  PlaneEntity.swift
//  BrokenPlane
//
//  Created by HS Song on 2016. 3. 23..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import SpriteKit
import GameplayKit

enum PlaneType: String {
    case Blue = "blue"
    case Green = "green"
    case Red = "red"
    case Yellow = "yellow"
    
    var boostValue: CGVector {
        switch self {
        case Blue: return CGVector(dx: 0, dy: 1000)
        case Green: return CGVector(dx: 0, dy: 1500)
        case Red: return CGVector(dx: 0, dy: 2000)
        case Yellow: return CGVector(dx: 0, dy: 2500)
        }
    }
    
    var speed: CGFloat {
        switch self {
        case Blue: return 50
        case Green: return 60
        case Red: return 70
        case Yellow: return 80
        }
    }
}

class PlaneEntity: GKEntity {
    let planeType: PlaneType
    var spriteComponent: SpriteComponent!
    var animationComponent: AnimationComponent!
    var movementComponent: PlaneMovementComponent!
    
    init(planeType: PlaneType, atPosition position: CGPoint) {
        self.planeType = planeType
        super.init()
        
        let textureAtlas = SKTextureAtlas(named: "plane")
        let defaultTexture = textureAtlas.textureNamed("plane_\(planeType.rawValue)_01")
        
        spriteComponent = SpriteComponent(entity: self, texture: defaultTexture, size: defaultTexture.size())
        addComponent(spriteComponent)

        let planeNode = spriteComponent.node

        planeNode.position = position
        planeNode.zPosition = 100
        planeNode.name = "plane"
        
        planeNode.physicsBody = SKPhysicsBody(circleOfRadius: planeNode.size.height / 2.0)
        planeNode.physicsBody?.dynamic = false
        planeNode.physicsBody?.allowsRotation = false
        planeNode.physicsBody?.categoryBitMask = PhysicsCategory.Plane
        planeNode.physicsBody?.collisionBitMask = PhysicsCategory.Obstabcle
        
        planeNode.addChild(SKEmitterNode(fileNamed: "Smoke")!)
        
        planeNode.runAction(SKAction.repeatActionForever(SKAction.moveByX(planeType.speed, y: 0, duration: 0.1)))
        
        animationComponent = AnimationComponent(node: spriteComponent.node, animations: loadAnimations())
        animationComponent.requestedAnimationState = .Flying
        addComponent(animationComponent)

        movementComponent = PlaneMovementComponent(node: spriteComponent.node)
        addComponent(movementComponent)
    }
    
    private func loadAnimations() -> [AnimationState: Animation] {
        let textureAtlas = SKTextureAtlas(named: "plane")
        var animations = [AnimationState: Animation]()

        animations[.Flying] = AnimationComponent.animationFromAtlas(textureAtlas, withImageIdentifier: "plane_\(planeType.rawValue)_", forAnimationState: .Flying, repeatTexturesForever: true)
        
        return animations
    }
}