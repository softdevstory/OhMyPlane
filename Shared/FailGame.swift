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
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        scene.planeState.enterState(Crash.self)
        
        scene.checkGameScore()
        
        scene.showGameOver()
        scene.playGameOverMusic()
    }
    
    override func willExitWithNextState(nextState: GKState) {
        scene.hideGameOver()
    }
}
