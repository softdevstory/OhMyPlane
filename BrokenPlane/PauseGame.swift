//
//  PauseGame.swift
//  BrokenPlane
//
//  Created by HS Song on 2016. 3. 25..
//  Copyright © 2016년 softdevstory. All rights reserved.
//


import GameplayKit
import SpriteKit

class PauseGame: GKState {
    unowned var scene: GameScene
    
    init(scene: GameScene) {
        self.scene = scene
        super.init()
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        scene.paused = true
        scene.showPause()
    }
    
    override func willExitWithNextState(nextState: GKState) {
        scene.paused = false
        scene.hidePause()
    }
}
