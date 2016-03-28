//
//  SuccessGame.swift
//  BrokenPlane
//
//  Created by HS Song on 2016. 3. 25..
//  Copyright © 2016년 softdevstory. All rights reserved.
//


import GameplayKit
import SpriteKit

class SuccessGame: GKState {
    unowned var scene: GameScene
    
    init(scene: GameScene) {
        self.scene = scene
        super.init()
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        scene.addHomeBackground()
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
}
