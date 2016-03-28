//
//  PlayGame.swift
//  BrokenPlane
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

    override func didEnterWithPreviousState(previousState: GKState?) {

    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        scene.updateBackground()
        scene.updateRockObstacle()
        
        scene.checkRockEntities()
    }
}
