//
//  PlayGame.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 3. 24..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import GameplayKit
import SpriteKit

class PlayGame: GKState {
    unowned var scene: GameScene
    
    init(scene: GameScene) {
        self.scene = scene
        super.init()
    }

    override func didEnter(from previousState: GKState?) {
        if !(previousState is PauseGame) {
            scene.planeState.enter(Broken.self)
            scene.showOverlay()
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        scene.updateBackground()
        scene.updateRockObstacle()
        scene.updateScore()
        
        scene.checkRockEntities()
    }
}
