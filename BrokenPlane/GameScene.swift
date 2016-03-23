//
//  GameScene.swift
//  BrokenPlane
//
//  Created by HS Song on 2016. 3. 23..
//  Copyright (c) 2016년 softdevstory. All rights reserved.
//

import SpriteKit
import GameplayKit

enum PhysicsCategory: Int {
    case Plane = 0
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    // MARK: update time
    
    var lastUpdateTimeInterval: NSTimeInterval = 0
    let maximumUpdateDeltaTime: NSTimeInterval = 1.0 / 60.0
    var lastDeltaTime: NSTimeInterval = 0

    // MARK: Sprite layers
    
    let backgroundLayer = SKNode()
    let spriteLayer = SKNode()

    // MARK: component systems
    
    lazy var componentSystems: [GKComponentSystem] = {
        let animationSystem = GKComponentSystem(componentClass: AnimationComponent.self)
        let planeMovementSystem = GKComponentSystem(componentClass: PlaneMovementComponent.self)
        
        return [animationSystem, planeMovementSystem]
    }()

    // MARK: touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let planeNode = spriteLayer.childNodeWithName("plane") as? EntityNode,
            let physicsBody = planeNode.physicsBody {
            physicsBody.velocity = CGVector.zero
            physicsBody.applyImpulse((planeNode.entity as! PlaneEntity).planeType.boostValue)
        }
    }

    // MARK: SKScene jobs
    
    override func didMoveToView(view: SKView) {

        physicsWorld.contactDelegate = self
        physicsWorld.gravity = GameSetting.PhysicsGravity
        
        addChild(backgroundLayer)
        addChild(spriteLayer)

        let background = SKSpriteNode(imageNamed: "background")
        background.anchorPoint = CGPoint.zero
        backgroundLayer.addChild(background)
        
        addPlane(.Yellow)
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        var deltaTime = currentTime - lastUpdateTimeInterval
        deltaTime = deltaTime > maximumUpdateDeltaTime ? maximumUpdateDeltaTime : deltaTime
        lastUpdateTimeInterval = currentTime
        
        for componentSystem in componentSystems {
            componentSystem.updateWithDeltaTime(deltaTime)
        }
    }
    
    // MARK: plane entity
    
    func addPlane(planeType: PlaneType) {
        let plane = PlaneEntity(planeType: planeType)
        let planeNode = plane.spriteComponent.node
        planeNode.position = CGPoint(x: 500, y: 500)
        planeNode.zPosition = 100
        planeNode.name = "plane"
        
        planeNode.physicsBody = SKPhysicsBody(circleOfRadius: planeNode.size.height / 2.0)
        planeNode.physicsBody?.dynamic = true
        planeNode.physicsBody?.allowsRotation = false
        
        plane.animationComponent.requestedAnimationState = .Flying
        
        addEntity(plane)
    }
    
    // MARK: entity management
    
    var entities = Set<GKEntity>()
    
    func addEntity(entity: GKEntity) {
        entities.insert(entity)
        
        if let spriteNode = entity.componentForClass(SpriteComponent.self)?.node {
            spriteLayer.addChild(spriteNode)
        }
        
        for componentSystem in componentSystems {
            componentSystem.addComponentWithEntity(entity)
        }
    }
    
}
