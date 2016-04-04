//
//  MainScene.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 4. 1..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import SpriteKit
import AVFoundation

class MainScene: SKScene {
    
    var audioPlayer: AVAudioPlayer?
    
    let backgroundLayer = SKNode()
    
    var startSprite: SKSpriteNode!
    var startTextures: [SKTexture] = []
    var startPressed = false
    
    override func didMoveToView(view: SKView) {
        
        addChild(backgroundLayer)
        
        loadBackground()
        playBackgroundMusic()
    }
    
    override func willMoveFromView(view: SKView) {
        stopBackgroundMusic()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch?.locationInNode(backgroundLayer)
        let node = backgroundLayer.nodeAtPoint(location!)
        
        if node == startSprite {
            startSprite.texture = startTextures[1]
            startSprite.size = (startSprite.texture?.size())!
            startPressed = true
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if startPressed {
            let scene = GameScene(size: GameSetting.SceneSize)
            scene.scaleMode = (self.scene?.scaleMode)!
            let transition = SKTransition.fadeWithDuration(0.6)
            view!.presentScene(scene, transition: transition)
            
            startSprite.texture = startTextures[0]
            startSprite.size = (startSprite.texture?.size())!
            startPressed = false
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if startPressed {
            startSprite.texture = startTextures[0]
            startSprite.size = (startSprite.texture?.size())!
            startPressed = false
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

        startTextures.append(SKTexture(imageNamed: "start"))
        startTextures.append(SKTexture(imageNamed: "start_pressed"))
        
        let start = SKSpriteNode(texture: startTextures[0])
        start.position = CGPoint(x: size.width / 2, y: size.height / 2 - start.size.height)
        start.zPosition = SpriteZPosition.Overlay

        backgroundLayer.addChild(start)
        startSprite = start

    }
    
    func playBackgroundMusic() {
        let url = NSBundle.mainBundle().URLForResource("intro", withExtension: "mp3")
        
        audioPlayer = try? AVAudioPlayer(contentsOfURL: url!)
        if audioPlayer != nil {
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.prepareToPlay()
            audioPlayer!.volume = 0.5
            audioPlayer!.play()
        }
    }
    
    func stopBackgroundMusic() {
        if audioPlayer != nil {
            audioPlayer!.stop()
        }
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
