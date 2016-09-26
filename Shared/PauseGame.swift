//
//  PauseGame.swift
//  OhMyPlane
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
    
    override func didEnter(from previousState: GKState?) {
        scene.pausePlay()
        scene.showPause()
    }
    
    override func willExit(to nextState: GKState) {
        scene.resumePlay()
        scene.hidePause()
    }
}
