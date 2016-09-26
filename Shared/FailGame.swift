//
//  FailGame.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 3. 25..
//  Copyright © 2016년 softdevstory. All rights reserved.
//


import GameplayKit
import SpriteKit

class FailGame: GKState {
    unowned var scene: GameScene
    
    init(scene: GameScene) {
        self.scene = scene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.planeState.enter(Crash.self)
        
        scene.checkGameScore()
        
        scene.showGameOver()
        scene.playGameOverMusic()
    }
    
    override func willExit(to nextState: GKState) {
        scene.hideGameOver()
    }
}
