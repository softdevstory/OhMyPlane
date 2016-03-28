//
//  ReadyGame.swift
//  BrokenPlane
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
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        scene.showBackground(BackgroundType.Ice)
        scene.addPlane(.Blue)
        scene.showReadyHud()
    }
    
    override func willExitWithNextState(nextState: GKState) {
        scene.hideReadyHud()
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        scene.updateBackground()
    }
}
