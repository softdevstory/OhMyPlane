//
//  MainScene.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 4. 1..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import SpriteKit
import SKTUtils

class MainScene: SKScene {
    
    let backgroundLayer = SKNode()
    
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
    
    override func didMoveToView(view: SKView) {
        
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
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch?.locationInNode(backgroundLayer)
        let node = backgroundLayer.nodeAtPoint(location!)
        
        if node == startSprite {
            startSprite.texture = startTextures[1]
            startSprite.size = (startSprite.texture?.size())!
            startPressed = true

            playClickSound()
        }
        
        if node == setupSprite {
            setupSprite.texture = setupTextures[1]
            setupSprite.size = (setupSprite.texture?.size())!
            setupPressed = true
            
            playClickSound()
        }
        
        if node == topRecordsSprite {
            topRecordsSprite.texture = topRecordsTextures[1]
            topRecordsSprite.size = (topRecordsSprite.texture?.size())!
            topRecordsPressed = true
            
            playClickSound()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if startPressed {
            let transition = SKTransition.fadeWithDuration(0.6)
            view!.presentScene(gameScene, transition: transition)
            
            startSprite.texture = startTextures[0]
            startSprite.size = (startSprite.texture?.size())!
            startPressed = false
        }
        
        if setupPressed {
            let transition = SKTransition.pushWithDirection(.Down, duration: 0.6)
            view!.presentScene(creditScene, transition: transition)
            
            setupSprite.texture = setupTextures[0]
            setupSprite.size = (setupSprite.texture?.size())!
            setupPressed = false
        }
        
        if topRecordsPressed {
            let transition = SKTransition.pushWithDirection(.Up, duration: 0.6)
            view!.presentScene(topRecordsScene, transition: transition)

            topRecordsSprite.texture = topRecordsTextures[0]
            topRecordsSprite.size = (topRecordsSprite.texture?.size())!
            topRecordsPressed = false
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if startPressed {
            startSprite.texture = startTextures[0]
            startSprite.size = (startSprite.texture?.size())!
            startPressed = false
        }
        
        if setupPressed {
            setupSprite.texture = setupTextures[0]
            setupSprite.size = (setupSprite.texture?.size())!
            setupPressed = false
        }
        
        if topRecordsPressed {
            topRecordsSprite.texture = topRecordsTextures[0]
            topRecordsSprite.size = (topRecordsSprite.texture?.size())!
            topRecordsPressed = false
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
        
        setupTextures.append(SKTexture(imageNamed: "setup"))
        setupTextures.append(SKTexture(imageNamed: "setup_pressed"))
        
        let setup = SKSpriteNode(texture: setupTextures[0])
        setup.position = CGPoint(x: size.width - setup.size.width, y: overlapAmount() / 2 + setup.size.height)
        setup.zPosition = SpriteZPosition.Overlay
        
        backgroundLayer.addChild(setup)
        setupSprite = setup
        
        topRecordsTextures.append(SKTexture(imageNamed: "topRecords"))
        topRecordsTextures.append(SKTexture(imageNamed: "topRecords_pressed"))
        
        let topRecords = SKSpriteNode(texture: topRecordsTextures[0])
        topRecords.position = CGPoint( x: setup.position.x, y: setup.position.y + topRecords.size.height)
        topRecords.zPosition = SpriteZPosition.Overlay
        
        backgroundLayer.addChild(topRecords)
        topRecordsSprite = topRecords
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
