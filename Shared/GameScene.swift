//
//  GameScene.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 3. 23..
//  Copyright (c) 2016년 softdevstory. All rights reserved.
//

import SpriteKit
import GameplayKit
import SKTUtilsExtended

struct PhysicsCategory {
    static let None: UInt32         = 0
    static let Plane: UInt32        = 0b1
    static let Obstacle: UInt32     = 0b10
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: update time
    
    var lastUpdateTimeInterval: TimeInterval = 0
    let maximumUpdateDeltaTime: TimeInterval = 1.0 / 60.0
    var lastDeltaTime: TimeInterval = 0

    // MARK: Sprite layers
    
    let backgroundLayer = SKNode()
    let spriteLayer = SKNode()
    
    let cameraNode = SKCameraNode()
    
    // MARK: game state machine
    
    lazy var gameState: GKStateMachine = GKStateMachine(states: [
        ReadyGame(scene: self),
        PlayGame(scene: self),
        FailGame(scene: self),
        PauseGame(scene: self)
        ])
    
    // MARK: Game data

    var score: Int = 0 {
        didSet {
            if scoreNode.count > 0 {
                var number = Int(score / 100)
                scoreNode[0].texture = numberTextures[number]
                number = (score - (score / 100 * 100)) / 10
                scoreNode[1].texture = numberTextures[number]
                number = score % 10
                scoreNode[2].texture = numberTextures[number]
            }
        }
    }
    var rockXPositions: [CGFloat] = []

    // MARK: UI buttons
    
    var pauseButton: SKSpriteNode! = nil
    var scoreNode: [SKSpriteNode] = []
    
    var exitButton: SKSpriteNode! = nil
    var returnButton: SKSpriteNode! = nil

    // MARK: plane

    var planeState: GKStateMachine!
    
    var planeEntity: PlaneEntity! = nil {
        didSet {
            planeState =  GKStateMachine(states: [
                Normal(planeEntity: planeEntity),
                Broken(planeEntity: planeEntity),
                Crash(planeEntity: planeEntity)])
        }
    }

    // MARK: component systems
    
    lazy var componentSystems: [GKComponentSystem] = {
        let animationSystem = GKComponentSystem(componentClass: AnimationComponent.self)
        let planeMovementSystem = GKComponentSystem(componentClass: PlaneMovementComponent.self)
        
        return [animationSystem, planeMovementSystem]
    }()

    // MARK: display size
    
    var displaySize = CGSize()
    var visibleArea = CGRect()
    
    func overlapAmount() -> CGFloat {
        guard let view = self.view else {
            return 0
        }
        
        let scale = view.bounds.size.width / self.size.width
        let scaledHeight = self.size.height * scale
        let scaledOverlap = scaledHeight - view.bounds.size.height
        
        return scaledOverlap / scale
    }

    // MARK: handling touches
    
    func touchDownPause() {
        playClickSound()
        
        changeGameState(PauseGame.self)
    }
    
    func touchDownReturn() {
        playClickSound()
        
        changeGameState(PlayGame.self)
    }
    
    func gotoMainScene() {
        let scene = MainScene(size: GameSetting.SceneSize)
        scene.scaleMode = (self.scene?.scaleMode)!
        let transition = SKTransition.fade(withDuration: 0.6)
        view!.presentScene(scene, transition: transition)
    }
    
    func touchDownExit() {
        playClickSound()

        gotoMainScene()
    }
    
    func goUpPlane() {
        if planeState.currentState is Broken {
            planeEntity.impulse()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // for tvOS
        let scene = (self as SKScene)
        if let scene = scene as? TVControlsScene {
            scene.touchOnRemoteBegan()
            return
        }
        
        let touch = touches.first
        let location = touch?.location(in: cameraNode)
        let node = cameraNode.atPoint(location!)
        
        switch gameState.currentState {
        case is ReadyGame:
            changeGameState(PlayGame.self)

        case is PlayGame:
            
            if node == pauseButton {
                touchDownPause()
            } else {
                goUpPlane()
            }
            
        case is FailGame:
            changeGameState(ReadyGame.self)
            
        case is PauseGame:
            
            if node == returnButton {
                touchDownReturn()
            } else if node == exitButton {
                touchDownExit()
            }
            
        default:
            break
        }
    }
    
    // MARK: Textures
    
    var backgroundTexture: SKTexture!
    
    var bottomFrontBackgroundPhysicsTexture: SKTexture!
    var bottomFrontBackgroundTextures: [BackgroundType: SKTexture] = [:]
    
    var topFrontBackgroundPhysicsTexture: SKTexture!
    var topFrontBackgroundTextures: [BackgroundType: SKTexture] = [:]
    
    var numberTextures: [SKTexture] = []
    
    fileprivate func loadNumberTextures() {
        for i in 0 ... 9 {
            let texture = SKTexture(imageNamed: "\(i)")
            numberTextures.append(texture)
        }
    }
    
    fileprivate func loadAllTextures() {
        RockEntityTexture.loadAllTextures()
        loadNumberTextures()
        
        backgroundTexture = SKTexture(imageNamed: "background")
        
        bottomFrontBackgroundPhysicsTexture = SKTexture(imageNamed: "background_physics")
        topFrontBackgroundPhysicsTexture = SKTexture(imageNamed: "background_top_physics")

        for backgroundType in BackgroundType.allTypes {
            let bottomTexture = SKTexture(imageNamed: backgroundType.imageFileName)
            bottomFrontBackgroundTextures[backgroundType] = bottomTexture
            
            let topTexture = SKTexture(imageNamed: backgroundType.topImageFileName)
            topFrontBackgroundTextures[backgroundType] = topTexture
        }
    }
    
    // MARK: sprite nodes
    
    var pauseNode = SKNode()
    var backgroundNodes: [SKSpriteNode] = []
    
    var gameOverNode = SKSpriteNode()
    
    var overlayNode = SKNode()
    
    var readyNode = SKNode()
    
    var medalNodes: [Rank: SKSpriteNode] = [:]
    
    fileprivate func prepareMedalNodes() {
        let goldMedal = SKSpriteNode(imageNamed: Rank.gold.imageFileName!)
        goldMedal.zPosition = SpriteZPosition.Overlay
        goldMedal.isHidden = true
        
        cameraNode.addChild(goldMedal)
        medalNodes[Rank.gold] = goldMedal
        
        let silverMedal = SKSpriteNode(imageNamed: Rank.silver.imageFileName!)
        silverMedal.zPosition = SpriteZPosition.Overlay
        silverMedal.isHidden = true
        
        cameraNode.addChild(silverMedal)
        medalNodes[Rank.silver] = silverMedal

        let bronzeMedal = SKSpriteNode(imageNamed: Rank.bronze.imageFileName!)
        bronzeMedal.zPosition = SpriteZPosition.Overlay
        bronzeMedal.isHidden = true
        
        cameraNode.addChild(bronzeMedal)
        medalNodes[Rank.bronze] = bronzeMedal
    }
    
    fileprivate func preparePauseNode() {
        let sprite = SKSpriteNode(imageNamed: "paused")
        sprite.position = convertPositionInCameraNodeFromScene(CGPoint(x: 0, y: sprite.size.height))
        sprite.zPosition = SpriteZPosition.Hud
        
        pauseNode.addChild(sprite)
        
        exitButton = SKSpriteNode(imageNamed: "exit")
        exitButton.position = convertPositionInCameraNodeFromScene(CGPoint(x: -sprite.size.width  / 2, y: -sprite.size.height))
        exitButton.zPosition = SpriteZPosition.Hud
        
        pauseNode.addChild(exitButton)
        
        returnButton = SKSpriteNode(imageNamed: "return")
        returnButton.position = convertPositionInCameraNodeFromScene(CGPoint(x: sprite.size.width  / 2, y: -sprite.size.height))
        returnButton.zPosition = SpriteZPosition.Hud
        
        pauseNode.addChild(returnButton)
        
        pauseNode.isHidden = true
        cameraNode.addChild(pauseNode)
    }
    
    fileprivate func prepareGameOverNode() {
        gameOverNode = SKSpriteNode(imageNamed: "game_over")
        gameOverNode.zPosition = SpriteZPosition.Hud
        gameOverNode.isHidden = true
        
        cameraNode.addChild(gameOverNode)
    }
    
    fileprivate func prepareOverlayNode() {
        let yPosition: CGFloat = (displaySize.height / 2) - 150
        var xPosition: CGFloat = 0
        
        pauseButton = SKSpriteNode(imageNamed: "pause")
        xPosition = (displaySize.width - pauseButton.size.width * 2) / 2
        pauseButton.position = convertPositionInCameraNodeFromScene(CGPoint(x: xPosition, y: yPosition))
        pauseButton.zPosition = SpriteZPosition.Hud
        
        overlayNode.addChild(pauseButton)
        
        scoreNode.append(SKSpriteNode(texture: numberTextures[0]))
        xPosition = (-1 * displaySize.width / 2) + scoreNode[0].size.width
        scoreNode[0].position = convertPositionInCameraNodeFromScene(CGPoint(x: xPosition, y: yPosition))
        scoreNode[0].zPosition = SpriteZPosition.Hud
        
        overlayNode.addChild(scoreNode[0])
        
        scoreNode.append(SKSpriteNode(texture: numberTextures[0]))
        xPosition += 150
        scoreNode[1].position = convertPositionInCameraNodeFromScene(CGPoint(x: xPosition, y: yPosition))
        scoreNode[1].zPosition = SpriteZPosition.Hud
        
        overlayNode.addChild(scoreNode[1])
        
        scoreNode.append(SKSpriteNode(texture: numberTextures[0]))
        xPosition += 150
        scoreNode[2].position = convertPositionInCameraNodeFromScene(CGPoint(x: xPosition, y: yPosition))
        scoreNode[2].zPosition = SpriteZPosition.Hud
        
        overlayNode.addChild(scoreNode[2])
        
        overlayNode.isHidden = true
        cameraNode.addChild(overlayNode)
    }
    
    fileprivate func prepareReadyNode() {
        let readyImage = SKSpriteNode(imageNamed: "ready")
        readyImage.position = convertPositionInCameraNodeFromScene(CGPoint(x: 0, y: displaySize.height / 4))
        readyImage.zPosition = SpriteZPosition.Hud
        readyNode.addChild(readyImage)
        
        let tap = SKSpriteNode(imageNamed: "tap")
        tap.position = convertPositionInCameraNodeFromScene(CGPoint(x: 0, y: displaySize.height / -4 ))
        tap.zPosition = SpriteZPosition.Hud
        readyNode.addChild(tap)
        
        let textures = [SKTexture(imageNamed: "tap"), SKTexture(imageNamed: "untap")]
        let animation = SKAction.animate(with: textures, timePerFrame: 0.5)
        let tapAction = SKAction.repeatForever(animation)
        tap.run(tapAction)
        
        let tapLeft = SKSpriteNode(imageNamed: "tap_left")
        tapLeft.position = convertPositionInCameraNodeFromScene(CGPoint(x: tap.size.width * -1.5, y: displaySize.height / -4))
        tapLeft.zPosition = SpriteZPosition.Hud
        readyNode.addChild(tapLeft)
        
        let tapRight = SKSpriteNode(imageNamed: "tap_right")
        tapRight.position = convertPositionInCameraNodeFromScene(CGPoint(x: tap.size.width * 1.5, y: displaySize.height / -4))
        tapRight.zPosition = SpriteZPosition.Hud
        readyNode.addChild(tapRight)
        
        readyNode.isHidden = true
        cameraNode.addChild(readyNode)
    }
    
    fileprivate func prepareHuds() {
        preparePauseNode()
        
        prepareGameOverNode()
        
        prepareOverlayNode()
        
        prepareReadyNode()
        
        prepareMedalNodes()
    }
    
    fileprivate func backgroundNode(_ backgroundType: BackgroundType) -> SKSpriteNode {
        let backgroundNode = SKSpriteNode()
        
        let backSprite = SKSpriteNode(texture: backgroundTexture)
        backSprite.anchorPoint = CGPoint.zero
        backSprite.position = CGPoint.zero
        backSprite.zPosition = SpriteZPosition.BackBackground
        backgroundNode.addChild(backSprite)
        
        let frontSprite = SKSpriteNode(texture: bottomFrontBackgroundTextures[backgroundType])
        frontSprite.position = CGPoint(x: frontSprite.size.width / 2, y: overlapAmount() / 2 + frontSprite.size.height / 2)
        frontSprite.zPosition = SpriteZPosition.FrontBackground
        
        frontSprite.physicsBody = SKPhysicsBody(texture: bottomFrontBackgroundPhysicsTexture, size: bottomFrontBackgroundPhysicsTexture.size())
        frontSprite.physicsBody?.isDynamic = false
        frontSprite.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        frontSprite.physicsBody?.collisionBitMask = PhysicsCategory.Plane
        frontSprite.physicsBody?.contactTestBitMask = PhysicsCategory.Plane
        
        backgroundNode.addChild(frontSprite)
        
        let frontSprite2 = SKSpriteNode(texture: topFrontBackgroundTextures[backgroundType])
        frontSprite2.position = CGPoint(x: frontSprite2.size.width / 2, y: size.height + overlapAmount() / 2 - frontSprite2.size.height / 2)
        frontSprite2.zPosition = SpriteZPosition.FrontBackground
        
        frontSprite2.physicsBody = SKPhysicsBody(texture: topFrontBackgroundPhysicsTexture, size: topFrontBackgroundPhysicsTexture.size())
        frontSprite2.physicsBody?.isDynamic = false
        frontSprite2.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        frontSprite2.physicsBody?.collisionBitMask = PhysicsCategory.Plane
        frontSprite2.physicsBody?.contactTestBitMask = PhysicsCategory.Plane
        
        backgroundNode.addChild(frontSprite2)
        
        backgroundNode.size = backSprite.size
        backgroundNode.name = SpriteName.background
        
        return backgroundNode
    }
    
    fileprivate func prepareBackgroundNodes(_ backgroundType: BackgroundType) {
        let background1 = backgroundNode(backgroundType)
        background1.anchorPoint = CGPoint.zero
        background1.position = CGPoint.zero
        backgroundLayer.addChild(background1)
        
        backgroundNodes.append(background1)
        
        let background2 = backgroundNode(backgroundType)
        background2.anchorPoint = CGPoint.zero
        background2.position = CGPoint(x: background1.size.width, y:0)
        backgroundLayer.addChild(background2)
        
        backgroundNodes.append(background2)
        
        let background3 = backgroundNode(backgroundType)
        background3.anchorPoint = CGPoint.zero
        background3.position = CGPoint(x: background1.size.width * 2, y:0)
        backgroundLayer.addChild(background3)
        
        backgroundNodes.append(background3)
    }
    
    fileprivate func prepareBackground(_ backgroundType: BackgroundType) {
        prepareBackgroundNodes(backgroundType)
    }
    
    fileprivate func resetBackground() {
        backgroundNodes[0].position = CGPoint.zero
        backgroundNodes[1].position = CGPoint(x: backgroundNodes[0].size.width, y:0)
        backgroundNodes[2].position = CGPoint(x: backgroundNodes[0].size.width * 2, y:0)
    }
    
    // MARK: SKScene jobs
    
    override func didMove(to view: SKView) {

        physicsWorld.contactDelegate = self
        physicsWorld.gravity = GameSetting.PhysicsGravity

        displaySize = CGSize(width: size.width, height: size.height - overlapAmount())

        addChild(spriteLayer)
        addChild(backgroundLayer)
        
        addChild(cameraNode)
        camera = cameraNode
        setCameraPosition(CGPoint(x: size.width / 2, y: size.height / 2))
        
        loadAllTextures()
        
        prepareHuds()
        
        let background: [BackgroundType] = [.Dirt, .Grass, .Ice, .Rock, .Snow]
        let choice = background[Int.random(5)]
        prepareBackgroundNodes(choice)

        initializeRockEntities()

        // for tvOS
        let scene = (self as SKScene)
        if let scene = scene as? TVControlsScene {
            scene.setupTVControls()
        }
        
        changeGameState(ReadyGame.self)
    }
    
    override func update(_ currentTime: TimeInterval) {
        var deltaTime = currentTime - lastUpdateTimeInterval
        deltaTime = deltaTime > maximumUpdateDeltaTime ? maximumUpdateDeltaTime : deltaTime
        lastUpdateTimeInterval = currentTime
        
        for componentSystem in componentSystems {
            componentSystem.update(deltaTime: deltaTime)
        }
        
        updateCameraNode()

        gameState.currentState?.update(deltaTime: deltaTime)
        
        planeState.currentState?.update(deltaTime: deltaTime)
    }
    
    // MARK: entity management
    
    func addPlane(_ planeType: PlaneType) {

        if planeEntity != nil {
            removeEntity(planeEntity)
        }
        
        planeEntity = PlaneEntity(planeType: planeType)
        planeEntity.planeNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        planeEntity.planeNode.zPosition = SpriteZPosition.Plane
        planeEntity.planeNode.name = SpriteName.plane
        planeEntity.targetNode = spriteLayer
        
        addEntity(planeEntity)
        
        planeState.enter(Normal.self)
    }
    
    func addRockEntity(_ rockType: RockType, position: CGPoint) {
        let background: [BackgroundType] = [.Dirt, .Grass, .Ice, .Snow]
        let backgroundType = background[Int.random(4)]

        let rockEntity = newRockEntity(backgroundType, rockType: rockType, atPosition: position)
        
        addEntity(rockEntity)
        
        rockXPositions.append(rockEntity.spriteComponent.node.position.x)
    }
    
    func checkRockEntities() {
        for entity in entities {
            if let rockEntity = entity as? RockEntity {
                let spriteNode = rockEntity.spriteComponent.node
                
                if spriteNode.position.x - spriteNode.size.width < visibleArea.origin.x - visibleArea.size.width / 2 {
                    freeRockEntity(rockEntity)
                    removeEntity(entity)
                }
            }
        }
    }
    
    fileprivate func resetRockEntities() {
        for entity in entities {
            if let rockEntity = entity as? RockEntity {
                let spriteNode = rockEntity.spriteComponent.node
                
                spriteNode.position = CGPoint.zero
                freeRockEntity(rockEntity)
                removeEntity(entity)
            }
        }
    }
    
    var entities = Set<GKEntity>()
    
    func addEntity(_ entity: GKEntity) {
        entities.insert(entity)
        
        for componentSystem in componentSystems {
            componentSystem.addComponent(foundIn: entity)
        }
        
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            spriteLayer.addChild(spriteNode)
        }
    }
    
    func removeEntity(_ entity: GKEntity) {

        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }

        for componentSystem in componentSystems {
            componentSystem.removeComponent(foundIn: entity)
        }
        
        entities.remove(entity)
    }
    
    // MARK: physics
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch collision {
        case PhysicsCategory.Plane | PhysicsCategory.Obstacle:
            if !(gameState.currentState is FailGame) {
                changeGameState(FailGame.self)
            }
            
        default:
            break
        }
    }
    
    // MARK: Rock obstacle
    
    var lastRockObstacleXPosition: CGFloat = 0
    var previousRockType: RockType = .bottom
    var countSameRock = 0
    var rockEntities: [RockEntity] = []
    var freeRockEntities: [RockEntity] = []
    
    func initializeRockEntities() {
        for _ in 0 ... 6 {
            let rockEntity = RockEntity(backgroundType: .Ice, rockType: .bottom, atPosition: CGPoint.zero)

            freeRockEntities.append(rockEntity)
        }
    }
    
    func freeRockEntity(_ rockEntity: RockEntity) {
        freeRockEntities.append(rockEntity)
    }
    
    func newRockEntity(_ backgroundType: BackgroundType, rockType: RockType, atPosition position: CGPoint) -> RockEntity {
        
        if let rockEntity = freeRockEntities.popLast() {
            rockEntity.reset(backgroundType, rockType: rockType, atPosition: position)

            return rockEntity
        }
        
        let rockEntity = RockEntity(backgroundType: backgroundType, rockType: rockType, atPosition: position)
        
        return rockEntity
    }
    
    func updateRockObstacle() {
        let rightEdge = (visibleArea.origin.x + visibleArea.size.width)
        let deltaX = rightEdge - lastRockObstacleXPosition
        
        if (deltaX > GameSetting.DeltaRockObstacle) {
            let rock: [RockType] = [.bottom, .top]
            var rockType = rock[Int.random(2)]
            
            if rockType == previousRockType {
                countSameRock += 1
            } else {
                previousRockType = rockType
                countSameRock = 0
            }
            
            if countSameRock > 2 {
                if rockType == .bottom {
                    rockType = .top
                } else {
                    rockType = .bottom
                }
                countSameRock = 0
                previousRockType = rockType
            }

            // position is left, bottom corner
            lastRockObstacleXPosition = rightEdge + GameSetting.DeltaRockObstacle

            let position: CGPoint
            switch rockType {
            case .bottom:
                position = CGPoint(x: lastRockObstacleXPosition, y: overlapAmount() / 2 - SpriteHight.plane / 2)

            case .top:
                position = CGPoint(x: lastRockObstacleXPosition, y: overlapAmount() / 2 + SpriteHight.frontBackground + SpriteHight.plane * 1.7)
            }
            
            addRockEntity(rockType, position: position)
        }
    }
    
    // MARK: background
    
    func showBackground(_ backgroundType: BackgroundType) {
        let background1 = backgroundNode(backgroundType)
        background1.anchorPoint = CGPoint.zero
        background1.position = CGPoint.zero
        backgroundLayer.addChild(background1)

        backgroundNodes.append(background1)
        
        let background2 = backgroundNode(backgroundType)
        background2.anchorPoint = CGPoint.zero
        background2.position = CGPoint(x: background1.size.width, y:0)
        backgroundLayer.addChild(background2)

        backgroundNodes.append(background2)
        
        let background3 = backgroundNode(backgroundType)
        background3.anchorPoint = CGPoint.zero
        background3.position = CGPoint(x: background1.size.width * 2, y:0)
        backgroundLayer.addChild(background3)
        
        backgroundNodes.append(background3)
    }
    
    func updateBackground() {

        for node in backgroundNodes {
            if node.position.x + (node.size.width / 2 * 3) < self.getCameraPosition().x - (self.displaySize.width / 2) {
                
                node.position.x += node.size.width * 3
            }
        }
    }

    // MARK: HUD
    
    func showPause() {
        pauseNode.isHidden = false
    }
    
    func hidePause() {
        pauseNode.isHidden = true
    }
    
    func showOverlay() {
        overlayNode.isHidden = false
    }
    
    func hideOverlay() {
        overlayNode.isHidden = true
    }
    
    func showGameOver() {
        isUserInteractionEnabled = false
        
        gameOverNode.position = convertPositionInCameraNodeFromScene(CGPoint(x: 0, y: displaySize.height / 2))
        gameOverNode.isHidden = false
        
        let action = SKAction.sequence([
            SKAction.move(to: convertPositionInCameraNodeFromScene(CGPoint(x: 0, y: 0)), duration: 0.3),
            SKAction.run( { self.isUserInteractionEnabled = true } )
            ])
        gameOverNode.run(action)
    }
    
    func hideGameOver() {
        gameOverNode.removeAllActions()
        gameOverNode.isHidden = true
    }
    
    func showReadyHud() {
        readyNode.isHidden = false
    }
    
    func hideReadyHud() {
        readyNode.isHidden = true
    }
    
    fileprivate func showMedal(_ rank: Rank) {
        if let sprite = medalNodes[rank] {
            sprite.alpha = 0.9
            sprite.position = convertPositionInCameraNodeFromScene(CGPoint.zero)
            sprite.isHidden = false
            
            sprite.run(SKAction.group([
                SKAction.rotate(byAngle: CGFloat(360).degreesToRadians() * 2, duration: 2),
                SKAction.scale(to: 2.0, duration: 2)
                ]))
        }
    }
    
    fileprivate func hideMedal() {
        medalNodes[Rank.gold]?.removeAllActions()
        medalNodes[Rank.gold]?.isHidden = true
        
        medalNodes[Rank.silver]?.removeAllActions()
        medalNodes[Rank.silver]?.isHidden = true
        
        medalNodes[Rank.bronze]?.removeAllActions()
        medalNodes[Rank.bronze]?.isHidden = true
    }

    // MARK: 
    
    func ready() {
        playBackgroundMusic()
        
        // reset background
        resetBackground()

        let plane: [PlaneType] = [ .Blue, .Green, .Red, .Yellow ]
        let planeChoice = plane[Int.random(4)]
        addPlane(planeChoice)
        
        showReadyHud()
        
        hideOverlay()
        hideMedal()
        
        reset()
    }
    
    func reset() {
        score = 0
        lastRockObstacleXPosition = 0
        
        rockXPositions = []
        
        resetRockEntities()
    }
    
    // MARK: 
    
    func updateScore() {
        let xPosition = rockXPositions.first!
        let planeNode = planeEntity.spriteComponent.node
        
        if xPosition < planeNode.position.x {
            score += 1
            rockXPositions.removeFirst()
        }
    }

    fileprivate func updateGameStatistics(_ planeType: PlaneType, medalType: Rank) {
        GameStatistics.flightCount.increaseCountByOne()
        
        switch planeType {
        case .Red:
            GameStatistics.flightCountRedPlane.increaseCountByOne()
        case .Green:
            GameStatistics.flightCountGreenPlane.increaseCountByOne()
        case .Yellow:
            GameStatistics.flightCountYellowPlane.increaseCountByOne()
        case .Blue:
            GameStatistics.flightCountBluePlane.increaseCountByOne()
        }
        
        switch medalType {
        case .gold:
            GameStatistics.goldMedalCount.increaseCountByOne()
        case .silver:
            GameStatistics.silverMedalCount.increaseCountByOne()
        case .bronze:
            GameStatistics.bronzeMedalCount.increaseCountByOne()
        case .none:
            break
        }
    }
    
    fileprivate func reportToGameCenter(_ planeType: PlaneType, medalType: Rank, score: Int) {
        let achievements = AchievementHelper.sharedInstance.createAchievements(planeType, medalType: medalType)
        GameKitHelper.sharedInstance.reportAchievements(achievements)
        
        let gkScore = LeaderBoardHelper.sharedInstance.createScore(planeType, score: score)
        GameKitHelper.sharedInstance.reportScore(gkScore)
    }
    
    func checkGameScore() {
        let topThreeRecord = TopThreeRecords()
        let rank = topThreeRecord.getRankOfPoint(score)
        
        if rank != .none {
            showMedal(rank)

            topThreeRecord.checkAndReplacePoint(planeEntity.planeType.rawValue, point: score)
        }
    
        updateGameStatistics(planeEntity.planeType, medalType: rank)

        reportToGameCenter(planeEntity.planeType, medalType: rank, score: score)
    }
    
    
    // MARK: Camera

    /*
     * Fixed: SKScene's camera has a bug
     */
    func getCameraPosition() -> CGPoint {
         return cameraNode.position
        //        return CGPoint(x: cameraNode.position.x, y: cameraNode.position.y + overlapAmount() / 2)
    }
    
    func setCameraPosition(_ position: CGPoint) {
        //cameraNode.position = CGPoint(x: position.x, y: position.y - overlapAmount() / 2)
        cameraNode.position = position
        
        visibleArea = CGRect(origin: CGPoint(x: cameraNode.position.x - displaySize.width / 2, y: cameraNode.position.y - displaySize.height / 2), size: displaySize)
    }
    
    func convertPositionInCameraNodeFromScene(_ position: CGPoint) -> CGPoint {
        //return CGPoint(x: position.x, y: position.y + overlapAmount() / 2)
        return position
    }
    
    fileprivate func updateCameraNode() {
        let planeNode = planeEntity.spriteComponent.node
        setCameraPosition(CGPoint(x: planeNode.position.x, y: size.height / 2))
    }
    
    // MARK: Music
    
    func playBackgroundMusic() {
        SKTAudio.sharedInstance().playBackgroundMusic("background.mp3")
    }
    
    func playGameOverMusic() {
        SKTAudio.sharedInstance().playBackgroundMusic("game_over.mp3")
    }
    
    func playClickSound() {
        SKTAudio.sharedInstance().playSoundEffect("click3.wav")
    }
    
    // MARK:
    
    func changeGameState(_ stateClass: AnyClass) {
        gameState.enter(stateClass)
        
        // for tvOS
        let scene = (self as SKScene)
        if let scene = scene as? TVControlsScene {
            scene.resetTVControls()
        }
    }
    
    func pausePlay() {
        backgroundLayer.isPaused = true
        spriteLayer.isPaused = true
        planeEntity.pause()
        physicsWorld.speed = 0.0
    }
    
    func resumePlay() {
        backgroundLayer.isPaused = false
        spriteLayer.isPaused = false
        planeEntity.resume()
        physicsWorld.speed = 1.0
    }
}
