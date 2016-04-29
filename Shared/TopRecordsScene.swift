//
//  TopRecordsScene.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 4. 5..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import SpriteKit
import SKTUtils

class TopRecordsScene: SKScene {

    let backgroundLayer = SKNode()
    
    var backSprite: SKSpriteNode!
    var backTextures: [SKTexture] = []
    var backPressed = false
    
    var gameCenterSprite: SKSpriteNode!
    var gameCenterTextures: [SKTexture] = []
    var gameCenterPressed = false
    
    var topThreeRecords = TopThreeRecords()

    override func didMoveToView(view: SKView) {
        addChild(backgroundLayer)

        loadBackground()
        loadButtons()
        
        showTopRecords()
        
        playBackgroundMusic()
        
        // for tvOS
        let scene = (self as SKScene)
        if let scene = scene as? TVControlsScene {
            scene.setupTVControls()
        }
    }

    func loadBackground() {
        let image = SKSpriteNode(imageNamed: "underground")
        image.anchorPoint = CGPoint.zero
        image.position = CGPoint(x: 0, y: overlapAmount() / 2)
        image.zPosition = SpriteZPosition.BackBackground
        
        backgroundLayer.addChild(image)
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
    
    func loadButtons() {
        gameCenterTextures.append(SKTexture(imageNamed: "game_center"))
        gameCenterTextures.append(SKTexture(imageNamed: "game_center_pressed"))
        
        let gameCenter = SKSpriteNode(texture: gameCenterTextures[0])
        gameCenter.position = CGPoint(x: size.width - gameCenter.size.width, y: overlapAmount() / 2 + gameCenter.size.height)
        gameCenter.zPosition = SpriteZPosition.Overlay
        
        backgroundLayer.addChild(gameCenter)
        gameCenterSprite = gameCenter
        
        backTextures.append(SKTexture(imageNamed: "back"))
        backTextures.append(SKTexture(imageNamed: "back_pressed"))
        
        let back = SKSpriteNode(texture: backTextures[0])
        back.position = CGPoint(x: size.width - back.size.width, y: gameCenter.position.y + back.size.height)
        back.zPosition = SpriteZPosition.Overlay
        
        backgroundLayer.addChild(back)
        backSprite = back
    }
    
    func playBackgroundMusic() {
        SKTAudio.sharedInstance().playBackgroundMusic("topThreeRecords.mp3")
    }
    
    func playClickSound() {
        SKTAudio.sharedInstance().playSoundEffect("click3.wav")
    }
    
    func touchDownGameCenter() {
        gameCenterSprite.texture = gameCenterTextures[1]
        gameCenterSprite.size = (gameCenterSprite.texture?.size())!
        gameCenterPressed = true
        
        playClickSound()
    }
    
    func touchDownBack() {
        backSprite.texture = backTextures[1]
        backSprite.size = (backSprite.texture?.size())!
        backPressed = true
        
        playClickSound()
    }
    
    func showGameCenterViewController() {
        NSNotificationCenter.defaultCenter().postNotificationName(PresentGameCenterViewController, object: self)
        
        gameCenterSprite.texture = gameCenterTextures[0]
        gameCenterSprite.size = (gameCenterSprite.texture?.size())!
        gameCenterPressed = false
    }
    
    func doBack() {
        
        let scene = MainScene(size: GameSetting.SceneSize)
        scene.scaleMode = (self.scene?.scaleMode)!
        let transition = SKTransition.pushWithDirection(.Down, duration: 0.6)
        view!.presentScene(scene, transition: transition)
        
        backSprite.texture = backTextures[0]
        backSprite.size = (backSprite.texture?.size())!
        backPressed = false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // for tvOS
        let scene = (self as SKScene)
        if let scene = scene as? TVControlsScene {
            scene.touchOnRemoteBegan()
            return
        }
        
        let touch = touches.first
        let location = touch?.locationInNode(backgroundLayer)
        let node = backgroundLayer.nodeAtPoint(location!)
        
        if node == backSprite {
            touchDownBack()
        } else if node == gameCenterSprite {
            touchDownGameCenter()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if backPressed {
            doBack()
        }
        
        if gameCenterPressed {
            showGameCenterViewController()
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if backPressed {
            backSprite.texture = backTextures[0]
            backSprite.size = (backSprite.texture?.size())!
            backPressed = false
        }
        
        if gameCenterPressed {
            gameCenterSprite.texture = gameCenterTextures[0]
            gameCenterSprite.size = (gameCenterSprite.texture?.size())!
            gameCenterPressed = false
        }
    }
    
    func showTopRecords() {
        let coins = ["gold", "silver", "bronze"]
        let modifier: [CGFloat] = [ 1, 0, -1]
        
        var i = 0

        for record in topThreeRecords.topThreeRecords {
            let coin = SKSpriteNode(imageNamed: coins[i])
            let yPosition = size.height / 2 + (modifier[i] * coin.size.height * 1.2)
            coin.position = CGPoint(x: size.width / 4, y: yPosition)
            
            let plane = SKSpriteNode(imageNamed: "plane_\(record.planeType)_02")
            plane.position = CGPoint(x: size.width / 2, y: yPosition)

            var number = Int(record.point / 100)
            let score1 = SKSpriteNode(imageNamed: "\(number)")
            score1.position = CGPoint(x: size.width / 4 * 3 - 150, y: yPosition)
            
            number = (record.point - (record.point / 100 * 100)) / 10
            let score2 = SKSpriteNode(imageNamed: "\(number)")
            score2.position = CGPoint(x: size.width / 4 * 3, y: yPosition)
            
            number = record.point % 10
            let score3 = SKSpriteNode(imageNamed: "\(number)")
            score3.position = CGPoint(x: size.width / 4 * 3 + 150, y: yPosition)
            
            backgroundLayer.addChild(coin)
            backgroundLayer.addChild(plane)

            backgroundLayer.addChild(score1)
            backgroundLayer.addChild(score2)
            backgroundLayer.addChild(score3)
            
            i += 1
        }
    }
}
