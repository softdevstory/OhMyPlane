//
//  MainScene.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 4. 1..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import SpriteKit
import SKTUtilsExtended

class MainScene: SKScene {
    
    let backgroundLayer = SKNode()
    
    // MARK: buttons
    
    var gameScene: SKScene!
    var creditScene: CreditScene!
    var topRecordsScene: SKScene!
    
    var startSprite: SKSpriteNode!
    var startTextures: [SKTexture] = []
    var startPressed = false
    
    var setupSprite: SKSpriteNode!
    var setupTextures: [SKTexture] = []
    var setupPressed = false
    
    var topRecordsSprite: SKSpriteNode!
    var topRecordsTextures: [SKTexture] = []
    var topRecordsPressed = false
    
    func touchDownStart() {
        startSprite.texture = startTextures[1]
        startSprite.size = (startSprite.texture?.size())!
        startPressed = true
        
        playClickSound()
    }
    
    func touchUpStart() {
        startSprite.texture = startTextures[0]
        startSprite.size = (startSprite.texture?.size())!
        startPressed = false
    }
    
    func touchDownSetup() {
        setupSprite.texture = setupTextures[1]
        setupSprite.size = (setupSprite.texture?.size())!
        setupPressed = true
        
        playClickSound()
    }
    
    func touchUpSetup() {
        setupSprite.texture = setupTextures[0]
        setupSprite.size = (setupSprite.texture?.size())!
        setupPressed = false
    }
    
    func touchDownTopRecord() {
        topRecordsSprite.texture = topRecordsTextures[1]
        topRecordsSprite.size = (topRecordsSprite.texture?.size())!
        topRecordsPressed = true
        
        playClickSound()
    }
    
    func touchUpTopRecord() {
        topRecordsSprite.texture = topRecordsTextures[0]
        topRecordsSprite.size = (topRecordsSprite.texture?.size())!
        topRecordsPressed = false
    }
    
    // MARK: Scene's job

    override func didMove(to view: SKView) {
        
        addChild(backgroundLayer)

        gameScene = GameScene(size: GameSetting.SceneSize)
        gameScene.scaleMode = (self.scene?.scaleMode)!
        
        creditScene = CreditScene(size: GameSetting.SceneSize)
        creditScene.scaleMode = (self.scene?.scaleMode)!
        
        topRecordsScene = TopRecordsScene(size: GameSetting.SceneSize)
        topRecordsScene.scaleMode = (self.scene?.scaleMode)!
        
        loadBackground()
        loadButtons()
        
        playBackgroundMusic()

        // for tvOS
        let scene = (self as SKScene)
        if let scene = scene as? TVControlsScene {
            scene.setupTVControls()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // for tvOS
        let scene = (self as SKScene)
        if let _ = scene as? TVControlsScene {
            return
        }
        
        let touch = touches.first
        let location = touch?.location(in: backgroundLayer)
        let node = backgroundLayer.atPoint(location!)
        
        if node == startSprite {
            touchDownStart()
        }
        
        if node == setupSprite {
            touchDownSetup()
        }
        
        if node == topRecordsSprite {
            touchDownTopRecord()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // for tvOS
        let scene = (self as SKScene)
        if let _ = scene as? TVControlsScene {
            return
        }

        if startPressed {
            let transition = SKTransition.fade(withDuration: 0.6)
            view!.presentScene(gameScene, transition: transition)
            
            touchUpStart()
        }
        
        if setupPressed {
            let transition = SKTransition.push(with: .down, duration: 0.6)
            view!.presentScene(creditScene, transition: transition)

            touchUpSetup()
        }
        
        if topRecordsPressed {
            let transition = SKTransition.push(with: .up, duration: 0.6)
            view!.presentScene(topRecordsScene, transition: transition)

            touchUpTopRecord()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if startPressed {
            touchUpStart()
        }
        
        if setupPressed {
            touchUpSetup()
        }
        
        if topRecordsPressed {
            touchUpTopRecord()
        }
    }
    
    func loadBackground() {
        let image = SKSpriteNode(imageNamed: "background_intro")
        image.anchorPoint = CGPoint.zero
        image.position = CGPoint(x: 0, y: overlapAmount() / 2)
        image.zPosition = SpriteZPosition.BackBackground
        
        backgroundLayer.addChild(image)
        
        let title = SKSpriteNode(imageNamed: "title")
        title.position = CGPoint(x: size.width / 2, y: size.height / 2 + title.size.height)
        title.zPosition = SpriteZPosition.Overlay
        
        backgroundLayer.addChild(title)
    }
    
    func loadButtons() {
        startTextures.append(SKTexture(imageNamed: "start"))
        startTextures.append(SKTexture(imageNamed: "start_pressed"))
        
        let start = SKSpriteNode(texture: startTextures[0])
        start.position = CGPoint(x: size.width / 2, y: size.height / 2 - start.size.height)
        start.zPosition = SpriteZPosition.Overlay
        
        backgroundLayer.addChild(start)
        startSprite = start
        
        topRecordsTextures.append(SKTexture(imageNamed: "topRecords"))
        topRecordsTextures.append(SKTexture(imageNamed: "topRecords_pressed"))
        
        let topRecords = SKSpriteNode(texture: topRecordsTextures[0])
        topRecords.position = CGPoint( x: size.width - topRecords.size.width, y: overlapAmount() / 2 + topRecords.size.height)
        topRecords.zPosition = SpriteZPosition.Overlay
        
        backgroundLayer.addChild(topRecords)
        topRecordsSprite = topRecords
        
        setupTextures.append(SKTexture(imageNamed: "setup"))
        setupTextures.append(SKTexture(imageNamed: "setup_pressed"))
        
        let setup = SKSpriteNode(texture: setupTextures[0])
        setup.position = CGPoint(x: topRecords.position.x, y: topRecords.position.y + setup.size.height)
        setup.zPosition = SpriteZPosition.Overlay
        
        backgroundLayer.addChild(setup)
        setupSprite = setup
        
        
    }
    
    func playBackgroundMusic() {
        SKTAudio.sharedInstance().playBackgroundMusic("intro.mp3")
    }
    
    func playClickSound() {
        SKTAudio.sharedInstance().playSoundEffect("click3.wav")
    }
    
    func overlapAmount() -> CGFloat {
        guard let view = self.view else {
            return 0
        }
        
        let scale = view.bounds.size.width / self.size.width
        let scaledHeight = self.size.height * scale
        let scaledOverlap = scaledHeight - view.bounds.size.height
        
        return scaledOverlap / scale
    }
}
