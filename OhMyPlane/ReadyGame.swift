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
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        scene.playBackgroundMusic()
        
        let background: [BackgroundType] = [.Dirt, .Grass, .Ice, .Rock, .Snow]
        let choice = background[Int.random(5)]
        scene.showBackground(choice)
        
        let plane: [PlaneType] = [ .Blue, .Green, .Red, .Yellow ]
        let planeChoice = plane[Int.random(4)]
        scene.addPlane(planeChoice)
        
        scene.showReadyHud()

    }
    
    override func willExitWithNextState(nextState: GKState) {
        scene.hideReadyHud()
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        scene.updateBackground()
    }
}
