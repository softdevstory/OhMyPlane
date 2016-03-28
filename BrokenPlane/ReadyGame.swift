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
        let background: [BackgroundType] = [.Dirt, .Grass, .Ice, .Rock, .Snow]
        let choice = background[Int(arc4random_uniform(6))]

        scene.showBackground(choice)
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
