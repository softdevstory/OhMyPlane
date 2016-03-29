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
    
    // MARK: components 
    
    var spriteComponent: SpriteComponent!
    var animationComponent: AnimationComponent!
    var movementComponent: PlaneMovementComponent!
    
    // MARK: plane sprite
    
    var planeNode: SKSpriteNode!
    var smokeEmitter: SKEmitterNode?
    
    init(planeType: PlaneType) {
        self.planeType = planeType
        super.init()
        
        let textureAtlas = SKTextureAtlas(named: "plane")
        let defaultTexture = textureAtlas.textureNamed("plane_\(planeType.rawValue)_01")
        
        spriteComponent = SpriteComponent(entity: self, texture: defaultTexture, size: defaultTexture.size())
        addComponent(spriteComponent)

        planeNode = spriteComponent.node
        
        planeNode.physicsBody = SKPhysicsBody(circleOfRadius: planeNode.size.height / 2.0)
        planeNode.physicsBody?.dynamic = false
        planeNode.physicsBody?.allowsRotation = false
        planeNode.physicsBody?.categoryBitMask = PhysicsCategory.Plane
        planeNode.physicsBody?.collisionBitMask = PhysicsCategory.Obstacle
        
        animationComponent = AnimationComponent(node: planeNode, animations: loadAnimations())
        animationComponent.requestedAnimationState = .Flying
        addComponent(animationComponent)

        movementComponent = PlaneMovementComponent(node: planeNode)
        addComponent(movementComponent)
    }
    
    private func loadAnimations() -> [AnimationState: Animation] {
        let textureAtlas = SKTextureAtlas(named: "plane")
        var animations = [AnimationState: Animation]()

        animations[.Flying] = AnimationComponent.animationFromAtlas(textureAtlas, withImageIdentifier: "plane_\(planeType.rawValue)_", forAnimationState: .Flying, repeatTexturesForever: true)
        
        return animations
    }
    
    // MARK:
    
    func enableFalling() {
        planeNode.physicsBody?.dynamic = true
    }
    
    func disableFalling() {
        planeNode.physicsBody?.dynamic = false
    }
    
    func showSmoke() {
        if smokeEmitter == nil {
            smokeEmitter = SKEmitterNode(fileNamed: "Smoke")
            planeNode.addChild(smokeEmitter!)
        }
    }
    
    func hideSmoke() {
        if let emitter = smokeEmitter {
            emitter.removeFromParent()
            smokeEmitter = nil
        }
    }
    
    func fly() {
        planeNode.removeActionForKey("fly")
        planeNode.runAction(SKAction.repeatActionForever(SKAction.moveByX(planeType.speed, y: 0, duration: 0.1)), withKey: "fly")
    }
    
    func stopFlying() {
        planeNode.removeActionForKey("fly")
    }

    func impulse() {
        planeNode.physicsBody?.velocity = CGVector.zero
        planeNode.physicsBody?.applyImpulse(planeType.boostValue)
    }
    
    func explosion() {
        let emitter = SKEmitterNode()
        let particleTexture = SKTexture(imageNamed: "spark")
        emitter.zPosition = 2
        emitter.particleTexture = particleTexture
        emitter.particleBirthRate = 4000
        emitter.numParticlesToEmit = 400
        emitter.particleLifetime = 2.0
        emitter.emissionAngle = CGFloat(M_PI) * 90.0 / 180.0
        emitter.emissionAngleRange = CGFloat(M_PI) * 360.0 / 180.0
        emitter.particleSpeed = 600
        emitter.particleSpeedRange = 1000
        emitter.particleAlpha = 1.0
        emitter.particleAlphaRange = 0.25
        emitter.particleScale = 1.2
        emitter.particleScaleRange = 2.0
        emitter.particleScaleSpeed = -1.5
        emitter.particleColor = SKColor.orangeColor()
        emitter.particleColorBlendFactor = 1
        emitter.particleBlendMode = SKBlendMode.Add
        emitter.runAction(SKAction.sequence([SKAction.waitForDuration(2.0), SKAction.removeFromParent()]))
        
        planeNode.addChild(emitter)
    }

}