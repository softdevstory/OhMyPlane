//
//  GameScene.swift
//  BrokenPlane
//
//  Created by HS Song on 2016. 3. 23..
//  Copyright (c) 2016년 softdevstory. All rights reserved.
//

import SpriteKit
import GameplayKit


struct PhysicsCategory {
    static let None: UInt32         = 0
    static let Plane: UInt32        = 0b1
    static let Obstabcle: UInt32    = 0b10
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: update time
    
    var lastUpdateTimeInterval: NSTimeInterval = 0
    let maximumUpdateDeltaTime: NSTimeInterval = 1.0 / 60.0
    var lastDeltaTime: NSTimeInterval = 0

    // MARK: Sprite layers
    
    let backgroundLayer = SKNode()
    let spriteLayer = SKNode()
    
    // MARK: Camera node and hud
    
    let readyHudNode = SKNode()
    let cameraNode = SKCameraNode()
    
    
    // MARK: game state machine
    
    lazy var gameState: GKStateMachine = GKStateMachine(states: [
        ReadyGame(scene: self),
        PlayGame(scene: self),
        ])
    
    // MARK: plane

    var planeEntity: PlaneEntity! = nil
    
    lazy var planeState: GKStateMachine = GKStateMachine(states: [
        Normal(planeEntity: self.planeEntity),
        Broken(planeEntity: self.planeEntity),
        Crash(planeEntity: self.planeEntity),
        Landing(planeEntity: self.planeEntity)])
    
    // MARK: component systems
    
    lazy var componentSystems: [GKComponentSystem] = {
        let animationSystem = GKComponentSystem(componentClass: AnimationComponent.self)
        let planeMovementSystem = GKComponentSystem(componentClass: PlaneMovementComponent.self)
        
        return [animationSystem, planeMovementSystem]
    }()

    // MARK: display size
    
    var displaySize = CGSize()
    
    private func overlapAmount() -> CGFloat {
        guard let view = self.view else {
            return 0
        }
        
        let scale = view.bounds.size.width / self.size.width
        let scaledHeight = self.size.height * scale
        let scaledOverlap = scaledHeight - view.bounds.size.height
        
        return scaledOverlap / scale
    }


    // MARK: touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        switch gameState.currentState {
        case is ReadyGame:
            gameState.enterState(PlayGame.self)

        case is PlayGame:
            planeEntity.impulse()
            
        default:
            break
        }
        
        switch planeState.currentState {
        case is Normal:
            planeState.enterState(Broken.self)
            
        case is Broken:
            planeState.enterState(Crash.self)
            
        case is Crash:
            planeState.enterState(Landing.self)
            
        case is Landing:
            planeState.enterState(Normal.self)

        default:
            break;
        }
    }

    // MARK: SKScene jobs
    
    override func didMoveToView(view: SKView) {

        physicsWorld.contactDelegate = self
        physicsWorld.gravity = GameSetting.PhysicsGravity
        
        displaySize = CGSize(width: size.width, height: size.height - overlapAmount())
        
        addChild(spriteLayer)
        addChild(backgroundLayer)
        
        addChild(cameraNode)
        camera = cameraNode
        setCameraPosition(CGPoint(x: size.width / 2, y: size.height / 2))
        
        gameState.enterState(ReadyGame.self)
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        var deltaTime = currentTime - lastUpdateTimeInterval
        deltaTime = deltaTime > maximumUpdateDeltaTime ? maximumUpdateDeltaTime : deltaTime
        lastUpdateTimeInterval = currentTime
        
        for componentSystem in componentSystems {
            componentSystem.updateWithDeltaTime(deltaTime)
        }
        
        updateCameraNode()
        

        gameState.currentState?.updateWithDeltaTime(deltaTime)
        
        planeState.currentState?.updateWithDeltaTime(deltaTime)
    }
    
    // MARK: plane entity
    
    func addPlane(planeType: PlaneType) {
        
        planeEntity = PlaneEntity(planeType: planeType)
        planeEntity.planeNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        planeEntity.planeNode.zPosition = 100
        planeEntity.planeNode.name = "plane"

        addEntity(planeEntity)
        
        spriteLayer.addChild(planeEntity.planeNode)
        
        planeState.enterState(Normal.self)
    }
    
    // MARK: entity management
    
    var entities = Set<GKEntity>()
    
    func addEntity(entity: GKEntity) {
        entities.insert(entity)
        
        for componentSystem in componentSystems {
            componentSystem.addComponentWithEntity(entity)
        }
    }
    
    // MARK: physics
    
    func didBeginContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch collision {
        case PhysicsCategory.Plane | PhysicsCategory.Obstabcle:
            
            break
            
        default:
            break
        }
    }
    
    // MARK: background
    
    func backgroundNode(backgroundType: BackgroundType) -> SKSpriteNode {
        let backgroundNode = SKSpriteNode()
        
        let bodyTexture = SKTexture(imageNamed: "background_physics")
        
        let backSprite = SKSpriteNode(imageNamed: "background")
        backSprite.anchorPoint = CGPoint.zero
        backSprite.position = CGPoint.zero
        backSprite.zPosition = -100
        backgroundNode.addChild(backSprite)
        
        let frontSprite = SKSpriteNode(imageNamed: backgroundType.imageFileName)
        frontSprite.position = CGPoint(x: size.width / 2, y: overlapAmount() / 2 + frontSprite.size.height / 2)
        frontSprite.zPosition = -50
        
        frontSprite.physicsBody = SKPhysicsBody(texture: bodyTexture, size: bodyTexture.size())
        frontSprite.physicsBody?.dynamic = false
        frontSprite.physicsBody?.categoryBitMask = PhysicsCategory.Obstabcle
        frontSprite.physicsBody?.collisionBitMask = PhysicsCategory.Plane
        frontSprite.physicsBody?.contactTestBitMask = PhysicsCategory.Plane
        
        backgroundNode.addChild(frontSprite)
        
        backgroundNode.size = backSprite.size
        backgroundNode.name = "background"
        
        return backgroundNode
    }
    
    func backgroundHome() -> SKSpriteNode {
        let backgroundNode = SKSpriteNode()
        
        let backSprite = SKSpriteNode(imageNamed: "background")
        backSprite.anchorPoint = CGPoint.zero
        backSprite.position = CGPoint.zero
        backSprite.zPosition = -100
        backgroundNode.addChild(backSprite)
        
        let frontSprite = SKSpriteNode(imageNamed: "background_port")
        frontSprite.position = CGPoint(x: size.width / 2, y: overlapAmount() / 2 + frontSprite.size.height / 2)
        frontSprite.zPosition = -50
        
        let bodyTexture = SKTexture(imageNamed: "background_port_physics")
        frontSprite.physicsBody = SKPhysicsBody(texture: bodyTexture, size: bodyTexture.size())
        frontSprite.physicsBody?.dynamic = false
        frontSprite.physicsBody?.categoryBitMask = PhysicsCategory.Obstabcle
        frontSprite.physicsBody?.collisionBitMask = PhysicsCategory.Plane
        frontSprite.physicsBody?.contactTestBitMask = PhysicsCategory.Plane
        
        backgroundNode.addChild(frontSprite)
        
        backgroundNode.size = backSprite.size
        backgroundNode.name = "background"
        
        return backgroundNode
    }
    
    func showBackground(backgroundType: BackgroundType) {
        let background1 = backgroundNode(backgroundType)
        background1.anchorPoint = CGPoint.zero
        background1.position = CGPoint.zero
        backgroundLayer.addChild(background1)
        
        let background2 = backgroundNode(backgroundType)
        background2.anchorPoint = CGPoint.zero
        background2.position = CGPoint(x: background1.size.width, y:0)
        backgroundLayer.addChild(background2)
        
        let background3 = backgroundNode(backgroundType)
        background3.anchorPoint = CGPoint.zero
        background3.position = CGPoint(x: background1.size.width * 2, y:0)
        backgroundLayer.addChild(background3)
        
        let background4 = backgroundHome()
        background4.anchorPoint = CGPoint.zero
        background4.position = CGPoint(x: background1.size.width * 3, y:0)
        backgroundLayer.addChild(background4)
    }
    
    func updateBackground() {
        backgroundLayer.enumerateChildNodesWithName("background") { node, _ in
            let background = node as! SKSpriteNode
            if background.position.x + background.size.width < self.getCameraPosition().x - (self.displaySize.width / 2) {
                background.position.x += background.size.width * 4
            }
        }
    }
    
    // MARK: ready scene
    
    func showReadyHud() {
        
        let readyImage = SKSpriteNode(imageNamed: "ready")
        readyImage.position = convertPositionInCameraNodeFromScene(CGPoint(x: 0, y: displaySize.height / 4))
        readyImage.zPosition = 1000
        readyHudNode.addChild(readyImage)
        
        let tap = SKSpriteNode(imageNamed: "tap")
        tap.position = convertPositionInCameraNodeFromScene(CGPoint(x: 0, y: displaySize.height / -4 ))
        tap.zPosition = 1000
        readyHudNode.addChild(tap)
        
        let textures = [SKTexture(imageNamed: "tap"), SKTexture(imageNamed: "untap")]
        let animation = SKAction.animateWithTextures(textures, timePerFrame: 0.5)
        let tapAction = SKAction.repeatActionForever(animation)
        tap.runAction(tapAction)
        
        let tapLeft = SKSpriteNode(imageNamed: "tap_left")
        tapLeft.position = convertPositionInCameraNodeFromScene(CGPoint(x: tap.size.width * -1.5, y: displaySize.height / -4))
        tapLeft.zPosition = 1000
        readyHudNode.addChild(tapLeft)
        
        let tapRight = SKSpriteNode(imageNamed: "tap_right")
        tapRight.position = convertPositionInCameraNodeFromScene(CGPoint(x: tap.size.width * 1.5, y: displaySize.height / -4))
        tapRight.zPosition = 1000
        readyHudNode.addChild(tapRight)
        
        // for debugging
        let box = SKShapeNode(rectOfSize: displaySize)
        box.lineWidth = 10
        box.position = convertPositionInCameraNodeFromScene(CGPoint.zero)
        box.strokeColor = UIColor.redColor()
        box.zPosition = 10000
        readyHudNode.addChild(box)
        
        cameraNode.addChild(readyHudNode)
    }
    
    func hideReadyHud() {
        readyHudNode.removeAllChildren()
        readyHudNode.removeFromParent()
    }
    
    // MARK: Camera

    /*
     * SKScene's camera has a bug
     */
    func getCameraPosition() -> CGPoint {
        return CGPoint(x: cameraNode.position.x, y: cameraNode.position.y + overlapAmount() / 2)
    }
    
    func setCameraPosition(position: CGPoint) {
        cameraNode.position = CGPoint(x: position.x, y: position.y - overlapAmount() / 2)
    }
    
    func convertPositionInCameraNodeFromScene(position: CGPoint) -> CGPoint {
        return CGPoint(x: position.x, y: position.y + overlapAmount() / 2)
    }
    
    private func updateCameraNode() {
        let planeNode = planeEntity.spriteComponent.node
        setCameraPosition(CGPoint(x: planeNode.position.x, y: size.height / 2))
    }
}
