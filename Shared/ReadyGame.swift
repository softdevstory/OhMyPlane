//
//  ReadyGame.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 3. 23..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import SpriteKit
import GameplayKit

class ReadyGame: GKState {
    unowned var scene: GameScene
    
    init(scene: GameScene) {
        self.scene = scene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.ready()
    }
    
    override func willExit(to nextState: GKState) {
        scene.hideReadyHud()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        scene.updateBackground()
    }
}
