//
//  GameScene+TVControlsScene.swift
//  OhMyPlane
//
//  Created by HS Song on 2016. 4. 14..
//  Copyright © 2016년 softdevstory. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameScene: TVControlsScene {

    func setupTVControls() {
        // nothing to do
    }
    
    func resetTVControls() {
        pauseButton.isHidden = true
    }
    
    func touchOnRemoteBegan() {
        switch gameState.currentState {
        case is ReadyGame:
            changeGameState(PlayGame.self)
            
        case is FailGame:
            changeGameState(ReadyGame.self)
                
        case is PlayGame:
            goUpPlane()

        default:
            break
        }
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            if press.type == .menu {
                gotoMainScene()
            }
        }
    }
}
