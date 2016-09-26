//
//  PlaneEntity.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 3. 23..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlaneEntity: GKEntity {
    let planeType: PlaneType
    
    // MARK: components 
    
    var spriteComponent: SpriteComponent!
    var animationComponent: AnimationComponent!
    var movementComponent: PlaneMovementComponent!
    
    // MARK: plane sprite
    
    var targetNode: SKNode?
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
        planeNode.physicsBody?.isDynamic = false
        planeNode.physicsBody?.allowsRotation = false
        planeNode.physicsBody?.categoryBitMask = PhysicsCategory.Plane
        planeNode.physicsBody?.collisionBitMask = PhysicsCategory.Obstacle
        
        animationComponent = AnimationComponent(node: planeNode, animations: loadAnimations())
        animationComponent.requestedAnimationState = .Flying
        addComponent(animationComponent)

        movementComponent = PlaneMovementComponent(node: planeNode)
        addComponent(movementComponent)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func loadAnimations() -> [AnimationState: Animation] {
        let textureAtlas = SKTextureAtlas(named: "plane")
        var animations = [AnimationState: Animation]()

        animations[.Flying] = AnimationComponent.animationFromAtlas(textureAtlas, withImageIdentifier: "plane_\(planeType.rawValue)_", forAnimationState: .Flying, repeatTexturesForever: true)
        
        return animations
    }
    
    // MARK:
    
    func enableFalling() {
        planeNode.physicsBody?.isDynamic = true
    }
    
    func disableFalling() {
        planeNode.physicsBody?.isDynamic = false
    }
    
    func showSmoke() {
        if smokeEmitter == nil {
            smokeEmitter = SKEmitterNode(fileNamed: "Smoke")
            smokeEmitter?.targetNode = targetNode
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
        planeNode.removeAction(forKey: "fly")
        planeNode.run(SKAction.repeatForever(SKAction.moveBy(x: planeType.speed, y: 0, duration: 0.1)), withKey: "fly")
    }
    
    func stopFlying() {
        planeNode.removeAction(forKey: "fly")
    }

    func impulse() {
        planeNode.physicsBody?.velocity = CGVector.zero
        planeNode.physicsBody?.applyImpulse(planeType.boostValue)
        
        planeNode.run(SKAction.playSoundFileNamed("Clank.mp3", waitForCompletion: false))
    }
    
    func explosion() {
        let emitter = SKEmitterNode()
        let particleTexture = SKTexture(imageNamed: "spark")

        emitter.targetNode = targetNode
        
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
        emitter.particleColor = SKColor.orange
        emitter.particleColorBlendFactor = 1
        emitter.particleBlendMode = SKBlendMode.add
        emitter.yAcceleration = -2000.0
        emitter.run(SKAction.sequence([SKAction.wait(forDuration: 2.0), SKAction.removeFromParent()]))
        
        planeNode.addChild(emitter)
        
        planeNode.run(SKAction.playSoundFileNamed("explosion", waitForCompletion: false))
    }
    
    func pause() {
        smokeEmitter?.speed = 0.0
        smokeEmitter?.isPaused = true

        planeNode.speed = 0.0
        planeNode.isPaused = true
    }
    
    func resume() {
        smokeEmitter?.speed = 1.0
        smokeEmitter?.isPaused = false
        
        planeNode.speed = 1.0
        planeNode.isPaused = false
    }
}
