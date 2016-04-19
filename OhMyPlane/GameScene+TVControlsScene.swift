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
        pauseButton.hidden = true
    }
    
    func touchOnRemoteBegan() {
        // nothing to do
    }
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        print("GameScene.pressesBegan")

        for press in presses {
            if press.type == .Menu {
                gotoMainScene()
            }
        }
    }
}
