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
    
    override func didMoveToView(view: SKView) {
        
        addChild(backgroundLayer)
        
        loadBackground()
        playBackgroundMusic()
    }
    
    func loadBackground() {
        let image = SKSpriteNode(imageNamed: "background_intro")
        image.anchorPoint = CGPoint.zero
        image.position = CGPoint(x: 0, y: overlapAmount() / 2)

        backgroundLayer.addChild(image)
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
