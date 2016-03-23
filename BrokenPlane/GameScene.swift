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

    var lastUpdateTimeInterval: NSTimeInterval = 0
    let maximumUpdateDeltaTime: NSTimeInterval = 1.0 / 60.0
    var lastDeltaTime: NSTimeInterval = 0
    
    let backgroundLayer = SKNode()
    let spriteLayer = SKNode()
    
    lazy var componentSystems: [GKComponentSystem] = {
        let animationSystem = GKComponentSystem(componentClass: AnimationComponent.self)
        return [animationSystem]
    }()
    
    override func didMoveToView(view: SKView) {

        addChild(backgroundLayer)
        addChild(spriteLayer)

        let background = SKSpriteNode(imageNamed: "background")
        background.anchorPoint = CGPoint.zero
        backgroundLayer.addChild(background)
        
        addPlane(.Yellow)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

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

        plane.animationComponent.requestedAnimationState = .Flying
        
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
        
        for componentSystem in componentSystems {
            componentSystem.addComponentWithEntity(entity)
        }
    }
    
}
